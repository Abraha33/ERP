-- Elimina tablas duplicadas / legado solo si están vacías (sin filas).
-- Sustituidas por el modelo canónico (ver comentario por bloque).
-- Orden: hijos primero (FKs internas del legado).
-- NOTA: DROP TABLE solo si COUNT(*) = 0 en esa tabla; CASCADE según especificación.

-- recepcionescompradetalle (vacía) -> canónico: public.oc_recepcion_conteo
DO $$
BEGIN
  IF to_regclass('public.recepcionescompradetalle') IS NOT NULL
     AND (SELECT COUNT(*) FROM public.recepcionescompradetalle) = 0 THEN
    DROP TABLE IF EXISTS public.recepcionescompradetalle CASCADE;
  END IF;
END $$;

-- recepcionescompra (vacía) -> canónico: public.oc_recepciones
DO $$
BEGIN
  IF to_regclass('public.recepcionescompra') IS NOT NULL
     AND (SELECT COUNT(*) FROM public.recepcionescompra) = 0 THEN
    DROP TABLE IF EXISTS public.recepcionescompra CASCADE;
  END IF;
END $$;

-- ordenescompradetalle (vacía) -> canónico: public.ordenes_compra_detalle
DO $$
BEGIN
  IF to_regclass('public.ordenescompradetalle') IS NOT NULL
     AND (SELECT COUNT(*) FROM public.ordenescompradetalle) = 0 THEN
    DROP TABLE IF EXISTS public.ordenescompradetalle CASCADE;
  END IF;
END $$;

-- ordenescompra (vacía) -> canónico: public.ordenes_compra_encabezado
DO $$
BEGIN
  IF to_regclass('public.ordenescompra') IS NOT NULL
     AND (SELECT COUNT(*) FROM public.ordenescompra) = 0 THEN
    DROP TABLE IF EXISTS public.ordenescompra CASCADE;
  END IF;
END $$;

-- categoriasproducto (vacía) -> canónico: public.categorias_producto
DO $$
BEGIN
  IF to_regclass('public.categoriasproducto') IS NOT NULL
     AND (SELECT COUNT(*) FROM public.categoriasproducto) = 0 THEN
    DROP TABLE IF EXISTS public.categoriasproducto CASCADE;
  END IF;
END $$;

-- productos_erp (vacía) -> canónico: public.productos
DO $$
BEGIN
  IF to_regclass('public.productos_erp') IS NOT NULL
     AND (SELECT COUNT(*) FROM public.productos_erp) = 0 THEN
    DROP TABLE IF EXISTS public.productos_erp CASCADE;
  END IF;
END $$;
