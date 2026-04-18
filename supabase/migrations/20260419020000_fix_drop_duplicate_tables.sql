-- Elimina tablas duplicadas / legado solo si están vacías (sin filas).
-- Sustituidas por el modelo canónico (ver comentario por bloque).
-- Orden: hijos primero (FKs internas del legado).
-- NOTA: DROP TABLE solo si COUNT(*) = 0 en esa tabla; CASCADE según especificación.

-- recepcionescompradetalle (vacía) -> canónico: public.oc_recepcion_conteo
DO $$
DECLARE
  _cnt bigint := 0;
BEGIN
  IF to_regclass('public.recepcionescompradetalle') IS NOT NULL THEN
    EXECUTE 'SELECT COUNT(*) FROM public.recepcionescompradetalle' INTO _cnt;
    IF _cnt = 0 THEN
      DROP TABLE IF EXISTS public.recepcionescompradetalle CASCADE;
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

-- recepcionescompra (vacía) -> canónico: public.oc_recepciones
DO $$
DECLARE
  _cnt bigint := 0;
BEGIN
  IF to_regclass('public.recepcionescompra') IS NOT NULL THEN
    EXECUTE 'SELECT COUNT(*) FROM public.recepcionescompra' INTO _cnt;
    IF _cnt = 0 THEN
      DROP TABLE IF EXISTS public.recepcionescompra CASCADE;
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

-- ordenescompradetalle (vacía) -> canónico: public.ordenes_compra_detalle
DO $$
DECLARE
  _cnt bigint := 0;
BEGIN
  IF to_regclass('public.ordenescompradetalle') IS NOT NULL THEN
    EXECUTE 'SELECT COUNT(*) FROM public.ordenescompradetalle' INTO _cnt;
    IF _cnt = 0 THEN
      DROP TABLE IF EXISTS public.ordenescompradetalle CASCADE;
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

-- ordenescompra (vacía) -> canónico: public.ordenes_compra_encabezado
DO $$
DECLARE
  _cnt bigint := 0;
BEGIN
  IF to_regclass('public.ordenescompra') IS NOT NULL THEN
    EXECUTE 'SELECT COUNT(*) FROM public.ordenescompra' INTO _cnt;
    IF _cnt = 0 THEN
      DROP TABLE IF EXISTS public.ordenescompra CASCADE;
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

-- categoriasproducto (vacía) -> canónico: public.categorias_producto
DO $$
DECLARE
  _cnt bigint := 0;
BEGIN
  IF to_regclass('public.categoriasproducto') IS NOT NULL THEN
    EXECUTE 'SELECT COUNT(*) FROM public.categoriasproducto' INTO _cnt;
    IF _cnt = 0 THEN
      DROP TABLE IF EXISTS public.categoriasproducto CASCADE;
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

-- productos_erp (vacía) -> canónico: public.productos
DO $$
DECLARE
  _cnt bigint := 0;
BEGIN
  IF to_regclass('public.productos_erp') IS NOT NULL THEN
    EXECUTE 'SELECT COUNT(*) FROM public.productos_erp' INTO _cnt;
    IF _cnt = 0 THEN
      DROP TABLE IF EXISTS public.productos_erp CASCADE;
    END IF;
  END IF;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;
