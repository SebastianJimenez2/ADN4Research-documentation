# language: en
@modulo:descarga @componente:paper-state-manager
Feature: Gestión del ciclo de vida de artículos
  Como revisor
  Quiero que mis decisiones de aprobación o rechazo actualicen los estados de los artículos
  Para que la plataforma coordine automáticamente las descargas y las siguientes fases del SLR

    Rule: Los artículos siguen transiciones de estado válidas y deterministas

        Background:
            Given la plataforma de descarga está operativa
              And el repositorio de metadatos está inicializado
              And la cola de descargas está disponible

        Scenario: Procesar lote de artículos aprobados
            Given existen los siguientes artículos con estado "recuperado":
                  | id        |
                  | paper-001 |
                  | paper-002 |
                  | paper-003 |
                  | paper-004 |
                  | paper-005 |
              And se recibe una lista de aprobación con los siguientes artículos:
                  | id        |
                  | paper-001 |
                  | paper-003 |
                  | paper-005 |
             When la plataforma procesa la lista de aprobación
             Then los artículos "paper-001","paper-003","paper-005" tienen estado "aprobado"
              And los artículos "paper-002","paper-004" mantienen estado "recuperado"
              And se emite el evento "DownloadQueued" para cada artículo aprobado
              And la respuesta incluye resumen con 3 aprobados y 0 errores

        Scenario: Procesar rechazo de un artículo
            Given existe un artículo con id "paper-reject-001" y estado "recuperado"
              And se recibe una decisión de rechazo para "paper-reject-001"
             When la plataforma procesa la decisión de rechazo
             Then el artículo "paper-reject-001" tiene estado "rechazado"
              And se emite el evento "PaperRejected" con el id del artículo
              And no se encola ninguna tarea de descarga

        Scenario: Procesar aprobación de ID inexistente con respuesta parcial
            Given no existe un artículo con id "FAKE-ID-999" en el repositorio
              And existen artículos válidos "paper-100" y "paper-101" con estado "recuperado"
             When se procesan aprobaciones para "FAKE-ID-999", "paper-100" y "paper-101"
             Then la respuesta es código 200 con detalle por elemento
              And el detalle indica error "paper_no_encontrado" para "FAKE-ID-999"
              And el detalle indica éxito para "paper-100" y "paper-101"
              And se emite el evento "PartialProcessingCompleted" con 2 éxitos y 1 error

        Scenario: Procesar aprobación duplicada (idempotencia)
            Given existe "paper-duplicate-001" con estado "aprobado"
             When se recibe nuevamente una aprobación para "paper-duplicate-001"
             Then el artículo mantiene estado "aprobado"
              And se emite el evento "DuplicateDecisionIgnored" con el id del artículo
              And no se encola nueva tarea de descarga

        Scenario: Transición a "descargando" al iniciar el worker
            Given existe "paper-dl-001" con estado "aprobado" y tarea de descarga en cola
             When un worker toma la tarea de "paper-dl-001"
             Then el artículo "paper-dl-001" tiene estado "descargando"
              And se emite el evento "DownloadStarted" con el id del artículo

        Scenario: Actualizar estado tras descarga exitosa
            Given existe "paper-download-001" con estado "descargando"
             When la descarga del PDF se completa exitosamente
             Then el artículo "paper-download-001" tiene estado "texto_completo_disponible"
              And se emite el evento "DownloadSucceeded" con ruta del archivo y checksum
              And se emite el evento "FulltextAvailable" para notificar al Módulo de Extracción

        Scenario: Actualizar estado tras fallo en la descarga
            Given existe "paper-fail-001" con estado "descargando"
             When la descarga del PDF falla con motivo "acceso_restringido"
             Then el artículo "paper-fail-001" tiene estado "descarga_fallida"
              And se emite el evento "DownloadFailed" con el motivo del fallo
              And el registro incluye el motivo "acceso_restringido" en sus metadatos

        Scenario: Consultar estado de múltiples artículos
            Given existen artículos en estados "recuperado","aprobado","texto_completo_disponible","rechazado"
             When se consulta el estado de un lote de artículos
             Then la respuesta incluye para cada artículo: id, estado actual, última actualización
              And la respuesta agrupa los conteos por estado

    Rule: PDFs solo se sirven si estado = "texto_completo_disponible"

        Scenario Outline: Proveer PDF según el estado del artículo
            Given existe un artículo con id "<id>" y estado "<estado>"
             When un cliente solicita el PDF de "<id>"
             Then la respuesta es código <codigo>
              And la respuesta incluye mensaje "<mensaje>"

        Examples:
                  | id         | estado                    | codigo | mensaje                         |
                  | paper-ok   | texto_completo_disponible | 200    | PDF disponible                  |
                  | paper-wip  | descargando               | 202    | Descarga en progreso, reintente |
                  | paper-rej  | rechazado                 | 403    | Artículo rechazado en selección |
                  | paper-miss | recuperado                | 404    | PDF no disponible               |
                  | paper-bad  | descarga_fallida          | 500    | Error en descarga previa        |

        Scenario Outline: Bloquear transiciones de estado inválidas
            Given existe un artículo con id "<id>" y estado "<estado_actual>"
             When se intenta cambiar su estado a "<estado_solicitado>"
             Then la respuesta es código 409 con error "transicion_invalida"
              And el artículo mantiene estado "<estado_actual>"
              And se emite el evento "InvalidTransitionAttempted"

        Examples:
                  | id       | estado_actual             | estado_solicitado         |
                  | paper-g1 | rechazado                 | aprobado                  |
                  | paper-g2 | texto_completo_disponible | aprobado                  |
                  | paper-g3 | recuperado                | texto_completo_disponible |