# language: en
@modulo:descarga @componente:data-provision
Feature: Provisión de Datos Bajo Demanda
  Como los Módulos de Selección y Extracción
  Quiero solicitar metadatos y archivos PDF al Módulo de Descarga
  Para que pueda cumplir mis funciones sin acceder directamente a los datos brutos

  Rule: Los metadatos se sirven según estado y filtros aplicados

  Background:
    Given el repositorio contiene artículos con diferentes estados
    And el almacenamiento contiene archivos PDF descargados
    And el servicio de provisión está operativo

  Scenario: Módulo de Selección solicita metadatos para revisión
    Given el repositorio contiene 25 artículos con estado "recuperado" para el lote "batch-2024-001"
    And los metadatos incluyen: título, autores, resumen, año, DOI, y fuente original
    When el Módulo de Selección solicita los metadatos del lote "batch-2024-001"
    Then la respuesta incluye código 200
    And el cuerpo contiene los 25 artículos con estado "recuperado"
    And cada artículo incluye todos sus metadatos canónicos
    And se emite el evento "MetadataServed" con count=25 y consumer="seleccion"

  Scenario: Módulo de Extracción solicita PDF disponible
    Given el artículo "paper-extract-001" tiene estado "texto_completo_disponible"
    And su archivo PDF está guardado en el almacenamiento con checksum válido
    When el Módulo de Extracción solicita el PDF del artículo "paper-extract-001"
    Then la respuesta incluye código 200
    And el header Content-Type es "application/pdf"
    And el cuerpo contiene el archivo PDF
    And se emite el evento "PDFServed" con id="paper-extract-001" y consumer="extraccion"

  Scenario: Solicitud de PDF con descarga en progreso
    Given el artículo "paper-pending-001" tiene estado "descargando"
    When el Módulo de Extracción solicita el PDF del artículo "paper-pending-001"
    Then la respuesta incluye código 202
    And el mensaje indica "Descarga de PDF en progreso, reintente más tarde"
    And se emite el evento "PDFRequestedWhileDownloading"

  Scenario: Solicitud de PDF de artículo rechazado
    Given el artículo "paper-rejected-001" tiene estado "rechazado"
    When el Módulo de Extracción solicita el PDF del artículo "paper-rejected-001"
    Then la respuesta incluye código 403
    And el mensaje indica "Artículo rechazado durante fase de selección"
    And se emite el evento "PDFAccessDenied" con motivo="articulo_rechazado"

  Scenario: Solicitud de recurso con ID inexistente
    Given no existe ningún artículo con ID "FAKE-ID-999" en el repositorio
    When cualquier módulo solicita el PDF del artículo "FAKE-ID-999"
    Then la respuesta incluye código 404
    And el mensaje indica "ID de artículo no encontrado"
    And se emite el evento "InvalidResourceRequested"

  Scenario: Módulo de Selección solicita metadatos de lote inexistente
    Given no existe ningún lote con ID "batch-inexistente-999"
    When el Módulo de Selección solicita los metadatos del lote "batch-inexistente-999"
    Then la respuesta incluye código 404
    And el mensaje indica "Lote de búsqueda no encontrado"

  Rule: Los filtros se aplican sobre metadatos canónicos

  Scenario: Solicitud de metadatos con filtros múltiples
    Given el repositorio contiene artículos de años 2020, 2021, 2022, 2023, 2024
    And existen artículos de fuentes "IEEE Xplore", "Scopus", "Manual"
    When se solicitan metadatos con filtros año="2022-2024" y fuente="IEEE Xplore"
    Then la respuesta incluye solo artículos del año 2022, 2023 o 2024
    And todos los artículos retornados tienen fuente "IEEE Xplore"
    And el resumen indica total_filtrados vs total_disponibles
    And se emite el evento "FilteredQueryExecuted" con los criterios aplicados

  Rule: La integridad se verifica antes de servir archivos

  Scenario: Verificación de integridad de PDF corrupto
    Given el artículo "paper-integrity-001" tiene estado "texto_completo_disponible"
    And el archivo PDF asociado está corrupto o tiene tamaño cero
    When el Módulo de Extracción solicita el PDF del artículo "paper-integrity-001"
    Then la respuesta incluye código 500
    And el mensaje indica "Archivo PDF corrupto o no disponible"
    And se emite el evento "PDFIntegrityCheckFailed"
    And el estado del artículo cambia a "descarga_fallida"

  Scenario: Provisión exitosa con enlace firmado de corta duración
    Given el artículo "paper-secure-001" tiene estado "texto_completo_disponible"
    And la política de seguridad requiere enlaces firmados
    When se solicita el PDF del artículo "paper-secure-001"
    Then la respuesta incluye un enlace firmado con expiración en 15 minutos
    And el enlace incluye token de autenticación temporal
    And se emite el evento "SecureLinkGenerated" con ttl=900