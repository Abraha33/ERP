-- F1 · Inventario — RPC registrar_recepcion (BORRADOR)
-- ----------------------------------------------------
-- Registra una recepción simple:
--  - Aumenta stock en una ubicación física.
--  - Crea un movimiento de inventario tipo "RECEPCION".
--  - Respeta tenant y RLS (empresa actual).

-- NOTA:
--  - Ajustar nombres de columnas / FKs (TODO marcados).
--  - Copiar este archivo a una migración nueva cuando se revise.

create or replace function public.registrar_recepcion(
  in p_producto_id uuid,
  in p_cubiculo_id uuid,
  in p_cantidad numeric,
  in p_origen_logico text default 'MANUAL'
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_empresa_id uuid;
  v_sucursal_id uuid;
  v_now timestamptz := now();
  v_usuario_id uuid := auth.uid();
begin
  -- TODO: si usas current_empresa_id() / current_sucursal_id(), puedes simplificar.
  v_empresa_id  := public.current_empresa_id();
  v_sucursal_id := public.current_sucursal_id();

  if v_usuario_id is null then
    raise exception 'registrar_recepcion: usuario no autenticado';
  end if;

  if p_cantidad <= 0 then
    raise exception 'registrar_recepcion: cantidad debe ser > 0';
  end if;

  -- 1) Validar que el producto exista y pertenezca a la empresa actual.
  if not exists (
    select 1
    from public.productos pr
    where pr.id_producto = p_producto_id      -- TODO: confirma nombre de PK
      and pr.empresa_id   = v_empresa_id     -- TODO: confirma columna empresa_id
  ) then
    raise exception 'registrar_recepcion: producto inválido para empresa actual';
  end if;

  -- 2) Validar que el cubículo/ubicación exista y pertenezca a la empresa actual.
  if not exists (
    select 1
    from public.cubiculosfila cf
    where cf.id = p_cubiculo_id              -- TODO: confirma PK
      and cf.empresa_id = v_empresa_id       -- TODO: si empresa_id viene via join a bodegas, ajustar
  ) then
    raise exception 'registrar_recepcion: ubicación inválida para empresa actual';
  end if;

  -- 3) Actualizar o insertar stock en stockubicacion.
  --    Suponiendo clave (empresa_id, producto_id, cubiculo_id).
  --    TODO: ajustar nombres de columnas clave según tu esquema real.
  insert into public.stockubicacion as su (
    empresa_id,
    producto_id,
    cubiculo_id,
    cantidad,
    updated_at
  )
  values (
    v_empresa_id,
    p_producto_id,
    p_cubiculo_id,
    p_cantidad,
    v_now
  )
  on conflict (empresa_id, producto_id, cubiculo_id)
  do update
  set cantidad   = su.cantidad + excluded.cantidad,
      updated_at = v_now;

  -- 4) Registrar movimiento de inventario (tipo RECEPCION).
  insert into public.movimientosinventario (
    empresa_id,
    sucursal_id,
    producto_id,
    cubiculo_id,
    tipo_movimiento,    -- TODO: confirma nombre de columna (ej. tipo)
    cantidad,
    origen_logico,
    creado_por,
    created_at
  )
  values (
    v_empresa_id,
    v_sucursal_id,
    p_producto_id,
    p_cubiculo_id,
    'RECEPCION',        -- TODO: si usas enum, ajustar
    p_cantidad,
    p_origen_logico,
    v_usuario_id,
    v_now
  );

end;
$$;