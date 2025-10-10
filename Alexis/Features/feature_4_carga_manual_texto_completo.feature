# language: en
@modulo:descarga @componente:manual-upload
Feature: Carga manual de texto completo por el investigador
  Como investigador
  Quiero subir manualmente el texto completo con metadatos canónicos
  Para mantener consistencia con los lotes existentes y completar brechas de descarga

  Rule: La carga manual requiere metadatos canónicos completos

  Background:
    Given existe una convención de metadatos canónicos acordada por el proyecto
    And el repositorio mantiene historial auditable por artículo
    And el umbral de similitud para deduplicación está configurado en 0.85

  Scenario: Carga manual exitosa con metadatos completos
    Given el investigador dispone del texto completo de un trabajo científico
    And posee los metadatos canónicos completos: título, autores, año y DOI
    And no existe en el repositorio un artículo con el mismo DOI
    When el investigador realiza la carga manual del texto completo y metadatos
    Then el artículo queda con estado "texto_completo_disponible"
    And la fuente se registra como "Manual"
    And se emite el evento "ManualUploadSucceeded" con el ID del artículo
    And se registra en el historial: responsable, fecha y tipo de carga

  Scenario: Rechazo por metadatos incompletos
    Given el investigador intenta cargar un trabajo sin el título requerido
    When envía la carga manual con metadatos incompletos
    Then la respuesta es código 400 con error "metadatos_incompletos"
    And el mensaje especifica los campos faltantes: "título"
    And no se crea ningún artículo en el repositorio
    And se emite el evento "ManualUploadRejected" con motivo="campos_faltantes"

  Scenario: Rechazo por archivo PDF corrupto
    Given el investigador tiene metadatos completos válidos
    And el archivo PDF está corrupto o tiene tamaño cero
    When intenta realizar la carga manual
    Then la respuesta es código 400 con error "archivo_invalido"
    And el mensaje indica "El archivo PDF está corrupto o vacío"
    And no se crea ningún artículo en el repositorio
    And se emite el evento "ManualUploadRejected" con motivo="pdf_corrupto"

  Rule: La deduplicación prioriza DOI sobre similitud de metadatos

  Scenario: Detección de duplicado exacto por DOI
    Given existe en el repositorio un artículo con DOI "10.1234/abcd.2024.001"
    When el investigador intenta cargar un trabajo con el mismo DOI "10.1234/abcd.2024.001"
    Then la respuesta es código 409 con error "duplicado_detectado"
    And el mensaje incluye el ID del artículo existente
    And se emite el evento "DuplicateUploadAttempted" con criterio="doi"
    And el historial del artículo existente registra el intento de carga duplicada

  Scenario: Detección de posible duplicado por similitud sin DOI
    Given no se proporciona DOI en la carga manual
    And existe un artículo con título "Machine Learning in Software Engineering", año 2023
    And el investigador intenta cargar con título "ML in Software Engineering", año 2023
    And la similitud calculada es 0.87 (superior al umbral de 0.85)
    When el sistema evalúa la carga
    Then la respuesta es código 409 con advertencia "posible_duplicado"
    And el mensaje sugiere revisar el artículo existente
    And se emite el evento "PossibleDuplicateDetected" con similitud=0.87
    And permite al investigador confirmar si es realmente distinto

  Scenario: Aceptación de carga con similitud bajo el umbral
    Given no se proporciona DOI en la carga manual
    And existe un artículo con título "Deep Learning Applications", año 2023
    And el investigador carga con título "Blockchain Technology Review", año 2023
    And la similitud calculada es 0.15 (inferior al umbral de 0.85)
    When el sistema evalúa la carga
    Then el artículo se crea exitosamente con estado "texto_completo_disponible"
    And se emite el evento "ManualUploadSucceeded"
    And no se marca como duplicado

  Rule: Las cargas manuales son idempotentes

  Scenario: Idempotencia en carga manual repetida
    Given el investigador ya cargó el artículo "paper-manual-001" con fuente "Manual"
    And el artículo tiene estado "texto_completo_disponible"
    When intenta cargar nuevamente el mismo trabajo con idénticos metadatos
    Then la respuesta es código 200 con el ID existente "paper-manual-001"
    And no se crea un artículo duplicado
    And se emite el evento "IdempotentUploadDetected"
    And el historial registra "carga idempotente detectada"

  Scenario Outline: Validación de tamaño y tipo de archivo
    Given el investigador tiene metadatos completos válidos
    And el archivo tiene tamaño <tamano_mb> MB y tipo "<tipo_mime>"
    When intenta realizar la carga manual
    Then la respuesta es código <codigo>
    And el mensaje indica "<mensaje>"

    Examples:
      | tamano_mb | tipo_mime           | codigo | mensaje                           |
      | 5         | application/pdf      | 200    | Carga exitosa                     |
      | 0         | application/pdf      | 400    | Archivo vacío                     |
      | 150       | application/pdf      | 400    | Archivo excede límite de 100MB    |
      | 10        | application/msword   | 400    | Solo se aceptan archivos PDF      |

  Scenario: Carga manual con enriquecimiento de metadatos
    Given el investigador proporciona metadatos mínimos: título, autores, año
    And no proporciona DOI, venue, abstract ni keywords
    When realiza la carga manual exitosa
    Then el artículo se crea con los metadatos provistos
    And los campos opcionales quedan marcados como null
    And el sistema permite enriquecimiento posterior de metadatos
    And se emite el evento "ManualUploadSucceeded" con flag "metadatos_minimos"