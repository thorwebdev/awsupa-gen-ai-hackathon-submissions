INSERT INTO "storage"."buckets" ("id", "name", "owner", "created_at", "updated_at", "public", "avif_autodetection", "file_size_limit", "allowed_mime_types", "owner_id") VALUES
	('products', 'products', NULL, '2024-07-05 04:10:26.934846+00', '2024-07-05 04:10:26.934846+00', true, false, NULL, NULL, NULL);

create policy "Anon read access 1ifhysk_0"
on "storage"."objects"
as permissive
for select
to public
using ((bucket_id = 'products'::text));


create policy "Anon Insert 1ifhysk_0"
on "storage"."objects"
as permissive
for insert
to anon
with check ((bucket_id = 'products'::text));


create policy "Deny Delete 1ifhysk_0"
on "storage"."objects"
as permissive
for delete
to service_role
using ((bucket_id = 'products'::text));



