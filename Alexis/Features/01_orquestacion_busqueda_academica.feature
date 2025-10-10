# language: en
@modulo:descarga @componente:search-orchestration
Feature: Orquestación de Búsqueda Académica
  Como investigador
  Quiero ejecutar una estrategia de búsqueda en la plataforma de descargas
  Para obtener metadatos consolidados desde múltiples repositorios

    Rule: Las búsquedas consolidan metadatos eliminando duplicados por DOI y similitud

        Background:
            Given la plataforma de descarga está operativa
              And el repositorio de metadatos está inicializado
              And existen fuentes académicas habilitadas en la plataforma

        Scenario: Búsqueda exitosa en múltiples repositorios
            Given una estrategia válida con query "machine learning AND software engineering" y filtros año="2020-2024"
              And las fuentes Scopus e IEEE Xplore están habilitadas
             When se inicia la búsqueda
             Then se emite el evento "BatchStarted" con un nuevo batchId
              And se envían solicitudes a todas las fuentes habilitadas respetando límites
              And se emite el evento "BatchCompleted" con totales="120", únicos="95" y sin advertencias
              And los metadatos únicos quedan disponibles con estado "recuperado" y el batchId asignado
              And se emite el evento "MetadataAvailable" para notificar al Módulo de Selección

        Scenario: Resultados parciales por caída de una fuente
            Given una estrategia válida
              And Scopus está operativo y IEEE Xplore está temporalmente inaccesible
             When se inicia la búsqueda
             Then se emite el evento "BatchStarted" con un nuevo batchId
              And se emite el evento "SourceFailed" para IEEE Xplore con motivo "conexión_rechazada"
              And se emite el evento "BatchCompleted" con estado "completado_con_advertencias"
              And los metadatos de Scopus quedan disponibles con estado "recuperado"
              And la respuesta incluye advertencia "IEEE Xplore no disponible"

        Scenario: Búsqueda sin resultados
            Given una estrategia válida extremadamente específica
              And todas las fuentes habilitadas están operativas
             When se inicia la búsqueda
             Then se emite el evento "BatchCompleted" con totales="0", únicos="0"
              And la respuesta indica estado "completado_sin_resultados"
              And no se emite el evento "MetadataAvailable"

        Scenario: Límite de cuota excedido en una fuente
            Given una estrategia válida
              And Scopus ha excedido su límite diario de consultas y IEEE Xplore tiene cuota disponible
             When se inicia la búsqueda
             Then se emite el evento "QuotaExceeded" para Scopus
              And se continúa la búsqueda solo en IEEE Xplore
              And se emite el evento "BatchCompleted" con estado "completado_con_advertencias"
              And la respuesta incluye advertencia "Scopus: cuota_excedida"

        Scenario: Estrategia de búsqueda mal formada
            Given una estrategia con sintaxis inválida (operadores booleanos mal formados)
             When la plataforma recibe la solicitud
             Then la respuesta es código 400 con error "sintaxis_invalida"
              And no se emite el evento "BatchStarted"
              And no se persiste ningún metadato

        Scenario: Idempotencia ante reenvío de la misma estrategia
            Given una estrategia válida con query "deep learning AND healthcare" y filtros año="2022-2024"
              And existe un lote previo con la misma estrategia normalizada
             When el sistema recibe nuevamente la misma estrategia
             Then devuelve el mismo batchId existente
              And se emite el evento "DuplicateSearchDetected" con el batchId original
              And no se crean metadatos duplicados

    Rule: La deduplicación prioriza DOI sobre similitud de título

        Scenario Outline: Consolidación de metadatos duplicados con DOI idéntico
            Given existen metadatos del mismo paper provenientes de <fuentes>
              And ambos registros pertenecen al batchId "<batchId>"
              And los registros comparten el DOI "<doi>"
             When el sistema consolida los resultados del lote
             Then conserva un único registro con el DOI "<doi>"
              And se emite el evento "DuplicatesMerged" con count=1 y criterio="doi"
              And el registro consolidado mantiene traza de las fuentes originales

        Examples:
                  | batchId  | doi             | fuentes             |
                  | BATCH001 | 10.1145/1234567 | Scopus, IEEE Xplore |
                  | BATCH002 | 10.1007/9876543 | Scopus, Springer    |

        Scenario Outline: Consolidación de metadatos por similitud de título y año
            Given existen metadatos sin DOI asociados al batchId "<batchId>"
              And los títulos "<tituloA>" y "<tituloB>" presentan similitud de <similitud>
              And ambos corresponden al año <anio>
              And el umbral de similitud configurado es 0.85
             When el sistema consolida los resultados del lote
             Then conserva un único metadato consolidado
              And se emite el evento "DuplicatesMerged" con count=1 y criterio="similitud"
              And la traza indica fusión por similitud de <similitud>

        Examples:
                  | batchId  | similitud | anio | tituloA                          | tituloB                                  |
                  | BATCH010 | 0.90      | 2022 | Deep Learning for Bug Prediction | Deep Learning Methods for Bug Prediction |
                  | BATCH011 | 0.87      | 2021 | ML in Software Engineering       | Machine Learning in SE                   |