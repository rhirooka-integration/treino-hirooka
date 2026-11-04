-- Rode no SQL Editor do Supabase (uma vez só)
create table if not exists logs (
  id bigint generated always as identity primary key,
  ts timestamptz default now(),
  session_date date not null,
  workout text not null,
  exercise text not null,
  sets text,
  reps text,
  load_kg numeric,
  done boolean default false
);

create table if not exists feedback (
  id bigint generated always as identity primary key,
  ts timestamptz default now(),
  session_date date not null,
  workout text,
  rpe int,
  knee int,
  back int,
  notes text
);

alter table logs enable row level security;
alter table feedback enable row level security;

-- acesso total via anon key (app pessoal, 1 usuário)
create policy "anon all logs" on logs for all to anon using (true) with check (true);
create policy "anon all feedback" on feedback for all to anon using (true) with check (true);
