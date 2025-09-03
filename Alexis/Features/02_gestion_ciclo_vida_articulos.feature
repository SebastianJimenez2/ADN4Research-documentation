Feature: Gestión del Ciclo de Vida de Artículos

  Como el Módulo de Descarga
  Quiero recibir decisiones del Módulo de Selección para actualizar el estado de los artículos
  Para que el sistema SLR funcione de manera coordinada y se activen los siguientes pasos del proceso

  Background:
    Given el Paper State Manager está operativo
    And el Download Manager está disponible para encolar tareas
    And el Metadata Repository está inicializado

  Scenario: Lote de artículos aprobados para descarga de texto completo
    Given existen 10 artículos en el Metadata Repository con estado "fetched"
    And los artículos tienen IDs: "paper-001", "paper-002", "paper-003", "paper-004", "paper-005", "paper-006", "paper-007", "paper-008", "paper-009", "paper-010"
    And el Módulo de Selección envía una lista de aprobación con los IDs: ["paper-001", "paper-003", "paper-005", "paper-007", "paper-009"]
    
    When el Módulo de Descarga procesa la lista de aprobación a través del API Gateway
    
    Then el API Gateway debe delegar la petición al Paper State Manager
    And el Paper State Manager debe actualizar el estado de "paper-001", "paper-003", "paper-005", "paper-007", "paper-009" a "approved" en el Metadata Repository
    And debe encolar una tarea de descarga en el Download Manager para cada paper aprobado
    And los papers "paper-002", "paper-004", "paper-006", "paper-008", "paper-010" deben mantener el estado "fetched"

  Scenario: Artículo explícitamente rechazado durante la selección
    Given un artículo con ID "paper-reject-001" tiene el estado "fetched"
    And el Módulo de Selección envía una decisión de rechazo para el artículo "paper-reject-001"
    
    When el Módulo de Descarga procesa la decisión de rechazo
    
    Then el Paper State Manager debe actualizar el estado del artículo "paper-reject-001" a "rejected" en el Metadata Repository
    And el sistema NO debe encolar ninguna tarea de descarga para ese artículo en el Download Manager
    And el artículo debe quedar marcado como procesado y descartado

  Scenario: Intento de procesar un artículo con ID inexistente
    Given el Módulo de Selección envía una aprobación para el ID de paper "FAKE-ID-999"
    And este ID no existe en el Metadata Repository
    
    When el Módulo de Descarga intenta procesar la aprobación
    
    Then el Paper State Manager debe intentar buscar el paper en el Metadata Repository
    And debe detectar que el ID no existe
    And debe registrar un error de "ID de paper no encontrado: FAKE-ID-999" en los logs del sistema
    And el proceso debe continuar sin fallar
    And otros papers válidos en el mismo lote de aprobación deben procesarse normalmente

  Scenario: Recepción de decisión duplicada (idempotencia)
    Given el artículo con ID "paper-duplicate-001" ya tiene el estado "approved" 
    And ya existe una tarea de descarga encolada para este artículo
    And el Módulo de Selección envía nuevamente una aprobación para el artículo "paper-duplicate-001"
    
    When el Módulo de Descarga procesa la aprobación duplicada
    
    Then el Paper State Manager debe verificar el estado actual del artículo en el Metadata Repository
    And debe detectar que el artículo ya está en estado "approved"
    And NO debe cambiar el estado del artículo
    And NO debe encolar una nueva tarea de descarga en el Download Manager
    And debe registrar en los logs que se recibió una decisión duplicada

  Scenario: Actualización de estado después de descarga exitosa de PDF
    Given un artículo con ID "paper-download-001" tiene el estado "approved"
    And existe una tarea de descarga en progreso para este artículo
    And el Download Manager completa exitosamente la descarga del PDF
    
    When el Download Manager notifica al Paper State Manager sobre la descarga exitosa
    
    Then el Paper State Manager debe actualizar el estado del artículo "paper-download-001" a "fulltext_available" en el Metadata Repository
    And debe registrar la ubicación del archivo PDF en el Document Storage
    And debe notificar al Módulo de Extracción que el PDF está disponible para análisis

  Scenario: Manejo de falla en la descarga de PDF
    Given un artículo con ID "paper-fail-001" tiene el estado "approved"
    And el Download Manager intenta descargar el PDF pero falla por acceso restringido
    
    When el Download Manager notifica al Paper State Manager sobre la falla de descarga
    
    Then el Paper State Manager debe actualizar el estado del artículo "paper-fail-001" a "download_failed" en el Metadata Repository
    And debe registrar el motivo del fallo en los metadatos del artículo
    And debe mantener los metadatos disponibles para el Módulo de Selección
    And NO debe notificar al Módulo de Extracción

  Scenario: Consulta de estado de múltiples artículos
    Given existen artículos en el Metadata Repository con estados: "fetched", "approved", "fulltext_available", "rejected"
    And un módulo externo solicita el estado de un lote de artículos
    
    When el Paper State Manager recibe la consulta de estado
    
    Then debe recuperar el estado actual de todos los artículos solicitados desde el Metadata Repository
    And debe retornar un reporte consolidado con el ID de cada artículo y su estado actual
    And debe incluir timestamps de las últimas actualizaciones de estado
