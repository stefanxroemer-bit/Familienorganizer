-- Familien-Tablet · Datenbank v1
-- Ausführen in Supabase: SQL Editor → New query → einfügen → Run

create table if not exists public.shopping_items (
  id          uuid primary key default gen_random_uuid(),
  name        text not null check (char_length(name) between 1 and 120),
  done        boolean not null default false,
  created_at  timestamptz not null default now(),
  done_at     timestamptz,
  created_by  uuid default auth.uid()
);

-- Zugriff nur für eingeloggte Familienmitglieder
alter table public.shopping_items enable row level security;

drop policy if exists "Familie darf alles" on public.shopping_items;
create policy "Familie darf alles" on public.shopping_items
  for all to authenticated
  using (true) with check (true);

-- Live-Sync (Änderungen erscheinen sofort auf allen Geräten)
alter publication supabase_realtime add table public.shopping_items;
