# language: es
@modulo:busqueda @componente:metadatos @mvp
Característica: Enriquecimiento y consolidación de metadatos desde el listado de descubrimiento
  Como investigador
  Quiero enriquecer mi listado de estudios con metadatos canónicos
  Para continuar la revisión con registros completos y trazables

  Antecedentes:
    Dado que existe un resultado de descubrimiento "disc-001" con el siguiente listado mínimo:
      | id_estudio | título_minimo                  | enlace                      | fuente_origen_listado |
      | st-101     | Deep Learning for Software     | https://example.org/101     | Scopus                |
      | st-102     | Bug Prediction with ML         | https://example.org/102     | IEEE Xplore           |
      | st-125     | Title only                     | https://example.org/125     | Scopus                |
    Y la tabla de precedencia de fuentes está definida:
      | fuente      | precedencia |
      | Scopus      | 2           |
      | IEEE Xplore | 1           |

  @lote @mvp
  Escenario: Enriquecimiento en lote del listado de descubrimiento
    Cuando el sistema solicita y recolecta metadatos para todos los estudios de "disc-001"
    Entonces se genera, por cada estudio, un registro canónico con trazabilidad por campo
    Y cada estudio queda con estado "consolidado" o "no_consolidado" según reglas de esenciales (título, autores, año_publicación)
    Y el resumen del proceso incluye:
      | métrica                |
      | total_solicitados      |
      | total_consolidados     |
      | total_no_consolidados  |
      | totales_por_fuente     |
    Y el listado contiene estudios únicos según la clave de deduplicación
