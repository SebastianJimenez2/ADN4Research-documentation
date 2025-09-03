Feature: Orquestación de Búsqueda Académica vía Portal Universitario
  Como el Módulo de Diseño
  Quiero ejecutar búsquedas "piloto" para validar estrategias o "refinadas" para iniciar el flujo de SLR
  Para que el proceso sea flexible y eficiente

  Background:
    Given el Módulo de Descarga está operativo
    And el portal de la biblioteca EPN está disponible
    And las credenciales universitarias están configuradas de forma segura
    And el Metadata Repository está inicializado

  Scenario: Ejecución de una búsqueda refinada exitosa
    Given una estrategia de búsqueda válida con los términos "machine learning AND software engineering"
    And se han configurado las fuentes: Scopus e IEEE Xplore
    When el Módulo de Diseño solicita una búsqueda "refinada"
    Then el Search Request Orchestrator debe iniciar una sesión de navegador automatizado
    And debe autenticarse en el portal de la biblioteca EPN
    And debe navegar a Scopus e IEEE Xplore a través del proxy universitario
    And debe traducir la estrategia de búsqueda al formato específico de cada fuente
    And debe ejecutar las búsquedas automatizadas en ambos sitios
    And debe extraer los metadatos de las páginas de resultados HTML
    And debe consolidar los metadatos obtenidos eliminando duplicados basados en DOI y título
    And debe almacenar los metadatos únicos en el Metadata Repository con estado "fetched"
    And debe retornar un ID de lote de búsqueda al Módulo de Diseño
    And debe notificar al Módulo de Selección que hay nuevos metadatos disponibles

  Scenario: Ejecución de una búsqueda piloto y recuperación asíncrona de resultados
    Given una estrategia de búsqueda de tipo "piloto" con los términos "microservices architecture"
    When el Módulo de Diseño solicita la búsqueda piloto
    Then el sistema debe aceptar la petición y encolar una tarea de búsqueda
    And debe responder inmediatamente con un ID de Tarea para seguimiento
    And en segundo plano, el Search Request Orchestrator debe ejecutar una búsqueda LIMITADA
    And una vez completada, los metadatos de la muestra deben estar disponibles para ser consultados con el ID de Tarea


  Scenario: Fallo de autenticación en el portal universitario
    Given las credenciales universitarias configuradas son incorrectas o han expirado
    When el Módulo de Diseño intenta ejecutar una búsqueda
    Then el Search Request Orchestrator debe intentar autenticarse en el portal EPN
    And debe detectar que la autenticación falló
    And debe registrar el error de autenticación en los logs del sistema
    And debe retornar un error específico: "Authentication failed - please verify university credentials"
    And NO debe almacenar ningún metadato en el Metadata Repository
    And NO debe notificar al Módulo de Selección

  Scenario: Portal universitario temporalmente inaccesible
    Given el portal de la biblioteca EPN está temporalmente caído o en mantenimiento
    When el Módulo de Diseño intenta ejecutar una búsqueda
    Then el Search Request Orchestrator debe intentar conectarse al portal EPN
    And debe detectar que el portal no está disponible
    And debe registrar el fallo de conectividad en los logs
    And debe retornar un error temporal: "University portal temporarily unavailable"
    And debe programar un reintento automático después de un período de espera
    And NO debe almacenar ningún metadato hasta que la conexión se restablezca

  Scenario: Cambios en la estructura HTML de la página de resultados
    Given una estrategia de búsqueda válida
    And el usuario se autentica correctamente en el portal EPN
    And Scopus ha cambiado la estructura HTML de su página de resultados
    When se ejecuta la búsqueda en Scopus
    Then el Search Request Orchestrator debe navegar exitosamente a Scopus
    And debe introducir la cadena de búsqueda correctamente
    And debe intentar extraer metadatos usando los selectores HTML configurados
    And debe detectar que la estructura HTML ha cambiado
    And debe registrar un error específico: "HTML parsing failed - page structure may have changed"
    And debe continuar la búsqueda en IEEE Xplore si está disponible
    And debe retornar un ID de lote con advertencia sobre el fallo parcial en Scopus

  Scenario: Sesión universitaria expira durante la búsqueda
    Given una estrategia de búsqueda válida que requerirá tiempo considerable
    And el usuario se autentica correctamente inicialmente
    And la sesión del portal EPN expira durante el proceso de scraping
    When se está ejecutando la búsqueda y la sesión expira
    Then el Search Request Orchestrator debe detectar que la sesión ha expirado
    And debe intentar reautenticarse automáticamente una vez
    And si la reautenticación es exitosa, debe continuar el proceso desde donde se interrumpió
    And si la reautenticación falla, debe registrar el error y detener el proceso
    And debe retornar el estado actual con los datos obtenidos hasta el momento de la expiración

  Scenario: Límite de tiempo excedido durante el scraping
    Given una estrategia de búsqueda válida
    And las páginas de resultados cargan muy lentamente
    And se ha configurado un timeout máximo de 5 minutos por fuente
    When se ejecuta la búsqueda y el tiempo límite es excedido
    Then el Search Request Orchestrator debe monitorear el tiempo transcurrido
    And debe detectar cuando se alcanza el límite de tiempo configurado
    And debe terminar gracefully la sesión de scraping
    And debe registrar en logs: "Search timeout exceeded for [fuente]"
    And debe retornar los resultados parciales obtenidos antes del timeout
    And debe incluir una advertencia sobre el timeout en la respuesta
