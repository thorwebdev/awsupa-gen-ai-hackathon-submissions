-- PRODUCST TABLE
create table products (
  id uuid default uuid_generate_v4() primary key,
  title text,
  email text,
  description text,
  categories text ARRAY,
  url text,
  github_url text,
  twitter text,
  instagram text,
  images text ARRAY,
  image_keys text ARRAY,
  slug text,
  supabase_features text ARRAY,
  approved boolean,
  created_at timestamp default now(),
  team_info jsonb
);

-- enable RLS
alter table products enable row level security;

-- VIEWS TABLE 
create table views (
  id uuid default uuid_generate_v4() primary key,
  created_at timestamp default now(),
  ip_address text,
  product_id uuid references products (id) on delete cascade
);

-- enable RLS
alter table views enable row level security;

-- PRODUCTS VIEW 
create view products_view as
  select
    products.id,
    products.title,
    products.description,
    products.categories,
    products.url,
    products.github_url,
    products.twitter,
    products.instagram,
    products.images,
    products.image_keys,
    products.slug,
    products.supabase_features,
    products.approved,
    products.created_at,
    count(views.id) as views
  from products
    left join views on products.id = views.product_id
  where products.approved = true
  group by products.id;

-- TAGS VIEW 
create view tags_view as
  select
    s.tags,
    count(*) as count
  from (
    select
      unnest(products.categories) as tags
    from products
    where products.approved = true
  ) s
  group by s.tags;

-- FUNCTIONS 
create or replace function public.get_related_products(parent_id uuid)
  returns setof products_view
  language plpgsql
as $$
  begin
    return query
      select * from products_view where id <> parent_id order by random();
  end; 
$$;

create or replace function public.get_tags(tag text)
  returns setof products_view
  language plpgsql
as $$
  begin
    return query
      select * from products_view where tag % any(categories);
  end; 
$$;

create or replace function public.get_supabase_tags(tag text)
  returns setof products_view
  language plpgsql
as $$
  begin
    return query
      select * from products_view where tag like any(supabase_features);
  end; 
$$;