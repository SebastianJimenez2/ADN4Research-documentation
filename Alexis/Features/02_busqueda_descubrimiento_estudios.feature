# language: es
@modulo:busqueda @componente:descubrimiento
Característica: Descubrimiento de estudios
  Como investigador
  Quiero obtener un listado inicial de estudios a partir de mi estrategia
  Para revisar rápidamente títulos y enlaces antes de profundizar

        Escenario: Descubrimiento exitoso en todas las fuentes disponibles
            Dada una estrategia previamente normalizada con identificador "norm-001"
              Y consultas preparadas para "Scopus" con estado "lista"
              Y consultas preparadas para "IEEE Xplore" con estado "lista"
             Cuando el sistema ejecuta el descubrimiento
             Entonces la respuesta contiene un listado de estudios sin duplicados
              Y cada estudio incluye al menos "título" y "enlace"
              Y el resumen expone el total de hallazgos

        Escenario: Descubrimiento parcial por fuente no compatible
            Dada una estrategia previamente normalizada con identificador "norm-002"
              Y consultas preparadas para "Scopus" con estado "lista"
              Y consultas preparadas para "IEEE Xplore" con estado "no compatible"
             Cuando el sistema ejecuta el descubrimiento
             Entonces la respuesta contiene un listado de estudios sin duplicados
              Y el resumen indica que el resultado es parcial
              Y el resumen lista "IEEE Xplore" como fuente no considerada

        Escenario: Descubrimiento sin resultados
            Dada una estrategia previamente normalizada con identificador "norm-003"
              Y consultas preparadas para "Scopus" con estado "lista"
              Y consultas preparadas para "IEEE Xplore" con estado "lista"
             Cuando el sistema ejecuta el descubrimiento
             Entonces la respuesta contiene un listado vacío
              Y el resumen indica cero hallazgos

        Escenario: Búsqueda repetida produce resultados idénticos
            Dada una estrategia previamente normalizada con identificador "norm-004"
              Y consultas preparadas para "Scopus" con estado "lista"
              Y consultas preparadas para "IEEE Xplore" con estado "lista"
             Cuando el sistema ejecuta el descubrimiento
              Y el sistema ejecuta nuevamente el descubrimiento con la misma estrategia
             Entonces ambas respuestas contienen listados idénticos

        Escenario: Consolidación elimina duplicados entre fuentes
            Dada una estrategia previamente normalizada con identificador "norm-005"
              Y consultas preparadas para "Scopus" con estado "lista"
              Y consultas preparadas para "IEEE Xplore" con estado "lista"
              Y ambas fuentes retornan estudios con identificadores coincidentes
             Cuando el sistema ejecuta el descubrimiento
             Entonces ningún estudio aparece más de una vez en la respuesta
              Y el resumen distingue entre total de hallazgos y total de únicos