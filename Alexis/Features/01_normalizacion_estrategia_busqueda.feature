# language: es
@modulo:busqueda @componente:normalizacion
Característica: Normalización de la estrategia de búsqueda
  Como investigador
  Quiero que mi estrategia de búsqueda sea interpretada y normalizada
  Para poder ejecutarla de forma consistente en distintas fuentes

        Escenario: Estrategia válida genera versión normalizada y consultas ejecutables
            Dada una estrategia con el texto "deep learning AND software engineering year:2022-2024"
             Cuando el sistema normaliza la estrategia
             Entonces se genera una versión normalizada con identificador único
              Y se traduce la estrategia para "Scopus" con estado "lista"
              Y se traduce la estrategia para "IEEE Xplore" con estado "lista"

        Escenario: Textos equivalentes producen la misma normalización
            Dadas dos estrategias equivalentes
                  | id | texto                                                         |
                  | A  | ( Deep   Learning ) AND software   engineering YEAR:2022-2024 |
                  | B  | deep learning AND software engineering year:2022-2024         |
             Cuando el sistema normaliza ambas estrategias
             Entonces ambas reciben el mismo identificador de normalización
              Y producen las mismas consultas por fuente

        Escenario: Operador no soportado se degrada o se marca como incompatible
            Dada una estrategia con el texto "\"bug prediction\" NEAR/5 (deep OR machine) year:2021"
             Cuando el sistema normaliza la estrategia
             Entonces se genera una versión normalizada con identificador único
              Y la traducción para "Scopus" queda "lista con ajustes" con la advertencia "NEAR/5 ajustado a AND"
              Y la traducción para "IEEE Xplore" queda "no compatible" con el motivo "no soporta operador de proximidad"

        Escenario: Estrategia inválida es rechazada con errores ubicados
            Dada una estrategia con el texto "deep AND (software OR) year:2020-2019"
             Cuando el sistema intenta normalizar la estrategia
             Entonces la estrategia es rechazada
              Y se reportan errores de sintaxis y filtros con ubicación aproximada
              Y no se genera versión normalizada ni traducciones

        Esquema del escenario: Compatibilidad de características por fuente
            Dada una estrategia con el texto "<entrada>"
             Cuando el sistema normaliza la estrategia
             Entonces se genera una versión normalizada con identificador único
              Y la traducción para "Scopus" queda "<estado_scopus>"
              Y la traducción para "IEEE Xplore" queda "<estado_ieee>"

        Ejemplos:
                  | entrada                                             | estado_scopus     | estado_ieee       |
                  | "bug prediction" NEAR/5 (deep OR machine) year:2021 | lista con ajustes | no compatible     |
                  | title:"program comprehension" year:>=2023           | lista con ajustes | lista             |
                  | ("microservices" AND resilience) year:2020 lang:EN  | lista             | lista con ajustes |
                  | "advanced WITHIN/3 testing" year:2020               | no compatible     | no compatible     |