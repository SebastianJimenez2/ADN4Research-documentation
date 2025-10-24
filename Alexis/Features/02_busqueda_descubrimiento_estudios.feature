# language: es
@modulo:busqueda
Característica: Descubrimiento de estudios
  Como investigador
  Quiero obtener un listado consolidado de estudios a partir de mi estrategia normalizada
  Para revisar rápidamente títulos y enlaces antes de profundizar

  Antecedentes:
    Dado que el sistema soporta las fuentes "Scopus" e "IEEE Xplore"
    Y existe una estrategia normalizada identificada como "<id_estrategia>"
    Y existen traducciones por fuente asociadas a esa estrategia con estado en {"lista","no compatible"}
    Y el sistema solo ejecuta descubrimiento en las fuentes cuyo estado es "lista"

  @descubrimiento @mvp
  Esquema del escenario: Descubrimiento consolida resultados y resume el estado por fuente
    Dada una estrategia previamente normalizada con identificador "<id>"
    Y consultas preparadas por fuente:
      | fuente       | estado          |
      | Scopus       | <estado_scopus> |
      | IEEE Xplore  | <estado_ieee>   |
    Cuando el sistema ejecuta el descubrimiento en las fuentes con estado "lista"
    Entonces la respuesta incluye un listado de estudios (puede ser vacío)
    Y el resumen incluye:
      """
      id_estrategia = "<id>",
      fuentes_consultadas = <consultadas>,
      fuentes_no_consideradas = <no_consideradas>,
      total_por_fuente.Scopus >= 0,
      total_por_fuente.IEEE Xplore >= 0,
      total_bruto >= 0,
      total_unicos >= 0,
      resultado = "<resultado>"
      """

    Ejemplos:
      | id        | estado_scopus | estado_ieee   | consultadas                      | no_consideradas                                   | resultado  |
      | norm-001  | lista         | lista         | ["Scopus","IEEE Xplore"]         | []                                                | completo   |
      | norm-002  | lista         | no compatible | ["Scopus"]                       | [{"fuente":"IEEE Xplore","motivo":"no compatible"}] | parcial    |
      | norm-003  | lista         | lista         | ["Scopus","IEEE Xplore"]         | []                                                | completo   |

 
