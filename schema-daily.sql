-- Fase 3: resumo diário do Apple Health (via Atalho do iOS, 1x por dia)
-- + proteção: a chave pública só consegue LER e INSERIR (não altera nem apaga histórico)
-- Rodar inteiro no Supabase → SQL Editor → Run.

create table if not exists health_daily (
  id bigint generated always as identity primary key,
  ts timestamptz default now(),
  day date not null,
  steps numeric,
  active_kcal numeric,
  exercise_min numeric,
  resting_hr numeric,
  hrv_ms numeric,
  sleep_h numeric
);
alter table health_daily enable row level security;

-- remove as políticas antigas "tudo liberado"
drop policy if exists "anon all logs" on logs;
drop policy if exists "anon all feedback" on feedback;
drop policy if exists "anon all workouts_watch" on workouts_watch;

-- leitura + inserção apenas, nas 4 tabelas
do $$
declare t text;
begin
  foreach t in array array['logs','feedback','workouts_watch','health_daily'] loop
    execute format('drop policy if exists "anon read %1$s" on %1$I', t);
    execute format('drop policy if exists "anon insert %1$s" on %1$I', t);
    execute format('create policy "anon read %1$s" on %1$I for select to anon using (true)', t);
    execute format('create policy "anon insert %1$s" on %1$I for insert to anon with check (true)', t);
  end loop;
end $$;
