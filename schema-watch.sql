-- Fase 2: treinos do Apple Watch (via Atalho do iOS)
create table if not exists workouts_watch (
  id bigint generated always as identity primary key,
  ts timestamptz default now(),
  workout_type text,
  start_date timestamptz,
  duration_min numeric,
  calories numeric,
  avg_hr numeric,
  max_hr numeric,
  distance_km numeric
);
alter table workouts_watch enable row level security;
create policy "anon all workouts_watch" on workouts_watch for all to anon using (true) with check (true);
