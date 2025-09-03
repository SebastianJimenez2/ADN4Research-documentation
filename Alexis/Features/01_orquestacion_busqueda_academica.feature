Feature: Orquestación de Búsqueda Académica

  Como el Módulo de Diseño
  Quiero enviar una estrategia de búsqueda al Módulo de Descarga
  Para que se ejecute en múltiples repositorios académicos y obtenga metadatos consolidados

  Background:
    Given el Módulo de Descarga está operativo
    And las APIs de los repositorios académicos están disponibles
    And el Metadata Repository está inicializado

  Scenario: Búsqueda exitosa en múltiples repositorios académicos
    Given una estrategia de búsqueda válida con los términos "machine learning AND software engineering"
    And se han configurado las fuentes: Scopus e IEEE Xplore
    And cada fuente tiene cuotas de API disponibles
    
    When se ejecuta la búsqueda a través del Módulo de Descarga
    
    Then el API Gateway debe delegar la petición al Academic Search Orchestrator
    And el Academic Search Orchestrator debe traducir la estrategia para cada repositorio académico
    And debe ejecutar las búsquedas en paralelo en Scopus e IEEE Xplore
    And debe consolidar los metadatos obtenidos eliminando duplicados basados en DOI y título
    And debe almacenar los metadatos únicos en el Metadata Repository con estado "fetched"
    And debe retornar un ID de lote de búsqueda al Módulo de Diseño
    And debe notificar al Módulo de Selección que hay nuevos metadatos disponibles

  Scenario: Búsqueda con resultados parciales por falla en un repositorio
    Given el Módulo de Diseño envía una estrategia de búsqueda válida
    And Scopus está disponible
    And IEEE Xplore está temporalmente inaccesible
    
    When el Academic Search Orchestrator ejecuta la búsqueda
    
    Then debe obtener resultados exitosamente de Scopus
    And debe registrar el fallo de IEEE Xplore en los logs del sistema
    And debe consolidar los metadatos disponibles eliminando duplicados
    And debe almacenar los metadatos obtenidos en el Metadata Repository
    And debe retornar un ID de lote de búsqueda con un mensaje de advertencia sobre IEEE Xplore
    And debe notificar al Módulo de Selección sobre los metadatos parciales disponibles

  Scenario: Búsqueda sin resultados en ningún repositorio
    Given el Módulo de Diseño envía una estrategia de búsqueda muy específica
    And todos los repositorios académicos están operativos
    And la búsqueda no encuentra coincidencias en ninguna fuente
    
    When el Academic Search Orchestrator ejecuta la búsqueda
    
    Then debe intentar la búsqueda en todos los repositorios configurados
    And debe confirmar que no se encontraron resultados en ninguna fuente
    And NO debe almacenar ningún metadato en el Metadata Repository
    And debe retornar una respuesta indicando "búsqueda completada sin resultados"
    And NO debe notificar al Módulo de Selección

  Scenario: Búsqueda rechazada por límites de cuota de API excedidos
    Given el Módulo de Diseño envía una estrategia de búsqueda válida
    And Scopus ha alcanzado su límite diario de consultas API
    And IEEE Xplore tiene cuotas disponibles
    
    When el Academic Search Orchestrator intenta ejecutar la búsqueda
    
    Then debe detectar que Scopus ha excedido sus cuotas
    And debe continuar la búsqueda solo en IEEE Xplore
    And debe registrar el límite de cuota de Scopus en los logs
    And debe almacenar los metadatos obtenidos de IEEE Xplore
    And debe retornar un ID de lote con una advertencia sobre las limitaciones de cuota

  Scenario: Validación de estrategia de búsqueda mal formada
    Given el Módulo de Diseño envía una estrategia de búsqueda con sintaxis inválida
    And la estrategia contiene operadores booleanos mal formados
    
    When el API Gateway recibe la petición
    
    Then debe validar la sintaxis de la estrategia de búsqueda
    And debe detectar que la estrategia está mal formada
    And debe rechazar la petición sin ejecutar ninguna búsqueda
    And debe retornar un error específico sobre la sintaxis inválida
    And NO debe almacenar nada en el Metadata Repository
