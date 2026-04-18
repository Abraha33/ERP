


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE TYPE "public"."arqueo_auditoria" AS ENUM (
    'PENDIENTE',
    'AUTORIZADO_ENCARGADO',
    'AUTORIZADO_ADMIN',
    'RECHAZADO'
);


ALTER TYPE "public"."arqueo_auditoria" OWNER TO "postgres";


CREATE TYPE "public"."arqueo_estado" AS ENUM (
    'BORRADOR',
    'ENVIADO',
    'CONFIRMADO'
);


ALTER TYPE "public"."arqueo_estado" OWNER TO "postgres";


CREATE TYPE "public"."arqueo_tipo" AS ENUM (
    'PARCIAL',
    'FINAL'
);


ALTER TYPE "public"."arqueo_tipo" OWNER TO "postgres";


CREATE TYPE "public"."bodegatipo" AS ENUM (
    'PRINCIPAL',
    'CUARENTENA',
    'MERMA',
    'DEVOLUCION',
    'TRANSITO'
);


ALTER TYPE "public"."bodegatipo" OWNER TO "postgres";


CREATE TYPE "public"."categoria_nivel" AS ENUM (
    'MADRE',
    'HIJA',
    'NIETA'
);


ALTER TYPE "public"."categoria_nivel" OWNER TO "postgres";


CREATE TYPE "public"."codigo_externo_tipo" AS ENUM (
    'SAE',
    'CODIGO_BARRAS',
    'CODIGO_PROVEEDOR',
    'OTRO'
);


ALTER TYPE "public"."codigo_externo_tipo" OWNER TO "postgres";


CREATE TYPE "public"."denominacion_tipo" AS ENUM (
    'BILLETE',
    'MONEDA'
);


ALTER TYPE "public"."denominacion_tipo" OWNER TO "postgres";


CREATE TYPE "public"."estado_autorizacion" AS ENUM (
    'PENDIENTE',
    'AUTORIZADO_ENCARGADO',
    'AUTORIZADO_ADMIN',
    'RECHAZADO'
);


ALTER TYPE "public"."estado_autorizacion" OWNER TO "postgres";


CREATE TYPE "public"."estado_factura" AS ENUM (
    'RECIBIDA',
    'PENDIENTE',
    'CON_DIFERENCIA'
);


ALTER TYPE "public"."estado_factura" OWNER TO "postgres";


CREATE TYPE "public"."estado_fisico" AS ENUM (
    'BUENO',
    'DANADO',
    'VENCIDO',
    'INCOMPLETO'
);


ALTER TYPE "public"."estado_fisico" OWNER TO "postgres";


CREATE TYPE "public"."estadofisico_tipo" AS ENUM (
    'BUENO',
    'DANADO',
    'VENCIDO',
    'INCOMPLETO'
);


ALTER TYPE "public"."estadofisico_tipo" OWNER TO "postgres";


CREATE TYPE "public"."facturacompra_estado" AS ENUM (
    'BORRADOR',
    'CONFIRMADA',
    'ANULADA'
);


ALTER TYPE "public"."facturacompra_estado" OWNER TO "postgres";


CREATE TYPE "public"."facturaventa_estado" AS ENUM (
    'EMITIDA',
    'ANULADA'
);


ALTER TYPE "public"."facturaventa_estado" OWNER TO "postgres";


CREATE TYPE "public"."jornada_estado" AS ENUM (
    'ABIERTA',
    'CERRADA'
);


ALTER TYPE "public"."jornada_estado" OWNER TO "postgres";


CREATE TYPE "public"."movimiento_caja_tipo" AS ENUM (
    'APERTURA',
    'INGRESO_MANUAL',
    'RETIRO',
    'AJUSTE'
);


ALTER TYPE "public"."movimiento_caja_tipo" OWNER TO "postgres";


CREATE TYPE "public"."movimiento_referencia_tipo" AS ENUM (
    'COMPRA',
    'VENTA',
    'TRASLADO',
    'AJUSTE_MANUAL',
    'DEVOLUCION'
);


ALTER TYPE "public"."movimiento_referencia_tipo" OWNER TO "postgres";


CREATE TYPE "public"."movimiento_tipo" AS ENUM (
    'INGRESO',
    'EGRESO',
    'RETIRO_VALORES',
    'DEVOLUCION'
);


ALTER TYPE "public"."movimiento_tipo" OWNER TO "postgres";


CREATE TYPE "public"."novedad_estado" AS ENUM (
    'REPORTADA',
    'EN_CUARENTENA',
    'MERMA_CONFIRMADA',
    'RESUELTA'
);


ALTER TYPE "public"."novedad_estado" OWNER TO "postgres";


CREATE TYPE "public"."novedad_tipo" AS ENUM (
    'FALTANTE',
    'DANADO',
    'EMPAQUE_ROTO',
    'VENCIDO'
);


ALTER TYPE "public"."novedad_tipo" OWNER TO "postgres";


CREATE TYPE "public"."ordencompra_estado" AS ENUM (
    'BORRADOR',
    'APROBADA',
    'EN_RECEPCION',
    'CERRADA',
    'ANULADA'
);


ALTER TYPE "public"."ordencompra_estado" OWNER TO "postgres";


CREATE TYPE "public"."ordenventa_canal" AS ENUM (
    'MAYORISTA',
    'TELEFONO',
    'ECOMMERCE_SOFT'
);


ALTER TYPE "public"."ordenventa_canal" OWNER TO "postgres";


CREATE TYPE "public"."ordenventa_estado" AS ENUM (
    'BORRADOR',
    'CONFIRMADO',
    'ENTREGADO',
    'CANCELADO',
    'CREADO',
    'EN_ARMADO',
    'ARMADO'
);


ALTER TYPE "public"."ordenventa_estado" OWNER TO "postgres";


CREATE TYPE "public"."otro_medio_pago" AS ENUM (
    'TARJETA_CREDITO',
    'TARJETA_DEBITO',
    'TRANSFERENCIA',
    'NEQUI',
    'DAVIPLATA',
    'OTRO'
);


ALTER TYPE "public"."otro_medio_pago" OWNER TO "postgres";


CREATE TYPE "public"."pedido_linea_estado" AS ENUM (
    'NORMAL',
    'PENDIENTE_STOCK'
);


ALTER TYPE "public"."pedido_linea_estado" OWNER TO "postgres";


CREATE TYPE "public"."producto_estado" AS ENUM (
    'ACTIVO',
    'PAUSADO',
    'DESCONTINUADO'
);


ALTER TYPE "public"."producto_estado" OWNER TO "postgres";


CREATE TYPE "public"."productounidad_tipostock" AS ENUM (
    'FISICA',
    'LOGICA'
);


ALTER TYPE "public"."productounidad_tipostock" OWNER TO "postgres";


CREATE TYPE "public"."recepcion_estado" AS ENUM (
    'BORRADOR',
    'CONFIRMADA',
    'ANULADA'
);


ALTER TYPE "public"."recepcion_estado" OWNER TO "postgres";


CREATE TYPE "public"."sugerencia_estado" AS ENUM (
    'PENDIENTE',
    'INCLUIDA_EN_OC',
    'DESCARTADA'
);


ALTER TYPE "public"."sugerencia_estado" OWNER TO "postgres";


CREATE TYPE "public"."tarea_estado" AS ENUM (
    'PENDIENTE',
    'EN_PROCESO',
    'COMPLETADA',
    'CANCELADA',
    'SUSPENDIDA'
);


ALTER TYPE "public"."tarea_estado" OWNER TO "postgres";


CREATE TYPE "public"."tarea_prioridad" AS ENUM (
    'BAJA',
    'MEDIA',
    'ALTA',
    'CRITICA'
);


ALTER TYPE "public"."tarea_prioridad" OWNER TO "postgres";


CREATE TYPE "public"."traslado_estado" AS ENUM (
    'BORRADOR',
    'ENVIADO',
    'APROBADO',
    'EN_TRANSITO',
    'COMPLETADO',
    'RECHAZADO',
    'ANULADO'
);


ALTER TYPE "public"."traslado_estado" OWNER TO "postgres";


CREATE TYPE "public"."turno_estado" AS ENUM (
    'ABIERTO',
    'PAUSADO',
    'CERRADO'
);


ALTER TYPE "public"."turno_estado" OWNER TO "postgres";


CREATE TYPE "public"."unidad_tipo" AS ENUM (
    'BASE',
    'AGRUPACION',
    'PESO',
    'VOLUMEN'
);


ALTER TYPE "public"."unidad_tipo" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."abrir_jornada"("p_sucursalid" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid     uuid := auth.uid();
  v_empresaid  uuid := public.current_empresa_id();
  v_jornada_id uuid;
  v_jornada    record;
begin
  if v_userid is null then
    return json_build_object('error', 'Usuario no autenticado');
  end if;

  if not exists (
    select 1 from public.sucursales
    where id = p_sucursalid and empresaid = v_empresaid
  ) then
    return json_build_object('error', 'Sucursal no valida para esta empresa');
  end if;

  select id, estado into v_jornada
  from public.jornadas
  where userid = v_userid
    and sucursalid = p_sucursalid
    and fecha = current_date
  limit 1;

  if v_jornada.id is not null and v_jornada.estado = 'CERRADA' then
    return json_build_object(
      'error', 'Ya existe una jornada cerrada para hoy',
      'jornada_id', v_jornada.id
    );
  end if;

  if v_jornada.id is not null and v_jornada.estado = 'ABIERTA' then
    return json_build_object(
      'ok', true,
      'mensaje', 'Jornada ya estaba abierta',
      'jornada_id', v_jornada.id
    );
  end if;

  insert into public.jornadas (
    empresaid, sucursalid, userid,
    fecha, horainicio, estado
  )
  values (
    v_empresaid, p_sucursalid, v_userid,
    current_date, now(), 'ABIERTA'
  )
  returning id into v_jornada_id;

  return json_build_object(
    'ok', true,
    'mensaje', 'Jornada abierta exitosamente',
    'jornada_id', v_jornada_id
  );
end;
$$;


ALTER FUNCTION "public"."abrir_jornada"("p_sucursalid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."abrir_turno"("p_jornadaid" "uuid", "p_cajaid" "uuid", "p_monto_sugerido" numeric DEFAULT 0, "p_monto_ajustado" numeric DEFAULT NULL::numeric, "p_nota_ajuste" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid          uuid    := auth.uid();
  v_empresaid       uuid    := public.current_empresa_id();
  v_sucursalid      uuid    := public.current_sucursal_id();
  v_turno_id        uuid;
  v_turno_orig      uuid;
  v_monto_apertura  numeric;
  v_estado_apertura text;
begin
  if v_userid is null then
    return json_build_object('error', 'Usuario no autenticado');
  end if;

  if not exists (
    select 1 from public.jornadas
    where id = p_jornadaid
      and userid = v_userid
      and estado = 'ABIERTA'
  ) then
    return json_build_object('error', 'Jornada no valida o no esta abierta');
  end if;

  if exists (
    select 1 from public.turnos
    where usuarioid = v_userid
      and estado = 'ABIERTO'
  ) then
    return json_build_object('error', 'Ya tienes un turno abierto. Cierralo o pausalo primero.');
  end if;

  if p_monto_ajustado is not null
     and p_monto_ajustado != p_monto_sugerido then
    v_monto_apertura  := p_monto_sugerido;
    v_estado_apertura := 'PENDIENTE_APROBACION';
  else
    v_monto_apertura  := p_monto_sugerido;
    v_estado_apertura := 'APROBADO';
  end if;

  select id into v_turno_orig
  from public.turnos
  where jornadaid = p_jornadaid
    and usuarioid = v_userid
    and estado = 'PAUSADO'
  order by createdat desc
  limit 1;

  insert into public.turnos (
    jornadaid, turnoorigenid,
    empresaid, sucursalid, cajaid, usuarioid,
    fechaapertura, estado, escierre_final,
    monto_apertura, monto_apertura_sugerido,
    monto_apertura_ajustado, estado_apertura,
    apertura_nota
  )
  values (
    p_jornadaid, v_turno_orig,
    v_empresaid, v_sucursalid, p_cajaid, v_userid,
    now(), 'ABIERTO', false,
    v_monto_apertura, p_monto_sugerido,
    p_monto_ajustado, v_estado_apertura,
    p_nota_ajuste
  )
  returning id into v_turno_id;

  insert into public.movimientos_caja (
    empresaid, sucursalid, cajaid,
    turnoid, jornadaid, registradopor,
    tipo, concepto, monto, fechahora
  )
  values (
    v_empresaid, v_sucursalid, p_cajaid,
    v_turno_id, p_jornadaid, v_userid,
    'INGRESO', 'Apertura de caja - Fondo inicial',
    v_monto_apertura, now()
  );

  return json_build_object(
    'ok', true,
    'turno_id', v_turno_id,
    'monto_apertura', v_monto_apertura,
    'estado_apertura', v_estado_apertura,
    'mensaje', case
      when v_estado_apertura = 'PENDIENTE_APROBACION'
      then 'Turno abierto. Ajuste de base pendiente de aprobacion del encargado.'
      else 'Turno abierto exitosamente.'
    end
  );
end;
$$;


ALTER FUNCTION "public"."abrir_turno"("p_jornadaid" "uuid", "p_cajaid" "uuid", "p_monto_sugerido" numeric, "p_monto_ajustado" numeric, "p_nota_ajuste" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."abrirjornada"("p_sucursalid" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_empresaid uuid;
  v_userid    uuid;
  v_fecha     date;
  v_jornadaid uuid;
  v_estado    text;
BEGIN
  -- Obtener contexto del usuario
  v_userid    := auth.uid();
  v_empresaid := (SELECT empresaid FROM user_profiles WHERE userid = v_userid LIMIT 1);
  v_fecha     := CURRENT_DATE;

  -- Verificar si ya existe jornada para hoy
  SELECT id, estado::text
  INTO v_jornadaid, v_estado
  FROM jornadas
  WHERE empresaid  = v_empresaid
    AND sucursalid = p_sucursalid
    AND userid     = v_userid
    AND fecha      = v_fecha
  LIMIT 1;

  -- Si existe y está cerrada, no se puede reabrir
  IF v_jornadaid IS NOT NULL AND v_estado = 'CERRADA' THEN
    RETURN json_build_object(
      'ok', false,
      'error', 'Ya existe una jornada cerrada para hoy. No se puede reabrir.'
    );
  END IF;

  -- Si ya existe y está abierta, devolverla
  IF v_jornadaid IS NOT NULL AND v_estado = 'ABIERTA' THEN
    RETURN json_build_object(
      'ok', true,
      'jornadaid', v_jornadaid,
      'mensaje', 'Jornada ya estaba abierta.'
    );
  END IF;

  -- Crear nueva jornada
  INSERT INTO jornadas (
    empresaid, sucursalid, userid,
    fecha, horainicio, estado,
    createdat, createdby, updatedat, updatedby
  )
  VALUES (
    v_empresaid, p_sucursalid, v_userid,
    v_fecha, now(), 'ABIERTA',
    now(), v_userid, now(), v_userid
  )
  RETURNING id INTO v_jornadaid;

  RETURN json_build_object(
    'ok', true,
    'jornadaid', v_jornadaid,
    'mensaje', 'Jornada abierta correctamente.'
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'ok', false,
    'error', SQLERRM
  );
END;
$$;


ALTER FUNCTION "public"."abrirjornada"("p_sucursalid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."abrirturno"("p_jornadaid" "uuid", "p_cajaid" "uuid", "p_montosugerido" numeric, "p_montoajustado" numeric DEFAULT NULL::numeric, "p_notaajuste" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid        uuid;
  v_empresaid     uuid;
  v_sucursalid    uuid;
  v_turnoid       uuid;
  v_estadoapertura text;
  v_montoapertura  numeric;
  v_jornada_estado text;
BEGIN
  v_userid    := auth.uid();
  v_empresaid := (SELECT empresaid  FROM user_profiles WHERE userid = v_userid LIMIT 1);
  v_sucursalid := (SELECT sucursalid FROM user_profiles WHERE userid = v_userid LIMIT 1);

  -- Validar que la jornada esté ABIERTA
  SELECT estado::text INTO v_jornada_estado
  FROM jornadas
  WHERE id = p_jornadaid AND empresaid = v_empresaid;

  IF v_jornada_estado IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Jornada no encontrada.');
  END IF;

  IF v_jornada_estado != 'ABIERTA' THEN
    RETURN json_build_object('ok', false, 'error', 'La jornada no está abierta.');
  END IF;

  -- Validar que el usuario no tenga turno ABIERTO o PAUSADO
  IF EXISTS (
    SELECT 1 FROM turnos
    WHERE usuarioid = v_userid
      AND estado IN ('ABIERTO', 'PAUSADO')
  ) THEN
    RETURN json_build_object('ok', false, 'error', 'Ya tienes un turno abierto o pausado.');
  END IF;

  -- Determinar monto apertura y estado apertura
  IF p_montoajustado IS NOT NULL
    AND p_montoajustado != p_montosugerido THEN
    v_estadoapertura := 'PENDIENTEAPROBACION';
    v_montoapertura  := p_montoajustado;
  ELSE
    v_estadoapertura := 'APROBADO';
    v_montoapertura  := COALESCE(p_montoajustado, p_montosugerido);
  END IF;

  -- Crear turno
  INSERT INTO turnos (
    jornadaid, empresaid, sucursalid, cajaid, usuarioid,
    fechaapertura, estado, escierre_final,
    monto_apertura, monto_apertura_sugerido, monto_apertura_ajustado,
    estado_apertura, apertura_nota,
    createdat, createdby, updatedat, updatedby
  )
  VALUES (
    p_jornadaid, v_empresaid, v_sucursalid, p_cajaid, v_userid,
    now(), 'ABIERTO', false,
    v_montoapertura, p_montosugerido, p_montoajustado,
    v_estadoapertura, p_notaajuste,
    now(), v_userid, now(), v_userid
  )
  RETURNING id INTO v_turnoid;

  -- Crear movimiento INGRESO de apertura si monto > 0
  IF v_montoapertura > 0 THEN
    INSERT INTO movimientos_caja (
      empresaid, sucursalid, cajaid, turnoid, jornadaid,
      registradopor, tipo, concepto, monto, fechahora,
      createdat, createdby, updatedat, updatedby
    )
    VALUES (
      v_empresaid, v_sucursalid, p_cajaid, v_turnoid, p_jornadaid,
      v_userid, 'INGRESO', 'Apertura de turno', v_montoapertura, now(),
      now(), v_userid, now(), v_userid
    );
  END IF;

  RETURN json_build_object(
    'ok',             true,
    'turnoid',        v_turnoid,
    'montoapertura',  v_montoapertura,
    'estadoapertura', v_estadoapertura
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."abrirturno"("p_jornadaid" "uuid", "p_cajaid" "uuid", "p_montosugerido" numeric, "p_montoajustado" numeric, "p_notaajuste" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."app_role"() RETURNS "text"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  r text;
begin
  select r2.codigo into r
  from public.user_roles ur
  join public.roles r2 on r2.id = ur.rolid
  where ur.userid = auth.uid()
    and ur.activo = true
  order by
    case r2.codigo
      when 'admin'     then 1
      when 'encargado' then 2
      when 'auditor'   then 3
      when 'cajero'    then 4
      when 'bodeguero' then 5
      when 'empleado'  then 6
      else                  7
    end
  limit 1;
  return r;
end;
$$;


ALTER FUNCTION "public"."app_role"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."aprobar_ajuste_apertura"("p_turnoid" "uuid", "p_aprobar" boolean, "p_nota" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid uuid := auth.uid();
  v_turno  record;
begin
  if public.app_role() not in ('encargado', 'admin') then
    return json_build_object('error', 'Solo el encargado o admin puede aprobar ajustes de apertura');
  end if;

  select * into v_turno
  from public.turnos
  where id = p_turnoid
    and estado_apertura = 'PENDIENTE_APROBACION';

  if v_turno.id is null then
    return json_build_object('error', 'Turno no valido o no tiene ajuste pendiente');
  end if;

  if p_aprobar then
    update public.turnos
    set
      monto_apertura            = monto_apertura_ajustado,
      estado_apertura           = 'AJUSTE_APROBADO',
      apertura_aprobada_por     = v_userid,
      apertura_fecha_aprobacion = now(),
      apertura_nota             = p_nota
    where id = p_turnoid;

    update public.movimientos_caja
    set monto = v_turno.monto_apertura_ajustado
    where turnoid = p_turnoid
      and tipo = 'INGRESO'
      and concepto like 'Apertura de caja%';

    return json_build_object(
      'ok', true,
      'mensaje', 'Ajuste de apertura aprobado',
      'monto_apertura_nuevo', v_turno.monto_apertura_ajustado
    );
  else
    update public.turnos
    set
      estado_apertura           = 'AJUSTE_RECHAZADO',
      apertura_aprobada_por     = v_userid,
      apertura_fecha_aprobacion = now(),
      apertura_nota             = p_nota
    where id = p_turnoid;

    return json_build_object(
      'ok', true,
      'mensaje', 'Ajuste rechazado. Se mantiene el monto sugerido original.',
      'monto_apertura_vigente', v_turno.monto_apertura_sugerido
    );
  end if;
end;
$$;


ALTER FUNCTION "public"."aprobar_ajuste_apertura"("p_turnoid" "uuid", "p_aprobar" boolean, "p_nota" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."aprobar_tarea"("p_tareaid" "uuid", "p_comentario" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid uuid := auth.uid();
begin
  if public.app_role() not in ('encargado', 'admin') then
    return json_build_object('error', 'Solo encargado o admin puede aprobar tareas');
  end if;

  if not exists (
    select 1 from public.tareas
    where id = p_tareaid
      and estado = 'COMPLETADA'
      and empresaid = public.current_empresa_id()
  ) then
    return json_build_object('error', 'Tarea no valida o no esta COMPLETADA');
  end if;

  -- La tarea ya está COMPLETADA, el encargado la valida
  -- agregamos comentario de aprobación
  update public.tareas
  set comentario = coalesce(p_comentario, comentario)
  where id = p_tareaid;

  return json_build_object(
    'ok', true,
    'tarea_id', p_tareaid,
    'mensaje', 'Tarea aprobada y cerrada'
  );
end;
$$;


ALTER FUNCTION "public"."aprobar_tarea"("p_tareaid" "uuid", "p_comentario" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."aprobarajusteapertura"("p_turnoid" "uuid", "p_aprobar" boolean, "p_nota" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid     uuid;
  v_rol        text;
  v_turno      record;
BEGIN
  v_userid := auth.uid();
  v_rol    := approle();

  -- Solo encargado o admin
  IF v_rol NOT IN ('encargado', 'admin') THEN
    RETURN json_build_object('ok', false, 'error', 'No tienes permisos para aprobar ajustes.');
  END IF;

  -- Obtener turno
  SELECT * INTO v_turno
  FROM turnos
  WHERE id = p_turnoid;

  IF v_turno IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Turno no encontrado.');
  END IF;

  IF v_turno.estado_apertura != 'PENDIENTEAPROBACION' THEN
    RETURN json_build_object('ok', false, 'error', 'Este turno no tiene un ajuste pendiente de aprobación.');
  END IF;

  IF p_aprobar THEN
    -- Aprobar: usar monto ajustado
    UPDATE turnos SET
      estado_apertura          = 'AJUSTEAPROBADO',
      monto_apertura           = monto_apertura_ajustado,
      apertura_aprobada_por    = v_userid,
      apertura_fecha_aprobacion = now(),
      apertura_nota            = p_nota,
      updatedat = now(), updatedby = v_userid
    WHERE id = p_turnoid;

    -- Actualizar movimiento de apertura con monto correcto
    UPDATE movimientos_caja SET
      monto     = v_turno.monto_apertura_ajustado,
      updatedat = now(), updatedby = v_userid
    WHERE turnoid = p_turnoid
      AND tipo    = 'INGRESO'
      AND concepto = 'Apertura de turno';

    RETURN json_build_object('ok', true, 'mensaje', 'Ajuste aprobado.');
  ELSE
    -- Rechazar: mantener monto sugerido
    UPDATE turnos SET
      estado_apertura          = 'AJUSTERECHAZADO',
      monto_apertura           = monto_apertura_sugerido,
      apertura_aprobada_por    = v_userid,
      apertura_fecha_aprobacion = now(),
      apertura_nota            = p_nota,
      updatedat = now(), updatedby = v_userid
    WHERE id = p_turnoid;

    -- Revertir movimiento de apertura al monto sugerido
    UPDATE movimientos_caja SET
      monto     = v_turno.monto_apertura_sugerido,
      updatedat = now(), updatedby = v_userid
    WHERE turnoid = p_turnoid
      AND tipo    = 'INGRESO'
      AND concepto = 'Apertura de turno';

    RETURN json_build_object('ok', true, 'mensaje', 'Ajuste rechazado. Se mantiene monto sugerido.');
  END IF;

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."aprobarajusteapertura"("p_turnoid" "uuid", "p_aprobar" boolean, "p_nota" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."aprobartarea"("p_tareaid" "uuid", "p_comentario" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid uuid;
  v_rol    text;
  v_tarea  record;
BEGIN
  v_userid := auth.uid();
  v_rol    := approle();

  IF v_rol NOT IN ('admin', 'encargado') THEN
    RETURN json_build_object('ok', false, 'error', 'Solo encargado o admin pueden aprobar tareas.');
  END IF;

  SELECT * INTO v_tarea
  FROM tareas
  WHERE id = p_tareaid;

  IF v_tarea IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Tarea no encontrada.');
  END IF;

  IF v_tarea.estado::text != 'COMPLETADA' THEN
    RETURN json_build_object('ok', false, 'error', 'Solo se puede aprobar una tarea en estado COMPLETADA.');
  END IF;

  UPDATE tareas SET
    comentario = COALESCE(p_comentario, comentario),
    updatedat  = now(),
    updatedby  = v_userid
  WHERE id = p_tareaid;

  RETURN json_build_object(
    'ok',      true,
    'tareaid', p_tareaid,
    'mensaje', 'Tarea aprobada.'
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."aprobartarea"("p_tareaid" "uuid", "p_comentario" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."autorizar_recepcion"("p_recepcion_id" "uuid", "p_aprobar" boolean, "p_nota" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid     uuid := auth.uid();
  v_recepcion  record;
  v_nuevo_estado text;
begin
  if public.app_role() not in ('encargado', 'admin') then
    return json_build_object('error', 'Solo encargado o admin puede autorizar recepciones');
  end if;

  select * into v_recepcion
  from public.oc_recepciones
  where id = p_recepcion_id
    and requiere_autorizacion = true
    and estado_autorizacion = 'PENDIENTE';

  if v_recepcion.id is null then
    return json_build_object('error', 'Recepcion no valida o no requiere autorizacion');
  end if;

  if p_aprobar then
    -- Encargado aprueba
    v_nuevo_estado := case
      when public.app_role() = 'admin' then 'AUTORIZADO_ADMIN'
      else 'AUTORIZADO_ENCARGADO'
    end;

    update public.oc_recepciones
    set
      estado_autorizacion   = v_nuevo_estado::public.estado_autorizacion,
      autorizado_por        = v_userid,
      fecha_autorizacion    = now(),
      nota_autorizacion     = p_nota,
      estado                = 'COMPLETADA'
    where id = p_recepcion_id;

    return json_build_object(
      'ok', true,
      'recepcion_id', p_recepcion_id,
      'estado_autorizacion', v_nuevo_estado,
      'mensaje', 'Recepcion autorizada. Inventario puede ser actualizado.'
    );
  else
    -- Encargado rechaza
    update public.oc_recepciones
    set
      estado_autorizacion = 'RECHAZADO'::public.estado_autorizacion,
      autorizado_por      = v_userid,
      fecha_autorizacion  = now(),
      nota_autorizacion   = p_nota,
      estado              = 'PENDIENTE'
    where id = p_recepcion_id;

    return json_build_object(
      'ok', true,
      'recepcion_id', p_recepcion_id,
      'estado_autorizacion', 'RECHAZADO',
      'mensaje', 'Recepcion rechazada. El bodeguero debe revisar y corregir.'
    );
  end if;
end;
$$;


ALTER FUNCTION "public"."autorizar_recepcion"("p_recepcion_id" "uuid", "p_aprobar" boolean, "p_nota" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."autorizarrecepcion"("p_recepcionid" "uuid", "p_aprobar" boolean, "p_nota" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid    uuid;
  v_rol       text;
  v_recepcion record;
  v_estadoaut text;
BEGIN
  v_userid := auth.uid();
  v_rol    := approle();

  IF v_rol NOT IN ('encargado', 'admin') THEN
    RETURN json_build_object('ok', false, 'error', 'Solo encargado o admin pueden autorizar recepciones.');
  END IF;

  SELECT * INTO v_recepcion
  FROM oc_recepciones
  WHERE id = p_recepcionid;

  IF v_recepcion IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Recepción no encontrada.');
  END IF;

  IF v_recepcion.estado != 'PENDIENTE' THEN
    RETURN json_build_object('ok', false, 'error', 'Solo se puede autorizar una recepción en estado PENDIENTE.');
  END IF;

  IF p_aprobar THEN
    v_estadoaut := CASE v_rol
      WHEN 'encargado' THEN 'AUTORIZADOENCARGADO'
      WHEN 'admin'     THEN 'AUTORIZADOADMIN'
    END;

    UPDATE oc_recepciones SET
      estado               = 'COMPLETADA',
      estado_autorizacion  = v_estadoaut::estadoautorizacion,
      autorizado_por       = v_userid,
      fecha_autorizacion   = now(),
      nota_autorizacion    = p_nota,
      updated_at           = now(),
      updated_by           = v_userid
    WHERE id = p_recepcionid;

    RETURN json_build_object(
      'ok',      true,
      'estado',  'COMPLETADA',
      'mensaje', 'Recepción autorizada y completada.'
    );
  ELSE
    UPDATE oc_recepciones SET
      estado              = 'PENDIENTE',
      estado_autorizacion = 'RECHAZADO'::estadoautorizacion,
      autorizado_por      = v_userid,
      fecha_autorizacion  = now(),
      nota_autorizacion   = p_nota,
      updated_at          = now(),
      updated_by          = v_userid
    WHERE id = p_recepcionid;

    RETURN json_build_object(
      'ok',      true,
      'estado',  'PENDIENTE',
      'mensaje', 'Recepción rechazada. Queda en PENDIENTE para corrección.'
    );
  END IF;

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."autorizarrecepcion"("p_recepcionid" "uuid", "p_aprobar" boolean, "p_nota" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."buscar_ocs_proveedor"("p_nombre_proveedor" "text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_empresaid  uuid := public.current_empresa_id();
  v_sucursalid uuid := public.current_sucursal_id();
  v_resultado  json;
begin
  if not public.has_role('bodeguero')
     and public.app_role() not in ('encargado','admin') then
    return json_build_object('error', 'Sin permisos para buscar OCs');
  end if;

  select json_agg(row_to_json(r)) into v_resultado
  from (
    select
      oc.idordencompra,
      oc.numoc,
      oc.fechaoc,
      oc.estado,
      p.razonsocial as proveedor,
      count(od.idoclinea)        as total_productos,
      sum(od.cantidad)           as total_unidades_pedidas,
      sum(od.cantidadrecibida)   as total_recibidas
    from public.ordenes_compra_encabezado oc
    join public.proveedores p  on p.idtercero    = oc.idproveedor
    join public.ordenes_compra_detalle od on od.idordencompra = oc.idordencompra
    where oc.empresaid  = v_empresaid
      and oc.idsucursal = v_sucursalid
      and oc.estado in ('APROBADA','PENDIENTE_RECEPCION')
      and p.razonsocial ilike '%' || p_nombre_proveedor || '%'
    group by oc.idordencompra, oc.numoc, oc.fechaoc, oc.estado, p.razonsocial
    order by oc.fechaoc desc
  ) r;

  return json_build_object(
    'ok', true,
    'resultado', coalesce(v_resultado, '[]'::json),
    'mensaje', case
      when v_resultado is null
      then 'No se encontraron OCs pendientes para ese proveedor'
      else 'OCs encontradas'
    end
  );
end;
$$;


ALTER FUNCTION "public"."buscar_ocs_proveedor"("p_nombre_proveedor" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."buscarocsproveedor"("p_nombreproveedor" "text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid    uuid;
  v_empresaid uuid;
  v_sucursalid uuid;
  v_rol       text;
  v_resultado json;
BEGIN
  v_userid     := auth.uid();
  v_empresaid  := (SELECT empresaid  FROM user_profiles WHERE userid = v_userid LIMIT 1);
  v_sucursalid := (SELECT sucursalid FROM user_profiles WHERE userid = v_userid LIMIT 1);
  v_rol        := approle();

  IF v_rol NOT IN ('bodeguero', 'encargado', 'admin') THEN
    RETURN json_build_object('ok', false, 'error', 'No tienes permisos para buscar órdenes de compra.');
  END IF;

  SELECT json_agg(row_to_json(r))
  INTO v_resultado
  FROM (
    SELECT
      o.id                AS ordenid,
      o.numero            AS numerorden,
      o.fecha,
      o.estado::text,
      p.razon_social      AS proveedor,
      COUNT(d.id)         AS totalproductos,
      SUM(d.cantidad)     AS totalunidades
    FROM ordenes_compra_encabezado o
    JOIN proveedores p ON p.id_tercero = o.proveedorid
    JOIN ordenes_compra_detalle d ON d.id_orden_compra = o.id
    WHERE o.empresa_id  = v_empresaid
      AND o.sucursal_id = v_sucursalid
      AND o.estado IN ('APROBADA', 'PENDIENTERECEPCION', 'EN_RECEPCION')
      AND p.razon_social ILIKE '%' || p_nombreproveedor || '%'
    GROUP BY o.id, o.numero, o.fecha, o.estado, p.razon_social
    ORDER BY o.fecha DESC
  ) r;

  RETURN json_build_object(
    'ok',        true,
    'resultado', COALESCE(v_resultado, '[]'::json)
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."buscarocsproveedor"("p_nombreproveedor" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."calcular_totales_arqueo"("p_arqueo_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_turno_id        uuid;
  v_empresaid       uuid;
  v_saldo_inicial   numeric;
  v_total_ventas    numeric := 0;
  v_total_dev       numeric := 0;
  v_total_gastos    numeric := 0;
  v_total_retiros   numeric := 0;
  v_neto_esperado   numeric := 0;
  v_total_contado   numeric := 0;
  v_diferencia      numeric := 0;
  v_tolerancia      numeric := 0;
  v_estado_audit    public.arqueo_auditoria;
begin
  -- Leer datos del arqueo
  select turnoid, empresaid, saldoinicial, totalcontado
  into v_turno_id, v_empresaid, v_saldo_inicial, v_total_contado
  from public.arqueos_caja
  where id = p_arqueo_id;

  if v_turno_id is null then
    return;
  end if;

  -- Sumar movimientos del turno por tipo
  select
    coalesce(sum(case when tipo = 'INGRESO'         then monto else 0 end), 0),
    coalesce(sum(case when tipo = 'DEVOLUCION'       then monto else 0 end), 0),
    coalesce(sum(case when tipo = 'EGRESO'           then monto else 0 end), 0),
    coalesce(sum(case when tipo = 'RETIRO_VALORES'   then monto else 0 end), 0)
  into v_total_ventas, v_total_dev, v_total_gastos, v_total_retiros
  from public.movimientos_caja
  where turnoid = v_turno_id;

  -- Calcular neto esperado
  v_neto_esperado := v_saldo_inicial
                   + v_total_ventas
                   - v_total_dev
                   - v_total_gastos
                   - v_total_retiros;

  -- Calcular diferencia
  v_diferencia := v_total_contado - v_neto_esperado;

  -- Leer tolerancia de config
  select coalesce(tolerancia_diferencia_arqueo, 0)
  into v_tolerancia
  from public.config_app_empresas
  where empresaid = v_empresaid
  limit 1;

  -- Determinar estado de auditoría según diferencia
  if abs(v_diferencia) <= v_tolerancia then
    v_estado_audit := 'PENDIENTE'; -- dentro de tolerancia, flujo normal
  else
    v_estado_audit := 'PENDIENTE'; -- fuera de tolerancia, requiere aprobación
  end if;

  -- Actualizar arqueo con todos los totales calculados
  update public.arqueos_caja
  set
    total_ventas        = v_total_ventas,
    total_devoluciones  = v_total_dev,
    total_gastos        = v_total_gastos,
    total_retiros       = v_total_retiros,
    total_neto_esperado = v_neto_esperado,
    diferencia          = v_diferencia,
    tolerancia_aplicada = v_tolerancia,
    -- Si diferencia supera tolerancia y arqueo está en borrador: marcar para revisión
    estado_auditoria = case
      when abs(v_diferencia) > v_tolerancia
        and estado in ('BORRADOR', 'ENVIADO')
      then 'PENDIENTE'::public.arqueo_auditoria
      else estado_auditoria
    end
  where id = p_arqueo_id;

end;
$$;


ALTER FUNCTION "public"."calcular_totales_arqueo"("p_arqueo_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."cerrar_jornada"("p_jornadaid" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid        uuid := auth.uid();
  v_turnos_abiertos integer;
  v_resumen       record;
begin
  if not exists (
    select 1 from public.jornadas
    where id = p_jornadaid
      and userid = v_userid
      and estado = 'ABIERTA'
  ) then
    return json_build_object('error', 'Jornada no valida o no esta abierta');
  end if;

  select count(*) into v_turnos_abiertos
  from public.turnos
  where jornadaid = p_jornadaid
    and estado in ('ABIERTO', 'PAUSADO');

  if v_turnos_abiertos > 0 then
    return json_build_object(
      'error', 'Hay turnos activos en esta jornada. Cierralos primero.',
      'turnos_pendientes', v_turnos_abiertos
    );
  end if;

  update public.jornadas
  set estado  = 'CERRADA',
      horafin = now()
  where id = p_jornadaid;

  select
    count(t.id)                          as total_turnos,
    sum(t.monto_apertura)                as total_apertura,
    sum(t.monto_retirado)                as total_retirado,
    sum(t.monto_dejado)                  as total_dejado,
    sum(a.total_ventas)                  as total_ventas,
    sum(a.total_devoluciones)            as total_devoluciones,
    sum(a.total_gastos)                  as total_gastos,
    sum(a.total_retiros)                 as total_retiros,
    sum(a.diferencia)                    as diferencia_total
  into v_resumen
  from public.turnos t
  left join public.arqueos_caja a on a.turnoid = t.id
  where t.jornadaid = p_jornadaid;

  return json_build_object(
    'ok',                true,
    'mensaje',           'Jornada cerrada exitosamente',
    'jornada_id',        p_jornadaid,
    'total_turnos',      v_resumen.total_turnos,
    'total_ventas',      v_resumen.total_ventas,
    'total_devoluciones', v_resumen.total_devoluciones,
    'total_gastos',      v_resumen.total_gastos,
    'total_retiros',     v_resumen.total_retiros,
    'total_retirado',    v_resumen.total_retirado,
    'total_dejado',      v_resumen.total_dejado,
    'diferencia_total',  v_resumen.diferencia_total
  );
end;
$$;


ALTER FUNCTION "public"."cerrar_jornada"("p_jornadaid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."cerrar_recepcion"("p_recepcion_id" "uuid", "p_comentario" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid         uuid := auth.uid();
  v_recepcion      record;
  v_diferencias    json;
  v_total_contados integer;
begin
  select * into v_recepcion
  from public.oc_recepciones
  where id = p_recepcion_id
    and empleado_id = v_userid
    and estado = 'PENDIENTE';

  if v_recepcion.id is null then
    return json_build_object('error', 'Recepcion no valida');
  end if;

  select count(*) into v_total_contados
  from public.oc_recepcion_conteo
  where recepcionid = p_recepcion_id;

  if v_total_contados = 0 then
    return json_build_object(
      'error', 'Debes registrar al menos un producto antes de cerrar'
    );
  end if;

  -- Productos con diferencia de precio o estado fisico malo
  select json_agg(row_to_json(r)) into v_diferencias
  from (
    select
      pr.nombre       as producto,
      pr.skucodigo,
      c.cantidad_oc,
      c.cantidad_recibida,
      c.precio_oc,
      c.precio_factura,
      c.diferencia_precio,
      c.estado_fisico
    from public.oc_recepcion_conteo c
    join public.productos pr on pr.id_producto = c.productoid
    where c.recepcionid = p_recepcion_id
      and (c.diferencia_precio != 0 or c.estado_fisico != 'BUENO')
    order by pr.nombre
  ) r;

  -- Actualizar recepcion con totales
  update public.oc_recepciones
  set
    estado = case
      when v_recepcion.requiere_autorizacion
      then 'PENDIENTE'
      else 'COMPLETADA'
    end,
    comentario           = p_comentario,
    precio_oc_total      = (
      select sum(precio_oc * cantidad_recibida)
      from public.oc_recepcion_conteo
      where recepcionid = p_recepcion_id
    ),
    precio_factura_total = (
      select sum(coalesce(precio_factura, precio_oc) * cantidad_recibida)
      from public.oc_recepcion_conteo
      where recepcionid = p_recepcion_id
    ),
    diferencia_precio    = (
      select sum(coalesce(diferencia_precio,0) * cantidad_recibida)
      from public.oc_recepcion_conteo
      where recepcionid = p_recepcion_id
    )
  where id = p_recepcion_id;

  return json_build_object(
    'ok',                       true,
    'recepcion_id',             p_recepcion_id,
    'total_productos_contados', v_total_contados,
    'requiere_autorizacion',    v_recepcion.requiere_autorizacion,
    'productos_con_diferencias', coalesce(v_diferencias, '[]'::json),
    'mensaje', case
      when v_recepcion.requiere_autorizacion
      then 'Recepcion cerrada con diferencias. Requiere autorizacion del encargado.'
      else 'Recepcion completada exitosamente.'
    end
  );
end;
$$;


ALTER FUNCTION "public"."cerrar_recepcion"("p_recepcion_id" "uuid", "p_comentario" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."cerrar_turno"("p_turnoid" "uuid", "p_total_contado" numeric, "p_monto_dejado" numeric DEFAULT 0, "p_monto_retirado" numeric DEFAULT 0, "p_es_cierre_final" boolean DEFAULT false) RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid     uuid    := auth.uid();
  v_empresaid  uuid    := public.current_empresa_id();
  v_sucursalid uuid    := public.current_sucursal_id();
  v_turno      record;
  v_arqueo_id  uuid;
  v_diferencia numeric;
  v_tolerancia numeric := 0;
begin
  select * into v_turno
  from public.turnos
  where id = p_turnoid
    and usuarioid = v_userid
    and estado in ('ABIERTO', 'PAUSADO');

  if v_turno.id is null then
    return json_build_object('error', 'Turno no valido o no esta activo');
  end if;

  if p_total_contado != (p_monto_dejado + p_monto_retirado) then
    return json_build_object(
      'error',         'El total contado debe ser igual a monto dejado + monto retirado',
      'total_contado',  p_total_contado,
      'monto_dejado',   p_monto_dejado,
      'monto_retirado', p_monto_retirado,
      'suma_esperada',  p_monto_dejado + p_monto_retirado
    );
  end if;

  select coalesce(tolerancia_diferencia_arqueo, 0)
  into v_tolerancia
  from public.config_app_empresas
  where empresaid = v_empresaid
  limit 1;

  update public.turnos
  set
    estado         = 'CERRADO',
    fechacierre    = now(),
    escierre_final = p_es_cierre_final,
    monto_dejado   = p_monto_dejado,
    monto_retirado = p_monto_retirado
  where id = p_turnoid;

  insert into public.arqueos_caja (
    empresaid, sucursalid, cajaid,
    turnoid, jornadaid, responsableid,
    tipo, estado, fechaarqueo,
    saldoinicial, totalcontado,
    monto_dejado, monto_retirado,
    tolerancia_aplicada
  )
  values (
    v_empresaid, v_sucursalid, v_turno.cajaid,
    p_turnoid, v_turno.jornadaid, v_userid,
    case when p_es_cierre_final
         then 'FINAL'::public.arqueo_tipo
         else 'PARCIAL'::public.arqueo_tipo end,
    'BORRADOR'::public.arqueo_estado,
    now(),
    v_turno.monto_apertura,
    p_total_contado,
    p_monto_dejado,
    p_monto_retirado,
    v_tolerancia
  )
  returning id into v_arqueo_id;

  -- trigger trg_arqueo_calcular_totales se dispara aqui automaticamente

  select diferencia into v_diferencia
  from public.arqueos_caja
  where id = v_arqueo_id;

  return json_build_object(
    'ok',        true,
    'turno_id',  p_turnoid,
    'arqueo_id', v_arqueo_id,
    'diferencia', v_diferencia,
    'tolerancia', v_tolerancia,
    'requiere_aprobacion', abs(v_diferencia) > v_tolerancia,
    'mensaje', case
      when abs(v_diferencia) <= v_tolerancia
      then 'Turno cerrado. Cuadre dentro de tolerancia.'
      else 'Turno cerrado con diferencia. Requiere aprobacion del encargado.'
    end
  );
end;
$$;


ALTER FUNCTION "public"."cerrar_turno"("p_turnoid" "uuid", "p_total_contado" numeric, "p_monto_dejado" numeric, "p_monto_retirado" numeric, "p_es_cierre_final" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."cerrarjornada"("p_jornadaid" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid       uuid;
  v_rol          text;
  v_jornada      record;
  v_turnosabiert integer;
  v_resumen      record;
BEGIN
  v_userid := auth.uid();
  v_rol    := approle();

  IF v_rol NOT IN ('encargado', 'admin') THEN
    RETURN json_build_object('ok', false, 'error', 'Solo encargado o admin pueden cerrar la jornada.');
  END IF;

  SELECT * INTO v_jornada
  FROM jornadas
  WHERE id = p_jornadaid;

  IF v_jornada IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Jornada no encontrada.');
  END IF;

  IF v_jornada.estado::text != 'ABIERTA' THEN
    RETURN json_build_object('ok', false, 'error', 'La jornada ya está cerrada.');
  END IF;

  -- Verificar que todos los turnos estén CERRADOS
  SELECT COUNT(*) INTO v_turnosabiert
  FROM turnos
  WHERE jornadaid = p_jornadaid
    AND estado IN ('ABIERTO', 'PAUSADO');

  IF v_turnosabiert > 0 THEN
    RETURN json_build_object(
      'ok', false,
      'error', 'Hay ' || v_turnosabiert || ' turno(s) aún abiertos o pausados.'
    );
  END IF;

  -- Calcular resumen del día
  SELECT
    COUNT(DISTINCT t.id)                                                AS totalturnos,
    COALESCE(SUM(CASE WHEN mc.tipo = 'INGRESO'       THEN mc.monto END), 0) AS totalventas,
    COALESCE(SUM(CASE WHEN mc.tipo = 'EGRESO'        THEN mc.monto END), 0) AS totalgastos,
    COALESCE(SUM(CASE WHEN mc.tipo = 'RETIROVALORES' THEN mc.monto END), 0) AS totalretiros,
    COALESCE(SUM(CASE WHEN mc.tipo = 'DEVOLUCION'    THEN mc.monto END), 0) AS totaldevoluciones,
    COALESCE(SUM(t.monto_dejado),   0)                                  AS totaldejado,
    COALESCE(SUM(t.monto_retirado), 0)                                  AS totalretirado
  INTO v_resumen
  FROM turnos t
  LEFT JOIN movimientos_caja mc ON mc.turnoid = t.id
  WHERE t.jornadaid = p_jornadaid;

  -- Cerrar jornada
  UPDATE jornadas SET
    estado    = 'CERRADA',
    horafin   = now(),
    updatedat = now(),
    updatedby = v_userid
  WHERE id = p_jornadaid;

  RETURN json_build_object(
    'ok',               true,
    'jornadaid',        p_jornadaid,
    'totalturnos',      v_resumen.totalturnos,
    'totalventas',      v_resumen.totalventas,
    'totalgastos',      v_resumen.totalgastos,
    'totalretiros',     v_resumen.totalretiros,
    'totaldevoluciones', v_resumen.totaldevoluciones,
    'totaldejado',      v_resumen.totaldejado,
    'totalretirado',    v_resumen.totalretirado
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."cerrarjornada"("p_jornadaid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."cerrarrecepcion"("p_recepcionid" "uuid", "p_comentario" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid       uuid;
  v_recepcion    record;
  v_totales      record;
  v_diferencias  json;
  v_estadofinal  text;
BEGIN
  v_userid := auth.uid();

  SELECT * INTO v_recepcion
  FROM oc_recepciones
  WHERE id = p_recepcionid;

  IF v_recepcion IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Recepción no encontrada.');
  END IF;

  IF v_recepcion.estado != 'PENDIENTE' THEN
    RETURN json_build_object('ok', false, 'error', 'Solo se puede cerrar una recepción en estado PENDIENTE.');
  END IF;

  -- Validar al menos 1 producto contado
  IF NOT EXISTS (
    SELECT 1 FROM oc_recepcion_conteo
    WHERE recepcionid = p_recepcionid
  ) THEN
    RETURN json_build_object('ok', false, 'error', 'Debe contar al menos 1 producto antes de cerrar.');
  END IF;

  -- Calcular totales
  SELECT
    SUM(precio_oc      * cantidad_recibida) AS total_oc,
    SUM(precio_factura * cantidad_recibida) AS total_factura,
    SUM(diferencia_precio * cantidad_recibida) AS diferencia_total
  INTO v_totales
  FROM oc_recepcion_conteo
  WHERE recepcionid = p_recepcionid;

  -- Determinar estado final
  v_estadofinal := CASE
    WHEN v_recepcion.requiere_autorizacion THEN 'PENDIENTE'
    ELSE 'COMPLETADA'
  END;

  -- Obtener lista de productos con diferencias
  SELECT json_agg(row_to_json(r))
  INTO v_diferencias
  FROM (
    SELECT
      productoid,
      precio_oc,
      precio_factura,
      diferencia_precio,
      estado_fisico::text,
      cantidad_recibida
    FROM oc_recepcion_conteo
    WHERE recepcionid = p_recepcionid
      AND (diferencia_precio != 0 OR estado_fisico::text != 'BUENO')
  ) r;

  -- Actualizar recepción
  UPDATE oc_recepciones SET
    estado               = v_estadofinal,
    comentario           = COALESCE(p_comentario, comentario),
    precio_oc_total      = v_totales.total_oc,
    precio_factura_total = v_totales.total_factura,
    diferencia_precio    = v_totales.diferencia_total,
    updated_at           = now(),
    updated_by           = v_userid
  WHERE id = p_recepcionid;

  RETURN json_build_object(
    'ok',                true,
    'recepcionid',       p_recepcionid,
    'estado',            v_estadofinal,
    'totaloc',           v_totales.total_oc,
    'totalfactura',      v_totales.total_factura,
    'diferencia',        v_totales.diferencia_total,
    'requiereautorizacion', v_recepcion.requiere_autorizacion,
    'diferencias',       COALESCE(v_diferencias, '[]'::json)
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."cerrarrecepcion"("p_recepcionid" "uuid", "p_comentario" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."cerrarturno"("p_turnoid" "uuid", "p_totalcontado" numeric, "p_montodejado" numeric, "p_montoretirado" numeric, "p_escierrefinal" boolean DEFAULT false) RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid        uuid;
  v_turno         record;
  v_config        record;
  v_arqueoid      uuid;
  v_arqueotipo    text;
  v_diferencia    numeric;
  v_tolerancia    numeric;
  v_reqaprobacion boolean;
  v_totalsistema  numeric;
BEGIN
  v_userid := auth.uid();

  -- Obtener turno
  SELECT * INTO v_turno
  FROM turnos
  WHERE id = p_turnoid;

  IF v_turno IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Turno no encontrado.');
  END IF;

  IF v_turno.usuarioid != v_userid THEN
    RETURN json_build_object('ok', false, 'error', 'No puedes cerrar un turno que no es tuyo.');
  END IF;

  IF v_turno.estado::text NOT IN ('ABIERTO', 'PAUSADO') THEN
    RETURN json_build_object('ok', false, 'error', 'Solo se puede cerrar un turno ABIERTO o PAUSADO.');
  END IF;

  -- Validar distribución del dinero
  IF p_totalcontado != p_montodejado + p_montoretirado THEN
    RETURN json_build_object(
      'ok', false,
      'error', 'El total contado debe ser igual a monto dejado + monto retirado.'
    );
  END IF;

  -- Obtener tolerancia de config
  SELECT tolerancia_diferencia_arqueo
  INTO v_tolerancia
  FROM config_app_empresas
  WHERE empresaid = v_turno.empresaid
  LIMIT 1;

  v_tolerancia := COALESCE(v_tolerancia, 0);

  -- Calcular total según sistema (movimientos del turno)
  SELECT
    v_turno.monto_apertura
    + COALESCE(SUM(CASE WHEN tipo = 'INGRESO'       THEN monto ELSE 0 END), 0)
    - COALESCE(SUM(CASE WHEN tipo = 'EGRESO'        THEN monto ELSE 0 END), 0)
    - COALESCE(SUM(CASE WHEN tipo = 'RETIROVALORES' THEN monto ELSE 0 END), 0)
    - COALESCE(SUM(CASE WHEN tipo = 'DEVOLUCION'    THEN monto ELSE 0 END), 0)
  INTO v_totalsistema
  FROM movimientos_caja
  WHERE turnoid = p_turnoid;

  v_diferencia    := p_totalcontado - v_totalsistema;
  v_reqaprobacion := ABS(v_diferencia) > v_tolerancia;
  v_arqueotipo    := CASE WHEN p_escierrefinal THEN 'FINAL' ELSE 'PARCIAL' END;

  -- Cerrar turno
  UPDATE turnos SET
    estado         = 'CERRADO',
    escierre_final = p_escierrefinal,
    fechacierre    = now(),
    monto_dejado   = p_montodejado,
    monto_retirado = p_montoretirado,
    updatedat      = now(),
    updatedby      = v_userid
  WHERE id = p_turnoid;

  -- Crear arqueo en BORRADOR
  INSERT INTO arqueos_caja (
    empresaid, sucursalid, cajaid, turnoid, jornadaid,
    responsableid, tipo, estado, estado_auditoria,
    fechaarqueo, saldoinicial, totalcontado,
    totalsegunsistema, diferencia,
    tolerancia_aplicada, monto_dejado, monto_retirado,
    createdat, createdby, updatedat, updatedby
  )
  VALUES (
    v_turno.empresaid, v_turno.sucursalid,
    v_turno.cajaid, p_turnoid, v_turno.jornadaid,
    v_userid, v_arqueotipo::arqueotipo, 'BORRADOR', 'PENDIENTE',
    now(), v_turno.monto_apertura, p_totalcontado,
    v_totalsistema, v_diferencia,
    v_tolerancia, p_montodejado, p_montoretirado,
    now(), v_userid, now(), v_userid
  )
  RETURNING id INTO v_arqueoid;

  RETURN json_build_object(
    'ok',               true,
    'turnoid',          p_turnoid,
    'arqueoid',         v_arqueoid,
    'diferencia',       v_diferencia,
    'tolerancia',       v_tolerancia,
    'requiereaprobacion', v_reqaprobacion
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."cerrarturno"("p_turnoid" "uuid", "p_totalcontado" numeric, "p_montodejado" numeric, "p_montoretirado" numeric, "p_escierrefinal" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."completar_tarea"("p_tareaid" "uuid", "p_comentario" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid    uuid := auth.uid();
  v_tarea     record;
  v_tipo_cod  text;
begin
  select t.*, tt.categoria
  into v_tarea
  from public.tareas t
  join public.tipos_tarea tt on tt.id = t.tipotareaid
  where t.id = p_tareaid
    and t.asignadaa = v_userid
    and t.estado in ('EN_PROCESO', 'SUSPENDIDA');

  if v_tarea.id is null then
    return json_build_object('error', 'Tarea no valida o no puede completarse en su estado actual');
  end if;

  -- Validar que traslado tenga al menos un producto registrado
  if v_tarea.categoria = 'traslado' then
    if not exists (
      select 1 from public.tareas_detalle_traslado
      where tareaid = p_tareaid
    ) then
      return json_build_object(
        'error', 'Debes registrar los productos trasladados antes de completar'
      );
    end if;
  end if;

  update public.tareas
  set estado     = 'COMPLETADA',
      fechafin   = now(),
      comentario = coalesce(p_comentario, comentario)
  where id = p_tareaid;

  return json_build_object(
    'ok', true,
    'tarea_id', p_tareaid,
    'mensaje', 'Tarea completada. Pendiente de revision por el encargado.'
  );
end;
$$;


ALTER FUNCTION "public"."completar_tarea"("p_tareaid" "uuid", "p_comentario" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."completartarea"("p_tareaid" "uuid", "p_comentario" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid    uuid;
  v_tarea     record;
  v_tipotarea record;
BEGIN
  v_userid := auth.uid();

  SELECT * INTO v_tarea
  FROM tareas
  WHERE id = p_tareaid;

  IF v_tarea IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Tarea no encontrada.');
  END IF;

  IF v_tarea.asignadaa != v_userid THEN
    RETURN json_build_object('ok', false, 'error', 'Solo el colaborador asignado puede completar esta tarea.');
  END IF;

  IF v_tarea.estado::text NOT IN ('ENPROCESO', 'SUSPENDIDA') THEN
    RETURN json_build_object('ok', false, 'error', 'Solo se puede completar una tarea en estado ENPROCESO o SUSPENDIDA.');
  END IF;

  -- Obtener tipo de tarea
  SELECT * INTO v_tipotarea
  FROM tipos_tarea
  WHERE id = v_tarea.tipotareaid;

  -- Si categoría es traslado, validar que exista al menos 1 línea en tareas_detalle_traslado
  IF v_tipotarea.categoria = 'traslado' THEN
    IF NOT EXISTS (
      SELECT 1 FROM tareas_detalle_traslado
      WHERE tareaid = p_tareaid
    ) THEN
      RETURN json_build_object(
        'ok', false,
        'error', 'Una tarea de traslado debe tener al menos 1 producto registrado.'
      );
    END IF;
  END IF;

  UPDATE tareas SET
    estado     = 'COMPLETADA',
    fechafin   = now(),
    comentario = COALESCE(p_comentario, comentario),
    updatedat  = now(),
    updatedby  = v_userid
  WHERE id = p_tareaid;

  RETURN json_build_object(
    'ok',      true,
    'tareaid', p_tareaid,
    'mensaje', 'Tarea completada.'
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."completartarea"("p_tareaid" "uuid", "p_comentario" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."crear_pedido_venta"("p_pedido" "jsonb") RETURNS "jsonb"
    LANGUAGE "plpgsql"
    SET "search_path" TO ''
    AS $$
DECLARE
    v_user_id uuid;
BEGIN
    v_user_id := auth.uid();

    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Usuario no autenticado';
    END IF;

    -- resto de la lógica...

    RETURN '{}'::jsonb;
END;
$$;


ALTER FUNCTION "public"."crear_pedido_venta"("p_pedido" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."crear_tarea"("p_sucursalid" "uuid", "p_asignadaa" "uuid", "p_tipotareaid" "uuid", "p_descripcion" "text", "p_prioridad" "public"."tarea_prioridad" DEFAULT 'MEDIA'::"public"."tarea_prioridad", "p_jornadaid" "uuid" DEFAULT NULL::"uuid", "p_referenciaid" "uuid" DEFAULT NULL::"uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid    uuid := auth.uid();
  v_empresaid uuid := public.current_empresa_id();
  v_tarea_id  uuid;
begin
  if public.app_role() not in ('admin', 'encargado') then
    return json_build_object('error', 'Solo admin o encargado puede crear tareas');
  end if;

  if not exists (
    select 1 from public.user_profiles
    where userid = p_asignadaa
      and empresaid = v_empresaid
      and activo = true
  ) then
    return json_build_object('error', 'El colaborador asignado no existe o no esta activo');
  end if;

  if not exists (
    select 1 from public.tipos_tarea
    where id = p_tipotareaid
      and empresaid = v_empresaid
      and activo = true
  ) then
    return json_build_object('error', 'Tipo de tarea no valido');
  end if;

  insert into public.tareas (
    empresaid, sucursalid, jornadaid,
    tipotareaid, asignadapor, asignadaa,
    descripcion, estado, prioridad,
    referenciaid, fechaprogramada
  )
  values (
    v_empresaid, p_sucursalid, p_jornadaid,
    p_tipotareaid, v_userid, p_asignadaa,
    p_descripcion, 'PENDIENTE', p_prioridad,
    p_referenciaid, now()
  )
  returning id into v_tarea_id;

  return json_build_object(
    'ok', true,
    'tarea_id', v_tarea_id,
    'mensaje', 'Tarea creada y asignada exitosamente'
  );
end;
$$;


ALTER FUNCTION "public"."crear_tarea"("p_sucursalid" "uuid", "p_asignadaa" "uuid", "p_tipotareaid" "uuid", "p_descripcion" "text", "p_prioridad" "public"."tarea_prioridad", "p_jornadaid" "uuid", "p_referenciaid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."creartarea"("p_sucursalid" "uuid", "p_asignadaa" "uuid", "p_tipotareaid" "uuid", "p_descripcion" "text", "p_prioridad" "public"."tarea_prioridad" DEFAULT 'MEDIA'::"public"."tarea_prioridad", "p_jornadaid" "uuid" DEFAULT NULL::"uuid", "p_referenciaid" "uuid" DEFAULT NULL::"uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid    uuid;
  v_empresaid uuid;
  v_rol       text;
  v_tareaid   uuid;
BEGIN
  v_userid    := auth.uid();
  v_empresaid := (SELECT empresaid FROM user_profiles WHERE userid = v_userid LIMIT 1);
  v_rol       := approle();

  IF v_rol NOT IN ('admin', 'encargado') THEN
    RETURN json_build_object('ok', false, 'error', 'No tienes permisos para crear tareas.');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM user_profiles
    WHERE userid    = p_asignadaa
      AND empresaid = v_empresaid
      AND activo    = true
  ) THEN
    RETURN json_build_object('ok', false, 'error', 'El colaborador no está activo en esta empresa.');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM tipos_tarea
    WHERE id        = p_tipotareaid
      AND empresaid = v_empresaid
      AND activo    = true
  ) THEN
    RETURN json_build_object('ok', false, 'error', 'El tipo de tarea no existe o está inactivo.');
  END IF;

  INSERT INTO tareas (
    empresaid, sucursalid, jornadaid, tipotareaid,
    asignadapor, asignadaa, descripcion,
    estado, prioridad, referenciaid,
    createdat, createdby, updatedat, updatedby
  )
  VALUES (
    v_empresaid, p_sucursalid, p_jornadaid, p_tipotareaid,
    v_userid, p_asignadaa, p_descripcion,
    'PENDIENTE', p_prioridad, p_referenciaid,
    now(), v_userid, now(), v_userid
  )
  RETURNING id INTO v_tareaid;

  RETURN json_build_object(
    'ok',      true,
    'tareaid', v_tareaid,
    'mensaje', 'Tarea creada correctamente.'
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."creartarea"("p_sucursalid" "uuid", "p_asignadaa" "uuid", "p_tipotareaid" "uuid", "p_descripcion" "text", "p_prioridad" "public"."tarea_prioridad", "p_jornadaid" "uuid", "p_referenciaid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."current_empresa_id"() RETURNS "uuid"
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  r uuid;
begin
  select p.empresaid into r
  from public.user_profiles p
  where p.userid = auth.uid()
  limit 1;
  return r;
end;
$$;


ALTER FUNCTION "public"."current_empresa_id"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."current_sucursal_id"() RETURNS "uuid"
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  SELECT sucursalid
  FROM public.user_profiles
  WHERE userid = auth.uid()
  LIMIT 1;
$$;


ALTER FUNCTION "public"."current_sucursal_id"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."current_user_id"() RETURNS "uuid"
    LANGUAGE "sql" STABLE
    SET "search_path" TO ''
    AS $$
  select auth.uid();
$$;


ALTER FUNCTION "public"."current_user_id"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_actualizar_stock"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO ''
    AS $$
BEGIN
  -- ENTRADA o DEVOLUCION: suma en destino
  IF NEW.tipo IN ('ENTRADA', 'DEVOLUCION') THEN
    INSERT INTO stockubicacion (
      id, ubicacionid, empresaid, sucursalid, bodegaid,
      productoid, varianteid, cantactual,
      ultimaactualizacion
    )
    VALUES (
      gen_random_uuid(),
      NEW.ubicaciondestinoid,
      NEW.empresaid,
      NEW.sucursalid,
      NEW.bodegadestinoid,
      NEW.productoid,
      NEW.varianteid,
      NEW.cantidadbase,
      now()
    )
    ON CONFLICT (ubicacionid, productoid, varianteid)
    DO UPDATE SET
      cantactual           = stockubicacion.cantactual + EXCLUDED.cantactual,
      ultimaactualizacion  = now();

  -- SALIDA: resta en origen
  ELSIF NEW.tipo = 'SALIDA' THEN
    UPDATE stockubicacion
    SET
      cantactual          = cantactual - NEW.cantidadbase,
      ultimaactualizacion = now()
    WHERE ubicacionid = NEW.ubicacionorigenid
      AND productoid  = NEW.productoid
      AND (varianteid = NEW.varianteid OR (varianteid IS NULL AND NEW.varianteid IS NULL));

  -- AJUSTE: puede ser positivo o negativo, aplica en origen
  ELSIF NEW.tipo = 'AJUSTE' THEN
    UPDATE stockubicacion
    SET
      cantactual          = cantactual + NEW.cantidadbase,
      ultimaactualizacion = now()
    WHERE ubicacionid = NEW.ubicacionorigenid
      AND productoid  = NEW.productoid
      AND (varianteid = NEW.varianteid OR (varianteid IS NULL AND NEW.varianteid IS NULL));

  -- TRASLADO: se maneja con dos movimientos vinculados (SALIDA + ENTRADA)
  -- cada uno actualiza su lado, no se hace nada extra aquí
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."fn_actualizar_stock"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_confirmar_recepcion"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO ''
    AS $$
BEGIN
  -- Solo actúa cuando el estado cambia a CONFIRMADA
  IF NEW.estado = 'CONFIRMADA' AND OLD.estado != 'CONFIRMADA' THEN

    -- Insertar un movimiento ENTRADA por cada línea de la recepción
    INSERT INTO movimientosinventario (
      empresaid, sucursalid, tipo,
      productoid, varianteid,
      unidadid, cantidad, cantidadbase,
      bodegadestinoid, ubicaciondestinoid,
      referenciatipo, referenciaid,
      fechamovimiento, usuarioid
    )
    SELECT
      NEW.empresaid,
      NEW.sucursalid,
      'ENTRADA'::movimiento_tipo,
      d.productoid,
      d.varianteid,
      d.unidadid,
      d.cantidad,
      d.cantidadbase,
      NEW.bodegaid,
      d.ubicacionid,
      'COMPRA'::movimiento_referencia_tipo,
      NEW.id,
      now(),
      NEW.updatedby
    FROM recepcionescompradetalle d
    WHERE d.recepcionid = NEW.id;

    -- Actualizar cantidadrecibida en el detalle de la orden
    UPDATE ordenescompradetalle od
    SET cantidadrecibida = cantidadrecibida + d.cantidadbase
    FROM recepcionescompradetalle d
    WHERE d.recepcionid = NEW.id
      AND d.ordendetalleid = od.id;

  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."fn_confirmar_recepcion"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_confirmar_traslado"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO ''
    AS $$
BEGIN
  -- Solo actúa cuando estado cambia a 'confirmado' o 'CONFIRMADO'
  IF LOWER(NEW.estado) = 'confirmado' AND LOWER(OLD.estado) != 'confirmado' THEN

    -- 1) SALIDA desde bodega origen
    INSERT INTO movimientosinventario (
      empresaid, sucursalid,
      tipo,
      productoid, varianteid,
      unidadid, cantidad, cantidadbase,
      bodegaorigenid, ubicacionorigenid,
      referenciatipo, referenciaid,
      fechamovimiento, usuarioid
    )
    SELECT
      NEW.empresa_id,
      NEW.id_sucursal_origen,
      'SALIDA'::movimiento_tipo,
      d.id_producto,
      NULL,                         -- variante: ajustar si tienes UUID de variante
      (SELECT id FROM unidadesmedida
       WHERE codigo = d.um_traslado
         AND empresaid = NEW.empresa_id
       LIMIT 1),
      d.cantidad,
      d.cantidad,                   -- cantidadbase: ajustar si hay conversión
      NEW.id_bodega_origen,
      NULL,                         -- ubicacionorigenid: sin ubicación específica por ahora
      'TRASLADO'::movimiento_referencia_tipo,
      NEW.id,
      now(),
      NEW.updated_by
    FROM traslados_detalle d
    WHERE d.id_traslado = NEW.id;

    -- 2) ENTRADA en bodega destino
    INSERT INTO movimientosinventario (
      empresaid, sucursalid,
      tipo,
      productoid, varianteid,
      unidadid, cantidad, cantidadbase,
      bodegadestinoid, ubicaciondestinoid,
      referenciatipo, referenciaid,
      fechamovimiento, usuarioid
    )
    SELECT
      NEW.empresa_id,
      NEW.id_sucursal_origen,
      'ENTRADA'::movimiento_tipo,
      d.id_producto,
      NULL,
      (SELECT id FROM unidadesmedida
       WHERE codigo = d.um_traslado
         AND empresaid = NEW.empresa_id
       LIMIT 1),
      d.cantidad,
      d.cantidad,
      NEW.id_bodega_destino,
      NULL,
      'TRASLADO'::movimiento_referencia_tipo,
      NEW.id,
      now(),
      NEW.updated_by
    FROM traslados_detalle d
    WHERE d.id_traslado = NEW.id;

  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."fn_confirmar_traslado"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_crear_notificacion"("p_empresaid" "uuid", "p_sucursalid" "uuid", "p_userid" "uuid", "p_evento" "text", "p_titulo" "text", "p_mensaje" "text", "p_referenciaid" "uuid" DEFAULT NULL::"uuid", "p_referenciatipo" "text" DEFAULT NULL::"text", "p_url" "text" DEFAULT NULL::"text") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_id uuid;
BEGIN
  INSERT INTO notificaciones_usuario (
    empresaid, sucursalid, userid,
    evento, titulo, mensaje, url,
    referenciaid, referenciatipo,
    createdat
  )
  VALUES (
    p_empresaid, p_sucursalid, p_userid,
    p_evento, p_titulo, p_mensaje, p_url,
    p_referenciaid, p_referenciatipo,
    now()
  )
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;


ALTER FUNCTION "public"."fn_crear_notificacion"("p_empresaid" "uuid", "p_sucursalid" "uuid", "p_userid" "uuid", "p_evento" "text", "p_titulo" "text", "p_mensaje" "text", "p_referenciaid" "uuid", "p_referenciatipo" "text", "p_url" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_generar_numtraslado"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO ''
    AS $$
DECLARE
  v_anio text;
  v_secuencia integer;
  v_numero text;
BEGIN
  v_anio := TO_CHAR(now(), 'YYYY');

  SELECT COUNT(*) + 1
  INTO v_secuencia
  FROM traslados_encabezado
  WHERE empresaid = NEW.empresaid
    AND TO_CHAR(fechasolicitud, 'YYYY') = v_anio;

  v_numero := 'TRA-' || v_anio || '-' || LPAD(v_secuencia::text, 4, '0');

  NEW.numtraslado := v_numero;
  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."fn_generar_numtraslado"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."fn_stock_por_estado_traslado"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    SET "search_path" TO ''
    AS $$
BEGIN

  -- BORRADOR → APROBADO
  -- Reserva stock en origen: cantactual - X, cantreservada + X
  IF NEW.estado = 'APROBADO' AND OLD.estado != 'APROBADO' THEN

    UPDATE stockubicacion su
    SET
      cantactual    = cantactual - d.cantidadbasesolicitada,
      cantreservada = cantreservada + d.cantidadbasesolicitada,
      ultimaactualizacion = now()
    FROM traslados_detalle d
    WHERE d.trasladoid = NEW.id
      AND su.ubicacionid = d.ubicacionorigenid
      AND su.productoid  = d.productoid
      AND (su.varianteid = d.varianteid
        OR (su.varianteid IS NULL AND d.varianteid IS NULL));

    -- Movimiento RESERVA
    INSERT INTO movimientosinventario (
      empresaid, sucursalid, tipo,
      productoid, varianteid,
      unidadid, cantidad, cantidadbase,
      bodegaorigenid, ubicacionorigenid,
      referenciatipo, referenciaid,
      fechamovimiento, usuarioid
    )
    SELECT
      NEW.empresaid, NEW.sucursalid,
      'TRASLADO'::movimiento_tipo,
      d.productoid, d.varianteid,
      d.unidadid, d.cantidadsolicitada, d.cantidadbasesolicitada,
      NEW.bodegaorigenid, d.ubicacionorigenid,
      'TRASLADO'::movimiento_referencia_tipo, NEW.id,
      now(), NEW.updatedby
    FROM traslados_detalle d
    WHERE d.trasladoid = NEW.id;

  END IF;

  -- APROBADO → EN_TRANSITO
  -- Stock origen: cantreservada - X, cantentransito + X
  IF NEW.estado = 'EN_TRANSITO' AND OLD.estado != 'EN_TRANSITO' THEN

    UPDATE stockubicacion su
    SET
      cantreservada  = cantreservada - d.cantidadbasesolicitada,
      cantentransito = cantentransito + d.cantidadbasesolicitada,
      ultimaactualizacion = now()
    FROM traslados_detalle d
    WHERE d.trasladoid = NEW.id
      AND su.ubicacionid = d.ubicacionorigenid
      AND su.productoid  = d.productoid
      AND (su.varianteid = d.varianteid
        OR (su.varianteid IS NULL AND d.varianteid IS NULL));

    -- Movimiento SALIDA
    INSERT INTO movimientosinventario (
      empresaid, sucursalid, tipo,
      productoid, varianteid,
      unidadid, cantidad, cantidadbase,
      bodegaorigenid, ubicacionorigenid,
      referenciatipo, referenciaid,
      fechamovimiento, usuarioid
    )
    SELECT
      NEW.empresaid, NEW.sucursalid,
      'SALIDA'::movimiento_tipo,
      d.productoid, d.varianteid,
      d.unidadid, d.cantidadsolicitada, d.cantidadbasesolicitada,
      NEW.bodegaorigenid, d.ubicacionorigenid,
      'TRASLADO'::movimiento_referencia_tipo, NEW.id,
      now(), NEW.updatedby
    FROM traslados_detalle d
    WHERE d.trasladoid = NEW.id;

  END IF;

  -- EN_TRANSITO → COMPLETADO
  -- Stock origen: cantentransito - X
  -- Stock destino: cantactual + cantidadbaserecibida
  IF NEW.estado = 'COMPLETADO' AND OLD.estado != 'COMPLETADO' THEN

    -- Resta tránsito en origen
    UPDATE stockubicacion su
    SET
      cantentransito = cantentransito - d.cantidadbasesolicitada,
      ultimaactualizacion = now()
    FROM traslados_detalle d
    WHERE d.trasladoid = NEW.id
      AND su.ubicacionid = d.ubicacionorigenid
      AND su.productoid  = d.productoid
      AND (su.varianteid = d.varianteid
        OR (su.varianteid IS NULL AND d.varianteid IS NULL));

    -- Suma en destino (upsert)
    INSERT INTO stockubicacion (
      id, ubicacionid, empresaid, sucursalid, bodegaid,
      productoid, varianteid, cantactual,
      ultimaactualizacion
    )
    SELECT
      gen_random_uuid(),
      d.ubicacionorigenid,    -- ajustar a ubicación destino si se define
      NEW.empresaid,
      NEW.sucursalid,
      NEW.bodegadestinoid,
      d.productoid,
      d.varianteid,
      COALESCE(d.cantidadbaserecibida, d.cantidadbasesolicitada),
      now()
    FROM traslados_detalle d
    WHERE d.trasladoid = NEW.id
    ON CONFLICT (ubicacionid, productoid, varianteid)
    DO UPDATE SET
      cantactual          = stockubicacion.cantactual
                            + EXCLUDED.cantactual,
      ultimaactualizacion = now();

    -- Movimiento ENTRADA en destino
    INSERT INTO movimientosinventario (
      empresaid, sucursalid, tipo,
      productoid, varianteid,
      unidadid, cantidad, cantidadbase,
      bodegadestinoid,
      referenciatipo, referenciaid,
      fechamovimiento, usuarioid
    )
    SELECT
      NEW.empresaid, NEW.sucursalid,
      'ENTRADA'::movimiento_tipo,
      d.productoid, d.varianteid,
      d.unidadid,
      COALESCE(d.cantidadrecibida, d.cantidadsolicitada),
      COALESCE(d.cantidadbaserecibida, d.cantidadbasesolicitada),
      NEW.bodegadestinoid,
      'TRASLADO'::movimiento_referencia_tipo, NEW.id,
      now(), NEW.updatedby
    FROM traslados_detalle d
    WHERE d.trasladoid = NEW.id;

  END IF;

  -- APROBADO → RECHAZADO o ANULADO
  -- Libera reserva: cantreservada - X, cantactual + X
  IF NEW.estado IN ('RECHAZADO', 'ANULADO')
    AND OLD.estado = 'APROBADO' THEN

    UPDATE stockubicacion su
    SET
      cantactual    = cantactual + d.cantidadbasesolicitada,
      cantreservada = cantreservada - d.cantidadbasesolicitada,
      ultimaactualizacion = now()
    FROM traslados_detalle d
    WHERE d.trasladoid = NEW.id
      AND su.ubicacionid = d.ubicacionorigenid
      AND su.productoid  = d.productoid
      AND (su.varianteid = d.varianteid
        OR (su.varianteid IS NULL AND d.varianteid IS NULL));

  END IF;

  -- EN_TRANSITO → ANULADO
  -- Libera tránsito: cantentransito - X, cantactual + X
  IF NEW.estado = 'ANULADO'
    AND OLD.estado = 'EN_TRANSITO' THEN

    UPDATE stockubicacion su
    SET
      cantactual     = cantactual + d.cantidadbasesolicitada,
      cantentransito = cantentransito - d.cantidadbasesolicitada,
      ultimaactualizacion = now()
    FROM traslados_detalle d
    WHERE d.trasladoid = NEW.id
      AND su.ubicacionid = d.ubicacionorigenid
      AND su.productoid  = d.productoid
      AND (su.varianteid = d.varianteid
        OR (su.varianteid IS NULL AND d.varianteid IS NULL));

  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."fn_stock_por_estado_traslado"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_auth_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  meta       jsonb := new.raw_user_meta_data;
  v_empresa  uuid;
  v_sucursal uuid;
  v_rol      text;
begin
  -- 1. Intentar leer de metadata (si algún día la pasas desde código)
  v_empresa  := (meta->>'empresa_id')::uuid;
  v_sucursal := (meta->>'sucursal_id')::uuid;
  v_rol      := coalesce(meta->>'app_role', 'empleado');

  -- 2. Fallback: empresa por defecto si no viene en metadata
  if v_empresa is null then
    select id
    into v_empresa
    from public.empresas
    order by created_at asc
    limit 1;
  end if;

  if v_empresa is null then
    -- Si ni metadata ni empresa por defecto, ya sí bloqueamos
    raise exception
      'user_profiles: falta empresa_id y no hay default_empresa';
  end if;

  -- 3. Fallback sucursal si no viene en metadata
  if v_sucursal is null then
    select id
    into v_sucursal
    from public.sucursales
    where empresa_id = v_empresa
    order by created_at asc
    limit 1;
  end if;

  -- 4. Insert en user_profiles
  insert into public.user_profiles (
    user_id,
    empresa_id,
    sucursal_id,
    nombre,
    activo,
    rol_principal,
    created_at,
    created_by
  )
  values (
    new.id,
    v_empresa,
    v_sucursal,
    coalesce(meta->>'full_name', new.email),
    true,
    v_rol,
    now(),
    new.id
  );

  return new;
end;
$$;


ALTER FUNCTION "public"."handle_new_auth_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user_profile"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_empresa_id   uuid;
  v_sucursal_id  uuid;
  v_nombre       text;
  v_profile_id   uuid;
begin

  -- Resolver nombre desde metadatos o email como fallback
  v_nombre := coalesce(
    new.raw_user_meta_data ->> 'nombre',
    new.raw_user_meta_data ->> 'name',
    new.raw_user_meta_data ->> 'full_name',
    new.email
  );

  -- Resolver empresa_id:
  -- Si viene en metadatos lo usa, si no toma la primera empresa activa
  if (new.raw_user_meta_data ? 'empresaid') then
    v_empresa_id := (new.raw_user_meta_data ->> 'empresaid')::uuid;
  else
    select id into v_empresa_id
    from public.empresas
    where activa = true
    order by createdat asc
    limit 1;
  end if;

  -- Si no hay empresa disponible, salir silenciosamente
  if v_empresa_id is null then
    return new;
  end if;

  -- Resolver sucursal_id:
  -- Si viene en metadatos lo usa, si no toma la primera sucursal activa
  -- de esa empresa
  if (new.raw_user_meta_data ? 'sucursalid') then
    v_sucursal_id := (new.raw_user_meta_data ->> 'sucursalid')::uuid;
  else
    select id into v_sucursal_id
    from public.sucursales
    where empresaid = v_empresa_id
      and activa = true
    order by createdat asc
    limit 1;
  end if;

  -- Si no hay sucursal disponible, salir silenciosamente
  if v_sucursal_id is null then
    return new;
  end if;

  -- Insertar user_profiles
  -- activo=false hasta que el admin apruebe
  -- pendiente_aprobacion=true para que aparezca en el panel del admin
  insert into public.user_profiles (
    userid,
    empresaid,
    sucursalid,
    nombre,
    activo,
    pendiente_aprobacion,
    createdat,
    createdby
  )
  values (
    new.id,
    v_empresa_id,
    v_sucursal_id,
    v_nombre,
    false,              -- inactivo hasta aprobación
    true,               -- visible para el admin
    now(),
    new.id              -- el propio usuario como creador
  )
  on conflict (userid) do nothing
  returning id into v_profile_id;

  -- Si el perfil fue creado (no era duplicado), crear user_sucursales
  if v_profile_id is not null then
    insert into public.user_sucursales (
      userid,
      empresaid,
      sucursalid,
      es_principal,
      activa,
      createdat,
      createdby
    )
    values (
      new.id,
      v_empresa_id,
      v_sucursal_id,
      true,             -- sucursal base marcada como principal
      true,
      now(),
      new.id
    )
    on conflict (userid, sucursalid) do nothing;
  end if;

  return new;
end;
$$;


ALTER FUNCTION "public"."handle_new_user_profile"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user_profiles"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  meta       jsonb := new.raw_user_meta_data;
  v_empresa  uuid;
  v_sucursal uuid;
  v_rol      text;
begin
  v_empresa  := (meta->>'empresa_id')::uuid;
  v_sucursal := (meta->>'sucursal_id')::uuid;
  v_rol      := coalesce(meta->>'app_role', 'empleado');

  if v_empresa is null then
    select id
    into v_empresa
    from public.empresas
    order by created_at asc
    limit 1;
  end if;

  if v_empresa is null then
    raise exception
      'user_profiles: falta empresa_id y no hay default_empresa';
  end if;

  if v_sucursal is null then
    select id
    into v_sucursal
    from public.sucursales
    where empresa_id = v_empresa
    order by created_at asc
    limit 1;
  end if;

  insert into public.user_profiles (
    user_id,
    empresa_id,
    sucursal_id,
    nombre,
    activo,
    rol_principal,
    created_at,
    created_by
  )
  values (
    new.id,
    v_empresa,
    v_sucursal,
    coalesce(meta->>'full_name', new.email),
    true,
    v_rol,
    now(),
    new.id
  )
  on conflict (user_id) do nothing;

  return new;
end;
$$;


ALTER FUNCTION "public"."handle_new_user_profiles"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  new.updatedat = now();
  return new;
end;
$$;


ALTER FUNCTION "public"."handle_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."has_role"("p_rol" "text") RETURNS boolean
    LANGUAGE "plpgsql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  return exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.rolid
    where ur.userid = auth.uid()
      and ur.activo = true
      and r.codigo = lower(p_rol)
  );
end;
$$;


ALTER FUNCTION "public"."has_role"("p_rol" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."iniciar_recepcion"("p_idordencompra" "uuid", "p_url_foto_factura" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid       uuid := auth.uid();
  v_empresaid    uuid := public.current_empresa_id();
  v_sucursalid   uuid := public.current_sucursal_id();
  v_recepcion_id uuid;
  v_productos    json;
begin
  if not public.has_role('bodeguero')
     and public.app_role() not in ('encargado','admin') then
    return json_build_object('error', 'Sin permisos para iniciar recepciones');
  end if;

  if not exists (
    select 1 from public.ordenes_compra_encabezado
    where idordencompra = p_idordencompra
      and empresaid     = v_empresaid
      and idsucursal    = v_sucursalid
      and estado in ('APROBADA','PENDIENTE_RECEPCION')
  ) then
    return json_build_object('error', 'OC no valida o no disponible para recepcion');
  end if;

  insert into public.oc_recepciones (
    id_orden_compra, empresa_id, sucursal_id,
    empleado_id, fecha_recepcion, estado,
    estado_factura, estado_autorizacion,
    requiere_autorizacion
  )
  values (
    p_idordencompra, v_empresaid, v_sucursalid,
    v_userid, now(), 'PENDIENTE',
    case when p_url_foto_factura is not null
         then 'RECIBIDA'::public.estado_factura
         else 'PENDIENTE'::public.estado_factura end,
    'PENDIENTE'::public.estado_autorizacion,
    false
  )
  returning id into v_recepcion_id;

  select json_agg(row_to_json(r)) into v_productos
  from (
    select
      od.idoclinea,
      od.idproducto,
      pr.nombre        as producto_nombre,
      pr.skucodigo,
      od.cantidad      as cantidad_pedida,
      od.cantidadrecibida as cantidad_ya_recibida,
      coalesce(od.cantidadpendiente, od.cantidad - od.cantidadrecibida) as cantidad_pendiente,
      od.costounitario as precio_oc,
      od.umcompra
    from public.ordenes_compra_detalle od
    join public.productos pr on pr.id_producto = od.idproducto
    where od.idordencompra = p_idordencompra
    order by pr.nombre
  ) r;

  return json_build_object(
    'ok', true,
    'recepcion_id', v_recepcion_id,
    'productos', coalesce(v_productos, '[]'::json),
    'mensaje', 'Recepcion iniciada. Registra las cantidades recibidas.'
  );
end;
$$;


ALTER FUNCTION "public"."iniciar_recepcion"("p_idordencompra" "uuid", "p_url_foto_factura" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."iniciar_tarea"("p_tareaid" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid uuid := auth.uid();
  v_tarea  record;
begin
  select * into v_tarea
  from public.tareas
  where id = p_tareaid
    and asignadaa = v_userid
    and estado = 'PENDIENTE';

  if v_tarea.id is null then
    return json_build_object('error', 'Tarea no valida o no esta en estado PENDIENTE');
  end if;

  update public.tareas
  set estado      = 'EN_PROCESO',
      fechainicio = now()
  where id = p_tareaid;

  return json_build_object(
    'ok', true,
    'tarea_id', p_tareaid,
    'mensaje', 'Tarea iniciada'
  );
end;
$$;


ALTER FUNCTION "public"."iniciar_tarea"("p_tareaid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."iniciarrecepcion"("p_idordencompra" "uuid", "p_urlfotofactura" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid       uuid;
  v_empresaid    uuid;
  v_sucursalid   uuid;
  v_recepcionid  uuid;
  v_estadofactura text;
  v_productos    json;
BEGIN
  v_userid     := auth.uid();
  v_empresaid  := (SELECT empresaid  FROM user_profiles WHERE userid = v_userid LIMIT 1);
  v_sucursalid := (SELECT sucursalid FROM user_profiles WHERE userid = v_userid LIMIT 1);

  -- Determinar estado factura
  v_estadofactura := CASE
    WHEN p_urlfotofactura IS NOT NULL THEN 'RECIBIDA'
    ELSE 'PENDIENTE'
  END;

  -- Crear recepción
  INSERT INTO oc_recepciones (
    id_orden_compra, empresa_id, sucursal_id,
    empleado_id, fecha_recepcion, estado,
    estado_factura, requiere_autorizacion,
    estado_autorizacion,
    created_at, created_by, updated_at, updated_by
  )
  VALUES (
    p_idordencompra, v_empresaid, v_sucursalid,
    v_userid, now(), 'PENDIENTE',
    v_estadofactura::estadofactura, false,
    'PENDIENTE',
    now(), v_userid, now(), v_userid
  )
  RETURNING id INTO v_recepcionid;

  -- Devolver lista de productos pendientes de recibir
  SELECT json_agg(row_to_json(r))
  INTO v_productos
  FROM (
    SELECT
      d.id              AS idoclinea,
      d.id_producto     AS productoid,
      d.cantidad        AS cantidadoc,
      d.cantidad - COALESCE(d.cantidad_recibida, 0) AS cantidadpendiente,
      d.costo_unitario  AS preciooc
    FROM ordenes_compra_detalle d
    WHERE d.id_orden_compra = p_idordencompra
      AND d.cantidad > COALESCE(d.cantidad_recibida, 0)
  ) r;

  RETURN json_build_object(
    'ok',          true,
    'recepcionid', v_recepcionid,
    'estadofactura', v_estadofactura,
    'productos',   COALESCE(v_productos, '[]'::json)
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."iniciarrecepcion"("p_idordencompra" "uuid", "p_urlfotofactura" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."iniciartarea"("p_tareaid" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid uuid;
  v_tarea  record;
BEGIN
  v_userid := auth.uid();

  SELECT * INTO v_tarea
  FROM tareas
  WHERE id = p_tareaid;

  IF v_tarea IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Tarea no encontrada.');
  END IF;

  -- Solo el colaborador asignado puede iniciarla
  IF v_tarea.asignadaa != v_userid THEN
    RETURN json_build_object('ok', false, 'error', 'Solo el colaborador asignado puede iniciar esta tarea.');
  END IF;

  IF v_tarea.estado::text != 'PENDIENTE' THEN
    RETURN json_build_object('ok', false, 'error', 'Solo se puede iniciar una tarea en estado PENDIENTE.');
  END IF;

  UPDATE tareas SET
    estado      = 'ENPROCESO',
    fechainicio = now(),
    updatedat   = now(),
    updatedby   = v_userid
  WHERE id = p_tareaid;

  RETURN json_build_object(
    'ok',      true,
    'tareaid', p_tareaid,
    'mensaje', 'Tarea iniciada.'
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."iniciartarea"("p_tareaid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."marcarnotificacionleida"("p_notificacionid" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid uuid;
BEGIN
  v_userid := auth.uid();

  UPDATE notificaciones_usuario SET
    leida      = true,
    fechaleida = now()
  WHERE id     = p_notificacionid
    AND userid = v_userid;

  IF NOT FOUND THEN
    RETURN json_build_object('ok', false, 'error', 'Notificación no encontrada.');
  END IF;

  RETURN json_build_object('ok', true, 'mensaje', 'Notificación marcada como leída.');

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."marcarnotificacionleida"("p_notificacionid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."marcartodasleidas"() RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid uuid;
  v_count  integer;
BEGIN
  v_userid := auth.uid();

  UPDATE notificaciones_usuario SET
    leida      = true,
    fechaleida = now()
  WHERE userid = v_userid
    AND leida  = false;

  GET DIAGNOSTICS v_count = ROW_COUNT;

  RETURN json_build_object(
    'ok',      true,
    'marcadas', v_count
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."marcartodasleidas"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."pausar_turno"("p_turnoid" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid uuid := auth.uid();
begin
  if not exists (
    select 1 from public.turnos
    where id = p_turnoid
      and usuarioid = v_userid
      and estado = 'ABIERTO'
  ) then
    return json_build_object('error', 'Turno no valido o no esta abierto');
  end if;

  update public.turnos
  set estado     = 'PAUSADO',
      fechacierre = now()
  where id = p_turnoid;

  return json_build_object(
    'ok', true,
    'mensaje', 'Turno pausado. Puedes retomarlo en otra caja.',
    'turno_id', p_turnoid
  );
end;
$$;


ALTER FUNCTION "public"."pausar_turno"("p_turnoid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."pausarturno"("p_turnoid" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid uuid;
  v_turno  record;
BEGIN
  v_userid := auth.uid();

  SELECT * INTO v_turno
  FROM turnos
  WHERE id = p_turnoid;

  IF v_turno IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Turno no encontrado.');
  END IF;

  IF v_turno.usuarioid != v_userid THEN
    RETURN json_build_object('ok', false, 'error', 'No puedes pausar un turno que no es tuyo.');
  END IF;

  IF v_turno.estado::text != 'ABIERTO' THEN
    RETURN json_build_object('ok', false, 'error', 'Solo se puede pausar un turno ABIERTO.');
  END IF;

  UPDATE turnos SET
    estado    = 'PAUSADO',
    updatedat = now(),
    updatedby = v_userid
  WHERE id = p_turnoid;

  RETURN json_build_object(
    'ok',      true,
    'turnoid', p_turnoid,
    'mensaje', 'Turno pausado correctamente.'
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."pausarturno"("p_turnoid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rechazar_tarea"("p_tareaid" "uuid", "p_motivo" "text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid uuid := auth.uid();
begin
  if public.app_role() not in ('encargado', 'admin') then
    return json_build_object('error', 'Solo encargado o admin puede rechazar tareas');
  end if;

  if p_motivo is null or trim(p_motivo) = '' then
    return json_build_object('error', 'Debes indicar el motivo del rechazo');
  end if;

  if not exists (
    select 1 from public.tareas
    where id = p_tareaid
      and estado = 'COMPLETADA'
      and empresaid = public.current_empresa_id()
  ) then
    return json_build_object('error', 'Tarea no valida o no esta COMPLETADA');
  end if;

  update public.tareas
  set estado     = 'PENDIENTE',
      fechainicio = null,
      fechafin    = null,
      comentario  = p_motivo
  where id = p_tareaid;

  return json_build_object(
    'ok', true,
    'tarea_id', p_tareaid,
    'mensaje', 'Tarea rechazada. Regresa a PENDIENTE para ser rehecha.'
  );
end;
$$;


ALTER FUNCTION "public"."rechazar_tarea"("p_tareaid" "uuid", "p_motivo" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rechazartarea"("p_tareaid" "uuid", "p_motivo" "text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid uuid;
  v_rol    text;
  v_tarea  record;
BEGIN
  v_userid := auth.uid();
  v_rol    := approle();

  IF v_rol NOT IN ('admin', 'encargado') THEN
    RETURN json_build_object('ok', false, 'error', 'Solo encargado o admin pueden rechazar tareas.');
  END IF;

  -- Motivo obligatorio
  IF p_motivo IS NULL OR TRIM(p_motivo) = '' THEN
    RETURN json_build_object('ok', false, 'error', 'El motivo de rechazo es obligatorio.');
  END IF;

  SELECT * INTO v_tarea
  FROM tareas
  WHERE id = p_tareaid;

  IF v_tarea IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Tarea no encontrada.');
  END IF;

  IF v_tarea.estado::text != 'COMPLETADA' THEN
    RETURN json_build_object('ok', false, 'error', 'Solo se puede rechazar una tarea en estado COMPLETADA.');
  END IF;

  -- Regresar a PENDIENTE y limpiar fechas
  UPDATE tareas SET
    estado      = 'PENDIENTE',
    fechainicio = NULL,
    fechafin    = NULL,
    comentario  = p_motivo,
    updatedat   = now(),
    updatedby   = v_userid
  WHERE id = p_tareaid;

  RETURN json_build_object(
    'ok',      true,
    'tareaid', p_tareaid,
    'mensaje', 'Tarea rechazada. Regresa a PENDIENTE para rehacerse.'
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."rechazartarea"("p_tareaid" "uuid", "p_motivo" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."registrar_conteo"("p_recepcion_id" "uuid", "p_idoclinea" "uuid", "p_cantidad_recibida" numeric, "p_precio_factura" numeric DEFAULT NULL::numeric, "p_estado_fisico" "public"."estado_fisico" DEFAULT 'BUENO'::"public"."estado_fisico", "p_lote" "text" DEFAULT NULL::"text", "p_fecha_vencimiento" "date" DEFAULT NULL::"date", "p_observaciones" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid          uuid := auth.uid();
  v_recepcion       record;
  v_linea_oc        record;
  v_conteo_id       uuid;
  v_hay_diff_precio boolean := false;
begin
  select * into v_recepcion
  from public.oc_recepciones
  where id = p_recepcion_id
    and empleado_id = v_userid
    and estado = 'PENDIENTE';

  if v_recepcion.id is null then
    return json_build_object('error', 'Recepcion no valida o no esta en estado PENDIENTE');
  end if;

  select od.*, pr.nombre as producto_nombre
  into v_linea_oc
  from public.ordenes_compra_detalle od
  join public.productos pr on pr.id_producto = od.idproducto
  where od.idoclinea = p_idoclinea;

  if v_linea_oc.idoclinea is null then
    return json_build_object('error', 'Linea de OC no valida');
  end if;

  v_hay_diff_precio := p_precio_factura is not null
    and p_precio_factura != v_linea_oc.costounitario;

  insert into public.oc_recepcion_conteo (
    recepcionid, productoid,
    cantidad_oc, cantidad_recibida, cantidad_pendiente,
    estado_fisico, lote, fecha_vencimiento,
    precio_oc, precio_factura, diferencia_precio,
    observaciones
  )
  values (
    p_recepcion_id, v_linea_oc.idproducto,
    v_linea_oc.cantidad,
    p_cantidad_recibida,
    greatest(v_linea_oc.cantidad - p_cantidad_recibida, 0),
    p_estado_fisico, p_lote, p_fecha_vencimiento,
    v_linea_oc.costounitario,
    p_precio_factura,
    case when v_hay_diff_precio
         then p_precio_factura - v_linea_oc.costounitario
         else 0 end,
    p_observaciones
  )
  returning id into v_conteo_id;

  if v_hay_diff_precio then
    update public.oc_recepciones
    set requiere_autorizacion = true,
        estado_factura        = 'CON_DIFERENCIA'
    where id = p_recepcion_id;
  end if;

  return json_build_object(
    'ok',               true,
    'conteo_id',        v_conteo_id,
    'producto',         v_linea_oc.producto_nombre,
    'cantidad_pedida',  v_linea_oc.cantidad,
    'cantidad_recibida', p_cantidad_recibida,
    'diferencia_precio', v_hay_diff_precio,
    'precio_oc',        v_linea_oc.costounitario,
    'precio_factura',   p_precio_factura,
    'mensaje', case
      when v_hay_diff_precio
      then 'Conteo registrado. ALERTA: precio factura difiere del precio OC.'
      else 'Conteo registrado correctamente.'
    end
  );
end;
$$;


ALTER FUNCTION "public"."registrar_conteo"("p_recepcion_id" "uuid", "p_idoclinea" "uuid", "p_cantidad_recibida" numeric, "p_precio_factura" numeric, "p_estado_fisico" "public"."estado_fisico", "p_lote" "text", "p_fecha_vencimiento" "date", "p_observaciones" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."registrarconteo"("p_recepcionid" "uuid", "p_idoclinea" "uuid", "p_cantidadrecibida" numeric, "p_preciofactura" numeric, "p_estadofisico" "public"."estado_fisico" DEFAULT 'BUENO'::"public"."estado_fisico", "p_lote" "text" DEFAULT NULL::"text", "p_fechavencimiento" "date" DEFAULT NULL::"date", "p_observaciones" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid        uuid;
  v_recepcion     record;
  v_oclinea       record;
  v_diferencia    numeric;
  v_alertaprecio  boolean := false;
BEGIN
  v_userid := auth.uid();

  SELECT * INTO v_recepcion
  FROM oc_recepciones
  WHERE id = p_recepcionid;

  IF v_recepcion IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Recepción no encontrada.');
  END IF;

  IF v_recepcion.estado != 'PENDIENTE' THEN
    RETURN json_build_object('ok', false, 'error', 'Solo se puede registrar conteo en recepciones en estado PENDIENTE.');
  END IF;

  SELECT * INTO v_oclinea
  FROM ordenes_compra_detalle
  WHERE id = p_idoclinea;

  IF v_oclinea IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Línea de orden de compra no encontrada.');
  END IF;

  v_diferencia   := p_preciofactura - COALESCE(v_oclinea.costo_unitario, 0);
  v_alertaprecio := v_diferencia != 0;

  INSERT INTO oc_recepcion_conteo (
    recepcionid, productoid,
    cantidad_oc, cantidad_recibida,
    cantidad_pendiente,
    estado_fisico, lote, fecha_vencimiento,
    precio_oc, precio_factura, diferencia_precio,
    observaciones,
    createdat, createdby, updatedat, updatedby
  )
  VALUES (
    p_recepcionid, v_oclinea.id_producto,
    v_oclinea.cantidad, p_cantidadrecibida,
    GREATEST(v_oclinea.cantidad - p_cantidadrecibida, 0),
    p_estadofisico, p_lote, p_fechavencimiento,
    v_oclinea.costo_unitario, p_preciofactura, v_diferencia,
    p_observaciones,
    now(), v_userid, now(), v_userid
  )
  ON CONFLICT (recepcionid, productoid)
  DO UPDATE SET
    cantidad_recibida  = EXCLUDED.cantidad_recibida,
    cantidad_pendiente = EXCLUDED.cantidad_pendiente,
    estado_fisico      = EXCLUDED.estado_fisico,
    lote               = EXCLUDED.lote,
    fecha_vencimiento  = EXCLUDED.fecha_vencimiento,
    precio_factura     = EXCLUDED.precio_factura,
    diferencia_precio  = EXCLUDED.diferencia_precio,
    observaciones      = EXCLUDED.observaciones,
    updatedat          = now(),
    updatedby          = v_userid;

  IF v_alertaprecio THEN
    UPDATE oc_recepciones SET
      requiere_autorizacion = true,
      estado_factura        = 'CONDIFERENCIA',
      updated_at            = now(),
      updated_by            = v_userid
    WHERE id = p_recepcionid;
  END IF;

  RETURN json_build_object(
    'ok',           true,
    'alertaprecio', v_alertaprecio,
    'diferencia',   v_diferencia,
    'mensaje',      CASE
      WHEN v_alertaprecio THEN 'Conteo registrado. ALERTA: diferencia de precio detectada.'
      ELSE 'Conteo registrado correctamente.'
    END
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."registrarconteo"("p_recepcionid" "uuid", "p_idoclinea" "uuid", "p_cantidadrecibida" numeric, "p_preciofactura" numeric, "p_estadofisico" "public"."estado_fisico", "p_lote" "text", "p_fechavencimiento" "date", "p_observaciones" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."reportar_novedad"("p_productoid" "uuid", "p_tipo" "public"."novedad_tipo", "p_cantidad" numeric, "p_comentario" "text" DEFAULT NULL::"text", "p_url_foto" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid      uuid := auth.uid();
  v_empresaid   uuid := public.current_empresa_id();
  v_sucursalid  uuid := public.current_sucursal_id();
  v_novedad_id  uuid;
  v_proveedor_id uuid;
  v_genera      boolean := false;
begin
  -- Validar foto obligatoria para DANADO y EMPAQUE_ROTO
  if p_tipo in ('DANADO', 'EMPAQUE_ROTO') and p_url_foto is null then
    return json_build_object(
      'error', 'La foto es obligatoria para novedades de tipo DANADO o EMPAQUE_ROTO'
    );
  end if;

  -- Buscar proveedor principal del producto
  -- (via ultima OC del producto)
  select oe.idproveedor into v_proveedor_id
  from public.ordenes_compra_detalle od
  join public.ordenes_compra_encabezado oe on oe.idordencompra = od.idordencompra
  where od.idproducto = p_productoid
    and oe.empresaid = v_empresaid
  order by oe.fechaoc desc
  limit 1;

  -- Determinar si genera sugerencia
  v_genera := p_tipo in ('DANADO', 'VENCIDO', 'FALTANTE');

  -- Insertar novedad
  insert into public.novedades_inventario (
    empresaid, sucursalid, productoid,
    reportadopor, tipo, estado,
    cantidad_afectada, comentario,
    url_foto, proveedorid, genera_sugerencia
  )
  values (
    v_empresaid, v_sucursalid, p_productoid,
    v_userid, p_tipo, 'REPORTADA',
    p_cantidad, p_comentario,
    p_url_foto, v_proveedor_id, v_genera
  )
  returning id into v_novedad_id;

  -- Crear sugerencia de pedido automática si aplica
  if v_genera and v_proveedor_id is not null then
    insert into public.sugerencias_pedido (
      empresaid, sucursalid, productoid,
      proveedorid, novedad_id,
      cantidad_sugerida, motivo, estado
    )
    values (
      v_empresaid, v_sucursalid, p_productoid,
      v_proveedor_id, v_novedad_id,
      p_cantidad,
      'Reposicion por ' || lower(p_tipo::text),
      'PENDIENTE'
    );
  end if;

  return json_build_object(
    'ok', true,
    'novedad_id', v_novedad_id,
    'genera_sugerencia', v_genera,
    'proveedor_detectado', v_proveedor_id is not null,
    'mensaje', case
      when v_genera and v_proveedor_id is not null
      then 'Novedad reportada. Sugerencia de reposicion creada automaticamente.'
      when v_genera and v_proveedor_id is null
      then 'Novedad reportada. No se encontro proveedor asociado. Revisa manualmente.'
      else 'Novedad reportada.'
    end
  );
end;
$$;


ALTER FUNCTION "public"."reportar_novedad"("p_productoid" "uuid", "p_tipo" "public"."novedad_tipo", "p_cantidad" numeric, "p_comentario" "text", "p_url_foto" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."reportarnovedad"("p_productoid" "uuid", "p_tipo" "text", "p_cantidad" numeric, "p_comentario" "text" DEFAULT NULL::"text", "p_urlfoto" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid      uuid;
  v_empresaid   uuid;
  v_sucursalid  uuid;
  v_rol         text;
  v_novedadid   uuid;
  v_proveedorid uuid;
  v_generasug   boolean := false;
BEGIN
  v_userid     := auth.uid();
  v_empresaid  := (SELECT empresaid  FROM user_profiles WHERE userid = v_userid LIMIT 1);
  v_sucursalid := (SELECT sucursalid FROM user_profiles WHERE userid = v_userid LIMIT 1);
  v_rol        := approle();

  -- Solo bodeguero puede reportar
  IF v_rol NOT IN ('bodeguero', 'encargado', 'admin') THEN
    RETURN json_build_object('ok', false, 'error', 'No tienes permisos para reportar novedades.');
  END IF;

  -- Foto obligatoria si tipo es DANADO o EMPAQUEROTO
  IF p_tipo IN ('DANADO', 'EMPAQUEROTO') AND (p_urlfoto IS NULL OR TRIM(p_urlfoto) = '') THEN
    RETURN json_build_object('ok', false, 'error', 'La foto es obligatoria para novedades de tipo DANADO o EMPAQUEROTO.');
  END IF;

  -- Buscar proveedor principal via última OC del producto
  SELECT o.proveedorid
  INTO v_proveedorid
  FROM ordenescompra o
  JOIN ordenescompradetalle d ON d.ordenid = o.id
  WHERE d.productoid  = p_productoid
    AND o.empresaid   = v_empresaid
  ORDER BY o.createdat DESC
  LIMIT 1;

  -- Determinar si genera sugerencia
  v_generasug := p_tipo IN ('DANADO', 'VENCIDO', 'FALTANTE');

  -- Insertar novedad
  INSERT INTO novedades_inventario (
    empresaid, sucursalid, productoid,
    reportadopor, tipo, estado,
    cantidadafectada, comentario, urlfoto,
    proveedorid, generasugerencia,
    createdat, createdby, updatedat, updatedby
  )
  VALUES (
    v_empresaid, v_sucursalid, p_productoid,
    v_userid, p_tipo::novedadtipo, 'REPORTADA',
    p_cantidad, p_comentario, p_urlfoto,
    v_proveedorid, v_generasug,
    now(), v_userid, now(), v_userid
  )
  RETURNING id INTO v_novedadid;

  -- Generar sugerencia de pedido automáticamente si aplica
  IF v_generasug THEN
    INSERT INTO sugerencias_pedido (
      empresaid, sucursalid, productoid,
      proveedorid, novedadid,
      cantidadsugerida, motivo, estado,
      createdat, createdby, updatedat, updatedby
    )
    VALUES (
      v_empresaid, v_sucursalid, p_productoid,
      v_proveedorid, v_novedadid,
      p_cantidad, 'Novedad: ' || p_tipo, 'PENDIENTE',
      now(), v_userid, now(), v_userid
    );
  END IF;

  RETURN json_build_object(
    'ok',               true,
    'novedadid',        v_novedadid,
    'generasugerencia', v_generasug,
    'proveedordetectado', v_proveedorid
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."reportarnovedad"("p_productoid" "uuid", "p_tipo" "text", "p_cantidad" numeric, "p_comentario" "text", "p_urlfoto" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rls_auto_enable"() RETURNS "event_trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'pg_catalog'
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION "public"."rls_auto_enable"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sugerir_monto_apertura"("p_cajaid" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_empresaid uuid := public.current_empresa_id();
  v_monto     numeric := 0;
  v_turno_id  uuid;
  v_cajero    text;
  v_fecha     timestamptz;
begin
  select
    t.id,
    t.monto_dejado,
    up.nombre,
    t.fechacierre
  into v_turno_id, v_monto, v_cajero, v_fecha
  from public.turnos t
  join public.user_profiles up on up.userid = t.usuarioid
  where t.cajaid = p_cajaid
    and t.empresaid = v_empresaid
    and t.estado = 'CERRADO'
  order by t.fechacierre desc
  limit 1;

  if v_turno_id is null then
    return json_build_object(
      'ok', true,
      'monto_sugerido', 0,
      'mensaje', 'No hay turno previo en esta caja. Ingresa el monto inicial.'
    );
  end if;

  return json_build_object(
    'ok', true,
    'monto_sugerido', v_monto,
    'turno_anterior_id', v_turno_id,
    'cajero_anterior', v_cajero,
    'fecha_cierre_anterior', v_fecha,
    'mensaje', 'Monto sugerido basado en el cierre anterior de esta caja'
  );
end;
$$;


ALTER FUNCTION "public"."sugerir_monto_apertura"("p_cajaid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sugerirmontoapertura"("p_cajaid" "uuid") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_monto_dejado   numeric;
  v_cajero_anterior uuid;
  v_fecha_cierre   timestamptz;
BEGIN
  -- Buscar último turno CERRADO de esa caja
  SELECT
    monto_dejado,
    usuarioid,
    fechacierre
  INTO
    v_monto_dejado,
    v_cajero_anterior,
    v_fecha_cierre
  FROM turnos
  WHERE cajaid = p_cajaid
    AND estado = 'CERRADO'
  ORDER BY fechacierre DESC
  LIMIT 1;

  IF v_monto_dejado IS NULL THEN
    RETURN json_build_object(
      'ok', true,
      'montosugerido', 0,
      'mensaje', 'No hay turno anterior para esta caja.'
    );
  END IF;

  RETURN json_build_object(
    'ok', true,
    'montosugerido',      v_monto_dejado,
    'cajeroanterior',     v_cajero_anterior,
    'fechacierreanterior', v_fecha_cierre
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object(
    'ok', false,
    'error', SQLERRM
  );
END;
$$;


ALTER FUNCTION "public"."sugerirmontoapertura"("p_cajaid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."suspender_tarea"("p_tareaid" "uuid", "p_comentario" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_userid uuid := auth.uid();
begin
  if not exists (
    select 1 from public.tareas
    where id = p_tareaid
      and asignadaa = v_userid
      and estado = 'EN_PROCESO'
  ) then
    return json_build_object('error', 'Tarea no valida o no esta EN_PROCESO');
  end if;

  update public.tareas
  set estado     = 'SUSPENDIDA',
      comentario = coalesce(p_comentario, comentario)
  where id = p_tareaid;

  return json_build_object(
    'ok', true,
    'tarea_id', p_tareaid,
    'mensaje', 'Tarea suspendida'
  );
end;
$$;


ALTER FUNCTION "public"."suspender_tarea"("p_tareaid" "uuid", "p_comentario" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."suspendertarea"("p_tareaid" "uuid", "p_comentario" "text" DEFAULT NULL::"text") RETURNS json
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
DECLARE
  v_userid uuid;
  v_tarea  record;
BEGIN
  v_userid := auth.uid();

  SELECT * INTO v_tarea
  FROM tareas
  WHERE id = p_tareaid;

  IF v_tarea IS NULL THEN
    RETURN json_build_object('ok', false, 'error', 'Tarea no encontrada.');
  END IF;

  IF v_tarea.asignadaa != v_userid THEN
    RETURN json_build_object('ok', false, 'error', 'Solo el colaborador asignado puede suspender esta tarea.');
  END IF;

  IF v_tarea.estado::text != 'ENPROCESO' THEN
    RETURN json_build_object('ok', false, 'error', 'Solo se puede suspender una tarea en estado ENPROCESO.');
  END IF;

  UPDATE tareas SET
    estado     = 'SUSPENDIDA',
    comentario = COALESCE(p_comentario, comentario),
    updatedat  = now(),
    updatedby  = v_userid
  WHERE id = p_tareaid;

  RETURN json_build_object(
    'ok',      true,
    'tareaid', p_tareaid,
    'mensaje', 'Tarea suspendida.'
  );

EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('ok', false, 'error', SQLERRM);
END;
$$;


ALTER FUNCTION "public"."suspendertarea"("p_tareaid" "uuid", "p_comentario" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trg_fn_arqueo_on_change"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  perform public.calcular_totales_arqueo(new.id);
  return new;
end;
$$;


ALTER FUNCTION "public"."trg_fn_arqueo_on_change"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."trg_fn_movimiento_afecta_arqueo"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
declare
  v_turno_id  uuid;
  v_arqueo_id uuid;
begin
  -- Determinar turno_id según operación
  if tg_op = 'DELETE' then
    v_turno_id := old.turnoid;
  else
    v_turno_id := new.turnoid;
  end if;

  -- Buscar arqueo en BORRADOR o ENVIADO para ese turno
  select id into v_arqueo_id
  from public.arqueos_caja
  where turnoid = v_turno_id
    and estado in ('BORRADOR', 'ENVIADO')
  order by createdat desc
  limit 1;

  -- Si existe, recalcular
  if v_arqueo_id is not null then
    perform public.calcular_totales_arqueo(v_arqueo_id);
  end if;

  if tg_op = 'DELETE' then
    return old;
  else
    return new;
  end if;
end;
$$;


ALTER FUNCTION "public"."trg_fn_movimiento_afecta_arqueo"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."arqueos_caja" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "cajaid" "uuid",
    "turnoid" "uuid" NOT NULL,
    "jornadaid" "uuid" NOT NULL,
    "responsableid" "uuid" NOT NULL,
    "tipo" "public"."arqueo_tipo" DEFAULT 'PARCIAL'::"public"."arqueo_tipo" NOT NULL,
    "estado" "public"."arqueo_estado" DEFAULT 'BORRADOR'::"public"."arqueo_estado" NOT NULL,
    "fechaarqueo" timestamp with time zone DEFAULT "now"() NOT NULL,
    "saldoinicial" numeric,
    "totalsegunsistema" numeric,
    "totalcontado" numeric,
    "diferencia" numeric,
    "comentario" "text",
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid",
    "total_ventas" numeric DEFAULT 0 NOT NULL,
    "total_devoluciones" numeric DEFAULT 0 NOT NULL,
    "total_gastos" numeric DEFAULT 0 NOT NULL,
    "total_neto_esperado" numeric DEFAULT 0 NOT NULL,
    "url_informe_z" "text",
    "supervisor_id" "uuid",
    "estado_auditoria" "public"."arqueo_auditoria" DEFAULT 'PENDIENTE'::"public"."arqueo_auditoria" NOT NULL,
    "monto_retirado" numeric DEFAULT 0 NOT NULL,
    "monto_dejado" numeric DEFAULT 0 NOT NULL,
    "tolerancia_aplicada" numeric DEFAULT 0 NOT NULL,
    "total_retiros" numeric DEFAULT 0 NOT NULL
);


ALTER TABLE "public"."arqueos_caja" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."arqueos_efectivo_detalle" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "arqueoid" "uuid" NOT NULL,
    "tipo" "public"."denominacion_tipo" NOT NULL,
    "denominacion" numeric NOT NULL,
    "cantidad" integer NOT NULL,
    "subtotal" numeric NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."arqueos_efectivo_detalle" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."arqueos_otros_medios" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "arqueoid" "uuid" NOT NULL,
    "metodo_pago" "public"."otro_medio_pago" NOT NULL,
    "total_esperado" numeric DEFAULT 0 NOT NULL,
    "total_declarado" numeric DEFAULT 0 NOT NULL,
    "diferencia" numeric DEFAULT 0 NOT NULL,
    "url_comprobante" "text",
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."arqueos_otros_medios" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."audit_log" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "tabla" "text" NOT NULL,
    "registro_id" "uuid" NOT NULL,
    "accion" "text" NOT NULL,
    "estado_antes" "text",
    "estado_despues" "text",
    "comentario" "text",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."audit_log" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."bodegas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "nombre" "text" NOT NULL,
    "codigo" "text" NOT NULL,
    "tipo" "public"."bodegatipo" NOT NULL,
    "esvirtual" boolean DEFAULT false NOT NULL,
    "esprincipal" boolean DEFAULT false NOT NULL,
    "activa" boolean DEFAULT true NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."bodegas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."cajas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "nombre" "text" NOT NULL,
    "codigo" "text",
    "activa" boolean DEFAULT true NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."cajas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."categorias_producto" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "nombre" "text" NOT NULL,
    "nivel" "public"."categoria_nivel" NOT NULL,
    "parentid" "uuid",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."categorias_producto" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."categoriasproducto" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "nombre" "text" NOT NULL,
    "imagenurl" "text",
    "nivel" "public"."categoria_nivel" NOT NULL,
    "parentid" "uuid",
    "activa" boolean DEFAULT true NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."categoriasproducto" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."clientes" (
    "id_tercero" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "tipo_tercero" "text" DEFAULT 'cliente'::"text",
    "estado" "text",
    "tipo_documento" "text",
    "num_documento" "text",
    "dv" "text",
    "tipo_persona" "text",
    "tipo_regimen" "text",
    "razon_social" "text",
    "nombres" "text",
    "segundo_nombre" "text",
    "primer_apellido" "text",
    "segundo_apellido" "text",
    "nombre_comercial" "text",
    "direccion" "text",
    "zona" "text",
    "barrio" "text",
    "ciudad" "text",
    "departamento" "text",
    "pais" "text",
    "telefono" "text",
    "email" "text",
    "lista_precios" "text",
    "grupo_cliente" "text",
    "vendedor_principal_id" "uuid",
    "afiliado_id" "uuid",
    "tipo_pago" "text",
    "limite_credito" numeric,
    "plazo_predeterminado" integer,
    "no_acumular_puntos" boolean,
    "acumula_puntos" boolean,
    "puntos_premio" numeric,
    "valor_anticipo" numeric,
    "solo_pos" boolean,
    "exento_impuestos" boolean,
    "aplicar_ret_sin_base" boolean,
    "es_retenedor_fuente" boolean,
    "es_retenedor_iva" boolean,
    "es_retenedor_ica" boolean,
    "canal_principal" "text",
    "segmento" "text",
    "lat" numeric,
    "lng" numeric,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_at" timestamp with time zone,
    "updated_by" "uuid",
    "fecha_ultima_compra" timestamp with time zone,
    "id" "uuid" DEFAULT "gen_random_uuid"()
);


ALTER TABLE "public"."clientes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."compras_detalle" (
    "id_compra_linea" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "id_compra" "uuid" NOT NULL,
    "id_producto" "uuid",
    "cod_producto" "text",
    "variante" "text",
    "cantidad" numeric,
    "um_compra" "text",
    "costo_unitario_bruto" numeric,
    "descuento_raw" "text",
    "nombre_impuesto" "text",
    "caducidad_fecha" "date",
    "lote_codigo" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_at" timestamp with time zone,
    "updated_by" "uuid",
    "id" "uuid" DEFAULT "gen_random_uuid"(),
    "descuento_valor" numeric DEFAULT 0,
    "costo_unitario_neto" numeric,
    "costo_unitario_final" numeric,
    "subtotal_linea" numeric
);


ALTER TABLE "public"."compras_detalle" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."compras_encabezado" (
    "id_compra" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "id_sucursal" "uuid" NOT NULL,
    "id_bodega" "uuid",
    "id_proveedor" "uuid",
    "num_compra" "text" NOT NULL,
    "fecha_compra" "date" NOT NULL,
    "tipo_compra" "text",
    "estado_compra" "text",
    "flete_otro_gasto_monto" numeric,
    "flete_prorratear" boolean,
    "num_pago" "text",
    "afecta_caja" boolean,
    "forma_pago" "text",
    "plazo_dias" integer,
    "moneda" "text",
    "tasa_cambio" numeric,
    "num_doc_proveedor" "text",
    "fecha_doc_proveedor" "date",
    "centro_costo_id" "uuid",
    "nota_compra" "text",
    "created_by" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_by" "uuid",
    "updated_at" timestamp with time zone,
    "id" "uuid" DEFAULT "gen_random_uuid"(),
    "sync_status" "text" DEFAULT 'SYNCED'::"text" NOT NULL,
    "deleted_at" timestamp with time zone,
    CONSTRAINT "compras_estado_check" CHECK (("estado_compra" = ANY (ARRAY['BORRADOR'::"text", 'APROBADO'::"text", 'NO_APROBADO'::"text"]))),
    CONSTRAINT "compras_sync_status_check" CHECK (("sync_status" = ANY (ARRAY['SYNCED'::"text", 'PENDING'::"text", 'CONFLICT'::"text"]))),
    CONSTRAINT "compras_tipo_check" CHECK (("tipo_compra" = ANY (ARRAY['PRODUCTOS'::"text", 'GASTOS'::"text", 'GASTO_IMPORTACION'::"text"])))
);


ALTER TABLE "public"."compras_encabezado" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."config_app_empresas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "zona_horaria" "text" DEFAULT 'America/Bogota'::"text" NOT NULL,
    "moneda" "text" DEFAULT 'COP'::"text" NOT NULL,
    "idioma" "text" DEFAULT 'es'::"text" NOT NULL,
    "tolerancia_diferencia_arqueo" numeric DEFAULT 0 NOT NULL,
    "requiere_arqueo_al_cerrar" boolean DEFAULT true NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid",
    "umbral_huesos_dias" integer DEFAULT 30 NOT NULL
);


ALTER TABLE "public"."config_app_empresas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."config_tipos_voucher" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "requiere_imagen" boolean DEFAULT false NOT NULL,
    "requiere_aprobacion" boolean DEFAULT false NOT NULL,
    "aprobador_rol" "text",
    "permite_cajero" boolean DEFAULT true NOT NULL,
    "permite_empleado" boolean DEFAULT false NOT NULL,
    "monto_maximo_sin_aprobacion" numeric,
    "activo" boolean DEFAULT true NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."config_tipos_voucher" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."cubiculosfila" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "filaid" "uuid" NOT NULL,
    "codigo" "text" NOT NULL,
    "activa" boolean DEFAULT true NOT NULL
);


ALTER TABLE "public"."cubiculosfila" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."empresas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "nombre" "text" NOT NULL,
    "nit" "text",
    "activa" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."empresas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."estanterias" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "zonaid" "uuid" NOT NULL,
    "codigo" "text" NOT NULL,
    "nombre" "text" NOT NULL,
    "tienecubiculos" boolean DEFAULT true NOT NULL,
    "activa" boolean DEFAULT true NOT NULL
);


ALTER TABLE "public"."estanterias" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."facturasVenta" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "pedidoVentaId" "uuid",
    "clienteid" "uuid" NOT NULL,
    "vendedorid" "uuid",
    "canal" "public"."ordenventa_canal",
    "numeroFactura" "text" NOT NULL,
    "fechaEmision" timestamp with time zone DEFAULT "now"() NOT NULL,
    "fechaVencimiento" timestamp with time zone,
    "condicionPago" "text" DEFAULT 'CONTADO'::"text" NOT NULL,
    "diasPlazo" integer,
    "subtotal" numeric(18,6) DEFAULT 0 NOT NULL,
    "descuentoTotal" numeric(18,6) DEFAULT 0 NOT NULL,
    "totalImpuestos" numeric(18,6) DEFAULT 0 NOT NULL,
    "total" numeric(18,6) DEFAULT 0 NOT NULL,
    "estado" "public"."facturaventa_estado" DEFAULT 'EMITIDA'::"public"."facturaventa_estado" NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."facturasVenta" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."facturasVentaLineas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "facturaVentaId" "uuid" NOT NULL,
    "lineaNumero" integer NOT NULL,
    "pedidoVentaLineaId" "uuid",
    "productoId" "uuid" NOT NULL,
    "unidadId" "uuid" NOT NULL,
    "cantidad" numeric(18,6) NOT NULL,
    "precioUnitario" numeric(18,6) NOT NULL,
    "descuentoPorcentaje" numeric(5,2),
    "descuentoValor" numeric(18,6),
    "subtotalLinea" numeric(18,6) DEFAULT 0 NOT NULL,
    "factorReferenciaSnapshot" numeric(18,6) NOT NULL,
    "tipoStock" "public"."productounidad_tipostock" NOT NULL,
    "baseImponible" numeric(18,6) DEFAULT 0 NOT NULL,
    "porcentajeImpuesto" numeric(5,2),
    "valorImpuesto" numeric(18,6) DEFAULT 0 NOT NULL,
    "atributos" "jsonb",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."facturasVentaLineas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."facturascompra" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "recepcionid" "uuid" NOT NULL,
    "proveedorid" "uuid" NOT NULL,
    "numerofactura" "text" NOT NULL,
    "fecha" "date" DEFAULT CURRENT_DATE NOT NULL,
    "estado" "public"."facturacompra_estado" DEFAULT 'BORRADOR'::"public"."facturacompra_estado" NOT NULL,
    "subtotal" numeric DEFAULT 0 NOT NULL,
    "total" numeric DEFAULT 0 NOT NULL,
    "observaciones" "text",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."facturascompra" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."facturascompradetalle" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "facturaid" "uuid" NOT NULL,
    "recepciondetalleid" "uuid" NOT NULL,
    "productoid" "uuid" NOT NULL,
    "varianteid" "uuid",
    "unidadid" "uuid" NOT NULL,
    "cantidad" numeric NOT NULL,
    "cantidadbase" numeric NOT NULL,
    "preciounitario" numeric NOT NULL,
    "subtotal" numeric DEFAULT 0 NOT NULL,
    "observaciones" "text",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid",
    CONSTRAINT "facturascompradetalle_cantidad_check" CHECK (("cantidad" > (0)::numeric)),
    CONSTRAINT "facturascompradetalle_cantidadbase_check" CHECK (("cantidadbase" > (0)::numeric)),
    CONSTRAINT "facturascompradetalle_preciounitario_check" CHECK (("preciounitario" >= (0)::numeric))
);


ALTER TABLE "public"."facturascompradetalle" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."filasestanteria" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "estanteriaid" "uuid" NOT NULL,
    "codigo" "text" NOT NULL,
    "activa" boolean DEFAULT true NOT NULL
);


ALTER TABLE "public"."filasestanteria" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."import_errors" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "import_id" "uuid" NOT NULL,
    "fila_num" integer,
    "tipo_error" "text",
    "mensaje_error" "text",
    "datos_crudos" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."import_errors" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."import_log" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "tipo_fuente" "text" NOT NULL,
    "archivo" "text",
    "total_filas" integer,
    "filas_validas" integer,
    "filas_error" integer,
    "started_at" timestamp with time zone DEFAULT "now"(),
    "finished_at" timestamp with time zone,
    "ejecutado_por" "uuid" NOT NULL,
    "exito" boolean,
    "mensaje" "text"
);


ALTER TABLE "public"."import_log" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."jornadas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "userid" "uuid" NOT NULL,
    "fecha" "date" NOT NULL,
    "horainicio" timestamp with time zone NOT NULL,
    "horafin" timestamp with time zone,
    "estado" "public"."jornada_estado" DEFAULT 'ABIERTA'::"public"."jornada_estado" NOT NULL,
    "observaciones" "text",
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."jornadas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."listasprecios" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "nombre" "text" NOT NULL,
    "tipocliente" "text" NOT NULL,
    "aplicacategorias" "uuid"[],
    "activa" boolean DEFAULT true NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."listasprecios" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."listaspreciosdetalle" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "listaid" "uuid" NOT NULL,
    "productoid" "uuid",
    "categoriaid" "uuid",
    "unidadbaseid" "uuid" NOT NULL,
    "rangomin" numeric NOT NULL,
    "rangomax" numeric,
    "precio" numeric NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid",
    CONSTRAINT "listaspreciosdetalle_producto_o_categoria_chk" CHECK (((("productoid" IS NOT NULL) AND ("categoriaid" IS NULL)) OR (("productoid" IS NULL) AND ("categoriaid" IS NOT NULL)))),
    CONSTRAINT "listaspreciosdetalle_rangos_validos_chk" CHECK ((("rangomin" > (0)::numeric) AND (("rangomax" IS NULL) OR ("rangomax" >= "rangomin"))))
);


ALTER TABLE "public"."listaspreciosdetalle" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."marcas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "nombre" "text" NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."marcas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."misiones_conteo" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "sucursal_id" "uuid" NOT NULL,
    "bodega_id" "uuid",
    "zona_producto" "text",
    "estado" "text" NOT NULL,
    "asignada_por" "uuid" NOT NULL,
    "asignada_a" "uuid" NOT NULL,
    "aprobada_por" "uuid",
    "comentario" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_at" timestamp with time zone,
    "updated_by" "uuid",
    "zonaid" "uuid",
    "fechainicio" timestamp with time zone,
    "fechafin" timestamp with time zone,
    CONSTRAINT "misiones_conteo_estado_check" CHECK (("estado" = ANY (ARRAY['ASIGNADA'::"text", 'EN_PROCESO'::"text", 'SUSPENDIDA'::"text", 'COMPLETADA'::"text", 'APROBADA'::"text", 'RECHAZADA'::"text"])))
);


ALTER TABLE "public"."misiones_conteo" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."misiones_conteo_detalle" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "mision_id" "uuid" NOT NULL,
    "id_producto" "uuid" NOT NULL,
    "stock_sistema" numeric,
    "cantidad_contada" numeric,
    "diferencia" numeric,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_at" timestamp with time zone,
    "updated_by" "uuid",
    "ubicacionid" "uuid",
    "unidadid" "uuid",
    "observacion" "text"
);


ALTER TABLE "public"."misiones_conteo_detalle" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."movimientos_caja" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "cajaid" "uuid",
    "turnoid" "uuid" NOT NULL,
    "jornadaid" "uuid" NOT NULL,
    "registradopor" "uuid" NOT NULL,
    "tipo" "public"."movimiento_tipo" NOT NULL,
    "concepto" "text" NOT NULL,
    "monto" numeric NOT NULL,
    "referencia_id" "text",
    "url_soporte" "text",
    "fechahora" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid",
    CONSTRAINT "movimientos_caja_devolucion_referencia" CHECK ((("tipo" <> 'DEVOLUCION'::"public"."movimiento_tipo") OR (("tipo" = 'DEVOLUCION'::"public"."movimiento_tipo") AND ("referencia_id" IS NOT NULL)))),
    CONSTRAINT "movimientos_caja_monto_check" CHECK (("monto" > (0)::numeric))
);


ALTER TABLE "public"."movimientos_caja" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."movimientosinventario" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "tipo" "public"."movimiento_tipo" NOT NULL,
    "productoid" "uuid" NOT NULL,
    "varianteid" "uuid",
    "unidadid" "uuid" NOT NULL,
    "cantidad" numeric NOT NULL,
    "cantidadbase" numeric NOT NULL,
    "bodegaorigenid" "uuid",
    "bodegadestinoid" "uuid",
    "ubicacionorigenid" "uuid",
    "ubicaciondestinoid" "uuid",
    "referenciatipo" "public"."movimiento_referencia_tipo",
    "referenciaid" "uuid",
    "fechamovimiento" timestamp with time zone DEFAULT "now"() NOT NULL,
    "usuarioid" "uuid",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."movimientosinventario" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."notificaciones_usuario" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid",
    "userid" "uuid" NOT NULL,
    "evento" "text" NOT NULL,
    "titulo" "text" NOT NULL,
    "mensaje" "text" NOT NULL,
    "url" "text",
    "leida" boolean DEFAULT false NOT NULL,
    "fechaleida" timestamp with time zone,
    "referenciaid" "uuid",
    "referenciatipo" "text",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid"
);


ALTER TABLE "public"."notificaciones_usuario" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."novedades_inventario" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "productoid" "uuid" NOT NULL,
    "reportadopor" "uuid" NOT NULL,
    "tipo" "public"."novedad_tipo" NOT NULL,
    "estado" "public"."novedad_estado" DEFAULT 'REPORTADA'::"public"."novedad_estado" NOT NULL,
    "cantidad_afectada" numeric NOT NULL,
    "comentario" "text",
    "url_foto" "text",
    "proveedorid" "uuid",
    "genera_sugerencia" boolean DEFAULT false NOT NULL,
    "aprobadopor" "uuid",
    "fecha_aprobacion" timestamp with time zone,
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."novedades_inventario" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."oc_recepcion_anomalias" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "id_recepcion" "uuid" NOT NULL,
    "id_producto" "uuid",
    "tipo_anomalia" "text" NOT NULL,
    "cantidad_reportada" numeric,
    "comentario" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid"
);


ALTER TABLE "public"."oc_recepcion_anomalias" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."oc_recepcion_conteo" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "recepcionid" "uuid" NOT NULL,
    "productoid" "uuid" NOT NULL,
    "cantidad_oc" numeric DEFAULT 0 NOT NULL,
    "cantidad_recibida" numeric DEFAULT 0 NOT NULL,
    "cantidad_pendiente" numeric DEFAULT 0 NOT NULL,
    "estado_fisico" "public"."estado_fisico" DEFAULT 'BUENO'::"public"."estado_fisico" NOT NULL,
    "lote" "text",
    "fecha_vencimiento" "date",
    "precio_oc" numeric,
    "precio_factura" numeric,
    "diferencia_precio" numeric,
    "observaciones" "text",
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."oc_recepcion_conteo" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."oc_recepcion_fotos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "id_recepcion" "uuid" NOT NULL,
    "url_foto" "text" NOT NULL,
    "descripcion" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid"
);


ALTER TABLE "public"."oc_recepcion_fotos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."oc_recepciones" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "id_orden_compra" "uuid" NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "sucursal_id" "uuid" NOT NULL,
    "empleado_id" "uuid" NOT NULL,
    "fecha_recepcion" timestamp with time zone DEFAULT "now"() NOT NULL,
    "estado" "text" NOT NULL,
    "comentario" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_at" timestamp with time zone,
    "updated_by" "uuid",
    "estado_factura" "public"."estado_factura" DEFAULT 'RECIBIDA'::"public"."estado_factura" NOT NULL,
    "precio_oc_total" numeric,
    "precio_factura_total" numeric,
    "diferencia_precio" numeric,
    "requiere_autorizacion" boolean DEFAULT false NOT NULL,
    "estado_autorizacion" "public"."estado_autorizacion" DEFAULT 'PENDIENTE'::"public"."estado_autorizacion" NOT NULL,
    "autorizado_por" "uuid",
    "fecha_autorizacion" timestamp with time zone,
    "cotejo_ciego" boolean DEFAULT false NOT NULL,
    "nota_autorizacion" "text",
    CONSTRAINT "oc_recepciones_estado_check" CHECK (("estado" = ANY (ARRAY['EN_PROCESO'::"text", 'COMPLETADA'::"text", 'ANULADA'::"text"])))
);


ALTER TABLE "public"."oc_recepciones" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."ordenesVenta" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "clienteid" "uuid" NOT NULL,
    "vendedorid" "uuid",
    "canal" "public"."ordenventa_canal" NOT NULL,
    "listaPrecioId" "uuid",
    "fechaPedido" timestamp with time zone DEFAULT "now"() NOT NULL,
    "fechaCompromiso" timestamp with time zone,
    "estado" "public"."ordenventa_estado" DEFAULT 'BORRADOR'::"public"."ordenventa_estado" NOT NULL,
    "condicionPago" "text" DEFAULT 'CONTADO'::"text" NOT NULL,
    "diasPlazo" integer,
    "subtotal" numeric(18,6) DEFAULT 0 NOT NULL,
    "descuentoTotal" numeric(18,6) DEFAULT 0 NOT NULL,
    "total" numeric(18,6) DEFAULT 0 NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."ordenesVenta" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."ordenes_compra_detalle" (
    "id_oc_linea" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "id_orden_compra" "uuid" NOT NULL,
    "id_producto" "uuid",
    "cod_producto" "text",
    "variante" "text",
    "cantidad" numeric,
    "um_compra" "text",
    "costo_unitario" numeric,
    "descuento_raw" "text",
    "nombre_impuesto" "text",
    "caducidad_fecha" "date",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_at" timestamp with time zone,
    "updated_by" "uuid",
    "cantidad_oc" numeric,
    "cantidad_recibida" numeric DEFAULT 0 NOT NULL,
    "cantidad_pendiente" numeric,
    "ultima_recepcion_at" timestamp with time zone,
    "id" "uuid" DEFAULT "gen_random_uuid"()
);


ALTER TABLE "public"."ordenes_compra_detalle" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."ordenes_compra_encabezado" (
    "id_orden_compra" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "id_sucursal" "uuid" NOT NULL,
    "id_bodega" "uuid",
    "id_proveedor" "uuid",
    "num_oc" "text" NOT NULL,
    "fecha_oc" "date" NOT NULL,
    "tipo_compra" "text",
    "estado" "text" NOT NULL,
    "flete_otro_gasto" numeric,
    "flete_prorratear" boolean,
    "nota" "text",
    "created_by" "uuid" NOT NULL,
    "empleado_asignado_id" "uuid" NOT NULL,
    "encargado_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_by" "uuid",
    "updated_at" timestamp with time zone,
    "fecha_aprobacion" timestamp with time zone,
    "aprobado_por" "uuid",
    "fecha_ultima_recepcion" timestamp with time zone,
    "recepcion_completa" boolean DEFAULT false NOT NULL,
    "id" "uuid" DEFAULT "gen_random_uuid"()
);


ALTER TABLE "public"."ordenes_compra_encabezado" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."ordenescompra" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "numero" "text" NOT NULL,
    "fecha" "date" DEFAULT CURRENT_DATE NOT NULL,
    "proveedorid" "uuid" NOT NULL,
    "estado" "public"."ordencompra_estado" DEFAULT 'BORRADOR'::"public"."ordencompra_estado" NOT NULL,
    "observaciones" "text",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."ordenescompra" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."ordenescompradetalle" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "ordenid" "uuid" NOT NULL,
    "productoid" "uuid" NOT NULL,
    "varianteid" "uuid",
    "unidadid" "uuid" NOT NULL,
    "cantidad" numeric NOT NULL,
    "cantidadrecibida" numeric DEFAULT 0 NOT NULL,
    "observaciones" "text",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid",
    CONSTRAINT "ordenescompradetalle_cantidad_check" CHECK (("cantidad" > (0)::numeric))
);


ALTER TABLE "public"."ordenescompradetalle" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pagos_compras" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "sucursal_id" "uuid" NOT NULL,
    "turno_id" "uuid",
    "arqueo_id" "uuid",
    "compra_id" "uuid",
    "proveedor_id" "uuid",
    "cliente_id" "uuid",
    "fecha_pago" timestamp with time zone DEFAULT "now"() NOT NULL,
    "monto" numeric NOT NULL,
    "moneda" "text" DEFAULT 'COP'::"text" NOT NULL,
    "canal" "text" NOT NULL,
    "referencia_pago" "text",
    "numero_factura_ref" "text",
    "origen_detectado" "text",
    "comentario" "text",
    "url_comprobante" "text",
    "creado_por" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_by" "uuid",
    "updated_at" timestamp with time zone
);


ALTER TABLE "public"."pagos_compras" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pedidosVenta" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "clienteid" "uuid" NOT NULL,
    "vendedorid" "uuid",
    "canal" "public"."ordenventa_canal" NOT NULL,
    "listaPrecioId" "uuid",
    "fechaPedido" timestamp with time zone DEFAULT "now"() NOT NULL,
    "fechaCompromiso" timestamp with time zone,
    "estado" "public"."ordenventa_estado" DEFAULT 'BORRADOR'::"public"."ordenventa_estado" NOT NULL,
    "condicionPago" "text" DEFAULT 'CONTADO'::"text" NOT NULL,
    "diasPlazo" integer,
    "subtotal" numeric(18,6) DEFAULT 0 NOT NULL,
    "descuentoTotal" numeric(18,6) DEFAULT 0 NOT NULL,
    "total" numeric(18,6) DEFAULT 0 NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid",
    CONSTRAINT "pedidosVenta_estado_chk" CHECK (("estado" = ANY (ARRAY['CREADO'::"public"."ordenventa_estado", 'EN_ARMADO'::"public"."ordenventa_estado", 'ARMADO'::"public"."ordenventa_estado", 'CANCELADO'::"public"."ordenventa_estado"])))
);


ALTER TABLE "public"."pedidosVenta" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."pedidosVentaLineas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "pedidoVentaId" "uuid" NOT NULL,
    "lineaNumero" integer NOT NULL,
    "productoId" "uuid" NOT NULL,
    "unidadId" "uuid" NOT NULL,
    "cantidad" numeric(18,6) NOT NULL,
    "precioUnitario" numeric(18,6) NOT NULL,
    "descuentoPorcentaje" numeric(5,2),
    "descuentoValor" numeric(18,6),
    "subtotalLinea" numeric(18,6) DEFAULT 0 NOT NULL,
    "factorReferenciaSnapshot" numeric(18,6) NOT NULL,
    "tipoStock" "public"."productounidad_tipostock" NOT NULL,
    "atributos" "jsonb",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid",
    "estadoLinea" "public"."pedido_linea_estado" DEFAULT 'NORMAL'::"public"."pedido_linea_estado" NOT NULL
);


ALTER TABLE "public"."pedidosVentaLineas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."producto_codigos_externos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "productoid" "uuid" NOT NULL,
    "varianteid" "uuid",
    "tipo" "public"."codigo_externo_tipo" NOT NULL,
    "codigo" "text" NOT NULL,
    "proveedorid" "uuid",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."producto_codigos_externos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."productos" (
    "id_producto" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "sku_codigo" "text" NOT NULL,
    "nombre" "text" NOT NULL,
    "categoria" "text",
    "subcategoria" "text",
    "codigo_subcategoria" "text",
    "clase_codigo_barras" "text",
    "codigo_barras" "text",
    "um_base" "text",
    "um_venta" "text",
    "um_compra" "text",
    "factor_um_base" numeric,
    "costo_ultimo" numeric,
    "costo_promedio" numeric,
    "precio_lista_base" numeric,
    "precio_lista_bolsas" numeric,
    "stock_alerta" numeric,
    "tasa_impuesto" "text",
    "metodo_calculo_impuesto" "text",
    "url_imagen" "text",
    "stock_sucursal_1" numeric,
    "stock_sucursal_2" numeric,
    "stock_total" numeric,
    "producto_inactivo" boolean DEFAULT false,
    "zona_producto" "text",
    "peso" numeric,
    "dimensiones" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_at" timestamp with time zone,
    "updated_by" "uuid",
    "id" "uuid" DEFAULT "gen_random_uuid"()
);


ALTER TABLE "public"."productos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."productos_erp" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "codigointerno" "text" NOT NULL,
    "nombre" "text" NOT NULL,
    "descripcion" "text",
    "categoriaid" "uuid",
    "marcaid" "uuid",
    "unidadbaseid" "uuid" NOT NULL,
    "escombo" boolean DEFAULT false NOT NULL,
    "estado" "public"."producto_estado" DEFAULT 'ACTIVO'::"public"."producto_estado" NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid",
    "nombrelargo" "text",
    "referencia_legacy" "text",
    "categoriaid_n2" "uuid",
    "categoriaid_n3" "uuid",
    "lineaid" "uuid",
    "tipo_producto" "text" DEFAULT 'FISICO'::"text" NOT NULL,
    "controla_stock" boolean DEFAULT true NOT NULL,
    "permite_conteo_ciclico" boolean DEFAULT true NOT NULL,
    "maneja_lotes" boolean DEFAULT false NOT NULL,
    "maneja_vencimiento" boolean DEFAULT false NOT NULL,
    "es_perecedero" boolean DEFAULT false NOT NULL,
    "pesounidad_referencia" numeric(18,6),
    "volumenunidad_referencia" numeric(18,6),
    "se_compra" boolean DEFAULT true NOT NULL,
    "se_vende" boolean DEFAULT true NOT NULL,
    "se_traslada" boolean DEFAULT true NOT NULL,
    "aparece_en_pos" boolean DEFAULT false NOT NULL,
    "admite_devoluciones" boolean DEFAULT true NOT NULL,
    "codigo_sae" "text",
    "codigo_ecommerce" "text"
);


ALTER TABLE "public"."productos_erp" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."productounidades" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "productoid" "uuid" NOT NULL,
    "unidadid" "uuid" NOT NULL,
    "factorbase" numeric NOT NULL,
    "esbase" boolean DEFAULT false NOT NULL,
    "escompra" boolean DEFAULT false NOT NULL,
    "esventa" boolean DEFAULT false NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid",
    "esreferencia" boolean DEFAULT false NOT NULL,
    "esindependiente" boolean DEFAULT false NOT NULL,
    "factorreferencia" numeric(18,6),
    "rolcompra" boolean DEFAULT false NOT NULL,
    "rolventa" boolean DEFAULT false NOT NULL,
    "roltraslado" boolean DEFAULT false NOT NULL,
    "rolpos" boolean DEFAULT false NOT NULL,
    "tipostock" "public"."productounidad_tipostock" DEFAULT 'FISICA'::"public"."productounidad_tipostock" NOT NULL,
    "activa" boolean DEFAULT true NOT NULL,
    CONSTRAINT "productounidades_factorbase_check" CHECK (("factorbase" > (0)::numeric))
);


ALTER TABLE "public"."productounidades" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."proveedores" (
    "id_tercero" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "tipo_tercero" "text" DEFAULT 'proveedor'::"text",
    "estado" "text",
    "tipo_documento" "text",
    "num_documento" "text",
    "dv" "text",
    "tipo_persona" "text",
    "razon_social" "text",
    "nombre_contacto" "text",
    "direccion" "text",
    "ciudad" "text",
    "departamento" "text",
    "codigo_postal" "text",
    "pais" "text",
    "telefono" "text",
    "email" "text",
    "condicion_pago" "text",
    "cuenta_bancaria" "text",
    "campo_personalizado_2" "text",
    "campo_personalizado_3" "text",
    "campo_personalizado_4" "text",
    "campo_personalizado_5" "text",
    "campo_personalizado_6" "text",
    "es_transportista" boolean DEFAULT false,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_at" timestamp with time zone,
    "updated_by" "uuid",
    "fecha_ultima_compra" timestamp with time zone,
    "dias_entrega_promedio" numeric,
    "score_cumplimiento" numeric,
    "id" "uuid" DEFAULT "gen_random_uuid"(),
    "whatsapp" "text",
    "lead_time_dias" integer DEFAULT 0,
    "categoria_proveedor" "text",
    "sitio_web" "text",
    "activo" boolean DEFAULT true NOT NULL,
    "sync_status" "text" DEFAULT 'SYNCED'::"text" NOT NULL,
    "deleted_at" timestamp with time zone,
    CONSTRAINT "proveedores_sync_status_check" CHECK (("sync_status" = ANY (ARRAY['SYNCED'::"text", 'PENDING'::"text", 'CONFLICT'::"text"])))
);


ALTER TABLE "public"."proveedores" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."proveedores_contactos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "proveedorid" "uuid" NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "nombre" "text" NOT NULL,
    "cargo" "text",
    "email" "text",
    "telefono" "text",
    "whatsapp" "text",
    "esprincipal" boolean DEFAULT false NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."proveedores_contactos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."proveedores_documentos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "proveedorid" "uuid" NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "tipodocumento" "text" NOT NULL,
    "nombre" "text" NOT NULL,
    "url" "text",
    "fechavence" "date",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."proveedores_documentos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."proveedores_evaluaciones" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "proveedorid" "uuid" NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "periodo" "date" NOT NULL,
    "puntajecalidad" numeric,
    "puntajeentrega" numeric,
    "pedidostotales" integer DEFAULT 0,
    "pedidosatiempo" integer DEFAULT 0,
    "incidencias" integer DEFAULT 0,
    "observaciones" "text",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid"
);


ALTER TABLE "public"."proveedores_evaluaciones" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."recepcionescompra" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "ordenid" "uuid" NOT NULL,
    "numero" "text" NOT NULL,
    "fecha" "date" DEFAULT CURRENT_DATE NOT NULL,
    "bodegaid" "uuid" NOT NULL,
    "estado" "public"."recepcion_estado" DEFAULT 'BORRADOR'::"public"."recepcion_estado" NOT NULL,
    "observaciones" "text",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."recepcionescompra" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."recepcionescompradetalle" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "recepcionid" "uuid" NOT NULL,
    "ordendetalleid" "uuid" NOT NULL,
    "productoid" "uuid" NOT NULL,
    "varianteid" "uuid",
    "unidadid" "uuid" NOT NULL,
    "cantidad" numeric NOT NULL,
    "cantidadbase" numeric NOT NULL,
    "ubicacionid" "uuid" NOT NULL,
    "observaciones" "text",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid",
    CONSTRAINT "recepcionescompradetalle_cantidad_check" CHECK (("cantidad" > (0)::numeric)),
    CONSTRAINT "recepcionescompradetalle_cantidadbase_check" CHECK (("cantidadbase" > (0)::numeric))
);


ALTER TABLE "public"."recepcionescompradetalle" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."role_permissions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "rol" "text" NOT NULL,
    "puede_ver_costo" boolean DEFAULT false NOT NULL,
    "puede_ver_margen" boolean DEFAULT false NOT NULL,
    "puede_ver_precio_venta" boolean DEFAULT true NOT NULL,
    "puede_ver_stock_valor" boolean DEFAULT false NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_at" timestamp with time zone,
    "updated_by" "uuid",
    CONSTRAINT "role_permissions_rol_check" CHECK (("rol" = ANY (ARRAY['admin'::"text", 'encargado'::"text", 'empleado'::"text"])))
);


ALTER TABLE "public"."role_permissions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."roles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "codigo" "text" NOT NULL,
    "nombre" "text" NOT NULL,
    "descripcion" "text",
    "activo" boolean DEFAULT true NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."roles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."stockubicacion" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "ubicacionid" "uuid" NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "bodegaid" "uuid" NOT NULL,
    "productoid" "uuid" NOT NULL,
    "varianteid" "uuid",
    "cantactual" numeric DEFAULT 0 NOT NULL,
    "cantminima" numeric DEFAULT 0 NOT NULL,
    "cantmaxima" numeric,
    "cantemergencia" numeric DEFAULT 0 NOT NULL,
    "cantreservada" numeric DEFAULT 0 NOT NULL,
    "cantentransito" numeric DEFAULT 0 NOT NULL,
    "ultimaactualizacion" timestamp with time zone DEFAULT "now"() NOT NULL,
    "diassinmovimiento" integer DEFAULT 0 NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid"
);


ALTER TABLE "public"."stockubicacion" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."sucursales" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "nombre" "text" NOT NULL,
    "codigo" "text",
    "activa" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "direccion" "text",
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."sucursales" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."sugerencias_pedido" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "productoid" "uuid" NOT NULL,
    "proveedorid" "uuid",
    "novedad_id" "uuid",
    "cantidad_sugerida" numeric NOT NULL,
    "motivo" "text",
    "estado" "public"."sugerencia_estado" DEFAULT 'PENDIENTE'::"public"."sugerencia_estado" NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."sugerencias_pedido" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tareas" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "jornadaid" "uuid",
    "tipotareaid" "uuid" NOT NULL,
    "asignadapor" "uuid" NOT NULL,
    "asignadaa" "uuid" NOT NULL,
    "descripcion" "text",
    "estado" "public"."tarea_estado" DEFAULT 'PENDIENTE'::"public"."tarea_estado" NOT NULL,
    "prioridad" "public"."tarea_prioridad" DEFAULT 'MEDIA'::"public"."tarea_prioridad" NOT NULL,
    "referenciaid" "uuid",
    "fechaprogramada" timestamp with time zone,
    "fechainicio" timestamp with time zone,
    "fechafin" timestamp with time zone,
    "comentario" "text",
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."tareas" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tareas_detalle_traslado" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tareaid" "uuid" NOT NULL,
    "productoid" "uuid" NOT NULL,
    "cantidad_pedida" numeric NOT NULL,
    "cantidad_movida" numeric DEFAULT 0 NOT NULL,
    "observaciones" "text",
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."tareas_detalle_traslado" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tareas_turno" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "turno_id" "uuid" NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "sucursal_id" "uuid" NOT NULL,
    "usuario_id" "uuid" NOT NULL,
    "tipo_tarea_id" "uuid" NOT NULL,
    "referencia_id" "uuid",
    "descripcion" "text",
    "estado" "text" NOT NULL,
    "comentario" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_at" timestamp with time zone,
    "updated_by" "uuid",
    CONSTRAINT "tareas_turno_estado_check" CHECK (("estado" = ANY (ARRAY['PENDIENTE'::"text", 'EN_PROCESO'::"text", 'COMPLETADA'::"text", 'EN_REVISION'::"text"])))
);


ALTER TABLE "public"."tareas_turno" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tipos_tarea" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "nombre" "text" NOT NULL,
    "descripcion" "text",
    "categoria" "text",
    "activo" boolean DEFAULT true NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."tipos_tarea" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tipos_tarea_turno" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "nombre" "text" NOT NULL,
    "descripcion" "text",
    "activo" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid"
);


ALTER TABLE "public"."tipos_tarea_turno" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."traslados_detalle" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "trasladoid" "uuid" NOT NULL,
    "productoid" "uuid" NOT NULL,
    "varianteid" "uuid",
    "ubicacionorigenid" "uuid" NOT NULL,
    "unidadid" "uuid" NOT NULL,
    "cantidadsolicitada" numeric NOT NULL,
    "cantidadbasesolicitada" numeric NOT NULL,
    "cantidadrecibida" numeric,
    "cantidadbaserecibida" numeric,
    "estadofisico" "public"."estadofisico_tipo",
    "lote" "text",
    "fechavencimiento" "date",
    "notalinea" "text",
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid",
    "traslado_id" "uuid",
    "producto_id" "uuid",
    "cantidad" numeric,
    "costo_unitario_ref" numeric,
    "lote_codigo" "text",
    "caducidad_fecha" "date",
    "nota_linea" "text",
    CONSTRAINT "traslados_detalle_cantidadbasesolicitada_check" CHECK (("cantidadbasesolicitada" > (0)::numeric)),
    CONSTRAINT "traslados_detalle_cantidadsolicitada_check" CHECK (("cantidadsolicitada" > (0)::numeric))
);


ALTER TABLE "public"."traslados_detalle" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."traslados_encabezado" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "numtraslado" "text" NOT NULL,
    "bodegaorigenid" "uuid" NOT NULL,
    "bodegadestinoid" "uuid" NOT NULL,
    "estado" "public"."traslado_estado" DEFAULT 'BORRADOR'::"public"."traslado_estado" NOT NULL,
    "solicitadopor" "uuid",
    "aprobadopor" "uuid",
    "ejecutadopor" "uuid",
    "receptorid" "uuid",
    "motivotraslado" "text",
    "notarechazo" "text",
    "fechasolicitud" timestamp with time zone DEFAULT "now"() NOT NULL,
    "fechaaprobacion" timestamp with time zone,
    "fechainiciotransito" timestamp with time zone,
    "fechacompletado" timestamp with time zone,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid",
    "empresa_id" "uuid",
    "ubicacion_origen_id" "uuid",
    "ubicacion_destino_id" "uuid",
    "num_traslado" "text",
    "fecha_traslado" "date",
    "motivo" "text",
    "nota" "text",
    "empleado_asignado_id" "uuid",
    "creado_por_id" "uuid",
    "sync_status" "text" DEFAULT 'SYNCED'::"text" NOT NULL,
    "deleted_at" timestamp with time zone,
    CONSTRAINT "traslados_enc_sync_status_check" CHECK (("sync_status" = ANY (ARRAY['SYNCED'::"text", 'PENDING'::"text", 'CONFLICT'::"text"])))
);


ALTER TABLE "public"."traslados_encabezado" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."turnos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "jornadaid" "uuid" NOT NULL,
    "turnoorigenid" "uuid",
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "cajaid" "uuid",
    "usuarioid" "uuid" NOT NULL,
    "fechaapertura" timestamp with time zone DEFAULT "now"() NOT NULL,
    "fechacierre" timestamp with time zone,
    "estado" "public"."turno_estado" DEFAULT 'ABIERTO'::"public"."turno_estado" NOT NULL,
    "escierre_final" boolean DEFAULT false NOT NULL,
    "observaciones" "text",
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid",
    "monto_apertura" numeric DEFAULT 0 NOT NULL,
    "monto_dejado" numeric DEFAULT 0 NOT NULL,
    "monto_retirado" numeric DEFAULT 0 NOT NULL,
    "monto_apertura_sugerido" numeric DEFAULT 0 NOT NULL,
    "monto_apertura_ajustado" numeric,
    "estado_apertura" "text" DEFAULT 'APROBADO'::"text" NOT NULL,
    "apertura_aprobada_por" "uuid",
    "apertura_fecha_aprobacion" timestamp with time zone,
    "apertura_nota" "text"
);


ALTER TABLE "public"."turnos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."turnos_caja" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresa_id" "uuid" NOT NULL,
    "sucursal_id" "uuid" NOT NULL,
    "usuario_id" "uuid" NOT NULL,
    "caja_id" "uuid",
    "estado" "text" NOT NULL,
    "turno_origen_id" "uuid",
    "fecha_apertura" timestamp with time zone DEFAULT "now"() NOT NULL,
    "fecha_cierre" timestamp with time zone,
    "estado_cierre" "text",
    "estado_auditoria" "text",
    "comentario" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid",
    "updated_at" timestamp with time zone,
    "updated_by" "uuid",
    CONSTRAINT "turnos_caja_estado_auditoria_check" CHECK (("estado_auditoria" = ANY (ARRAY['NO_REQUERIDA'::"text", 'PENDIENTE'::"text", 'EN_PROCESO'::"text", 'CERRADA'::"text"]))),
    CONSTRAINT "turnos_caja_estado_check" CHECK (("estado" = ANY (ARRAY['ABIERTO'::"text", 'SUSPENDIDO'::"text", 'TRANSFERIDO'::"text", 'CERRADO'::"text"]))),
    CONSTRAINT "turnos_caja_estado_cierre_check" CHECK (("estado_cierre" = ANY (ARRAY['SIN_INICIAR'::"text", 'EN_PROCESO'::"text", 'COMPLETADO_OK'::"text", 'COMPLETADO_CON_ANOMALIAS'::"text"])))
);


ALTER TABLE "public"."turnos_caja" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."zonasbodega" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "bodegaid" "uuid" NOT NULL,
    "codigo" "text" NOT NULL,
    "nombre" "text" NOT NULL,
    "activa" boolean DEFAULT true NOT NULL
);


ALTER TABLE "public"."zonasbodega" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vw_ubicaciones_bodega" WITH ("security_invoker"='true') AS
 SELECT "b"."id" AS "bodegaid",
    "z"."id" AS "zonaid",
    "e"."id" AS "estanteriaid",
    "f"."id" AS "filaid",
    "c"."id" AS "cubiculoid",
    ((((((("b"."codigo" || '-'::"text") || "z"."codigo") || '-'::"text") || "e"."codigo") || '-'::"text") || "f"."codigo") || COALESCE(('-'::"text" || "c"."codigo"), ''::"text")) AS "codigocompleto",
    true AS "activa"
   FROM (((("public"."bodegas" "b"
     JOIN "public"."zonasbodega" "z" ON (("z"."bodegaid" = "b"."id")))
     JOIN "public"."estanterias" "e" ON (("e"."zonaid" = "z"."id")))
     JOIN "public"."filasestanteria" "f" ON (("f"."estanteriaid" = "e"."id")))
     LEFT JOIN "public"."cubiculosfila" "c" ON (("c"."filaid" = "f"."id")));


ALTER VIEW "public"."vw_ubicaciones_bodega" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."unidadesmedida" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "codigo" "text" NOT NULL,
    "nombre" "text" NOT NULL,
    "tipo" "public"."unidad_tipo" DEFAULT 'BASE'::"public"."unidad_tipo" NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "createdby" "uuid",
    "updatedat" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updatedby" "uuid",
    "abreviatura" "text"
);


ALTER TABLE "public"."unidadesmedida" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_profiles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "userid" "uuid" NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "nombre" "text",
    "activo" boolean DEFAULT true NOT NULL,
    "encargadoid" "uuid",
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid",
    "pendiente_aprobacion" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."user_profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_roles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "userid" "uuid" NOT NULL,
    "rolid" "uuid" NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "activo" boolean DEFAULT true NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."user_roles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_sucursales" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "userid" "uuid" NOT NULL,
    "empresaid" "uuid" NOT NULL,
    "sucursalid" "uuid" NOT NULL,
    "es_principal" boolean DEFAULT false NOT NULL,
    "activa" boolean DEFAULT true NOT NULL,
    "createdat" timestamp with time zone DEFAULT "now"(),
    "createdby" "uuid" DEFAULT "auth"."uid"(),
    "updatedat" timestamp with time zone,
    "updatedby" "uuid"
);


ALTER TABLE "public"."user_sucursales" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vstockbodega" WITH ("security_invoker"='true') AS
 SELECT "empresaid",
    "sucursalid",
    "bodegaid",
    "productoid",
    "varianteid",
    "sum"("cantactual") AS "canttotal",
    "sum"("cantreservada") AS "cantreservadatotal",
    "sum"("cantentransito") AS "canttransitototal"
   FROM "public"."stockubicacion"
  GROUP BY "empresaid", "sucursalid", "bodegaid", "productoid", "varianteid";


ALTER VIEW "public"."vstockbodega" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."vstocksucursal" WITH ("security_invoker"='true') AS
 SELECT "empresaid",
    "sucursalid",
    "productoid",
    "varianteid",
    "sum"("cantactual") AS "canttotal"
   FROM "public"."stockubicacion"
  GROUP BY "empresaid", "sucursalid", "productoid", "varianteid";


ALTER VIEW "public"."vstocksucursal" OWNER TO "postgres";


ALTER TABLE ONLY "public"."arqueos_caja"
    ADD CONSTRAINT "arqueos_caja_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."arqueos_efectivo_detalle"
    ADD CONSTRAINT "arqueos_efectivo_detalle_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."arqueos_otros_medios"
    ADD CONSTRAINT "arqueos_otros_medios_arqueoid_metodo_key" UNIQUE ("arqueoid", "metodo_pago");



ALTER TABLE ONLY "public"."arqueos_otros_medios"
    ADD CONSTRAINT "arqueos_otros_medios_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."audit_log"
    ADD CONSTRAINT "audit_log_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."bodegas"
    ADD CONSTRAINT "bodegas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."cajas"
    ADD CONSTRAINT "cajas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."cajas"
    ADD CONSTRAINT "cajas_sucursalid_codigo_key" UNIQUE ("sucursalid", "codigo");



ALTER TABLE ONLY "public"."categorias_producto"
    ADD CONSTRAINT "categorias_producto_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."categoriasproducto"
    ADD CONSTRAINT "categoriasproducto_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."clientes"
    ADD CONSTRAINT "clientes_pkey" PRIMARY KEY ("id_tercero");



ALTER TABLE ONLY "public"."compras_detalle"
    ADD CONSTRAINT "compras_detalle_pkey" PRIMARY KEY ("id_compra_linea");



ALTER TABLE ONLY "public"."compras_encabezado"
    ADD CONSTRAINT "compras_encabezado_pkey" PRIMARY KEY ("id_compra");



ALTER TABLE ONLY "public"."config_app_empresas"
    ADD CONSTRAINT "config_app_empresas_empresaid_key" UNIQUE ("empresaid");



ALTER TABLE ONLY "public"."config_app_empresas"
    ADD CONSTRAINT "config_app_empresas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."config_tipos_voucher"
    ADD CONSTRAINT "config_tipos_voucher_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."cubiculosfila"
    ADD CONSTRAINT "cubiculosfila_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."empresas"
    ADD CONSTRAINT "empresas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."estanterias"
    ADD CONSTRAINT "estanterias_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."facturasVentaLineas"
    ADD CONSTRAINT "facturasVentaLineas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."facturasVenta"
    ADD CONSTRAINT "facturasVenta_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."facturascompra"
    ADD CONSTRAINT "facturascompra_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."facturascompradetalle"
    ADD CONSTRAINT "facturascompradetalle_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."filasestanteria"
    ADD CONSTRAINT "filasestanteria_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."import_errors"
    ADD CONSTRAINT "import_errors_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."import_log"
    ADD CONSTRAINT "import_log_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."jornadas"
    ADD CONSTRAINT "jornadas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."jornadas"
    ADD CONSTRAINT "jornadas_userid_sucursalid_fecha_key" UNIQUE ("userid", "sucursalid", "fecha");



ALTER TABLE ONLY "public"."listasprecios"
    ADD CONSTRAINT "listasprecios_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."listaspreciosdetalle"
    ADD CONSTRAINT "listaspreciosdetalle_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."marcas"
    ADD CONSTRAINT "marcas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."misiones_conteo_detalle"
    ADD CONSTRAINT "misiones_conteo_detalle_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."misiones_conteo"
    ADD CONSTRAINT "misiones_conteo_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."movimientos_caja"
    ADD CONSTRAINT "movimientos_caja_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."movimientosinventario"
    ADD CONSTRAINT "movimientosinventario_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."notificaciones_usuario"
    ADD CONSTRAINT "notificaciones_usuario_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."novedades_inventario"
    ADD CONSTRAINT "novedades_inventario_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."oc_recepcion_anomalias"
    ADD CONSTRAINT "oc_recepcion_anomalias_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."oc_recepcion_conteo"
    ADD CONSTRAINT "oc_recepcion_conteo_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."oc_recepcion_fotos"
    ADD CONSTRAINT "oc_recepcion_fotos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."oc_recepciones"
    ADD CONSTRAINT "oc_recepciones_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."ordenesVenta"
    ADD CONSTRAINT "ordenesVenta_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."ordenes_compra_detalle"
    ADD CONSTRAINT "ordenes_compra_detalle_pkey" PRIMARY KEY ("id_oc_linea");



ALTER TABLE ONLY "public"."ordenes_compra_encabezado"
    ADD CONSTRAINT "ordenes_compra_encabezado_pkey" PRIMARY KEY ("id_orden_compra");



ALTER TABLE ONLY "public"."ordenescompra"
    ADD CONSTRAINT "ordenescompra_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."ordenescompradetalle"
    ADD CONSTRAINT "ordenescompradetalle_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."pagos_compras"
    ADD CONSTRAINT "pagos_compras_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."pedidosVentaLineas"
    ADD CONSTRAINT "pedidosVentaLineas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."pedidosVenta"
    ADD CONSTRAINT "pedidosVenta_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."producto_codigos_externos"
    ADD CONSTRAINT "producto_codigos_externos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."productos_erp"
    ADD CONSTRAINT "productos_erp_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."productos"
    ADD CONSTRAINT "productos_pkey" PRIMARY KEY ("id_producto");



ALTER TABLE ONLY "public"."productounidades"
    ADD CONSTRAINT "productounidades_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."proveedores_contactos"
    ADD CONSTRAINT "proveedores_contactos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."proveedores_documentos"
    ADD CONSTRAINT "proveedores_documentos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."proveedores_evaluaciones"
    ADD CONSTRAINT "proveedores_evaluaciones_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."proveedores"
    ADD CONSTRAINT "proveedores_pkey" PRIMARY KEY ("id_tercero");



ALTER TABLE ONLY "public"."recepcionescompra"
    ADD CONSTRAINT "recepcionescompra_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."recepcionescompradetalle"
    ADD CONSTRAINT "recepcionescompradetalle_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."role_permissions"
    ADD CONSTRAINT "role_permissions_empresa_id_rol_key" UNIQUE ("empresa_id", "rol");



ALTER TABLE ONLY "public"."role_permissions"
    ADD CONSTRAINT "role_permissions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_empresaid_codigo_key" UNIQUE ("empresaid", "codigo");



ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stockubicacion"
    ADD CONSTRAINT "stockubicacion_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."sucursales"
    ADD CONSTRAINT "sucursales_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."sugerencias_pedido"
    ADD CONSTRAINT "sugerencias_pedido_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tareas_detalle_traslado"
    ADD CONSTRAINT "tareas_detalle_traslado_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tareas"
    ADD CONSTRAINT "tareas_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tareas_turno"
    ADD CONSTRAINT "tareas_turno_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tipos_tarea"
    ADD CONSTRAINT "tipos_tarea_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tipos_tarea_turno"
    ADD CONSTRAINT "tipos_tarea_turno_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."traslados_detalle"
    ADD CONSTRAINT "traslados_detalle_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."traslados_encabezado"
    ADD CONSTRAINT "traslados_encabezado_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."turnos_caja"
    ADD CONSTRAINT "turnos_caja_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."turnos"
    ADD CONSTRAINT "turnos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."unidadesmedida"
    ADD CONSTRAINT "unidadesmedida_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_profiles"
    ADD CONSTRAINT "user_profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_profiles"
    ADD CONSTRAINT "user_profiles_userid_key" UNIQUE ("userid");



ALTER TABLE ONLY "public"."user_roles"
    ADD CONSTRAINT "user_roles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_roles"
    ADD CONSTRAINT "user_roles_userid_rolid_empresaid_key" UNIQUE ("userid", "rolid", "empresaid");



ALTER TABLE ONLY "public"."user_sucursales"
    ADD CONSTRAINT "user_sucursales_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_sucursales"
    ADD CONSTRAINT "user_sucursales_userid_sucursalid_key" UNIQUE ("userid", "sucursalid");



ALTER TABLE ONLY "public"."zonasbodega"
    ADD CONSTRAINT "zonasbodega_pkey" PRIMARY KEY ("id");



CREATE UNIQUE INDEX "bodegas_empresa_codigo_unico" ON "public"."bodegas" USING "btree" ("empresaid", "codigo");



CREATE UNIQUE INDEX "categorias_producto_empresa_nombre_nivel_unico" ON "public"."categorias_producto" USING "btree" ("empresaid", "nombre", "nivel");



CREATE UNIQUE INDEX "categoriasproducto_empresa_nombre_nivel_unico" ON "public"."categoriasproducto" USING "btree" ("empresaid", "nombre", "nivel");



CREATE INDEX "facturasVentaLineas_facturaVentaId_idx" ON "public"."facturasVentaLineas" USING "btree" ("facturaVentaId");



CREATE UNIQUE INDEX "facturasVentaLineas_factura_linea_uidx" ON "public"."facturasVentaLineas" USING "btree" ("facturaVentaId", "lineaNumero");



CREATE INDEX "facturasVenta_clienteid_idx" ON "public"."facturasVenta" USING "btree" ("clienteid");



CREATE INDEX "facturasVenta_empresaid_idx" ON "public"."facturasVenta" USING "btree" ("empresaid");



CREATE INDEX "facturasVenta_pedidoVentaId_idx" ON "public"."facturasVenta" USING "btree" ("pedidoVentaId");



CREATE UNIQUE INDEX "facturascompra_empresa_numero_unico" ON "public"."facturascompra" USING "btree" ("empresaid", "numerofactura");



CREATE INDEX "facturascompra_recepcion_idx" ON "public"."facturascompra" USING "btree" ("recepcionid");



CREATE INDEX "facturascompradetalle_factura_idx" ON "public"."facturascompradetalle" USING "btree" ("facturaid");



CREATE INDEX "idx_arq_efec_arqueoid" ON "public"."arqueos_efectivo_detalle" USING "btree" ("arqueoid");



CREATE INDEX "idx_arq_efec_tipo" ON "public"."arqueos_efectivo_detalle" USING "btree" ("tipo");



CREATE INDEX "idx_arq_otros_arqueoid" ON "public"."arqueos_otros_medios" USING "btree" ("arqueoid");



CREATE INDEX "idx_arq_otros_metodo" ON "public"."arqueos_otros_medios" USING "btree" ("metodo_pago");



CREATE INDEX "idx_arqueos_caja_cajaid" ON "public"."arqueos_caja" USING "btree" ("cajaid");



CREATE INDEX "idx_arqueos_caja_empresaid" ON "public"."arqueos_caja" USING "btree" ("empresaid");



CREATE INDEX "idx_arqueos_caja_estado" ON "public"."arqueos_caja" USING "btree" ("estado");



CREATE INDEX "idx_arqueos_caja_fecha" ON "public"."arqueos_caja" USING "btree" ("fechaarqueo");



CREATE INDEX "idx_arqueos_caja_jornadaid" ON "public"."arqueos_caja" USING "btree" ("jornadaid");



CREATE INDEX "idx_arqueos_caja_responsable" ON "public"."arqueos_caja" USING "btree" ("responsableid");



CREATE INDEX "idx_arqueos_caja_sucursalid" ON "public"."arqueos_caja" USING "btree" ("sucursalid");



CREATE INDEX "idx_arqueos_caja_tipo" ON "public"."arqueos_caja" USING "btree" ("tipo");



CREATE INDEX "idx_arqueos_caja_turnoid" ON "public"."arqueos_caja" USING "btree" ("turnoid");



CREATE INDEX "idx_cajas_activa" ON "public"."cajas" USING "btree" ("activa");



CREATE INDEX "idx_cajas_empresaid" ON "public"."cajas" USING "btree" ("empresaid");



CREATE INDEX "idx_cajas_sucursalid" ON "public"."cajas" USING "btree" ("sucursalid");



CREATE INDEX "idx_cfg_voucher_activo" ON "public"."config_tipos_voucher" USING "btree" ("activo");



CREATE INDEX "idx_cfg_voucher_empresaid" ON "public"."config_tipos_voucher" USING "btree" ("empresaid");



CREATE INDEX "idx_compras_det_compra" ON "public"."compras_detalle" USING "btree" ("id_compra");



CREATE INDEX "idx_compras_det_producto" ON "public"."compras_detalle" USING "btree" ("id_producto");



CREATE INDEX "idx_compras_enc_empresa" ON "public"."compras_encabezado" USING "btree" ("empresa_id");



CREATE INDEX "idx_compras_enc_proveedor" ON "public"."compras_encabezado" USING "btree" ("id_proveedor");



CREATE INDEX "idx_compras_enc_sucursal" ON "public"."compras_encabezado" USING "btree" ("id_sucursal");



CREATE INDEX "idx_mov_caja_cajaid" ON "public"."movimientos_caja" USING "btree" ("cajaid");



CREATE INDEX "idx_mov_caja_empresaid" ON "public"."movimientos_caja" USING "btree" ("empresaid");



CREATE INDEX "idx_mov_caja_fechahora" ON "public"."movimientos_caja" USING "btree" ("fechahora");



CREATE INDEX "idx_mov_caja_jornadaid" ON "public"."movimientos_caja" USING "btree" ("jornadaid");



CREATE INDEX "idx_mov_caja_registradopor" ON "public"."movimientos_caja" USING "btree" ("registradopor");



CREATE INDEX "idx_mov_caja_sucursalid" ON "public"."movimientos_caja" USING "btree" ("sucursalid");



CREATE INDEX "idx_mov_caja_tipo" ON "public"."movimientos_caja" USING "btree" ("tipo");



CREATE INDEX "idx_mov_caja_turnoid" ON "public"."movimientos_caja" USING "btree" ("turnoid");



CREATE INDEX "idx_novedades_empresaid" ON "public"."novedades_inventario" USING "btree" ("empresaid");



CREATE INDEX "idx_novedades_estado" ON "public"."novedades_inventario" USING "btree" ("estado");



CREATE INDEX "idx_novedades_productoid" ON "public"."novedades_inventario" USING "btree" ("productoid");



CREATE INDEX "idx_novedades_proveedorid" ON "public"."novedades_inventario" USING "btree" ("proveedorid");



CREATE INDEX "idx_novedades_sucursalid" ON "public"."novedades_inventario" USING "btree" ("sucursalid");



CREATE INDEX "idx_novedades_tipo" ON "public"."novedades_inventario" USING "btree" ("tipo");



CREATE INDEX "idx_oc_conteo_estado_fisico" ON "public"."oc_recepcion_conteo" USING "btree" ("estado_fisico");



CREATE INDEX "idx_oc_conteo_producto" ON "public"."oc_recepcion_conteo" USING "btree" ("productoid");



CREATE INDEX "idx_oc_conteo_recepcion" ON "public"."oc_recepcion_conteo" USING "btree" ("recepcionid");



CREATE INDEX "idx_proveedores_empresa_id" ON "public"."proveedores" USING "btree" ("empresa_id");



CREATE INDEX "idx_roles_activo" ON "public"."roles" USING "btree" ("activo");



CREATE INDEX "idx_roles_codigo" ON "public"."roles" USING "btree" ("codigo");



CREATE INDEX "idx_roles_empresaid" ON "public"."roles" USING "btree" ("empresaid");



CREATE INDEX "idx_sugerencias_empresaid" ON "public"."sugerencias_pedido" USING "btree" ("empresaid");



CREATE INDEX "idx_sugerencias_estado" ON "public"."sugerencias_pedido" USING "btree" ("estado");



CREATE INDEX "idx_sugerencias_productoid" ON "public"."sugerencias_pedido" USING "btree" ("productoid");



CREATE INDEX "idx_sugerencias_proveedorid" ON "public"."sugerencias_pedido" USING "btree" ("proveedorid");



CREATE INDEX "idx_tareas_asignadaa" ON "public"."tareas" USING "btree" ("asignadaa");



CREATE INDEX "idx_tareas_asignadapor" ON "public"."tareas" USING "btree" ("asignadapor");



CREATE INDEX "idx_tareas_empresaid" ON "public"."tareas" USING "btree" ("empresaid");



CREATE INDEX "idx_tareas_estado" ON "public"."tareas" USING "btree" ("estado");



CREATE INDEX "idx_tareas_fecha" ON "public"."tareas" USING "btree" ("fechaprogramada");



CREATE INDEX "idx_tareas_jornadaid" ON "public"."tareas" USING "btree" ("jornadaid");



CREATE INDEX "idx_tareas_prioridad" ON "public"."tareas" USING "btree" ("prioridad");



CREATE INDEX "idx_tareas_sucursalid" ON "public"."tareas" USING "btree" ("sucursalid");



CREATE INDEX "idx_tareas_tipotareaid" ON "public"."tareas" USING "btree" ("tipotareaid");



CREATE INDEX "idx_tareas_traslado_productoid" ON "public"."tareas_detalle_traslado" USING "btree" ("productoid");



CREATE INDEX "idx_tareas_traslado_tareaid" ON "public"."tareas_detalle_traslado" USING "btree" ("tareaid");



CREATE INDEX "idx_tipos_tarea_activo" ON "public"."tipos_tarea" USING "btree" ("activo");



CREATE INDEX "idx_tipos_tarea_categoria" ON "public"."tipos_tarea" USING "btree" ("categoria");



CREATE INDEX "idx_tipos_tarea_empresaid" ON "public"."tipos_tarea" USING "btree" ("empresaid");



CREATE INDEX "idx_traslados_det_producto" ON "public"."traslados_detalle" USING "btree" ("producto_id");



CREATE INDEX "idx_traslados_det_traslado" ON "public"."traslados_detalle" USING "btree" ("traslado_id");



CREATE INDEX "idx_traslados_enc_destino" ON "public"."traslados_encabezado" USING "btree" ("ubicacion_destino_id");



CREATE INDEX "idx_traslados_enc_empresa" ON "public"."traslados_encabezado" USING "btree" ("empresa_id");



CREATE INDEX "idx_traslados_enc_origen" ON "public"."traslados_encabezado" USING "btree" ("ubicacion_origen_id");



CREATE INDEX "idx_turnos_cajaid" ON "public"."turnos" USING "btree" ("cajaid");



CREATE INDEX "idx_turnos_empresaid" ON "public"."turnos" USING "btree" ("empresaid");



CREATE INDEX "idx_turnos_estado" ON "public"."turnos" USING "btree" ("estado");



CREATE INDEX "idx_turnos_fecha" ON "public"."turnos" USING "btree" ("fechaapertura");



CREATE INDEX "idx_turnos_jornadaid" ON "public"."turnos" USING "btree" ("jornadaid");



CREATE INDEX "idx_turnos_sucursalid" ON "public"."turnos" USING "btree" ("sucursalid");



CREATE INDEX "idx_turnos_turnoorigen" ON "public"."turnos" USING "btree" ("turnoorigenid");



CREATE INDEX "idx_turnos_usuarioid" ON "public"."turnos" USING "btree" ("usuarioid");



CREATE INDEX "idx_user_profiles_activo" ON "public"."user_profiles" USING "btree" ("activo");



CREATE INDEX "idx_user_profiles_empresaid" ON "public"."user_profiles" USING "btree" ("empresaid");



CREATE INDEX "idx_user_profiles_encargadoid" ON "public"."user_profiles" USING "btree" ("encargadoid");



CREATE INDEX "idx_user_profiles_pendiente" ON "public"."user_profiles" USING "btree" ("pendiente_aprobacion") WHERE ("pendiente_aprobacion" = true);



CREATE INDEX "idx_user_profiles_sucursalid" ON "public"."user_profiles" USING "btree" ("sucursalid");



CREATE INDEX "idx_user_profiles_userid" ON "public"."user_profiles" USING "btree" ("userid");



CREATE INDEX "idx_user_roles_activo" ON "public"."user_roles" USING "btree" ("activo");



CREATE INDEX "idx_user_roles_empresaid" ON "public"."user_roles" USING "btree" ("empresaid");



CREATE INDEX "idx_user_roles_rolid" ON "public"."user_roles" USING "btree" ("rolid");



CREATE INDEX "idx_user_roles_userid" ON "public"."user_roles" USING "btree" ("userid");



CREATE INDEX "idx_user_sucursales_empresaid" ON "public"."user_sucursales" USING "btree" ("empresaid");



CREATE INDEX "idx_user_sucursales_principal" ON "public"."user_sucursales" USING "btree" ("es_principal");



CREATE INDEX "idx_user_sucursales_sucursalid" ON "public"."user_sucursales" USING "btree" ("sucursalid");



CREATE INDEX "idx_user_sucursales_userid" ON "public"."user_sucursales" USING "btree" ("userid");



CREATE UNIQUE INDEX "listasprecios_empresa_nombre_unico" ON "public"."listasprecios" USING "btree" ("empresaid", "nombre");



CREATE INDEX "listaspreciosdetalle_lista_productorango_idx" ON "public"."listaspreciosdetalle" USING "btree" ("listaid", "productoid", "rangomin", "rangomax");



CREATE UNIQUE INDEX "marcas_empresa_nombre_unico" ON "public"."marcas" USING "btree" ("empresaid", "nombre");



CREATE INDEX "movimientosinventario_empresa_fecha_idx" ON "public"."movimientosinventario" USING "btree" ("empresaid", "fechamovimiento");



CREATE INDEX "movimientosinventario_producto_idx" ON "public"."movimientosinventario" USING "btree" ("productoid");



CREATE INDEX "movimientosinventario_referencia_idx" ON "public"."movimientosinventario" USING "btree" ("referenciaid");



CREATE INDEX "notificaciones_usuario_empresa_idx" ON "public"."notificaciones_usuario" USING "btree" ("empresaid", "createdat" DESC);



CREATE INDEX "notificaciones_usuario_userid_idx" ON "public"."notificaciones_usuario" USING "btree" ("userid", "leida", "createdat" DESC);



CREATE INDEX "ordenesVenta_clienteid_idx" ON "public"."ordenesVenta" USING "btree" ("clienteid");



CREATE INDEX "ordenesVenta_empresaid_idx" ON "public"."ordenesVenta" USING "btree" ("empresaid");



CREATE INDEX "ordenesVenta_estado_idx" ON "public"."ordenesVenta" USING "btree" ("estado");



CREATE UNIQUE INDEX "ordenescompra_empresa_numero_unico" ON "public"."ordenescompra" USING "btree" ("empresaid", "numero");



CREATE INDEX "ordenescompradetalle_orden_idx" ON "public"."ordenescompradetalle" USING "btree" ("ordenid");



CREATE INDEX "pedidosVentaLineas_pedidoVentaId_idx" ON "public"."pedidosVentaLineas" USING "btree" ("pedidoVentaId");



CREATE UNIQUE INDEX "pedidosVentaLineas_pedido_linea_uidx" ON "public"."pedidosVentaLineas" USING "btree" ("pedidoVentaId", "lineaNumero");



CREATE INDEX "pedidosVenta_clienteid_idx" ON "public"."pedidosVenta" USING "btree" ("clienteid");



CREATE INDEX "pedidosVenta_empresaid_idx" ON "public"."pedidosVenta" USING "btree" ("empresaid");



CREATE INDEX "pedidosVenta_estado_idx" ON "public"."pedidosVenta" USING "btree" ("estado");



CREATE UNIQUE INDEX "producto_codigos_externos_codigo_unico" ON "public"."producto_codigos_externos" USING "btree" ("codigo");



CREATE UNIQUE INDEX "productos_erp_empresa_codigo_unico" ON "public"."productos_erp" USING "btree" ("empresaid", "codigointerno");



CREATE UNIQUE INDEX "productos_erp_empresa_codigointerno_uidx" ON "public"."productos_erp" USING "btree" ("empresaid", "lower"("codigointerno"));



CREATE UNIQUE INDEX "productounidades_producto_unidad_unico" ON "public"."productounidades" USING "btree" ("productoid", "unidadid");



CREATE UNIQUE INDEX "productounidades_referencia_uidx" ON "public"."productounidades" USING "btree" ("productoid") WHERE ("esreferencia" = true);



CREATE UNIQUE INDEX "recepcionescompra_empresa_numero_unico" ON "public"."recepcionescompra" USING "btree" ("empresaid", "numero");



CREATE INDEX "recepcionescompra_orden_idx" ON "public"."recepcionescompra" USING "btree" ("ordenid");



CREATE INDEX "recepcionescompradetalle_recepcion_idx" ON "public"."recepcionescompradetalle" USING "btree" ("recepcionid");



CREATE UNIQUE INDEX "stockubicacion_unico" ON "public"."stockubicacion" USING "btree" ("ubicacionid", "productoid", "varianteid");



CREATE INDEX "traslados_detalle_traslado_idx" ON "public"."traslados_detalle" USING "btree" ("trasladoid");



CREATE UNIQUE INDEX "traslados_encabezado_empresa_num_unico" ON "public"."traslados_encabezado" USING "btree" ("empresaid", "numtraslado");



CREATE UNIQUE INDEX "turnos_caja_usuario_unico_abierto" ON "public"."turnos_caja" USING "btree" ("usuario_id") WHERE ("estado" = ANY (ARRAY['ABIERTO'::"text", 'SUSPENDIDO'::"text"]));



CREATE UNIQUE INDEX "turnos_usuario_unico_abierto" ON "public"."turnos" USING "btree" ("usuarioid") WHERE ("estado" = ANY (ARRAY['ABIERTO'::"public"."turno_estado", 'PAUSADO'::"public"."turno_estado"]));



CREATE UNIQUE INDEX "uidx_compras_num" ON "public"."compras_encabezado" USING "btree" ("empresa_id", "num_compra") WHERE ("deleted_at" IS NULL);



CREATE UNIQUE INDEX "uidx_proveedores_doc" ON "public"."proveedores" USING "btree" ("empresa_id", "num_documento") WHERE (("deleted_at" IS NULL) AND ("num_documento" IS NOT NULL));



CREATE UNIQUE INDEX "uidx_traslados_num" ON "public"."traslados_encabezado" USING "btree" ("empresa_id", "num_traslado") WHERE ("deleted_at" IS NULL);



CREATE UNIQUE INDEX "unidadesmedida_empresa_abrev_uidx" ON "public"."unidadesmedida" USING "btree" (COALESCE("empresaid", '00000000-0000-0000-0000-000000000000'::"uuid"), "lower"("codigo"));



CREATE UNIQUE INDEX "unidadesmedida_empresa_codigo_uidx" ON "public"."unidadesmedida" USING "btree" (COALESCE("empresaid", '00000000-0000-0000-0000-000000000000'::"uuid"), "lower"("codigo"));



CREATE UNIQUE INDEX "unidadesmedida_empresa_codigo_unico" ON "public"."unidadesmedida" USING "btree" ("empresaid", "codigo");



CREATE OR REPLACE TRIGGER "trg_actualizar_stock" AFTER INSERT ON "public"."movimientosinventario" FOR EACH ROW EXECUTE FUNCTION "public"."fn_actualizar_stock"();



CREATE OR REPLACE TRIGGER "trg_arqueo_calcular_totales" AFTER INSERT OR UPDATE OF "saldoinicial", "totalcontado", "turnoid" ON "public"."arqueos_caja" FOR EACH ROW EXECUTE FUNCTION "public"."trg_fn_arqueo_on_change"();



CREATE OR REPLACE TRIGGER "trg_arqueos_caja_updated_at" BEFORE UPDATE ON "public"."arqueos_caja" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_arqueos_efectivo_detalle_updated_at" BEFORE UPDATE ON "public"."arqueos_efectivo_detalle" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_arqueos_otros_medios_updated_at" BEFORE UPDATE ON "public"."arqueos_otros_medios" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_cajas_updated_at" BEFORE UPDATE ON "public"."cajas" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_config_app_empresas_updated_at" BEFORE UPDATE ON "public"."config_app_empresas" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_config_tipos_voucher_updated_at" BEFORE UPDATE ON "public"."config_tipos_voucher" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_confirmar_recepcion" AFTER UPDATE ON "public"."recepcionescompra" FOR EACH ROW EXECUTE FUNCTION "public"."fn_confirmar_recepcion"();



CREATE OR REPLACE TRIGGER "trg_empresas_updated_at" BEFORE UPDATE ON "public"."empresas" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_generar_numtraslado" BEFORE INSERT ON "public"."traslados_encabezado" FOR EACH ROW WHEN ((("new"."numtraslado" IS NULL) OR ("new"."numtraslado" = ''::"text"))) EXECUTE FUNCTION "public"."fn_generar_numtraslado"();



CREATE OR REPLACE TRIGGER "trg_jornadas_updated_at" BEFORE UPDATE ON "public"."jornadas" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_movimiento_recalcula_arqueo" AFTER INSERT OR DELETE OR UPDATE ON "public"."movimientos_caja" FOR EACH ROW EXECUTE FUNCTION "public"."trg_fn_movimiento_afecta_arqueo"();



CREATE OR REPLACE TRIGGER "trg_movimientos_caja_updated_at" BEFORE UPDATE ON "public"."movimientos_caja" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_novedades_inventario_updated_at" BEFORE UPDATE ON "public"."novedades_inventario" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_oc_recepcion_conteo_updated_at" BEFORE UPDATE ON "public"."oc_recepcion_conteo" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_roles_updated_at" BEFORE UPDATE ON "public"."roles" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_stock_por_estado_traslado" AFTER UPDATE OF "estado" ON "public"."traslados_encabezado" FOR EACH ROW EXECUTE FUNCTION "public"."fn_stock_por_estado_traslado"();



CREATE OR REPLACE TRIGGER "trg_sucursales_updated_at" BEFORE UPDATE ON "public"."sucursales" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_sugerencias_pedido_updated_at" BEFORE UPDATE ON "public"."sugerencias_pedido" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_tareas_detalle_traslado_updated_at" BEFORE UPDATE ON "public"."tareas_detalle_traslado" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_tareas_updated_at" BEFORE UPDATE ON "public"."tareas" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_tipos_tarea_updated_at" BEFORE UPDATE ON "public"."tipos_tarea" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_turnos_updated_at" BEFORE UPDATE ON "public"."turnos" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_updated_at_compras_det" BEFORE UPDATE ON "public"."compras_detalle" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_updated_at_compras_enc" BEFORE UPDATE ON "public"."compras_encabezado" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_updated_at_proveedores" BEFORE UPDATE ON "public"."proveedores" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_updated_at_traslados_det" BEFORE UPDATE ON "public"."traslados_detalle" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_updated_at_traslados_enc" BEFORE UPDATE ON "public"."traslados_encabezado" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_user_profiles_updated_at" BEFORE UPDATE ON "public"."user_profiles" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_user_roles_updated_at" BEFORE UPDATE ON "public"."user_roles" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



CREATE OR REPLACE TRIGGER "trg_user_sucursales_updated_at" BEFORE UPDATE ON "public"."user_sucursales" FOR EACH ROW EXECUTE FUNCTION "public"."handle_updated_at"();



ALTER TABLE ONLY "public"."arqueos_caja"
    ADD CONSTRAINT "arqueos_caja_cajaid_fkey" FOREIGN KEY ("cajaid") REFERENCES "public"."cajas"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."arqueos_caja"
    ADD CONSTRAINT "arqueos_caja_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."arqueos_caja"
    ADD CONSTRAINT "arqueos_caja_jornadaid_fkey" FOREIGN KEY ("jornadaid") REFERENCES "public"."jornadas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."arqueos_caja"
    ADD CONSTRAINT "arqueos_caja_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."arqueos_caja"
    ADD CONSTRAINT "arqueos_caja_turnoid_fkey" FOREIGN KEY ("turnoid") REFERENCES "public"."turnos"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."arqueos_efectivo_detalle"
    ADD CONSTRAINT "arqueos_efectivo_detalle_arqueoid_fkey" FOREIGN KEY ("arqueoid") REFERENCES "public"."arqueos_caja"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."arqueos_otros_medios"
    ADD CONSTRAINT "arqueos_otros_medios_arqueoid_fkey" FOREIGN KEY ("arqueoid") REFERENCES "public"."arqueos_caja"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."audit_log"
    ADD CONSTRAINT "audit_log_empresa_id_fkey" FOREIGN KEY ("empresa_id") REFERENCES "public"."empresas"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."bodegas"
    ADD CONSTRAINT "bodegas_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."bodegas"
    ADD CONSTRAINT "bodegas_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id");



ALTER TABLE ONLY "public"."cajas"
    ADD CONSTRAINT "cajas_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."cajas"
    ADD CONSTRAINT "cajas_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."categorias_producto"
    ADD CONSTRAINT "categorias_producto_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."categoriasproducto"
    ADD CONSTRAINT "categoriasproducto_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."categoriasproducto"
    ADD CONSTRAINT "categoriasproducto_parentid_fkey" FOREIGN KEY ("parentid") REFERENCES "public"."categoriasproducto"("id");



ALTER TABLE ONLY "public"."compras_detalle"
    ADD CONSTRAINT "compras_detalle_id_compra_fkey" FOREIGN KEY ("id_compra") REFERENCES "public"."compras_encabezado"("id_compra") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."compras_detalle"
    ADD CONSTRAINT "compras_detalle_id_producto_fkey" FOREIGN KEY ("id_producto") REFERENCES "public"."productos"("id_producto");



ALTER TABLE ONLY "public"."compras_encabezado"
    ADD CONSTRAINT "compras_encabezado_id_proveedor_fkey" FOREIGN KEY ("id_proveedor") REFERENCES "public"."proveedores"("id_tercero");



ALTER TABLE ONLY "public"."config_app_empresas"
    ADD CONSTRAINT "config_app_empresas_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."config_tipos_voucher"
    ADD CONSTRAINT "config_tipos_voucher_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."cubiculosfila"
    ADD CONSTRAINT "cubiculosfila_filaid_fkey" FOREIGN KEY ("filaid") REFERENCES "public"."filasestanteria"("id");



ALTER TABLE ONLY "public"."estanterias"
    ADD CONSTRAINT "estanterias_zonaid_fkey" FOREIGN KEY ("zonaid") REFERENCES "public"."zonasbodega"("id");



ALTER TABLE ONLY "public"."facturasVentaLineas"
    ADD CONSTRAINT "facturasVentaLineas_facturaVentaId_fkey" FOREIGN KEY ("facturaVentaId") REFERENCES "public"."facturasVenta"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."facturascompra"
    ADD CONSTRAINT "facturascompra_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."facturascompra"
    ADD CONSTRAINT "facturascompra_proveedorid_fkey" FOREIGN KEY ("proveedorid") REFERENCES "public"."proveedores"("id_tercero");



ALTER TABLE ONLY "public"."facturascompra"
    ADD CONSTRAINT "facturascompra_recepcionid_fkey" FOREIGN KEY ("recepcionid") REFERENCES "public"."recepcionescompra"("id");



ALTER TABLE ONLY "public"."facturascompra"
    ADD CONSTRAINT "facturascompra_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id");



ALTER TABLE ONLY "public"."facturascompradetalle"
    ADD CONSTRAINT "facturascompradetalle_facturaid_fkey" FOREIGN KEY ("facturaid") REFERENCES "public"."facturascompra"("id");



ALTER TABLE ONLY "public"."facturascompradetalle"
    ADD CONSTRAINT "facturascompradetalle_productoid_fkey" FOREIGN KEY ("productoid") REFERENCES "public"."productos_erp"("id");



ALTER TABLE ONLY "public"."facturascompradetalle"
    ADD CONSTRAINT "facturascompradetalle_recepciondetalleid_fkey" FOREIGN KEY ("recepciondetalleid") REFERENCES "public"."recepcionescompradetalle"("id");



ALTER TABLE ONLY "public"."facturascompradetalle"
    ADD CONSTRAINT "facturascompradetalle_unidadid_fkey" FOREIGN KEY ("unidadid") REFERENCES "public"."unidadesmedida"("id");



ALTER TABLE ONLY "public"."filasestanteria"
    ADD CONSTRAINT "filasestanteria_estanteriaid_fkey" FOREIGN KEY ("estanteriaid") REFERENCES "public"."estanterias"("id");



ALTER TABLE ONLY "public"."import_errors"
    ADD CONSTRAINT "import_errors_import_id_fkey" FOREIGN KEY ("import_id") REFERENCES "public"."import_log"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."import_log"
    ADD CONSTRAINT "import_log_empresa_id_fkey" FOREIGN KEY ("empresa_id") REFERENCES "public"."empresas"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."jornadas"
    ADD CONSTRAINT "jornadas_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."jornadas"
    ADD CONSTRAINT "jornadas_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."listasprecios"
    ADD CONSTRAINT "listasprecios_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."listaspreciosdetalle"
    ADD CONSTRAINT "listaspreciosdetalle_listaid_fkey" FOREIGN KEY ("listaid") REFERENCES "public"."listasprecios"("id");



ALTER TABLE ONLY "public"."listaspreciosdetalle"
    ADD CONSTRAINT "listaspreciosdetalle_productoid_fkey" FOREIGN KEY ("productoid") REFERENCES "public"."productos_erp"("id");



ALTER TABLE ONLY "public"."marcas"
    ADD CONSTRAINT "marcas_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."misiones_conteo_detalle"
    ADD CONSTRAINT "misiones_conteo_detalle_id_producto_fkey" FOREIGN KEY ("id_producto") REFERENCES "public"."productos"("id_producto");



ALTER TABLE ONLY "public"."misiones_conteo_detalle"
    ADD CONSTRAINT "misiones_conteo_detalle_mision_id_fkey" FOREIGN KEY ("mision_id") REFERENCES "public"."misiones_conteo"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."misiones_conteo_detalle"
    ADD CONSTRAINT "misiones_conteo_detalle_unidadid_fkey" FOREIGN KEY ("unidadid") REFERENCES "public"."unidadesmedida"("id");



ALTER TABLE ONLY "public"."misiones_conteo"
    ADD CONSTRAINT "misiones_conteo_zonaid_fkey" FOREIGN KEY ("zonaid") REFERENCES "public"."zonasbodega"("id");



ALTER TABLE ONLY "public"."movimientos_caja"
    ADD CONSTRAINT "movimientos_caja_cajaid_fkey" FOREIGN KEY ("cajaid") REFERENCES "public"."cajas"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."movimientos_caja"
    ADD CONSTRAINT "movimientos_caja_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."movimientos_caja"
    ADD CONSTRAINT "movimientos_caja_jornadaid_fkey" FOREIGN KEY ("jornadaid") REFERENCES "public"."jornadas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."movimientos_caja"
    ADD CONSTRAINT "movimientos_caja_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."movimientos_caja"
    ADD CONSTRAINT "movimientos_caja_turnoid_fkey" FOREIGN KEY ("turnoid") REFERENCES "public"."turnos"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."movimientosinventario"
    ADD CONSTRAINT "movimientosinventario_bodegadestinoid_fkey" FOREIGN KEY ("bodegadestinoid") REFERENCES "public"."bodegas"("id");



ALTER TABLE ONLY "public"."movimientosinventario"
    ADD CONSTRAINT "movimientosinventario_bodegaorigenid_fkey" FOREIGN KEY ("bodegaorigenid") REFERENCES "public"."bodegas"("id");



ALTER TABLE ONLY "public"."movimientosinventario"
    ADD CONSTRAINT "movimientosinventario_productoid_fkey" FOREIGN KEY ("productoid") REFERENCES "public"."productos_erp"("id");



ALTER TABLE ONLY "public"."movimientosinventario"
    ADD CONSTRAINT "movimientosinventario_unidadid_fkey" FOREIGN KEY ("unidadid") REFERENCES "public"."unidadesmedida"("id");



ALTER TABLE ONLY "public"."notificaciones_usuario"
    ADD CONSTRAINT "notificaciones_usuario_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."novedades_inventario"
    ADD CONSTRAINT "novedades_inventario_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."novedades_inventario"
    ADD CONSTRAINT "novedades_inventario_productoid_fkey" FOREIGN KEY ("productoid") REFERENCES "public"."productos"("id_producto") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."novedades_inventario"
    ADD CONSTRAINT "novedades_inventario_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."oc_recepcion_anomalias"
    ADD CONSTRAINT "oc_recepcion_anomalias_id_producto_fkey" FOREIGN KEY ("id_producto") REFERENCES "public"."productos"("id_producto");



ALTER TABLE ONLY "public"."oc_recepcion_anomalias"
    ADD CONSTRAINT "oc_recepcion_anomalias_id_recepcion_fkey" FOREIGN KEY ("id_recepcion") REFERENCES "public"."oc_recepciones"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."oc_recepcion_conteo"
    ADD CONSTRAINT "oc_recepcion_conteo_productoid_fkey" FOREIGN KEY ("productoid") REFERENCES "public"."productos"("id_producto") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."oc_recepcion_conteo"
    ADD CONSTRAINT "oc_recepcion_conteo_recepcionid_fkey" FOREIGN KEY ("recepcionid") REFERENCES "public"."oc_recepciones"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."oc_recepcion_fotos"
    ADD CONSTRAINT "oc_recepcion_fotos_id_recepcion_fkey" FOREIGN KEY ("id_recepcion") REFERENCES "public"."oc_recepciones"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."oc_recepciones"
    ADD CONSTRAINT "oc_recepciones_id_orden_compra_fkey" FOREIGN KEY ("id_orden_compra") REFERENCES "public"."ordenes_compra_encabezado"("id_orden_compra") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."ordenes_compra_detalle"
    ADD CONSTRAINT "ordenes_compra_detalle_id_orden_compra_fkey" FOREIGN KEY ("id_orden_compra") REFERENCES "public"."ordenes_compra_encabezado"("id_orden_compra") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."ordenes_compra_detalle"
    ADD CONSTRAINT "ordenes_compra_detalle_id_producto_fkey" FOREIGN KEY ("id_producto") REFERENCES "public"."productos"("id_producto");



ALTER TABLE ONLY "public"."ordenes_compra_encabezado"
    ADD CONSTRAINT "ordenes_compra_encabezado_id_proveedor_fkey" FOREIGN KEY ("id_proveedor") REFERENCES "public"."proveedores"("id_tercero");



ALTER TABLE ONLY "public"."ordenescompra"
    ADD CONSTRAINT "ordenescompra_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."ordenescompra"
    ADD CONSTRAINT "ordenescompra_proveedorid_fkey" FOREIGN KEY ("proveedorid") REFERENCES "public"."proveedores"("id_tercero");



ALTER TABLE ONLY "public"."ordenescompra"
    ADD CONSTRAINT "ordenescompra_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id");



ALTER TABLE ONLY "public"."ordenescompradetalle"
    ADD CONSTRAINT "ordenescompradetalle_ordenid_fkey" FOREIGN KEY ("ordenid") REFERENCES "public"."ordenescompra"("id");



ALTER TABLE ONLY "public"."ordenescompradetalle"
    ADD CONSTRAINT "ordenescompradetalle_productoid_fkey" FOREIGN KEY ("productoid") REFERENCES "public"."productos_erp"("id");



ALTER TABLE ONLY "public"."ordenescompradetalle"
    ADD CONSTRAINT "ordenescompradetalle_unidadid_fkey" FOREIGN KEY ("unidadid") REFERENCES "public"."unidadesmedida"("id");



ALTER TABLE ONLY "public"."pagos_compras"
    ADD CONSTRAINT "pagos_compras_turno_id_fkey" FOREIGN KEY ("turno_id") REFERENCES "public"."turnos_caja"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."producto_codigos_externos"
    ADD CONSTRAINT "producto_codigos_externos_productoid_fkey" FOREIGN KEY ("productoid") REFERENCES "public"."productos_erp"("id");



ALTER TABLE ONLY "public"."productos_erp"
    ADD CONSTRAINT "productos_erp_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."productounidades"
    ADD CONSTRAINT "productounidades_productoid_fkey" FOREIGN KEY ("productoid") REFERENCES "public"."productos_erp"("id");



ALTER TABLE ONLY "public"."productounidades"
    ADD CONSTRAINT "productounidades_unidadid_fkey" FOREIGN KEY ("unidadid") REFERENCES "public"."unidadesmedida"("id");



ALTER TABLE ONLY "public"."proveedores_contactos"
    ADD CONSTRAINT "proveedores_contactos_empresa_id_fkey" FOREIGN KEY ("empresa_id") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."proveedores_contactos"
    ADD CONSTRAINT "proveedores_contactos_proveedorid_fkey" FOREIGN KEY ("proveedorid") REFERENCES "public"."proveedores"("id_tercero");



ALTER TABLE ONLY "public"."proveedores_documentos"
    ADD CONSTRAINT "proveedores_documentos_empresa_id_fkey" FOREIGN KEY ("empresa_id") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."proveedores_documentos"
    ADD CONSTRAINT "proveedores_documentos_proveedorid_fkey" FOREIGN KEY ("proveedorid") REFERENCES "public"."proveedores"("id_tercero");



ALTER TABLE ONLY "public"."proveedores_evaluaciones"
    ADD CONSTRAINT "proveedores_evaluaciones_empresa_id_fkey" FOREIGN KEY ("empresa_id") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."proveedores_evaluaciones"
    ADD CONSTRAINT "proveedores_evaluaciones_proveedorid_fkey" FOREIGN KEY ("proveedorid") REFERENCES "public"."proveedores"("id_tercero");



ALTER TABLE ONLY "public"."recepcionescompra"
    ADD CONSTRAINT "recepcionescompra_bodegaid_fkey" FOREIGN KEY ("bodegaid") REFERENCES "public"."bodegas"("id");



ALTER TABLE ONLY "public"."recepcionescompra"
    ADD CONSTRAINT "recepcionescompra_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."recepcionescompra"
    ADD CONSTRAINT "recepcionescompra_ordenid_fkey" FOREIGN KEY ("ordenid") REFERENCES "public"."ordenescompra"("id");



ALTER TABLE ONLY "public"."recepcionescompra"
    ADD CONSTRAINT "recepcionescompra_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id");



ALTER TABLE ONLY "public"."recepcionescompradetalle"
    ADD CONSTRAINT "recepcionescompradetalle_ordendetalleid_fkey" FOREIGN KEY ("ordendetalleid") REFERENCES "public"."ordenescompradetalle"("id");



ALTER TABLE ONLY "public"."recepcionescompradetalle"
    ADD CONSTRAINT "recepcionescompradetalle_productoid_fkey" FOREIGN KEY ("productoid") REFERENCES "public"."productos_erp"("id");



ALTER TABLE ONLY "public"."recepcionescompradetalle"
    ADD CONSTRAINT "recepcionescompradetalle_recepcionid_fkey" FOREIGN KEY ("recepcionid") REFERENCES "public"."recepcionescompra"("id");



ALTER TABLE ONLY "public"."recepcionescompradetalle"
    ADD CONSTRAINT "recepcionescompradetalle_unidadid_fkey" FOREIGN KEY ("unidadid") REFERENCES "public"."unidadesmedida"("id");



ALTER TABLE ONLY "public"."role_permissions"
    ADD CONSTRAINT "role_permissions_empresa_id_fkey" FOREIGN KEY ("empresa_id") REFERENCES "public"."empresas"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."sucursales"
    ADD CONSTRAINT "sucursales_empresa_id_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."sugerencias_pedido"
    ADD CONSTRAINT "sugerencias_pedido_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."sugerencias_pedido"
    ADD CONSTRAINT "sugerencias_pedido_novedad_fkey" FOREIGN KEY ("novedad_id") REFERENCES "public"."novedades_inventario"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."sugerencias_pedido"
    ADD CONSTRAINT "sugerencias_pedido_productoid_fkey" FOREIGN KEY ("productoid") REFERENCES "public"."productos"("id_producto") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."tareas_detalle_traslado"
    ADD CONSTRAINT "tareas_detalle_traslado_productoid_fkey" FOREIGN KEY ("productoid") REFERENCES "public"."productos"("id_producto") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."tareas_detalle_traslado"
    ADD CONSTRAINT "tareas_detalle_traslado_tareaid_fkey" FOREIGN KEY ("tareaid") REFERENCES "public"."tareas"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tareas"
    ADD CONSTRAINT "tareas_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."tareas"
    ADD CONSTRAINT "tareas_jornadaid_fkey" FOREIGN KEY ("jornadaid") REFERENCES "public"."jornadas"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."tareas"
    ADD CONSTRAINT "tareas_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."tareas"
    ADD CONSTRAINT "tareas_tipotareaid_fkey" FOREIGN KEY ("tipotareaid") REFERENCES "public"."tipos_tarea"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."tareas_turno"
    ADD CONSTRAINT "tareas_turno_tipo_tarea_id_fkey" FOREIGN KEY ("tipo_tarea_id") REFERENCES "public"."tipos_tarea_turno"("id");



ALTER TABLE ONLY "public"."tareas_turno"
    ADD CONSTRAINT "tareas_turno_turno_id_fkey" FOREIGN KEY ("turno_id") REFERENCES "public"."turnos_caja"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tipos_tarea"
    ADD CONSTRAINT "tipos_tarea_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."traslados_detalle"
    ADD CONSTRAINT "traslados_detalle_productoid_fkey" FOREIGN KEY ("productoid") REFERENCES "public"."productos_erp"("id");



ALTER TABLE ONLY "public"."traslados_detalle"
    ADD CONSTRAINT "traslados_detalle_trasladoid_fkey" FOREIGN KEY ("trasladoid") REFERENCES "public"."traslados_encabezado"("id");



ALTER TABLE ONLY "public"."traslados_detalle"
    ADD CONSTRAINT "traslados_detalle_unidadid_fkey" FOREIGN KEY ("unidadid") REFERENCES "public"."unidadesmedida"("id");



ALTER TABLE ONLY "public"."traslados_encabezado"
    ADD CONSTRAINT "traslados_encabezado_bodegadestinoid_fkey" FOREIGN KEY ("bodegadestinoid") REFERENCES "public"."bodegas"("id");



ALTER TABLE ONLY "public"."traslados_encabezado"
    ADD CONSTRAINT "traslados_encabezado_bodegaorigenid_fkey" FOREIGN KEY ("bodegaorigenid") REFERENCES "public"."bodegas"("id");



ALTER TABLE ONLY "public"."traslados_encabezado"
    ADD CONSTRAINT "traslados_encabezado_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."traslados_encabezado"
    ADD CONSTRAINT "traslados_encabezado_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id");



ALTER TABLE ONLY "public"."turnos"
    ADD CONSTRAINT "turnos_cajaid_fkey" FOREIGN KEY ("cajaid") REFERENCES "public"."cajas"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."turnos"
    ADD CONSTRAINT "turnos_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."turnos"
    ADD CONSTRAINT "turnos_jornadaid_fkey" FOREIGN KEY ("jornadaid") REFERENCES "public"."jornadas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."turnos"
    ADD CONSTRAINT "turnos_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."turnos"
    ADD CONSTRAINT "turnos_turnoorigenid_fkey" FOREIGN KEY ("turnoorigenid") REFERENCES "public"."turnos"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."unidadesmedida"
    ADD CONSTRAINT "unidadesmedida_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id");



ALTER TABLE ONLY "public"."user_profiles"
    ADD CONSTRAINT "user_profiles_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."user_profiles"
    ADD CONSTRAINT "user_profiles_encargadoid_fkey" FOREIGN KEY ("encargadoid") REFERENCES "public"."user_profiles"("userid") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."user_profiles"
    ADD CONSTRAINT "user_profiles_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."user_roles"
    ADD CONSTRAINT "user_roles_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."user_roles"
    ADD CONSTRAINT "user_roles_rolid_fkey" FOREIGN KEY ("rolid") REFERENCES "public"."roles"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."user_sucursales"
    ADD CONSTRAINT "user_sucursales_empresaid_fkey" FOREIGN KEY ("empresaid") REFERENCES "public"."empresas"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."user_sucursales"
    ADD CONSTRAINT "user_sucursales_sucursalid_fkey" FOREIGN KEY ("sucursalid") REFERENCES "public"."sucursales"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."zonasbodega"
    ADD CONSTRAINT "zonasbodega_bodegaid_fkey" FOREIGN KEY ("bodegaid") REFERENCES "public"."bodegas"("id");



CREATE POLICY "arq_efec_detalle_all" ON "public"."arqueos_efectivo_detalle" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_efectivo_detalle"."arqueoid") AND ("a"."empresaid" = "public"."current_empresa_id"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_efectivo_detalle"."arqueoid") AND ("a"."empresaid" = "public"."current_empresa_id"())))));



CREATE POLICY "arq_otros_medios_all" ON "public"."arqueos_otros_medios" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_otros_medios"."arqueoid") AND ("a"."empresaid" = "public"."current_empresa_id"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_otros_medios"."arqueoid") AND ("a"."empresaid" = "public"."current_empresa_id"())))));



CREATE POLICY "arqueos_admin_all" ON "public"."arqueos_caja" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK (("empresaid" = "public"."current_empresa_id"()));



CREATE POLICY "arqueos_auditor_select" ON "public"."arqueos_caja" FOR SELECT TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'auditor'::"text")));



ALTER TABLE "public"."arqueos_caja" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "arqueos_caja_delete" ON "public"."arqueos_caja" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "arqueos_caja_insert" ON "public"."arqueos_caja" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "arqueos_caja_select" ON "public"."arqueos_caja" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "arqueos_caja_update" ON "public"."arqueos_caja" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."arqueos_efectivo_detalle" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "arqueos_efectivo_detalle_delete" ON "public"."arqueos_efectivo_detalle" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_efectivo_detalle"."arqueoid") AND ("a"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "arqueos_efectivo_detalle_insert" ON "public"."arqueos_efectivo_detalle" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_efectivo_detalle"."arqueoid") AND ("a"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "arqueos_efectivo_detalle_select" ON "public"."arqueos_efectivo_detalle" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_efectivo_detalle"."arqueoid") AND ("a"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "arqueos_efectivo_detalle_update" ON "public"."arqueos_efectivo_detalle" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_efectivo_detalle"."arqueoid") AND ("a"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_efectivo_detalle"."arqueoid") AND ("a"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "arqueos_encargado_confirm" ON "public"."arqueos_caja" FOR UPDATE TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text") AND ("estado" = 'ENVIADO'::"public"."arqueo_estado"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("estado" = ANY (ARRAY['CONFIRMADO'::"public"."arqueo_estado", 'ENVIADO'::"public"."arqueo_estado"]))));



CREATE POLICY "arqueos_encargado_select" ON "public"."arqueos_caja" FOR SELECT TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text")));



ALTER TABLE "public"."arqueos_otros_medios" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "arqueos_otros_medios_delete" ON "public"."arqueos_otros_medios" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_otros_medios"."arqueoid") AND ("a"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "arqueos_otros_medios_insert" ON "public"."arqueos_otros_medios" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_otros_medios"."arqueoid") AND ("a"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "arqueos_otros_medios_select" ON "public"."arqueos_otros_medios" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_otros_medios"."arqueoid") AND ("a"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "arqueos_otros_medios_update" ON "public"."arqueos_otros_medios" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_otros_medios"."arqueoid") AND ("a"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."arqueos_caja" "a"
  WHERE (("a"."id" = "arqueos_otros_medios"."arqueoid") AND ("a"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "arqueos_self_insert" ON "public"."arqueos_caja" FOR INSERT TO "authenticated" WITH CHECK ((("responsableid" = "auth"."uid"()) AND ("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"()) AND "public"."has_role"('cajero'::"text")));



CREATE POLICY "arqueos_self_select" ON "public"."arqueos_caja" FOR SELECT TO "authenticated" USING (("responsableid" = "auth"."uid"()));



CREATE POLICY "arqueos_self_update" ON "public"."arqueos_caja" FOR UPDATE TO "authenticated" USING ((("responsableid" = "auth"."uid"()) AND ("estado" = 'BORRADOR'::"public"."arqueo_estado"))) WITH CHECK ((("responsableid" = "auth"."uid"()) AND ("estado" = ANY (ARRAY['BORRADOR'::"public"."arqueo_estado", 'ENVIADO'::"public"."arqueo_estado"]))));



ALTER TABLE "public"."audit_log" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "audit_log_admin_only" ON "public"."audit_log" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"()))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"())));



ALTER TABLE "public"."bodegas" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "bodegas_delete" ON "public"."bodegas" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "bodegas_insert" ON "public"."bodegas" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "bodegas_select" ON "public"."bodegas" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "bodegas_update" ON "public"."bodegas" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."cajas" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "cajas_admin_all" ON "public"."cajas" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



CREATE POLICY "cajas_delete" ON "public"."cajas" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "cajas_encargado_write" ON "public"."cajas" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"())));



CREATE POLICY "cajas_insert" ON "public"."cajas" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "cajas_select" ON "public"."cajas" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "cajas_update" ON "public"."cajas" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."categorias_producto" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "categorias_producto_select_all" ON "public"."categorias_producto" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "categorias_producto_write_admin" ON "public"."categorias_producto" TO "authenticated" USING (("public"."app_role"() = 'admin'::"text")) WITH CHECK (("public"."app_role"() = 'admin'::"text"));



ALTER TABLE "public"."categoriasproducto" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "categoriasproducto_select_all" ON "public"."categoriasproducto" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "categoriasproducto_write_admin" ON "public"."categoriasproducto" TO "authenticated" USING (("public"."app_role"() = 'admin'::"text")) WITH CHECK (("public"."app_role"() = 'admin'::"text"));



CREATE POLICY "cfg_empresa_admin_all" ON "public"."config_app_empresas" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK (("empresaid" = "public"."current_empresa_id"()));



CREATE POLICY "cfg_empresa_select" ON "public"."config_app_empresas" FOR SELECT TO "authenticated" USING (("empresaid" = "public"."current_empresa_id"()));



ALTER TABLE "public"."clientes" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "clientes_admin_write" ON "public"."clientes" TO "authenticated" USING ((("empresa_id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



CREATE POLICY "clientes_delete" ON "public"."clientes" FOR DELETE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "clientes_insert" ON "public"."clientes" FOR INSERT TO "authenticated" WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "clientes_select" ON "public"."clientes" FOR SELECT TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "clientes_tenant_isolation" ON "public"."clientes" TO "authenticated" USING (("empresa_id" = "public"."current_empresa_id"())) WITH CHECK (("empresa_id" = "public"."current_empresa_id"()));



CREATE POLICY "clientes_update" ON "public"."clientes" FOR UPDATE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "compras_admin_all" ON "public"."compras_encabezado" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"()))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"())));



ALTER TABLE "public"."compras_detalle" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "compras_detalle_delete" ON "public"."compras_detalle" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."compras_encabezado" "ce"
  WHERE (("ce"."id" = "compras_detalle"."id_compra") AND ("ce"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "compras_detalle_insert" ON "public"."compras_detalle" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."compras_encabezado" "ce"
  WHERE (("ce"."id" = "compras_detalle"."id_compra") AND ("ce"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "compras_detalle_select" ON "public"."compras_detalle" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."compras_encabezado" "ce"
  WHERE (("ce"."id" = "compras_detalle"."id_compra") AND ("ce"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "compras_detalle_tenant" ON "public"."compras_detalle" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."compras_encabezado" "ce"
  WHERE (("ce"."id_compra" = "compras_detalle"."id_compra") AND ("ce"."empresa_id" = "public"."current_empresa_id"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."compras_encabezado" "ce"
  WHERE (("ce"."id_compra" = "compras_detalle"."id_compra") AND ("ce"."empresa_id" = "public"."current_empresa_id"())))));



CREATE POLICY "compras_detalle_update" ON "public"."compras_detalle" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."compras_encabezado" "ce"
  WHERE (("ce"."id" = "compras_detalle"."id_compra") AND ("ce"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."compras_encabezado" "ce"
  WHERE (("ce"."id" = "compras_detalle"."id_compra") AND ("ce"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



ALTER TABLE "public"."compras_encabezado" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "compras_encabezado_delete" ON "public"."compras_encabezado" FOR DELETE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "compras_encabezado_insert" ON "public"."compras_encabezado" FOR INSERT TO "authenticated" WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "compras_encabezado_select" ON "public"."compras_encabezado" FOR SELECT TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "compras_encabezado_update" ON "public"."compras_encabezado" FOR UPDATE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "compras_encargado_select" ON "public"."compras_encabezado" FOR SELECT TO "authenticated" USING ((("public"."app_role"() = 'encargado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("id_sucursal" = "public"."current_sucursal_id"())));



ALTER TABLE "public"."config_app_empresas" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."config_tipos_voucher" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "config_tipos_voucher_select" ON "public"."config_tipos_voucher" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "config_tipos_voucher_write_admin" ON "public"."config_tipos_voucher" TO "authenticated" USING (("public"."app_role"() = 'admin'::"text")) WITH CHECK (("public"."app_role"() = 'admin'::"text"));



ALTER TABLE "public"."cubiculosfila" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "cubiculosfila_delete" ON "public"."cubiculosfila" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ((("public"."filasestanteria" "f"
     JOIN "public"."estanterias" "e" ON (("e"."id" = "f"."estanteriaid")))
     JOIN "public"."zonasbodega" "z" ON (("z"."id" = "e"."zonaid")))
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("f"."id" = "cubiculosfila"."filaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "cubiculosfila_insert" ON "public"."cubiculosfila" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM ((("public"."filasestanteria" "f"
     JOIN "public"."estanterias" "e" ON (("e"."id" = "f"."estanteriaid")))
     JOIN "public"."zonasbodega" "z" ON (("z"."id" = "e"."zonaid")))
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("f"."id" = "cubiculosfila"."filaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "cubiculosfila_select" ON "public"."cubiculosfila" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ((("public"."filasestanteria" "f"
     JOIN "public"."estanterias" "e" ON (("e"."id" = "f"."estanteriaid")))
     JOIN "public"."zonasbodega" "z" ON (("z"."id" = "e"."zonaid")))
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("f"."id" = "cubiculosfila"."filaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "cubiculosfila_update" ON "public"."cubiculosfila" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ((("public"."filasestanteria" "f"
     JOIN "public"."estanterias" "e" ON (("e"."id" = "f"."estanteriaid")))
     JOIN "public"."zonasbodega" "z" ON (("z"."id" = "e"."zonaid")))
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("f"."id" = "cubiculosfila"."filaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ((("public"."filasestanteria" "f"
     JOIN "public"."estanterias" "e" ON (("e"."id" = "f"."estanteriaid")))
     JOIN "public"."zonasbodega" "z" ON (("z"."id" = "e"."zonaid")))
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("f"."id" = "cubiculosfila"."filaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



ALTER TABLE "public"."empresas" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "empresas_admin_all" ON "public"."empresas" TO "authenticated" USING ((("id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



CREATE POLICY "empresas_select" ON "public"."empresas" FOR SELECT TO "authenticated" USING (("id" = "public"."current_empresa_id"()));



ALTER TABLE "public"."estanterias" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "estanterias_delete" ON "public"."estanterias" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."zonasbodega" "z"
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("z"."id" = "estanterias"."zonaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "estanterias_insert" ON "public"."estanterias" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."zonasbodega" "z"
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("z"."id" = "estanterias"."zonaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "estanterias_select" ON "public"."estanterias" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."zonasbodega" "z"
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("z"."id" = "estanterias"."zonaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "estanterias_update" ON "public"."estanterias" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM ("public"."zonasbodega" "z"
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("z"."id" = "estanterias"."zonaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM ("public"."zonasbodega" "z"
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("z"."id" = "estanterias"."zonaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



ALTER TABLE "public"."facturasVenta" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."facturasVentaLineas" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "facturasVentaLineas_delete" ON "public"."facturasVentaLineas" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."facturasVenta" "fv"
  WHERE (("fv"."id" = "facturasVentaLineas"."facturaVentaId") AND ("fv"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "facturasVentaLineas_insert" ON "public"."facturasVentaLineas" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."facturasVenta" "fv"
  WHERE (("fv"."id" = "facturasVentaLineas"."facturaVentaId") AND ("fv"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "facturasVentaLineas_select" ON "public"."facturasVentaLineas" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."facturasVenta" "fv"
  WHERE (("fv"."id" = "facturasVentaLineas"."facturaVentaId") AND ("fv"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "facturasVentaLineas_update" ON "public"."facturasVentaLineas" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."facturasVenta" "fv"
  WHERE (("fv"."id" = "facturasVentaLineas"."facturaVentaId") AND ("fv"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."facturasVenta" "fv"
  WHERE (("fv"."id" = "facturasVentaLineas"."facturaVentaId") AND ("fv"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "facturasVenta_delete" ON "public"."facturasVenta" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "facturasVenta_insert" ON "public"."facturasVenta" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "facturasVenta_select" ON "public"."facturasVenta" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "facturasVenta_update" ON "public"."facturasVenta" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."facturascompra" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "facturascompra_select" ON "public"."facturascompra" FOR SELECT TO "authenticated" USING (("empresaid" = "public"."current_empresa_id"()));



CREATE POLICY "facturascompra_write_admin" ON "public"."facturascompra" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



ALTER TABLE "public"."facturascompradetalle" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "facturascompradetalle_select" ON "public"."facturascompradetalle" FOR SELECT TO "authenticated" USING (("facturaid" IN ( SELECT "facturascompra"."id"
   FROM "public"."facturascompra"
  WHERE ("facturascompra"."empresaid" = "public"."current_empresa_id"()))));



CREATE POLICY "facturascompradetalle_write_admin" ON "public"."facturascompradetalle" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("facturaid" IN ( SELECT "facturascompra"."id"
   FROM "public"."facturascompra"
  WHERE ("facturascompra"."empresaid" = "public"."current_empresa_id"()))))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("facturaid" IN ( SELECT "facturascompra"."id"
   FROM "public"."facturascompra"
  WHERE ("facturascompra"."empresaid" = "public"."current_empresa_id"())))));



ALTER TABLE "public"."filasestanteria" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "filasestanteria_delete" ON "public"."filasestanteria" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM (("public"."estanterias" "e"
     JOIN "public"."zonasbodega" "z" ON (("z"."id" = "e"."zonaid")))
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("e"."id" = "filasestanteria"."estanteriaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "filasestanteria_insert" ON "public"."filasestanteria" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM (("public"."estanterias" "e"
     JOIN "public"."zonasbodega" "z" ON (("z"."id" = "e"."zonaid")))
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("e"."id" = "filasestanteria"."estanteriaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "filasestanteria_select" ON "public"."filasestanteria" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM (("public"."estanterias" "e"
     JOIN "public"."zonasbodega" "z" ON (("z"."id" = "e"."zonaid")))
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("e"."id" = "filasestanteria"."estanteriaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "filasestanteria_update" ON "public"."filasestanteria" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM (("public"."estanterias" "e"
     JOIN "public"."zonasbodega" "z" ON (("z"."id" = "e"."zonaid")))
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("e"."id" = "filasestanteria"."estanteriaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM (("public"."estanterias" "e"
     JOIN "public"."zonasbodega" "z" ON (("z"."id" = "e"."zonaid")))
     JOIN "public"."bodegas" "b" ON (("b"."id" = "z"."bodegaid")))
  WHERE (("e"."id" = "filasestanteria"."estanteriaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



ALTER TABLE "public"."import_errors" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "import_errors_admin_insert" ON "public"."import_errors" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."import_log" "l"
  WHERE (("l"."id" = "import_errors"."import_id") AND ("l"."empresa_id" = "public"."current_empresa_id"())))));



CREATE POLICY "import_errors_by_import" ON "public"."import_errors" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."import_log" "l"
  WHERE (("l"."id" = "import_errors"."import_id") AND ("l"."empresa_id" = "public"."current_empresa_id"())))));



ALTER TABLE "public"."import_log" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "import_log_admin_insert" ON "public"."import_log" FOR INSERT TO "authenticated" WITH CHECK (("empresa_id" = "public"."current_empresa_id"()));



CREATE POLICY "import_log_empresa" ON "public"."import_log" FOR SELECT TO "authenticated" USING (("empresa_id" = "public"."current_empresa_id"()));



ALTER TABLE "public"."jornadas" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "jornadas_admin_all" ON "public"."jornadas" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK (("empresaid" = "public"."current_empresa_id"()));



CREATE POLICY "jornadas_auditor_select" ON "public"."jornadas" FOR SELECT TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'auditor'::"text")));



CREATE POLICY "jornadas_delete" ON "public"."jornadas" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "jornadas_encargado_select" ON "public"."jornadas" FOR SELECT TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text")));



CREATE POLICY "jornadas_insert" ON "public"."jornadas" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "jornadas_select" ON "public"."jornadas" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "jornadas_self_select" ON "public"."jornadas" FOR SELECT TO "authenticated" USING (("userid" = "auth"."uid"()));



CREATE POLICY "jornadas_self_update" ON "public"."jornadas" FOR UPDATE TO "authenticated" USING (("userid" = "auth"."uid"())) WITH CHECK (("userid" = "auth"."uid"()));



CREATE POLICY "jornadas_self_write" ON "public"."jornadas" FOR INSERT TO "authenticated" WITH CHECK ((("userid" = "auth"."uid"()) AND ("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"())));



CREATE POLICY "jornadas_update" ON "public"."jornadas" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."listasprecios" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "listasprecios_select" ON "public"."listasprecios" FOR SELECT TO "authenticated" USING (("empresaid" = "public"."current_empresa_id"()));



CREATE POLICY "listasprecios_write_admin" ON "public"."listasprecios" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



ALTER TABLE "public"."listaspreciosdetalle" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "listaspreciosdetalle_select" ON "public"."listaspreciosdetalle" FOR SELECT TO "authenticated" USING (("listaid" IN ( SELECT "listasprecios"."id"
   FROM "public"."listasprecios"
  WHERE ("listasprecios"."empresaid" = "public"."current_empresa_id"()))));



CREATE POLICY "listaspreciosdetalle_write_admin" ON "public"."listaspreciosdetalle" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("listaid" IN ( SELECT "listasprecios"."id"
   FROM "public"."listasprecios"
  WHERE ("listasprecios"."empresaid" = "public"."current_empresa_id"()))))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("listaid" IN ( SELECT "listasprecios"."id"
   FROM "public"."listasprecios"
  WHERE ("listasprecios"."empresaid" = "public"."current_empresa_id"())))));



ALTER TABLE "public"."marcas" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "marcas_select_all" ON "public"."marcas" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "marcas_write_admin" ON "public"."marcas" TO "authenticated" USING (("public"."app_role"() = 'admin'::"text")) WITH CHECK (("public"."app_role"() = 'admin'::"text"));



CREATE POLICY "misiones_admin_all" ON "public"."misiones_conteo" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"()))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"())));



ALTER TABLE "public"."misiones_conteo" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "misiones_conteo_delete" ON "public"."misiones_conteo" FOR DELETE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."misiones_conteo_detalle" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "misiones_conteo_detalle_delete" ON "public"."misiones_conteo_detalle" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."misiones_conteo" "m"
  WHERE (("m"."id" = "misiones_conteo_detalle"."mision_id") AND ("m"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "misiones_conteo_detalle_insert" ON "public"."misiones_conteo_detalle" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."misiones_conteo" "m"
  WHERE (("m"."id" = "misiones_conteo_detalle"."mision_id") AND ("m"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "misiones_conteo_detalle_select" ON "public"."misiones_conteo_detalle" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."misiones_conteo" "m"
  WHERE (("m"."id" = "misiones_conteo_detalle"."mision_id") AND ("m"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "misiones_conteo_detalle_update" ON "public"."misiones_conteo_detalle" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."misiones_conteo" "m"
  WHERE (("m"."id" = "misiones_conteo_detalle"."mision_id") AND ("m"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."misiones_conteo" "m"
  WHERE (("m"."id" = "misiones_conteo_detalle"."mision_id") AND ("m"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "misiones_conteo_insert" ON "public"."misiones_conteo" FOR INSERT TO "authenticated" WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "misiones_conteo_select" ON "public"."misiones_conteo" FOR SELECT TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "misiones_conteo_update" ON "public"."misiones_conteo" FOR UPDATE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "misiones_detalle_all" ON "public"."misiones_conteo_detalle" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."misiones_conteo" "m"
  WHERE (("m"."id" = "misiones_conteo_detalle"."mision_id") AND ("m"."empresa_id" = "public"."current_empresa_id"()) AND ((("public"."app_role"() = 'empleado'::"text") AND ("m"."sucursal_id" = "public"."current_sucursal_id"()) AND ("m"."asignada_a" = "public"."current_user_id"())) OR (("public"."app_role"() = 'encargado'::"text") AND ("m"."sucursal_id" = "public"."current_sucursal_id"())) OR ("public"."app_role"() = 'admin'::"text")))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."misiones_conteo" "m"
  WHERE (("m"."id" = "misiones_conteo_detalle"."mision_id") AND ("m"."empresa_id" = "public"."current_empresa_id"())))));



CREATE POLICY "misiones_empleado_select" ON "public"."misiones_conteo" FOR SELECT TO "authenticated" USING ((("public"."app_role"() = 'empleado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("sucursal_id" = "public"."current_sucursal_id"()) AND ("asignada_a" = "public"."current_user_id"())));



CREATE POLICY "misiones_empleado_update" ON "public"."misiones_conteo" FOR UPDATE TO "authenticated" USING ((("public"."app_role"() = 'empleado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("sucursal_id" = "public"."current_sucursal_id"()) AND ("asignada_a" = "public"."current_user_id"()) AND ("estado" = ANY (ARRAY['ASIGNADA'::"text", 'EN_PROCESO'::"text", 'SUSPENDIDA'::"text"])))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("sucursal_id" = "public"."current_sucursal_id"()) AND ("asignada_a" = "public"."current_user_id"()) AND ("estado" = ANY (ARRAY['ASIGNADA'::"text", 'EN_PROCESO'::"text", 'SUSPENDIDA'::"text", 'COMPLETADA'::"text"]))));



CREATE POLICY "misiones_encargado_select" ON "public"."misiones_conteo" FOR SELECT TO "authenticated" USING ((("public"."app_role"() = 'encargado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("sucursal_id" = "public"."current_sucursal_id"())));



CREATE POLICY "misiones_encargado_update_estado" ON "public"."misiones_conteo" FOR UPDATE TO "authenticated" USING ((("public"."app_role"() = 'encargado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("sucursal_id" = "public"."current_sucursal_id"()) AND ("estado" = 'COMPLETADA'::"text"))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("sucursal_id" = "public"."current_sucursal_id"()) AND ("estado" = ANY (ARRAY['APROBADA'::"text", 'RECHAZADA'::"text"]))));



CREATE POLICY "mov_caja_admin_all" ON "public"."movimientos_caja" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK (("empresaid" = "public"."current_empresa_id"()));



CREATE POLICY "mov_caja_auditor_select" ON "public"."movimientos_caja" FOR SELECT TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'auditor'::"text")));



CREATE POLICY "mov_caja_encargado_select" ON "public"."movimientos_caja" FOR SELECT TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text")));



CREATE POLICY "mov_caja_self_insert" ON "public"."movimientos_caja" FOR INSERT TO "authenticated" WITH CHECK ((("registradopor" = "auth"."uid"()) AND ("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"())));



CREATE POLICY "mov_caja_self_select" ON "public"."movimientos_caja" FOR SELECT TO "authenticated" USING (("registradopor" = "auth"."uid"()));



ALTER TABLE "public"."movimientos_caja" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "movimientos_caja_delete" ON "public"."movimientos_caja" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "movimientos_caja_insert" ON "public"."movimientos_caja" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "movimientos_caja_select" ON "public"."movimientos_caja" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "movimientos_caja_update" ON "public"."movimientos_caja" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."movimientosinventario" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "movimientosinventario_delete" ON "public"."movimientosinventario" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "movimientosinventario_insert" ON "public"."movimientosinventario" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "movimientosinventario_select" ON "public"."movimientosinventario" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "movimientosinventario_update" ON "public"."movimientosinventario" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."notificaciones_usuario" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "notificaciones_usuario_insert" ON "public"."notificaciones_usuario" FOR INSERT TO "authenticated" WITH CHECK (("public"."app_role"() = ANY (ARRAY['admin'::"text", 'encargado'::"text"])));



CREATE POLICY "notificaciones_usuario_select" ON "public"."notificaciones_usuario" FOR SELECT TO "authenticated" USING (("userid" = "auth"."uid"()));



CREATE POLICY "notificaciones_usuario_update" ON "public"."notificaciones_usuario" FOR UPDATE TO "authenticated" USING (("userid" = "auth"."uid"())) WITH CHECK (("userid" = "auth"."uid"()));



CREATE POLICY "novedades_admin_all" ON "public"."novedades_inventario" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK (("empresaid" = "public"."current_empresa_id"()));



CREATE POLICY "novedades_bodeguero_insert" ON "public"."novedades_inventario" FOR INSERT TO "authenticated" WITH CHECK ((("reportadopor" = "auth"."uid"()) AND ("empresaid" = "public"."current_empresa_id"()) AND "public"."has_role"('bodeguero'::"text")));



CREATE POLICY "novedades_encargado_all" ON "public"."novedades_inventario" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"())));



ALTER TABLE "public"."novedades_inventario" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "novedades_self_select" ON "public"."novedades_inventario" FOR SELECT TO "authenticated" USING (("reportadopor" = "auth"."uid"()));



CREATE POLICY "oc_admin_all" ON "public"."ordenes_compra_encabezado" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"()))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"())));



CREATE POLICY "oc_conteo_admin_all" ON "public"."oc_recepcion_conteo" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_conteo"."recepcionid") AND ("r"."empresa_id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_conteo"."recepcionid") AND ("r"."empresa_id" = "public"."current_empresa_id"())))));



CREATE POLICY "oc_conteo_auditor_select" ON "public"."oc_recepcion_conteo" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_conteo"."recepcionid") AND ("r"."empresa_id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'auditor'::"text")))));



CREATE POLICY "oc_conteo_bodeguero_all" ON "public"."oc_recepcion_conteo" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_conteo"."recepcionid") AND ("r"."sucursal_id" = "public"."current_sucursal_id"()) AND "public"."has_role"('bodeguero'::"text"))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_conteo"."recepcionid") AND ("r"."sucursal_id" = "public"."current_sucursal_id"())))));



CREATE POLICY "oc_conteo_encargado_select" ON "public"."oc_recepcion_conteo" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_conteo"."recepcionid") AND ("r"."sucursal_id" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text")))));



CREATE POLICY "oc_detalle_empleado_update_recepcion" ON "public"."ordenes_compra_detalle" FOR UPDATE TO "authenticated" USING ((("public"."app_role"() = 'empleado'::"text") AND (EXISTS ( SELECT 1
   FROM "public"."ordenes_compra_encabezado" "oc"
  WHERE (("oc"."id_orden_compra" = "ordenes_compra_detalle"."id_orden_compra") AND ("oc"."empresa_id" = "public"."current_empresa_id"()) AND ("oc"."id_sucursal" = "public"."current_sucursal_id"()) AND ("oc"."empleado_asignado_id" = "public"."current_user_id"()) AND ("oc"."estado" = 'PENDIENTE_RECEPCION'::"text")))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."ordenes_compra_encabezado" "oc"
  WHERE (("oc"."id_orden_compra" = "ordenes_compra_detalle"."id_orden_compra") AND ("oc"."empresa_id" = "public"."current_empresa_id"()) AND ("oc"."id_sucursal" = "public"."current_sucursal_id"()) AND ("oc"."empleado_asignado_id" = "public"."current_user_id"()) AND ("oc"."estado" = 'PENDIENTE_RECEPCION'::"text")))));



CREATE POLICY "oc_detalle_tenant" ON "public"."ordenes_compra_detalle" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."ordenes_compra_encabezado" "oc"
  WHERE (("oc"."id_orden_compra" = "ordenes_compra_detalle"."id_orden_compra") AND ("oc"."empresa_id" = "public"."current_empresa_id"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."ordenes_compra_encabezado" "oc"
  WHERE (("oc"."id_orden_compra" = "ordenes_compra_detalle"."id_orden_compra") AND ("oc"."empresa_id" = "public"."current_empresa_id"())))));



CREATE POLICY "oc_empleado_insert" ON "public"."ordenes_compra_encabezado" FOR INSERT TO "authenticated" WITH CHECK ((("public"."app_role"() = 'empleado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("id_sucursal" = "public"."current_sucursal_id"()) AND ("empleado_asignado_id" = "public"."current_user_id"()) AND ("estado" = 'BORRADOR'::"text")));



CREATE POLICY "oc_empleado_select" ON "public"."ordenes_compra_encabezado" FOR SELECT TO "authenticated" USING ((("public"."app_role"() = 'empleado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("id_sucursal" = "public"."current_sucursal_id"()) AND ("empleado_asignado_id" = "public"."current_user_id"())));



CREATE POLICY "oc_empleado_update_borrador" ON "public"."ordenes_compra_encabezado" FOR UPDATE TO "authenticated" USING ((("public"."app_role"() = 'empleado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("id_sucursal" = "public"."current_sucursal_id"()) AND ("empleado_asignado_id" = "public"."current_user_id"()) AND ("estado" = 'BORRADOR'::"text"))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("id_sucursal" = "public"."current_sucursal_id"()) AND ("empleado_asignado_id" = "public"."current_user_id"()) AND ("estado" = ANY (ARRAY['BORRADOR'::"text", 'ENVIADA'::"text"]))));



CREATE POLICY "oc_empleado_update_recepcion" ON "public"."ordenes_compra_encabezado" FOR UPDATE TO "authenticated" USING ((("public"."app_role"() = 'empleado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("id_sucursal" = "public"."current_sucursal_id"()) AND ("empleado_asignado_id" = "public"."current_user_id"()) AND ("estado" = 'PENDIENTE_RECEPCION'::"text"))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("id_sucursal" = "public"."current_sucursal_id"()) AND ("empleado_asignado_id" = "public"."current_user_id"()) AND ("estado" = ANY (ARRAY['PENDIENTE_RECEPCION'::"text", 'RECIBIDA'::"text"]))));



CREATE POLICY "oc_encargado_select" ON "public"."ordenes_compra_encabezado" FOR SELECT TO "authenticated" USING ((("public"."app_role"() = 'encargado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("id_sucursal" = "public"."current_sucursal_id"())));



CREATE POLICY "oc_encargado_update_estado" ON "public"."ordenes_compra_encabezado" FOR UPDATE TO "authenticated" USING ((("public"."app_role"() = 'encargado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("id_sucursal" = "public"."current_sucursal_id"()) AND ("estado" = ANY (ARRAY['ENVIADA'::"text", 'APROBADA'::"text", 'PENDIENTE_RECEPCION'::"text"])))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("id_sucursal" = "public"."current_sucursal_id"()) AND ("estado" = ANY (ARRAY['APROBADA'::"text", 'PENDIENTE_RECEPCION'::"text", 'ANULADA'::"text"]))));



ALTER TABLE "public"."oc_recepcion_anomalias" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "oc_recepcion_anomalias_all" ON "public"."oc_recepcion_anomalias" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_anomalias"."id_recepcion") AND ("r"."empresa_id" = "public"."current_empresa_id"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_anomalias"."id_recepcion") AND ("r"."empresa_id" = "public"."current_empresa_id"())))));



CREATE POLICY "oc_recepcion_anomalias_delete" ON "public"."oc_recepcion_anomalias" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_anomalias"."id_recepcion") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "oc_recepcion_anomalias_insert" ON "public"."oc_recepcion_anomalias" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_anomalias"."id_recepcion") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "oc_recepcion_anomalias_select" ON "public"."oc_recepcion_anomalias" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_anomalias"."id_recepcion") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "oc_recepcion_anomalias_update" ON "public"."oc_recepcion_anomalias" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_anomalias"."id_recepcion") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_anomalias"."id_recepcion") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



ALTER TABLE "public"."oc_recepcion_conteo" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "oc_recepcion_conteo_delete" ON "public"."oc_recepcion_conteo" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_conteo"."recepcionid") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "oc_recepcion_conteo_insert" ON "public"."oc_recepcion_conteo" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_conteo"."recepcionid") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "oc_recepcion_conteo_select" ON "public"."oc_recepcion_conteo" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_conteo"."recepcionid") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "oc_recepcion_conteo_update" ON "public"."oc_recepcion_conteo" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_conteo"."recepcionid") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_conteo"."recepcionid") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



ALTER TABLE "public"."oc_recepcion_fotos" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "oc_recepcion_fotos_all" ON "public"."oc_recepcion_fotos" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_fotos"."id_recepcion") AND ("r"."empresa_id" = "public"."current_empresa_id"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_fotos"."id_recepcion") AND ("r"."empresa_id" = "public"."current_empresa_id"())))));



CREATE POLICY "oc_recepcion_fotos_delete" ON "public"."oc_recepcion_fotos" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_fotos"."id_recepcion") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "oc_recepcion_fotos_insert" ON "public"."oc_recepcion_fotos" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_fotos"."id_recepcion") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "oc_recepcion_fotos_select" ON "public"."oc_recepcion_fotos" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_fotos"."id_recepcion") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "oc_recepcion_fotos_update" ON "public"."oc_recepcion_fotos" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_fotos"."id_recepcion") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."oc_recepciones" "r"
  WHERE (("r"."id" = "oc_recepcion_fotos"."id_recepcion") AND ("r"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



ALTER TABLE "public"."oc_recepciones" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "oc_recepciones_admin_autorizar" ON "public"."oc_recepciones" FOR UPDATE TO "authenticated" USING ((("empresa_id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text") AND ("estado_autorizacion" = 'AUTORIZADO_ENCARGADO'::"public"."estado_autorizacion"))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("estado_autorizacion" = ANY (ARRAY['AUTORIZADO_ADMIN'::"public"."estado_autorizacion", 'RECHAZADO'::"public"."estado_autorizacion"]))));



CREATE POLICY "oc_recepciones_delete" ON "public"."oc_recepciones" FOR DELETE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "oc_recepciones_encargado_autorizar" ON "public"."oc_recepciones" FOR UPDATE TO "authenticated" USING ((("sucursal_id" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text") AND ("estado_autorizacion" = 'PENDIENTE'::"public"."estado_autorizacion"))) WITH CHECK ((("sucursal_id" = "public"."current_sucursal_id"()) AND ("estado_autorizacion" = ANY (ARRAY['AUTORIZADO_ENCARGADO'::"public"."estado_autorizacion", 'RECHAZADO'::"public"."estado_autorizacion"]))));



CREATE POLICY "oc_recepciones_insert" ON "public"."oc_recepciones" FOR INSERT TO "authenticated" WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "oc_recepciones_select" ON "public"."oc_recepciones" FOR SELECT TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "oc_recepciones_update" ON "public"."oc_recepciones" FOR UPDATE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."ordenesVenta" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "ordenesVenta_delete" ON "public"."ordenesVenta" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "ordenesVenta_insert" ON "public"."ordenesVenta" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "ordenesVenta_select" ON "public"."ordenesVenta" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "ordenesVenta_update" ON "public"."ordenesVenta" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."ordenes_compra_detalle" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "ordenes_compra_detalle_delete" ON "public"."ordenes_compra_detalle" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."ordenes_compra_encabezado" "oe"
  WHERE (("oe"."id" = "ordenes_compra_detalle"."id_orden_compra") AND ("oe"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "ordenes_compra_detalle_insert" ON "public"."ordenes_compra_detalle" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."ordenes_compra_encabezado" "oe"
  WHERE (("oe"."id" = "ordenes_compra_detalle"."id_orden_compra") AND ("oe"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "ordenes_compra_detalle_select" ON "public"."ordenes_compra_detalle" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."ordenes_compra_encabezado" "oe"
  WHERE (("oe"."id" = "ordenes_compra_detalle"."id_orden_compra") AND ("oe"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "ordenes_compra_detalle_update" ON "public"."ordenes_compra_detalle" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."ordenes_compra_encabezado" "oe"
  WHERE (("oe"."id" = "ordenes_compra_detalle"."id_orden_compra") AND ("oe"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."ordenes_compra_encabezado" "oe"
  WHERE (("oe"."id" = "ordenes_compra_detalle"."id_orden_compra") AND ("oe"."empresa_id" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



ALTER TABLE "public"."ordenes_compra_encabezado" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "ordenes_compra_encabezado_delete" ON "public"."ordenes_compra_encabezado" FOR DELETE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "ordenes_compra_encabezado_insert" ON "public"."ordenes_compra_encabezado" FOR INSERT TO "authenticated" WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "ordenes_compra_encabezado_select" ON "public"."ordenes_compra_encabezado" FOR SELECT TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "ordenes_compra_encabezado_update" ON "public"."ordenes_compra_encabezado" FOR UPDATE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."ordenescompra" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "ordenescompra_select" ON "public"."ordenescompra" FOR SELECT TO "authenticated" USING (("empresaid" = "public"."current_empresa_id"()));



CREATE POLICY "ordenescompra_write_admin" ON "public"."ordenescompra" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



ALTER TABLE "public"."ordenescompradetalle" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "ordenescompradetalle_select" ON "public"."ordenescompradetalle" FOR SELECT TO "authenticated" USING (("ordenid" IN ( SELECT "ordenescompra"."id"
   FROM "public"."ordenescompra"
  WHERE ("ordenescompra"."empresaid" = "public"."current_empresa_id"()))));



CREATE POLICY "ordenescompradetalle_write_admin" ON "public"."ordenescompradetalle" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("ordenid" IN ( SELECT "ordenescompra"."id"
   FROM "public"."ordenescompra"
  WHERE ("ordenescompra"."empresaid" = "public"."current_empresa_id"()))))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("ordenid" IN ( SELECT "ordenescompra"."id"
   FROM "public"."ordenescompra"
  WHERE ("ordenescompra"."empresaid" = "public"."current_empresa_id"())))));



CREATE POLICY "p_compras_det_admin_all" ON "public"."compras_detalle" USING ((("public"."app_role"() = 'admin'::"text") AND (EXISTS ( SELECT 1
   FROM "public"."compras_encabezado" "ce"
  WHERE (("ce"."id_compra" = "compras_detalle"."id_compra") AND ("ce"."empresa_id" = "public"."current_empresa_id"())))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."compras_encabezado" "ce"
  WHERE (("ce"."id_compra" = "compras_detalle"."id_compra") AND ("ce"."empresa_id" = "public"."current_empresa_id"())))));



CREATE POLICY "p_compras_det_all_admin" ON "public"."compras_detalle" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND (EXISTS ( SELECT 1
   FROM "public"."compras_encabezado" "c"
  WHERE (("c"."id_compra" = "compras_detalle"."id_compra") AND ("c"."empresa_id" = "public"."current_empresa_id"())))))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND (EXISTS ( SELECT 1
   FROM "public"."compras_encabezado" "c"
  WHERE (("c"."id_compra" = "compras_detalle"."id_compra") AND ("c"."empresa_id" = "public"."current_empresa_id"()))))));



CREATE POLICY "p_compras_det_encargado_select" ON "public"."compras_detalle" FOR SELECT USING ((("public"."app_role"() = 'encargado'::"text") AND (EXISTS ( SELECT 1
   FROM "public"."compras_encabezado" "ce"
  WHERE (("ce"."id_compra" = "compras_detalle"."id_compra") AND ("ce"."empresa_id" = "public"."current_empresa_id"()) AND ("ce"."id_sucursal" = "public"."current_sucursal_id"()) AND ("ce"."deleted_at" IS NULL))))));



CREATE POLICY "p_compras_enc_admin_all" ON "public"."compras_encabezado" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"()))) WITH CHECK (("empresa_id" = "public"."current_empresa_id"()));



CREATE POLICY "p_compras_enc_encargado_select" ON "public"."compras_encabezado" FOR SELECT USING ((("public"."app_role"() = 'encargado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("id_sucursal" = "public"."current_sucursal_id"()) AND ("deleted_at" IS NULL)));



CREATE POLICY "p_oc_det_all_admin" ON "public"."ordenes_compra_detalle" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND (EXISTS ( SELECT 1
   FROM "public"."ordenes_compra_encabezado" "o"
  WHERE (("o"."id_orden_compra" = "ordenes_compra_detalle"."id_orden_compra") AND ("o"."empresa_id" = "public"."current_empresa_id"())))))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND (EXISTS ( SELECT 1
   FROM "public"."ordenes_compra_encabezado" "o"
  WHERE (("o"."id_orden_compra" = "ordenes_compra_detalle"."id_orden_compra") AND ("o"."empresa_id" = "public"."current_empresa_id"()))))));



CREATE POLICY "p_proveedores_admin_all" ON "public"."proveedores" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"()))) WITH CHECK (("empresa_id" = "public"."current_empresa_id"()));



CREATE POLICY "p_proveedores_select" ON "public"."proveedores" FOR SELECT USING ((("empresa_id" = "public"."current_empresa_id"()) AND ("deleted_at" IS NULL) AND ("public"."app_role"() = ANY (ARRAY['empleado'::"text", 'encargado'::"text", 'admin'::"text"]))));



CREATE POLICY "p_traslados_det_admin_all" ON "public"."traslados_detalle" USING ((("public"."app_role"() = 'admin'::"text") AND (EXISTS ( SELECT 1
   FROM "public"."traslados_encabezado" "te"
  WHERE (("te"."id" = "traslados_detalle"."traslado_id") AND ("te"."empresa_id" = "public"."current_empresa_id"())))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."traslados_encabezado" "te"
  WHERE (("te"."id" = "traslados_detalle"."traslado_id") AND ("te"."empresa_id" = "public"."current_empresa_id"())))));



CREATE POLICY "p_traslados_det_empleado" ON "public"."traslados_detalle" USING ((("public"."app_role"() = 'empleado'::"text") AND (EXISTS ( SELECT 1
   FROM "public"."traslados_encabezado" "te"
  WHERE (("te"."id" = "traslados_detalle"."traslado_id") AND ("te"."creado_por_id" = "auth"."uid"()) AND ("te"."empresa_id" = "public"."current_empresa_id"()) AND ("te"."estado" = 'BORRADOR'::"public"."traslado_estado") AND ("te"."deleted_at" IS NULL)))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."traslados_encabezado" "te"
  WHERE (("te"."id" = "traslados_detalle"."traslado_id") AND ("te"."creado_por_id" = "auth"."uid"()) AND ("te"."empresa_id" = "public"."current_empresa_id"()) AND ("te"."estado" = 'BORRADOR'::"public"."traslado_estado")))));



CREATE POLICY "p_traslados_det_encargado" ON "public"."traslados_detalle" FOR SELECT USING ((("public"."app_role"() = 'encargado'::"text") AND (EXISTS ( SELECT 1
   FROM "public"."traslados_encabezado" "te"
  WHERE (("te"."id" = "traslados_detalle"."traslado_id") AND ("te"."empresa_id" = "public"."current_empresa_id"()) AND (("te"."ubicacion_origen_id" = "public"."current_sucursal_id"()) OR ("te"."ubicacion_destino_id" = "public"."current_sucursal_id"())) AND ("te"."deleted_at" IS NULL))))));



CREATE POLICY "p_traslados_enc_admin_all" ON "public"."traslados_encabezado" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"()))) WITH CHECK (("empresa_id" = "public"."current_empresa_id"()));



CREATE POLICY "p_traslados_enc_empleado_delete" ON "public"."traslados_encabezado" FOR DELETE USING ((("public"."app_role"() = 'empleado'::"text") AND ("creado_por_id" = "auth"."uid"()) AND ("empresa_id" = "public"."current_empresa_id"()) AND ("estado" = 'BORRADOR'::"public"."traslado_estado")));



CREATE POLICY "p_traslados_enc_empleado_insert" ON "public"."traslados_encabezado" FOR INSERT WITH CHECK ((("public"."app_role"() = 'empleado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("estado" = 'BORRADOR'::"public"."traslado_estado")));



CREATE POLICY "p_traslados_enc_empleado_select" ON "public"."traslados_encabezado" FOR SELECT USING ((("public"."app_role"() = 'empleado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("creado_por_id" = "auth"."uid"()) AND ("deleted_at" IS NULL)));



CREATE POLICY "p_traslados_enc_empleado_update" ON "public"."traslados_encabezado" FOR UPDATE USING ((("public"."app_role"() = 'empleado'::"text") AND ("creado_por_id" = "auth"."uid"()) AND ("empresa_id" = "public"."current_empresa_id"()) AND ("estado" = 'BORRADOR'::"public"."traslado_estado"))) WITH CHECK (("estado" = 'BORRADOR'::"public"."traslado_estado"));



CREATE POLICY "p_traslados_enc_encargado_select" ON "public"."traslados_encabezado" FOR SELECT USING ((("public"."app_role"() = 'encargado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND (("ubicacion_origen_id" = "public"."current_sucursal_id"()) OR ("ubicacion_destino_id" = "public"."current_sucursal_id"())) AND ("deleted_at" IS NULL)));



CREATE POLICY "p_traslados_enc_encargado_update" ON "public"."traslados_encabezado" FOR UPDATE USING ((("public"."app_role"() = 'encargado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND (("ubicacion_origen_id" = "public"."current_sucursal_id"()) OR ("ubicacion_destino_id" = "public"."current_sucursal_id"())))) WITH CHECK (("estado" = ANY (ARRAY['ENVIADO'::"public"."traslado_estado", 'APROBADO'::"public"."traslado_estado", 'EN_TRANSITO'::"public"."traslado_estado", 'COMPLETADO'::"public"."traslado_estado", 'RECHAZADO'::"public"."traslado_estado", 'ANULADO'::"public"."traslado_estado"])));



ALTER TABLE "public"."pagos_compras" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "pagos_compras_delete" ON "public"."pagos_compras" FOR DELETE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "pagos_compras_insert" ON "public"."pagos_compras" FOR INSERT TO "authenticated" WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "pagos_compras_select" ON "public"."pagos_compras" FOR SELECT TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "pagos_compras_update" ON "public"."pagos_compras" FOR UPDATE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "pagos_compras_write_admin_encargado" ON "public"."pagos_compras" TO "authenticated" USING ((("empresa_id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = ANY (ARRAY['admin'::"text", 'encargado'::"text"])))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = ANY (ARRAY['admin'::"text", 'encargado'::"text"]))));



ALTER TABLE "public"."pedidosVenta" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."pedidosVentaLineas" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "pedidosVentaLineas_delete" ON "public"."pedidosVentaLineas" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."pedidosVenta" "pv"
  WHERE (("pv"."id" = "pedidosVentaLineas"."pedidoVentaId") AND ("pv"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "pedidosVentaLineas_insert" ON "public"."pedidosVentaLineas" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."pedidosVenta" "pv"
  WHERE (("pv"."id" = "pedidosVentaLineas"."pedidoVentaId") AND ("pv"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "pedidosVentaLineas_select" ON "public"."pedidosVentaLineas" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."pedidosVenta" "pv"
  WHERE (("pv"."id" = "pedidosVentaLineas"."pedidoVentaId") AND ("pv"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "pedidosVentaLineas_update" ON "public"."pedidosVentaLineas" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."pedidosVenta" "pv"
  WHERE (("pv"."id" = "pedidosVentaLineas"."pedidoVentaId") AND ("pv"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."pedidosVenta" "pv"
  WHERE (("pv"."id" = "pedidosVentaLineas"."pedidoVentaId") AND ("pv"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "pedidosVenta_delete" ON "public"."pedidosVenta" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "pedidosVenta_insert" ON "public"."pedidosVenta" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "pedidosVenta_select" ON "public"."pedidosVenta" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "pedidosVenta_update" ON "public"."pedidosVenta" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."producto_codigos_externos" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "producto_codigos_externos_select" ON "public"."producto_codigos_externos" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "producto_codigos_externos_write_admin" ON "public"."producto_codigos_externos" TO "authenticated" USING (("public"."app_role"() = 'admin'::"text")) WITH CHECK (("public"."app_role"() = 'admin'::"text"));



ALTER TABLE "public"."productos" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "productos_admin_write" ON "public"."productos" TO "authenticated" USING ((("empresa_id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



CREATE POLICY "productos_delete" ON "public"."productos" FOR DELETE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "productos_delete_admin_only" ON "public"."productos" FOR DELETE TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"())));



ALTER TABLE "public"."productos_erp" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "productos_erp_select" ON "public"."productos_erp" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "productos_erp_write_admin" ON "public"."productos_erp" TO "authenticated" USING (("public"."app_role"() = 'admin'::"text")) WITH CHECK (("public"."app_role"() = 'admin'::"text"));



CREATE POLICY "productos_insert" ON "public"."productos" FOR INSERT TO "authenticated" WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "productos_insert_admin_only" ON "public"."productos" FOR INSERT TO "authenticated" WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"())));



CREATE POLICY "productos_select" ON "public"."productos" FOR SELECT TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "productos_select_by_empresa" ON "public"."productos" FOR SELECT TO "authenticated" USING (("empresa_id" = "public"."current_empresa_id"()));



CREATE POLICY "productos_tenant_isolation" ON "public"."productos" TO "authenticated" USING (("empresa_id" = "public"."current_empresa_id"())) WITH CHECK (("empresa_id" = "public"."current_empresa_id"()));



CREATE POLICY "productos_update" ON "public"."productos" FOR UPDATE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "productos_update_admin_only" ON "public"."productos" FOR UPDATE TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"()))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"())));



ALTER TABLE "public"."productounidades" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "productounidades_select_all" ON "public"."productounidades" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "productounidades_write_admin" ON "public"."productounidades" TO "authenticated" USING (("public"."app_role"() = 'admin'::"text")) WITH CHECK (("public"."app_role"() = 'admin'::"text"));



ALTER TABLE "public"."proveedores" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "proveedores_admin_write" ON "public"."proveedores" TO "authenticated" USING ((("empresa_id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



ALTER TABLE "public"."proveedores_contactos" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "proveedores_contactos_select" ON "public"."proveedores_contactos" FOR SELECT TO "authenticated" USING (("proveedorid" IN ( SELECT "proveedores"."id"
   FROM "public"."proveedores"
  WHERE ("proveedores"."empresa_id" = "public"."current_empresa_id"()))));



CREATE POLICY "proveedores_contactos_write_admin" ON "public"."proveedores_contactos" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("proveedorid" IN ( SELECT "proveedores"."id"
   FROM "public"."proveedores"
  WHERE ("proveedores"."empresa_id" = "public"."current_empresa_id"()))))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("proveedorid" IN ( SELECT "proveedores"."id"
   FROM "public"."proveedores"
  WHERE ("proveedores"."empresa_id" = "public"."current_empresa_id"())))));



CREATE POLICY "proveedores_delete" ON "public"."proveedores" FOR DELETE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."proveedores_documentos" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "proveedores_documentos_select" ON "public"."proveedores_documentos" FOR SELECT TO "authenticated" USING (("proveedorid" IN ( SELECT "proveedores"."id"
   FROM "public"."proveedores"
  WHERE ("proveedores"."empresa_id" = "public"."current_empresa_id"()))));



CREATE POLICY "proveedores_documentos_write_admin" ON "public"."proveedores_documentos" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("proveedorid" IN ( SELECT "proveedores"."id"
   FROM "public"."proveedores"
  WHERE ("proveedores"."empresa_id" = "public"."current_empresa_id"()))))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("proveedorid" IN ( SELECT "proveedores"."id"
   FROM "public"."proveedores"
  WHERE ("proveedores"."empresa_id" = "public"."current_empresa_id"())))));



ALTER TABLE "public"."proveedores_evaluaciones" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "proveedores_evaluaciones_select" ON "public"."proveedores_evaluaciones" FOR SELECT TO "authenticated" USING (("proveedorid" IN ( SELECT "proveedores"."id"
   FROM "public"."proveedores"
  WHERE ("proveedores"."empresa_id" = "public"."current_empresa_id"()))));



CREATE POLICY "proveedores_evaluaciones_write_admin" ON "public"."proveedores_evaluaciones" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("proveedorid" IN ( SELECT "proveedores"."id"
   FROM "public"."proveedores"
  WHERE ("proveedores"."empresa_id" = "public"."current_empresa_id"()))))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("proveedorid" IN ( SELECT "proveedores"."id"
   FROM "public"."proveedores"
  WHERE ("proveedores"."empresa_id" = "public"."current_empresa_id"())))));



CREATE POLICY "proveedores_insert" ON "public"."proveedores" FOR INSERT TO "authenticated" WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "proveedores_select" ON "public"."proveedores" FOR SELECT TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "proveedores_tenant_isolation" ON "public"."proveedores" TO "authenticated" USING (("empresa_id" = "public"."current_empresa_id"())) WITH CHECK (("empresa_id" = "public"."current_empresa_id"()));



CREATE POLICY "proveedores_update" ON "public"."proveedores" FOR UPDATE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."recepcionescompra" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "recepcionescompra_select" ON "public"."recepcionescompra" FOR SELECT TO "authenticated" USING (("empresaid" = "public"."current_empresa_id"()));



CREATE POLICY "recepcionescompra_write_admin" ON "public"."recepcionescompra" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



ALTER TABLE "public"."recepcionescompradetalle" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "recepcionescompradetalle_select" ON "public"."recepcionescompradetalle" FOR SELECT TO "authenticated" USING (("recepcionid" IN ( SELECT "recepcionescompra"."id"
   FROM "public"."recepcionescompra"
  WHERE ("recepcionescompra"."empresaid" = "public"."current_empresa_id"()))));



CREATE POLICY "recepcionescompradetalle_write_admin" ON "public"."recepcionescompradetalle" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("recepcionid" IN ( SELECT "recepcionescompra"."id"
   FROM "public"."recepcionescompra"
  WHERE ("recepcionescompra"."empresaid" = "public"."current_empresa_id"()))))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("recepcionid" IN ( SELECT "recepcionescompra"."id"
   FROM "public"."recepcionescompra"
  WHERE ("recepcionescompra"."empresaid" = "public"."current_empresa_id"())))));



ALTER TABLE "public"."role_permissions" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "role_permissions_admin_write" ON "public"."role_permissions" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"()))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



CREATE POLICY "role_permissions_select_empresa" ON "public"."role_permissions" FOR SELECT TO "authenticated" USING (("empresa_id" = "public"."current_empresa_id"()));



ALTER TABLE "public"."roles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "roles_admin_all" ON "public"."roles" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



CREATE POLICY "roles_select" ON "public"."roles" FOR SELECT TO "authenticated" USING (("empresaid" = "public"."current_empresa_id"()));



ALTER TABLE "public"."stockubicacion" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "stockubicacion_delete" ON "public"."stockubicacion" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "stockubicacion_insert" ON "public"."stockubicacion" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "stockubicacion_select" ON "public"."stockubicacion" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "stockubicacion_update" ON "public"."stockubicacion" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."sucursales" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "sucursales_admin_all" ON "public"."sucursales" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



CREATE POLICY "sucursales_delete" ON "public"."sucursales" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "sucursales_encargado_select" ON "public"."sucursales" FOR SELECT TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'encargado'::"text")));



CREATE POLICY "sucursales_insert" ON "public"."sucursales" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "sucursales_select" ON "public"."sucursales" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "sucursales_update" ON "public"."sucursales" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "sugerencias_admin_all" ON "public"."sugerencias_pedido" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK (("empresaid" = "public"."current_empresa_id"()));



ALTER TABLE "public"."sugerencias_pedido" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "sugerencias_select" ON "public"."sugerencias_pedido" FOR SELECT TO "authenticated" USING (("empresaid" = "public"."current_empresa_id"()));



ALTER TABLE "public"."tareas" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "tareas_admin_all" ON "public"."tareas" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK (("empresaid" = "public"."current_empresa_id"()));



CREATE POLICY "tareas_auditor_select" ON "public"."tareas" FOR SELECT TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'auditor'::"text")));



CREATE POLICY "tareas_delete" ON "public"."tareas" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."tareas_detalle_traslado" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "tareas_detalle_traslado_delete" ON "public"."tareas_detalle_traslado" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."tareas" "t"
  WHERE (("t"."id" = "tareas_detalle_traslado"."tareaid") AND ("t"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "tareas_detalle_traslado_insert" ON "public"."tareas_detalle_traslado" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."tareas" "t"
  WHERE (("t"."id" = "tareas_detalle_traslado"."tareaid") AND ("t"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "tareas_detalle_traslado_select" ON "public"."tareas_detalle_traslado" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."tareas" "t"
  WHERE (("t"."id" = "tareas_detalle_traslado"."tareaid") AND ("t"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "tareas_detalle_traslado_update" ON "public"."tareas_detalle_traslado" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."tareas" "t"
  WHERE (("t"."id" = "tareas_detalle_traslado"."tareaid") AND ("t"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."tareas" "t"
  WHERE (("t"."id" = "tareas_detalle_traslado"."tareaid") AND ("t"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "tareas_encargado_insert" ON "public"."tareas" FOR INSERT TO "authenticated" WITH CHECK ((("asignadapor" = "auth"."uid"()) AND ("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text")));



CREATE POLICY "tareas_encargado_select" ON "public"."tareas" FOR SELECT TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text")));



CREATE POLICY "tareas_encargado_update" ON "public"."tareas" FOR UPDATE TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"())));



CREATE POLICY "tareas_insert" ON "public"."tareas" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "tareas_select" ON "public"."tareas" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "tareas_self_select" ON "public"."tareas" FOR SELECT TO "authenticated" USING (("asignadaa" = "auth"."uid"()));



CREATE POLICY "tareas_self_update" ON "public"."tareas" FOR UPDATE TO "authenticated" USING ((("asignadaa" = "auth"."uid"()) AND ("estado" = ANY (ARRAY['PENDIENTE'::"public"."tarea_estado", 'EN_PROCESO'::"public"."tarea_estado", 'SUSPENDIDA'::"public"."tarea_estado"])))) WITH CHECK ((("asignadaa" = "auth"."uid"()) AND ("estado" = ANY (ARRAY['PENDIENTE'::"public"."tarea_estado", 'EN_PROCESO'::"public"."tarea_estado", 'COMPLETADA'::"public"."tarea_estado", 'SUSPENDIDA'::"public"."tarea_estado"]))));



CREATE POLICY "tareas_traslado_all" ON "public"."tareas_detalle_traslado" TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."tareas" "t"
  WHERE (("t"."id" = "tareas_detalle_traslado"."tareaid") AND ("t"."empresaid" = "public"."current_empresa_id"()) AND (("t"."asignadaa" = "auth"."uid"()) OR ("public"."app_role"() = ANY (ARRAY['encargado'::"text", 'admin'::"text"]))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."tareas" "t"
  WHERE (("t"."id" = "tareas_detalle_traslado"."tareaid") AND ("t"."empresaid" = "public"."current_empresa_id"())))));



ALTER TABLE "public"."tareas_turno" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "tareas_turno_admin_all" ON "public"."tareas_turno" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"()))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"())));



CREATE POLICY "tareas_turno_delete" ON "public"."tareas_turno" FOR DELETE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "tareas_turno_empleado_select" ON "public"."tareas_turno" FOR SELECT TO "authenticated" USING ((("empresa_id" = "public"."current_empresa_id"()) AND ("usuario_id" = "public"."current_user_id"())));



CREATE POLICY "tareas_turno_empleado_update" ON "public"."tareas_turno" FOR UPDATE TO "authenticated" USING ((("public"."app_role"() = 'empleado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("usuario_id" = "public"."current_user_id"()) AND ("estado" = ANY (ARRAY['PENDIENTE'::"text", 'EN_PROCESO'::"text"])))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("usuario_id" = "public"."current_user_id"()) AND ("estado" = ANY (ARRAY['PENDIENTE'::"text", 'EN_PROCESO'::"text", 'COMPLETADA'::"text"]))));



CREATE POLICY "tareas_turno_encargado_select" ON "public"."tareas_turno" FOR SELECT TO "authenticated" USING ((("public"."app_role"() = 'encargado'::"text") AND ("empresa_id" = "public"."current_empresa_id"()) AND ("sucursal_id" = "public"."current_sucursal_id"())));



CREATE POLICY "tareas_turno_insert" ON "public"."tareas_turno" FOR INSERT TO "authenticated" WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "tareas_turno_select" ON "public"."tareas_turno" FOR SELECT TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "tareas_turno_update" ON "public"."tareas_turno" FOR UPDATE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "tareas_update" ON "public"."tareas" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."tipos_tarea" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "tipos_tarea_admin_write" ON "public"."tipos_tarea_turno" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"()))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"())));



CREATE POLICY "tipos_tarea_select" ON "public"."tipos_tarea" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "tipos_tarea_select" ON "public"."tipos_tarea_turno" FOR SELECT TO "authenticated" USING (("empresa_id" = "public"."current_empresa_id"()));



ALTER TABLE "public"."tipos_tarea_turno" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "tipos_tarea_write_admin" ON "public"."tipos_tarea" TO "authenticated" USING (("public"."app_role"() = 'admin'::"text")) WITH CHECK (("public"."app_role"() = 'admin'::"text"));



ALTER TABLE "public"."traslados_detalle" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "traslados_detalle_delete" ON "public"."traslados_detalle" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."traslados_encabezado" "te"
  WHERE (("te"."id" = "traslados_detalle"."trasladoid") AND ("te"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "traslados_detalle_insert" ON "public"."traslados_detalle" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."traslados_encabezado" "te"
  WHERE (("te"."id" = "traslados_detalle"."trasladoid") AND ("te"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "traslados_detalle_select" ON "public"."traslados_detalle" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."traslados_encabezado" "te"
  WHERE (("te"."id" = "traslados_detalle"."trasladoid") AND ("te"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "traslados_detalle_update" ON "public"."traslados_detalle" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."traslados_encabezado" "te"
  WHERE (("te"."id" = "traslados_detalle"."trasladoid") AND ("te"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."traslados_encabezado" "te"
  WHERE (("te"."id" = "traslados_detalle"."trasladoid") AND ("te"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



ALTER TABLE "public"."traslados_encabezado" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "traslados_encabezado_delete" ON "public"."traslados_encabezado" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "traslados_encabezado_insert" ON "public"."traslados_encabezado" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "traslados_encabezado_select" ON "public"."traslados_encabezado" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "traslados_encabezado_update" ON "public"."traslados_encabezado" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."turnos" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "turnos_admin_all" ON "public"."turnos" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK (("empresaid" = "public"."current_empresa_id"()));



CREATE POLICY "turnos_auditor_select" ON "public"."turnos" FOR SELECT TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'auditor'::"text")));



ALTER TABLE "public"."turnos_caja" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "turnos_caja_admin_all" ON "public"."turnos_caja" TO "authenticated" USING ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"()))) WITH CHECK ((("public"."app_role"() = 'admin'::"text") AND ("empresa_id" = "public"."current_empresa_id"())));



CREATE POLICY "turnos_caja_delete" ON "public"."turnos_caja" FOR DELETE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "turnos_caja_insert" ON "public"."turnos_caja" FOR INSERT TO "authenticated" WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "turnos_caja_select" ON "public"."turnos_caja" FOR SELECT TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "turnos_caja_update" ON "public"."turnos_caja" FOR UPDATE TO "authenticated" USING (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresa_id" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "turnos_caja_usuario_select" ON "public"."turnos_caja" FOR SELECT TO "authenticated" USING ((("empresa_id" = "public"."current_empresa_id"()) AND ("usuario_id" = "public"."current_user_id"())));



CREATE POLICY "turnos_caja_usuario_write" ON "public"."turnos_caja" TO "authenticated" USING ((("public"."app_role"() = ANY (ARRAY['encargado'::"text", 'admin'::"text"])) AND ("empresa_id" = "public"."current_empresa_id"()) AND ("usuario_id" = "public"."current_user_id"()))) WITH CHECK ((("empresa_id" = "public"."current_empresa_id"()) AND ("usuario_id" = "public"."current_user_id"())));



CREATE POLICY "turnos_delete" ON "public"."turnos" FOR DELETE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "turnos_encargado_select" ON "public"."turnos" FOR SELECT TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text")));



CREATE POLICY "turnos_insert" ON "public"."turnos" FOR INSERT TO "authenticated" WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "turnos_select" ON "public"."turnos" FOR SELECT TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



CREATE POLICY "turnos_self_insert" ON "public"."turnos" FOR INSERT TO "authenticated" WITH CHECK ((("usuarioid" = "auth"."uid"()) AND ("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"())));



CREATE POLICY "turnos_self_select" ON "public"."turnos" FOR SELECT TO "authenticated" USING (("usuarioid" = "auth"."uid"()));



CREATE POLICY "turnos_self_update" ON "public"."turnos" FOR UPDATE TO "authenticated" USING (("usuarioid" = "auth"."uid"())) WITH CHECK (("usuarioid" = "auth"."uid"()));



CREATE POLICY "turnos_update" ON "public"."turnos" FOR UPDATE TO "authenticated" USING (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"())))) WITH CHECK (("empresaid" = ( SELECT "user_profiles"."empresaid"
   FROM "public"."user_profiles"
  WHERE ("user_profiles"."id" = "auth"."uid"()))));



ALTER TABLE "public"."unidadesmedida" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "unidadesmedida_select_all" ON "public"."unidadesmedida" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "unidadesmedida_write_admin" ON "public"."unidadesmedida" TO "authenticated" USING (("public"."app_role"() = 'admin'::"text")) WITH CHECK (("public"."app_role"() = 'admin'::"text"));



ALTER TABLE "public"."user_profiles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "user_profiles_admin_all" ON "public"."user_profiles" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK (("empresaid" = "public"."current_empresa_id"()));



CREATE POLICY "user_profiles_encargado_select" ON "public"."user_profiles" FOR SELECT TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("sucursalid" = "public"."current_sucursal_id"()) AND ("public"."app_role"() = 'encargado'::"text")));



CREATE POLICY "user_profiles_insert_trigger" ON "public"."user_profiles" FOR INSERT TO "authenticated" WITH CHECK (false);



CREATE POLICY "user_profiles_self_select" ON "public"."user_profiles" FOR SELECT TO "authenticated" USING (("userid" = "auth"."uid"()));



CREATE POLICY "user_profiles_self_update" ON "public"."user_profiles" FOR UPDATE TO "authenticated" USING (("userid" = "auth"."uid"())) WITH CHECK (("userid" = "auth"."uid"()));



ALTER TABLE "public"."user_roles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "user_roles_admin_all" ON "public"."user_roles" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



CREATE POLICY "user_roles_self_select" ON "public"."user_roles" FOR SELECT TO "authenticated" USING (("userid" = "auth"."uid"()));



ALTER TABLE "public"."user_sucursales" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "user_sucursales_admin_all" ON "public"."user_sucursales" TO "authenticated" USING ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text"))) WITH CHECK ((("empresaid" = "public"."current_empresa_id"()) AND ("public"."app_role"() = 'admin'::"text")));



CREATE POLICY "user_sucursales_self_select" ON "public"."user_sucursales" FOR SELECT TO "authenticated" USING (("userid" = "auth"."uid"()));



ALTER TABLE "public"."zonasbodega" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "zonasbodega_delete" ON "public"."zonasbodega" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."bodegas" "b"
  WHERE (("b"."id" = "zonasbodega"."bodegaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "zonasbodega_insert" ON "public"."zonasbodega" FOR INSERT TO "authenticated" WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."bodegas" "b"
  WHERE (("b"."id" = "zonasbodega"."bodegaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "zonasbodega_select" ON "public"."zonasbodega" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."bodegas" "b"
  WHERE (("b"."id" = "zonasbodega"."bodegaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



CREATE POLICY "zonasbodega_update" ON "public"."zonasbodega" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."bodegas" "b"
  WHERE (("b"."id" = "zonasbodega"."bodegaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"()))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."bodegas" "b"
  WHERE (("b"."id" = "zonasbodega"."bodegaid") AND ("b"."empresaid" = ( SELECT "user_profiles"."empresaid"
           FROM "public"."user_profiles"
          WHERE ("user_profiles"."id" = "auth"."uid"())))))));



GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



GRANT ALL ON FUNCTION "public"."abrir_jornada"("p_sucursalid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."abrir_jornada"("p_sucursalid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."abrir_jornada"("p_sucursalid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."abrir_turno"("p_jornadaid" "uuid", "p_cajaid" "uuid", "p_monto_sugerido" numeric, "p_monto_ajustado" numeric, "p_nota_ajuste" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."abrir_turno"("p_jornadaid" "uuid", "p_cajaid" "uuid", "p_monto_sugerido" numeric, "p_monto_ajustado" numeric, "p_nota_ajuste" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."abrir_turno"("p_jornadaid" "uuid", "p_cajaid" "uuid", "p_monto_sugerido" numeric, "p_monto_ajustado" numeric, "p_nota_ajuste" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."abrirjornada"("p_sucursalid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."abrirjornada"("p_sucursalid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."abrirjornada"("p_sucursalid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."abrirturno"("p_jornadaid" "uuid", "p_cajaid" "uuid", "p_montosugerido" numeric, "p_montoajustado" numeric, "p_notaajuste" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."abrirturno"("p_jornadaid" "uuid", "p_cajaid" "uuid", "p_montosugerido" numeric, "p_montoajustado" numeric, "p_notaajuste" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."abrirturno"("p_jornadaid" "uuid", "p_cajaid" "uuid", "p_montosugerido" numeric, "p_montoajustado" numeric, "p_notaajuste" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."app_role"() TO "anon";
GRANT ALL ON FUNCTION "public"."app_role"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."app_role"() TO "service_role";



GRANT ALL ON FUNCTION "public"."aprobar_ajuste_apertura"("p_turnoid" "uuid", "p_aprobar" boolean, "p_nota" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."aprobar_ajuste_apertura"("p_turnoid" "uuid", "p_aprobar" boolean, "p_nota" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."aprobar_ajuste_apertura"("p_turnoid" "uuid", "p_aprobar" boolean, "p_nota" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."aprobar_tarea"("p_tareaid" "uuid", "p_comentario" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."aprobar_tarea"("p_tareaid" "uuid", "p_comentario" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."aprobar_tarea"("p_tareaid" "uuid", "p_comentario" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."aprobarajusteapertura"("p_turnoid" "uuid", "p_aprobar" boolean, "p_nota" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."aprobarajusteapertura"("p_turnoid" "uuid", "p_aprobar" boolean, "p_nota" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."aprobarajusteapertura"("p_turnoid" "uuid", "p_aprobar" boolean, "p_nota" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."aprobartarea"("p_tareaid" "uuid", "p_comentario" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."aprobartarea"("p_tareaid" "uuid", "p_comentario" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."aprobartarea"("p_tareaid" "uuid", "p_comentario" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."autorizar_recepcion"("p_recepcion_id" "uuid", "p_aprobar" boolean, "p_nota" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."autorizar_recepcion"("p_recepcion_id" "uuid", "p_aprobar" boolean, "p_nota" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."autorizar_recepcion"("p_recepcion_id" "uuid", "p_aprobar" boolean, "p_nota" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."autorizarrecepcion"("p_recepcionid" "uuid", "p_aprobar" boolean, "p_nota" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."autorizarrecepcion"("p_recepcionid" "uuid", "p_aprobar" boolean, "p_nota" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."autorizarrecepcion"("p_recepcionid" "uuid", "p_aprobar" boolean, "p_nota" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."buscar_ocs_proveedor"("p_nombre_proveedor" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."buscar_ocs_proveedor"("p_nombre_proveedor" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."buscar_ocs_proveedor"("p_nombre_proveedor" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."buscarocsproveedor"("p_nombreproveedor" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."buscarocsproveedor"("p_nombreproveedor" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."buscarocsproveedor"("p_nombreproveedor" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."calcular_totales_arqueo"("p_arqueo_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."calcular_totales_arqueo"("p_arqueo_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."calcular_totales_arqueo"("p_arqueo_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."cerrar_jornada"("p_jornadaid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."cerrar_jornada"("p_jornadaid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."cerrar_jornada"("p_jornadaid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."cerrar_recepcion"("p_recepcion_id" "uuid", "p_comentario" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."cerrar_recepcion"("p_recepcion_id" "uuid", "p_comentario" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."cerrar_recepcion"("p_recepcion_id" "uuid", "p_comentario" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."cerrar_turno"("p_turnoid" "uuid", "p_total_contado" numeric, "p_monto_dejado" numeric, "p_monto_retirado" numeric, "p_es_cierre_final" boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."cerrar_turno"("p_turnoid" "uuid", "p_total_contado" numeric, "p_monto_dejado" numeric, "p_monto_retirado" numeric, "p_es_cierre_final" boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."cerrar_turno"("p_turnoid" "uuid", "p_total_contado" numeric, "p_monto_dejado" numeric, "p_monto_retirado" numeric, "p_es_cierre_final" boolean) TO "service_role";



GRANT ALL ON FUNCTION "public"."cerrarjornada"("p_jornadaid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."cerrarjornada"("p_jornadaid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."cerrarjornada"("p_jornadaid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."cerrarrecepcion"("p_recepcionid" "uuid", "p_comentario" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."cerrarrecepcion"("p_recepcionid" "uuid", "p_comentario" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."cerrarrecepcion"("p_recepcionid" "uuid", "p_comentario" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."cerrarturno"("p_turnoid" "uuid", "p_totalcontado" numeric, "p_montodejado" numeric, "p_montoretirado" numeric, "p_escierrefinal" boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."cerrarturno"("p_turnoid" "uuid", "p_totalcontado" numeric, "p_montodejado" numeric, "p_montoretirado" numeric, "p_escierrefinal" boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."cerrarturno"("p_turnoid" "uuid", "p_totalcontado" numeric, "p_montodejado" numeric, "p_montoretirado" numeric, "p_escierrefinal" boolean) TO "service_role";



GRANT ALL ON FUNCTION "public"."completar_tarea"("p_tareaid" "uuid", "p_comentario" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."completar_tarea"("p_tareaid" "uuid", "p_comentario" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."completar_tarea"("p_tareaid" "uuid", "p_comentario" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."completartarea"("p_tareaid" "uuid", "p_comentario" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."completartarea"("p_tareaid" "uuid", "p_comentario" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."completartarea"("p_tareaid" "uuid", "p_comentario" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."crear_pedido_venta"("p_pedido" "jsonb") TO "anon";
GRANT ALL ON FUNCTION "public"."crear_pedido_venta"("p_pedido" "jsonb") TO "authenticated";
GRANT ALL ON FUNCTION "public"."crear_pedido_venta"("p_pedido" "jsonb") TO "service_role";



GRANT ALL ON FUNCTION "public"."crear_tarea"("p_sucursalid" "uuid", "p_asignadaa" "uuid", "p_tipotareaid" "uuid", "p_descripcion" "text", "p_prioridad" "public"."tarea_prioridad", "p_jornadaid" "uuid", "p_referenciaid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."crear_tarea"("p_sucursalid" "uuid", "p_asignadaa" "uuid", "p_tipotareaid" "uuid", "p_descripcion" "text", "p_prioridad" "public"."tarea_prioridad", "p_jornadaid" "uuid", "p_referenciaid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."crear_tarea"("p_sucursalid" "uuid", "p_asignadaa" "uuid", "p_tipotareaid" "uuid", "p_descripcion" "text", "p_prioridad" "public"."tarea_prioridad", "p_jornadaid" "uuid", "p_referenciaid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."creartarea"("p_sucursalid" "uuid", "p_asignadaa" "uuid", "p_tipotareaid" "uuid", "p_descripcion" "text", "p_prioridad" "public"."tarea_prioridad", "p_jornadaid" "uuid", "p_referenciaid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."creartarea"("p_sucursalid" "uuid", "p_asignadaa" "uuid", "p_tipotareaid" "uuid", "p_descripcion" "text", "p_prioridad" "public"."tarea_prioridad", "p_jornadaid" "uuid", "p_referenciaid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."creartarea"("p_sucursalid" "uuid", "p_asignadaa" "uuid", "p_tipotareaid" "uuid", "p_descripcion" "text", "p_prioridad" "public"."tarea_prioridad", "p_jornadaid" "uuid", "p_referenciaid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."current_empresa_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."current_empresa_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."current_empresa_id"() TO "service_role";



GRANT ALL ON FUNCTION "public"."current_sucursal_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."current_sucursal_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."current_sucursal_id"() TO "service_role";



GRANT ALL ON FUNCTION "public"."current_user_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."current_user_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."current_user_id"() TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_actualizar_stock"() TO "anon";
GRANT ALL ON FUNCTION "public"."fn_actualizar_stock"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_actualizar_stock"() TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_confirmar_recepcion"() TO "anon";
GRANT ALL ON FUNCTION "public"."fn_confirmar_recepcion"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_confirmar_recepcion"() TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_confirmar_traslado"() TO "anon";
GRANT ALL ON FUNCTION "public"."fn_confirmar_traslado"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_confirmar_traslado"() TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_crear_notificacion"("p_empresaid" "uuid", "p_sucursalid" "uuid", "p_userid" "uuid", "p_evento" "text", "p_titulo" "text", "p_mensaje" "text", "p_referenciaid" "uuid", "p_referenciatipo" "text", "p_url" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."fn_crear_notificacion"("p_empresaid" "uuid", "p_sucursalid" "uuid", "p_userid" "uuid", "p_evento" "text", "p_titulo" "text", "p_mensaje" "text", "p_referenciaid" "uuid", "p_referenciatipo" "text", "p_url" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_crear_notificacion"("p_empresaid" "uuid", "p_sucursalid" "uuid", "p_userid" "uuid", "p_evento" "text", "p_titulo" "text", "p_mensaje" "text", "p_referenciaid" "uuid", "p_referenciatipo" "text", "p_url" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_generar_numtraslado"() TO "anon";
GRANT ALL ON FUNCTION "public"."fn_generar_numtraslado"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_generar_numtraslado"() TO "service_role";



GRANT ALL ON FUNCTION "public"."fn_stock_por_estado_traslado"() TO "anon";
GRANT ALL ON FUNCTION "public"."fn_stock_por_estado_traslado"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."fn_stock_por_estado_traslado"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_auth_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_auth_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_auth_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user_profile"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user_profile"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user_profile"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_new_user_profiles"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user_profiles"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user_profiles"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_updated_at"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_updated_at"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_updated_at"() TO "service_role";



GRANT ALL ON FUNCTION "public"."has_role"("p_rol" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."has_role"("p_rol" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."has_role"("p_rol" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."iniciar_recepcion"("p_idordencompra" "uuid", "p_url_foto_factura" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."iniciar_recepcion"("p_idordencompra" "uuid", "p_url_foto_factura" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."iniciar_recepcion"("p_idordencompra" "uuid", "p_url_foto_factura" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."iniciar_tarea"("p_tareaid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."iniciar_tarea"("p_tareaid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."iniciar_tarea"("p_tareaid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."iniciarrecepcion"("p_idordencompra" "uuid", "p_urlfotofactura" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."iniciarrecepcion"("p_idordencompra" "uuid", "p_urlfotofactura" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."iniciarrecepcion"("p_idordencompra" "uuid", "p_urlfotofactura" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."iniciartarea"("p_tareaid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."iniciartarea"("p_tareaid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."iniciartarea"("p_tareaid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."marcarnotificacionleida"("p_notificacionid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."marcarnotificacionleida"("p_notificacionid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."marcarnotificacionleida"("p_notificacionid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."marcartodasleidas"() TO "anon";
GRANT ALL ON FUNCTION "public"."marcartodasleidas"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."marcartodasleidas"() TO "service_role";



GRANT ALL ON FUNCTION "public"."pausar_turno"("p_turnoid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."pausar_turno"("p_turnoid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."pausar_turno"("p_turnoid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."pausarturno"("p_turnoid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."pausarturno"("p_turnoid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."pausarturno"("p_turnoid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."rechazar_tarea"("p_tareaid" "uuid", "p_motivo" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."rechazar_tarea"("p_tareaid" "uuid", "p_motivo" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rechazar_tarea"("p_tareaid" "uuid", "p_motivo" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."rechazartarea"("p_tareaid" "uuid", "p_motivo" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."rechazartarea"("p_tareaid" "uuid", "p_motivo" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."rechazartarea"("p_tareaid" "uuid", "p_motivo" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."registrar_conteo"("p_recepcion_id" "uuid", "p_idoclinea" "uuid", "p_cantidad_recibida" numeric, "p_precio_factura" numeric, "p_estado_fisico" "public"."estado_fisico", "p_lote" "text", "p_fecha_vencimiento" "date", "p_observaciones" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."registrar_conteo"("p_recepcion_id" "uuid", "p_idoclinea" "uuid", "p_cantidad_recibida" numeric, "p_precio_factura" numeric, "p_estado_fisico" "public"."estado_fisico", "p_lote" "text", "p_fecha_vencimiento" "date", "p_observaciones" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."registrar_conteo"("p_recepcion_id" "uuid", "p_idoclinea" "uuid", "p_cantidad_recibida" numeric, "p_precio_factura" numeric, "p_estado_fisico" "public"."estado_fisico", "p_lote" "text", "p_fecha_vencimiento" "date", "p_observaciones" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."registrarconteo"("p_recepcionid" "uuid", "p_idoclinea" "uuid", "p_cantidadrecibida" numeric, "p_preciofactura" numeric, "p_estadofisico" "public"."estado_fisico", "p_lote" "text", "p_fechavencimiento" "date", "p_observaciones" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."registrarconteo"("p_recepcionid" "uuid", "p_idoclinea" "uuid", "p_cantidadrecibida" numeric, "p_preciofactura" numeric, "p_estadofisico" "public"."estado_fisico", "p_lote" "text", "p_fechavencimiento" "date", "p_observaciones" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."registrarconteo"("p_recepcionid" "uuid", "p_idoclinea" "uuid", "p_cantidadrecibida" numeric, "p_preciofactura" numeric, "p_estadofisico" "public"."estado_fisico", "p_lote" "text", "p_fechavencimiento" "date", "p_observaciones" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."reportar_novedad"("p_productoid" "uuid", "p_tipo" "public"."novedad_tipo", "p_cantidad" numeric, "p_comentario" "text", "p_url_foto" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."reportar_novedad"("p_productoid" "uuid", "p_tipo" "public"."novedad_tipo", "p_cantidad" numeric, "p_comentario" "text", "p_url_foto" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."reportar_novedad"("p_productoid" "uuid", "p_tipo" "public"."novedad_tipo", "p_cantidad" numeric, "p_comentario" "text", "p_url_foto" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."reportarnovedad"("p_productoid" "uuid", "p_tipo" "text", "p_cantidad" numeric, "p_comentario" "text", "p_urlfoto" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."reportarnovedad"("p_productoid" "uuid", "p_tipo" "text", "p_cantidad" numeric, "p_comentario" "text", "p_urlfoto" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."reportarnovedad"("p_productoid" "uuid", "p_tipo" "text", "p_cantidad" numeric, "p_comentario" "text", "p_urlfoto" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "anon";
GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."rls_auto_enable"() TO "service_role";



GRANT ALL ON FUNCTION "public"."sugerir_monto_apertura"("p_cajaid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."sugerir_monto_apertura"("p_cajaid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."sugerir_monto_apertura"("p_cajaid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."sugerirmontoapertura"("p_cajaid" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."sugerirmontoapertura"("p_cajaid" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."sugerirmontoapertura"("p_cajaid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."suspender_tarea"("p_tareaid" "uuid", "p_comentario" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."suspender_tarea"("p_tareaid" "uuid", "p_comentario" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."suspender_tarea"("p_tareaid" "uuid", "p_comentario" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."suspendertarea"("p_tareaid" "uuid", "p_comentario" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."suspendertarea"("p_tareaid" "uuid", "p_comentario" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."suspendertarea"("p_tareaid" "uuid", "p_comentario" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."trg_fn_arqueo_on_change"() TO "anon";
GRANT ALL ON FUNCTION "public"."trg_fn_arqueo_on_change"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trg_fn_arqueo_on_change"() TO "service_role";



GRANT ALL ON FUNCTION "public"."trg_fn_movimiento_afecta_arqueo"() TO "anon";
GRANT ALL ON FUNCTION "public"."trg_fn_movimiento_afecta_arqueo"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."trg_fn_movimiento_afecta_arqueo"() TO "service_role";



GRANT ALL ON TABLE "public"."arqueos_caja" TO "anon";
GRANT ALL ON TABLE "public"."arqueos_caja" TO "authenticated";
GRANT ALL ON TABLE "public"."arqueos_caja" TO "service_role";



GRANT ALL ON TABLE "public"."arqueos_efectivo_detalle" TO "anon";
GRANT ALL ON TABLE "public"."arqueos_efectivo_detalle" TO "authenticated";
GRANT ALL ON TABLE "public"."arqueos_efectivo_detalle" TO "service_role";



GRANT ALL ON TABLE "public"."arqueos_otros_medios" TO "anon";
GRANT ALL ON TABLE "public"."arqueos_otros_medios" TO "authenticated";
GRANT ALL ON TABLE "public"."arqueos_otros_medios" TO "service_role";



GRANT ALL ON TABLE "public"."audit_log" TO "anon";
GRANT ALL ON TABLE "public"."audit_log" TO "authenticated";
GRANT ALL ON TABLE "public"."audit_log" TO "service_role";



GRANT ALL ON TABLE "public"."bodegas" TO "anon";
GRANT ALL ON TABLE "public"."bodegas" TO "authenticated";
GRANT ALL ON TABLE "public"."bodegas" TO "service_role";



GRANT ALL ON TABLE "public"."cajas" TO "anon";
GRANT ALL ON TABLE "public"."cajas" TO "authenticated";
GRANT ALL ON TABLE "public"."cajas" TO "service_role";



GRANT ALL ON TABLE "public"."categorias_producto" TO "anon";
GRANT ALL ON TABLE "public"."categorias_producto" TO "authenticated";
GRANT ALL ON TABLE "public"."categorias_producto" TO "service_role";



GRANT ALL ON TABLE "public"."categoriasproducto" TO "anon";
GRANT ALL ON TABLE "public"."categoriasproducto" TO "authenticated";
GRANT ALL ON TABLE "public"."categoriasproducto" TO "service_role";



GRANT ALL ON TABLE "public"."clientes" TO "anon";
GRANT ALL ON TABLE "public"."clientes" TO "authenticated";
GRANT ALL ON TABLE "public"."clientes" TO "service_role";



GRANT ALL ON TABLE "public"."compras_detalle" TO "anon";
GRANT ALL ON TABLE "public"."compras_detalle" TO "authenticated";
GRANT ALL ON TABLE "public"."compras_detalle" TO "service_role";



GRANT ALL ON TABLE "public"."compras_encabezado" TO "anon";
GRANT ALL ON TABLE "public"."compras_encabezado" TO "authenticated";
GRANT ALL ON TABLE "public"."compras_encabezado" TO "service_role";



GRANT ALL ON TABLE "public"."config_app_empresas" TO "anon";
GRANT ALL ON TABLE "public"."config_app_empresas" TO "authenticated";
GRANT ALL ON TABLE "public"."config_app_empresas" TO "service_role";



GRANT ALL ON TABLE "public"."config_tipos_voucher" TO "anon";
GRANT ALL ON TABLE "public"."config_tipos_voucher" TO "authenticated";
GRANT ALL ON TABLE "public"."config_tipos_voucher" TO "service_role";



GRANT ALL ON TABLE "public"."cubiculosfila" TO "anon";
GRANT ALL ON TABLE "public"."cubiculosfila" TO "authenticated";
GRANT ALL ON TABLE "public"."cubiculosfila" TO "service_role";



GRANT ALL ON TABLE "public"."empresas" TO "anon";
GRANT ALL ON TABLE "public"."empresas" TO "authenticated";
GRANT ALL ON TABLE "public"."empresas" TO "service_role";



GRANT ALL ON TABLE "public"."estanterias" TO "anon";
GRANT ALL ON TABLE "public"."estanterias" TO "authenticated";
GRANT ALL ON TABLE "public"."estanterias" TO "service_role";



GRANT ALL ON TABLE "public"."facturasVenta" TO "anon";
GRANT ALL ON TABLE "public"."facturasVenta" TO "authenticated";
GRANT ALL ON TABLE "public"."facturasVenta" TO "service_role";



GRANT ALL ON TABLE "public"."facturasVentaLineas" TO "anon";
GRANT ALL ON TABLE "public"."facturasVentaLineas" TO "authenticated";
GRANT ALL ON TABLE "public"."facturasVentaLineas" TO "service_role";



GRANT ALL ON TABLE "public"."facturascompra" TO "anon";
GRANT ALL ON TABLE "public"."facturascompra" TO "authenticated";
GRANT ALL ON TABLE "public"."facturascompra" TO "service_role";



GRANT ALL ON TABLE "public"."facturascompradetalle" TO "anon";
GRANT ALL ON TABLE "public"."facturascompradetalle" TO "authenticated";
GRANT ALL ON TABLE "public"."facturascompradetalle" TO "service_role";



GRANT ALL ON TABLE "public"."filasestanteria" TO "anon";
GRANT ALL ON TABLE "public"."filasestanteria" TO "authenticated";
GRANT ALL ON TABLE "public"."filasestanteria" TO "service_role";



GRANT ALL ON TABLE "public"."import_errors" TO "anon";
GRANT ALL ON TABLE "public"."import_errors" TO "authenticated";
GRANT ALL ON TABLE "public"."import_errors" TO "service_role";



GRANT ALL ON TABLE "public"."import_log" TO "anon";
GRANT ALL ON TABLE "public"."import_log" TO "authenticated";
GRANT ALL ON TABLE "public"."import_log" TO "service_role";



GRANT ALL ON TABLE "public"."jornadas" TO "anon";
GRANT ALL ON TABLE "public"."jornadas" TO "authenticated";
GRANT ALL ON TABLE "public"."jornadas" TO "service_role";



GRANT ALL ON TABLE "public"."listasprecios" TO "anon";
GRANT ALL ON TABLE "public"."listasprecios" TO "authenticated";
GRANT ALL ON TABLE "public"."listasprecios" TO "service_role";



GRANT ALL ON TABLE "public"."listaspreciosdetalle" TO "anon";
GRANT ALL ON TABLE "public"."listaspreciosdetalle" TO "authenticated";
GRANT ALL ON TABLE "public"."listaspreciosdetalle" TO "service_role";



GRANT ALL ON TABLE "public"."marcas" TO "anon";
GRANT ALL ON TABLE "public"."marcas" TO "authenticated";
GRANT ALL ON TABLE "public"."marcas" TO "service_role";



GRANT ALL ON TABLE "public"."misiones_conteo" TO "anon";
GRANT ALL ON TABLE "public"."misiones_conteo" TO "authenticated";
GRANT ALL ON TABLE "public"."misiones_conteo" TO "service_role";



GRANT ALL ON TABLE "public"."misiones_conteo_detalle" TO "anon";
GRANT ALL ON TABLE "public"."misiones_conteo_detalle" TO "authenticated";
GRANT ALL ON TABLE "public"."misiones_conteo_detalle" TO "service_role";



GRANT ALL ON TABLE "public"."movimientos_caja" TO "anon";
GRANT ALL ON TABLE "public"."movimientos_caja" TO "authenticated";
GRANT ALL ON TABLE "public"."movimientos_caja" TO "service_role";



GRANT ALL ON TABLE "public"."movimientosinventario" TO "anon";
GRANT ALL ON TABLE "public"."movimientosinventario" TO "authenticated";
GRANT ALL ON TABLE "public"."movimientosinventario" TO "service_role";



GRANT ALL ON TABLE "public"."notificaciones_usuario" TO "anon";
GRANT ALL ON TABLE "public"."notificaciones_usuario" TO "authenticated";
GRANT ALL ON TABLE "public"."notificaciones_usuario" TO "service_role";



GRANT ALL ON TABLE "public"."novedades_inventario" TO "anon";
GRANT ALL ON TABLE "public"."novedades_inventario" TO "authenticated";
GRANT ALL ON TABLE "public"."novedades_inventario" TO "service_role";



GRANT ALL ON TABLE "public"."oc_recepcion_anomalias" TO "anon";
GRANT ALL ON TABLE "public"."oc_recepcion_anomalias" TO "authenticated";
GRANT ALL ON TABLE "public"."oc_recepcion_anomalias" TO "service_role";



GRANT ALL ON TABLE "public"."oc_recepcion_conteo" TO "anon";
GRANT ALL ON TABLE "public"."oc_recepcion_conteo" TO "authenticated";
GRANT ALL ON TABLE "public"."oc_recepcion_conteo" TO "service_role";



GRANT ALL ON TABLE "public"."oc_recepcion_fotos" TO "anon";
GRANT ALL ON TABLE "public"."oc_recepcion_fotos" TO "authenticated";
GRANT ALL ON TABLE "public"."oc_recepcion_fotos" TO "service_role";



GRANT ALL ON TABLE "public"."oc_recepciones" TO "anon";
GRANT ALL ON TABLE "public"."oc_recepciones" TO "authenticated";
GRANT ALL ON TABLE "public"."oc_recepciones" TO "service_role";



GRANT ALL ON TABLE "public"."ordenesVenta" TO "anon";
GRANT ALL ON TABLE "public"."ordenesVenta" TO "authenticated";
GRANT ALL ON TABLE "public"."ordenesVenta" TO "service_role";



GRANT ALL ON TABLE "public"."ordenes_compra_detalle" TO "anon";
GRANT ALL ON TABLE "public"."ordenes_compra_detalle" TO "authenticated";
GRANT ALL ON TABLE "public"."ordenes_compra_detalle" TO "service_role";



GRANT ALL ON TABLE "public"."ordenes_compra_encabezado" TO "anon";
GRANT ALL ON TABLE "public"."ordenes_compra_encabezado" TO "authenticated";
GRANT ALL ON TABLE "public"."ordenes_compra_encabezado" TO "service_role";



GRANT ALL ON TABLE "public"."ordenescompra" TO "anon";
GRANT ALL ON TABLE "public"."ordenescompra" TO "authenticated";
GRANT ALL ON TABLE "public"."ordenescompra" TO "service_role";



GRANT ALL ON TABLE "public"."ordenescompradetalle" TO "anon";
GRANT ALL ON TABLE "public"."ordenescompradetalle" TO "authenticated";
GRANT ALL ON TABLE "public"."ordenescompradetalle" TO "service_role";



GRANT ALL ON TABLE "public"."pagos_compras" TO "anon";
GRANT ALL ON TABLE "public"."pagos_compras" TO "authenticated";
GRANT ALL ON TABLE "public"."pagos_compras" TO "service_role";



GRANT ALL ON TABLE "public"."pedidosVenta" TO "anon";
GRANT ALL ON TABLE "public"."pedidosVenta" TO "authenticated";
GRANT ALL ON TABLE "public"."pedidosVenta" TO "service_role";



GRANT ALL ON TABLE "public"."pedidosVentaLineas" TO "anon";
GRANT ALL ON TABLE "public"."pedidosVentaLineas" TO "authenticated";
GRANT ALL ON TABLE "public"."pedidosVentaLineas" TO "service_role";



GRANT ALL ON TABLE "public"."producto_codigos_externos" TO "anon";
GRANT ALL ON TABLE "public"."producto_codigos_externos" TO "authenticated";
GRANT ALL ON TABLE "public"."producto_codigos_externos" TO "service_role";



GRANT ALL ON TABLE "public"."productos" TO "anon";
GRANT ALL ON TABLE "public"."productos" TO "authenticated";
GRANT ALL ON TABLE "public"."productos" TO "service_role";



GRANT ALL ON TABLE "public"."productos_erp" TO "anon";
GRANT ALL ON TABLE "public"."productos_erp" TO "authenticated";
GRANT ALL ON TABLE "public"."productos_erp" TO "service_role";



GRANT ALL ON TABLE "public"."productounidades" TO "anon";
GRANT ALL ON TABLE "public"."productounidades" TO "authenticated";
GRANT ALL ON TABLE "public"."productounidades" TO "service_role";



GRANT ALL ON TABLE "public"."proveedores" TO "anon";
GRANT ALL ON TABLE "public"."proveedores" TO "authenticated";
GRANT ALL ON TABLE "public"."proveedores" TO "service_role";



GRANT ALL ON TABLE "public"."proveedores_contactos" TO "anon";
GRANT ALL ON TABLE "public"."proveedores_contactos" TO "authenticated";
GRANT ALL ON TABLE "public"."proveedores_contactos" TO "service_role";



GRANT ALL ON TABLE "public"."proveedores_documentos" TO "anon";
GRANT ALL ON TABLE "public"."proveedores_documentos" TO "authenticated";
GRANT ALL ON TABLE "public"."proveedores_documentos" TO "service_role";



GRANT ALL ON TABLE "public"."proveedores_evaluaciones" TO "anon";
GRANT ALL ON TABLE "public"."proveedores_evaluaciones" TO "authenticated";
GRANT ALL ON TABLE "public"."proveedores_evaluaciones" TO "service_role";



GRANT ALL ON TABLE "public"."recepcionescompra" TO "anon";
GRANT ALL ON TABLE "public"."recepcionescompra" TO "authenticated";
GRANT ALL ON TABLE "public"."recepcionescompra" TO "service_role";



GRANT ALL ON TABLE "public"."recepcionescompradetalle" TO "anon";
GRANT ALL ON TABLE "public"."recepcionescompradetalle" TO "authenticated";
GRANT ALL ON TABLE "public"."recepcionescompradetalle" TO "service_role";



GRANT ALL ON TABLE "public"."role_permissions" TO "anon";
GRANT ALL ON TABLE "public"."role_permissions" TO "authenticated";
GRANT ALL ON TABLE "public"."role_permissions" TO "service_role";



GRANT ALL ON TABLE "public"."roles" TO "anon";
GRANT ALL ON TABLE "public"."roles" TO "authenticated";
GRANT ALL ON TABLE "public"."roles" TO "service_role";



GRANT ALL ON TABLE "public"."stockubicacion" TO "anon";
GRANT ALL ON TABLE "public"."stockubicacion" TO "authenticated";
GRANT ALL ON TABLE "public"."stockubicacion" TO "service_role";



GRANT ALL ON TABLE "public"."sucursales" TO "anon";
GRANT ALL ON TABLE "public"."sucursales" TO "authenticated";
GRANT ALL ON TABLE "public"."sucursales" TO "service_role";



GRANT ALL ON TABLE "public"."sugerencias_pedido" TO "anon";
GRANT ALL ON TABLE "public"."sugerencias_pedido" TO "authenticated";
GRANT ALL ON TABLE "public"."sugerencias_pedido" TO "service_role";



GRANT ALL ON TABLE "public"."tareas" TO "anon";
GRANT ALL ON TABLE "public"."tareas" TO "authenticated";
GRANT ALL ON TABLE "public"."tareas" TO "service_role";



GRANT ALL ON TABLE "public"."tareas_detalle_traslado" TO "anon";
GRANT ALL ON TABLE "public"."tareas_detalle_traslado" TO "authenticated";
GRANT ALL ON TABLE "public"."tareas_detalle_traslado" TO "service_role";



GRANT ALL ON TABLE "public"."tareas_turno" TO "anon";
GRANT ALL ON TABLE "public"."tareas_turno" TO "authenticated";
GRANT ALL ON TABLE "public"."tareas_turno" TO "service_role";



GRANT ALL ON TABLE "public"."tipos_tarea" TO "anon";
GRANT ALL ON TABLE "public"."tipos_tarea" TO "authenticated";
GRANT ALL ON TABLE "public"."tipos_tarea" TO "service_role";



GRANT ALL ON TABLE "public"."tipos_tarea_turno" TO "anon";
GRANT ALL ON TABLE "public"."tipos_tarea_turno" TO "authenticated";
GRANT ALL ON TABLE "public"."tipos_tarea_turno" TO "service_role";



GRANT ALL ON TABLE "public"."traslados_detalle" TO "anon";
GRANT ALL ON TABLE "public"."traslados_detalle" TO "authenticated";
GRANT ALL ON TABLE "public"."traslados_detalle" TO "service_role";



GRANT ALL ON TABLE "public"."traslados_encabezado" TO "anon";
GRANT ALL ON TABLE "public"."traslados_encabezado" TO "authenticated";
GRANT ALL ON TABLE "public"."traslados_encabezado" TO "service_role";



GRANT ALL ON TABLE "public"."turnos" TO "anon";
GRANT ALL ON TABLE "public"."turnos" TO "authenticated";
GRANT ALL ON TABLE "public"."turnos" TO "service_role";



GRANT ALL ON TABLE "public"."turnos_caja" TO "anon";
GRANT ALL ON TABLE "public"."turnos_caja" TO "authenticated";
GRANT ALL ON TABLE "public"."turnos_caja" TO "service_role";



GRANT ALL ON TABLE "public"."zonasbodega" TO "anon";
GRANT ALL ON TABLE "public"."zonasbodega" TO "authenticated";
GRANT ALL ON TABLE "public"."zonasbodega" TO "service_role";



GRANT ALL ON TABLE "public"."vw_ubicaciones_bodega" TO "anon";
GRANT ALL ON TABLE "public"."vw_ubicaciones_bodega" TO "authenticated";
GRANT ALL ON TABLE "public"."vw_ubicaciones_bodega" TO "service_role";



GRANT ALL ON TABLE "public"."unidadesmedida" TO "anon";
GRANT ALL ON TABLE "public"."unidadesmedida" TO "authenticated";
GRANT ALL ON TABLE "public"."unidadesmedida" TO "service_role";



GRANT ALL ON TABLE "public"."user_profiles" TO "anon";
GRANT ALL ON TABLE "public"."user_profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."user_profiles" TO "service_role";



GRANT ALL ON TABLE "public"."user_roles" TO "anon";
GRANT ALL ON TABLE "public"."user_roles" TO "authenticated";
GRANT ALL ON TABLE "public"."user_roles" TO "service_role";



GRANT ALL ON TABLE "public"."user_sucursales" TO "anon";
GRANT ALL ON TABLE "public"."user_sucursales" TO "authenticated";
GRANT ALL ON TABLE "public"."user_sucursales" TO "service_role";



GRANT ALL ON TABLE "public"."vstockbodega" TO "anon";
GRANT ALL ON TABLE "public"."vstockbodega" TO "authenticated";
GRANT ALL ON TABLE "public"."vstockbodega" TO "service_role";



GRANT ALL ON TABLE "public"."vstocksucursal" TO "anon";
GRANT ALL ON TABLE "public"."vstocksucursal" TO "authenticated";
GRANT ALL ON TABLE "public"."vstocksucursal" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";







