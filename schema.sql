-- RPD Investigations: Supabase SQL Editor'da tek sefer çalıştırın.
create table if not exists public.profiles (id uuid primary key references auth.users(id) on delete cascade,email text,role text not null default 'viewer' check(role in ('viewer','detective','admin')),approved boolean not null default false,created_at timestamptz not null default now());
create or replace function public.rpd_new_user() returns trigger language plpgsql security definer set search_path=public as $$begin insert into public.profiles(id,email) values(new.id,new.email) on conflict(id) do nothing;return new;end$$;
drop trigger if exists rpd_auth_created on auth.users;
create trigger rpd_auth_created after insert on auth.users for each row execute function public.rpd_new_user();
insert into public.profiles(id,email) select id,email from auth.users on conflict(id) do nothing;
create or replace function public.rpd_approved() returns boolean language sql stable security definer set search_path=public as $$select exists(select 1 from public.profiles where id=(select auth.uid()) and approved)$$;
create or replace function public.rpd_role() returns text language sql stable security definer set search_path=public as $$select role from public.profiles where id=(select auth.uid()) and approved$$;
create or replace function public.rpd_admin() returns boolean language sql stable security definer set search_path=public as $$select exists(select 1 from public.profiles where id=(select auth.uid()) and approved and role='admin')$$;
alter table public.profiles enable row level security;
drop policy if exists rpd_profiles_read on public.profiles;
create policy rpd_profiles_read on public.profiles for select to authenticated using(id=(select auth.uid()) or (select public.rpd_admin()));
drop policy if exists rpd_profiles_admin_update on public.profiles;
create policy rpd_profiles_admin_update on public.profiles for update to authenticated using((select public.rpd_admin())) with check((select public.rpd_admin()));
do $$ declare t text; begin foreach t in array array['cases','people','evidence','interviews','timeline','reports'] loop
execute format('create table if not exists public.%I(id text primary key,data jsonb not null default ''{}''::jsonb,created_at timestamptz not null default now())',t);
execute format('alter table public.%I enable row level security',t);
execute format('drop policy if exists rpd_read on public.%I',t);
execute format('create policy rpd_read on public.%I for select to authenticated using ((select public.rpd_approved()))',t);
execute format('drop policy if exists rpd_insert on public.%I',t);
execute format('create policy rpd_insert on public.%I for insert to authenticated with check ((select public.rpd_role()) in (''admin'',''detective''))',t);
execute format('drop policy if exists rpd_update on public.%I',t);
execute format('create policy rpd_update on public.%I for update to authenticated using ((select public.rpd_role()) in (''admin'',''detective'')) with check ((select public.rpd_role()) in (''admin'',''detective''))',t);
execute format('drop policy if exists rpd_delete on public.%I',t);
execute format('create policy rpd_delete on public.%I for delete to authenticated using ((select public.rpd_role()) in (''admin'',''detective''))',t);
end loop;end$$;
-- Admin hesabını site üzerinden kaydettikten sonra aşağıdaki örneği kendi UUID ile çalıştırın:
-- update public.profiles set approved=true, role='admin' where id='KENDI-UUID';
