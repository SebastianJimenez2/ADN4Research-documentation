Feature: Provisión de Datos Bajo Demanda

  Como los Módulos de Selección y Extracción
  Quiero solicitar metadatos y archivos PDF al Módulo de Descarga
  Para que pueda cumplir mis funciones sin acceder directamente a los datos brutos

  Background:
    Given el Metadata Repository contiene artículos con diferentes estados
    And el Document Storage contiene archivos PDF descargados
    And el API Gateway está operativo para manejar peticiones de lectura

  Scenario: Módulo de Selección solicita metadatos para revisión
    Given el Metadata Repository contiene 25 artículos con estado "fetched" para el lote de búsqueda "batch-2024-001"
    And los metadatos incluyen: título, autores, resumen, año, DOI, y fuente original
    
    When el Módulo de Selección solicita los metadatos del lote "batch-2024-001" a través del API Gateway
    
    Then el API Gateway debe delegar la petición de lectura al Paper State Manager
    And el Paper State Manager debe consultar el Metadata Repository para obtener los 25 artículos
    And debe filtrar solo los artículos con estado "fetched"
    And debe retornar una respuesta exitosa con la lista completa de metadatos estructurada
    And la respuesta debe incluir el ID del lote, el número total de artículos, y los metadatos de cada artículo

  Scenario: Módulo de Extracción solicita PDF que ya está disponible
    Given el artículo con ID "paper-extract-001" tiene el estado "fulltext_available"
    And su archivo PDF correspondiente "paper-extract-001.pdf" está guardado en el Document Storage
    And el archivo tiene un tamaño válido y no está corrupto
    
    When el Módulo de Extracción solicita el PDF del artículo "paper-extract-001" al API Gateway
    
    Then el API Gateway debe delegar la petición de entrega del archivo al Download Manager
    And el Download Manager debe verificar que el archivo existe en el Document Storage
    And debe recuperar el archivo PDF desde el Document Storage
    And debe retornar el archivo PDF exitosamente con los headers correctos (content-type: application/pdf)

  Scenario: Solicitud de PDF cuya descarga está pendiente
    Given el artículo con ID "paper-pending-001" tiene el estado "approved"
    And la descarga del PDF está en progreso pero no ha terminado
    And NO existe el archivo correspondiente en el Document Storage
    
    When el Módulo de Extracción solicita el PDF del artículo "paper-pending-001"
    
    Then el sistema debe verificar el estado del artículo en el Metadata Repository
    And debe detectar que el estado es "approved" pero no "fulltext_available"
    And debe responder con un código de estado HTTP 202 (Accepted) indicando que el recurso no está listo
    And debe incluir un mensaje explicativo: "PDF download in progress, please retry later"
    And NO debe intentar retornar ningún archivo

  Scenario: Solicitud de PDF de un artículo rechazado
    Given el artículo con ID "paper-rejected-001" tiene el estado "rejected"
    And NO existe ningún archivo PDF para este artículo en el Document Storage
    
    When el Módulo de Extracción solicita el PDF del artículo "paper-rejected-001"
    
    Then el sistema debe verificar el estado del artículo
    And debe detectar que el estado es "rejected"
    And debe responder con un código de estado HTTP 403 (Forbidden)
    And debe incluir un mensaje explicativo: "Article was rejected during selection phase"

  Scenario: Solicitud de recurso con ID completamente inválido
    Given no existe ningún artículo con el ID "COMPLETELY-FAKE-ID-999" en el Metadata Repository
    
    When cualquier módulo solicita el PDF del artículo "COMPLETELY-FAKE-ID-999"
    
    Then el sistema debe buscar el artículo en el Metadata Repository
    And debe confirmar que el ID no existe
    And debe responder con un código de estado HTTP 404 (Not Found)
    And debe incluir un mensaje explicativo: "Article ID not found"
    And debe registrar la petición inválida en los logs del sistema

  Scenario: Módulo de Selección solicita metadatos de un lote inexistente
    Given no existe ningún lote de búsqueda con ID "batch-inexistente-999"
    
    When el Módulo de Selección solicita los metadatos del lote "batch-inexistente-999"
    
    Then el Paper State Manager debe buscar el lote en el Metadata Repository
    And debe confirmar que el lote no existe
    And debe responder con un código de estado HTTP 404 (Not Found)
    And debe incluir un mensaje: "Search batch not found"

  Scenario: Solicitud de metadatos con filtros específicos
    Given el Metadata Repository contiene artículos de diferentes años: 2020, 2021, 2022, 2023, 2024
    And el Módulo de Selección especifica un filtro de año: "2022-2024"
    And especifica un filtro de fuente: "IEEE Xplore"
    
    When el Módulo de Selección solicita metadatos con estos filtros aplicados
    
    Then el Paper State Manager debe aplicar los filtros sobre los datos en el Metadata Repository
    And debe retornar solo los artículos que coincidan con ambos criterios: año 2022-2024 Y fuente IEEE Xplore
    And la respuesta debe incluir el número de artículos filtrados vs el total disponible
    And debe mantener la estructura completa de metadatos para cada artículo filtrado

  Scenario: Verificación de integridad de archivo PDF antes de entrega
    Given el artículo con ID "paper-integrity-001" tiene estado "fulltext_available"
    And existe un archivo "paper-integrity-001.pdf" en el Document Storage
    And el archivo está corrupto o tiene tamaño cero
    
    When el Módulo de Extracción solicita el PDF del artículo "paper-integrity-001"
    
    Then el Download Manager debe verificar la integridad del archivo antes de entregarlo
    And debe detectar que el archivo está corrupto
    And debe responder con un código de estado HTTP 500 (Internal Server Error)
    And debe incluir un mensaje: "PDF file is corrupted or unavailable"
    And debe registrar el problema de integridad en los logs
    And debe actualizar el estado del artículo a "download_failed" a través del Paper State Manager
