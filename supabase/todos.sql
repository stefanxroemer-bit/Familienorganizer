-- Familien-Tablet · Datenbank v2: Gemeinsame Todos
-- Einmal ausführen in Supabase: SQL Editor → New query → einfügen → Run
-- (schema.sql aus v1 muss vorher gelaufen sein; dieses Skript ändert die Einkaufsliste nicht)

create table if not exists public.todos (
  id          uuid primary key default gen_random_uuid(),
  title       text not null check (char_length(title) between 1 and 200),
  assignee    text not null default 'beide' check (assignee in ('beide', 'stefan', 'kiara')),
  due         date,                                   -- leer = ohne Datum
  repeat      text not null default 'none' check (repeat in ('none', 'daily', 'weekly', 'monthly')),
  done        boolean not null default false,
  done_at     timestamptz,                            -- bei wiederkehrenden: zuletzt erledigt
  created_at  timestamptz not null default now(),
  created_by  uuid default auth.uid()
);

create index if not exists todos_open_due on public.todos (done, due);

-- Zugriff nur für eingeloggte Familienmitglieder
alter table public.todos enable row level security;

drop policy if exists "Familie darf alles" on public.todos;
create policy "Familie darf alles" on public.todos
  for all to authenticated
  using (true) with check (true);

-- Live-Sync (Änderungen erscheinen sofort auf allen Geräten)
alter publication supabase_realtime add table public.todos;
