## Salida 1 – Diseño de un nuevo plan de estudios con aprendizaje experiencial (16 semanas)

### Estructura macro

|Capítulo|Semanas|Enfoque teórico/práctico|Evaluaciones principales|
|---|---|---|---|
|**1. Fundamentos de calidad y verificación**|1‑3|30 % teoría / 70 % práctica|1 laboratorio de medición, 1 estudio de caso|
|**2. Verificación estática y especificación orientada a comportamiento**|4‑7|25 % teoría / 75 % práctica|1 par de ejercicios de revisión & análisis, 1 miniproyecto BDD|
|**3. Pruebas dinámicas y TDD**|8‑11|25 % teoría / 75 % práctica|1 laboratorio TDD, 1 proyecto individual de pruebas dinámicas|
|**4. Automatización, métricas y proyecto integrador**|12‑16|20 % teoría / 80 % práctica|Entregas quincenales de proyecto y presentación final|

Cada capítulo incluye objetivos de aprendizaje medibles, actividades prácticas y evaluaciones auténticas. Se propone una progresión **scaffolding**: los estudiantes construyen conocimientos desde la medición de la calidad hasta el desarrollo guiado por pruebas, culminando con un proyecto real.

### Capítulo 1 – Fundamentos de calidad y verificación (sem. 1‑3)

**Objetivos de aprendizaje (taxonomía de Bloom)**

1. **Recordar y comprender** la importancia de la medición y las métricas en el ciclo de vida del software, diferenciando entre perspectivas funcionales y no funcionales.
    
2. **Aplicar** un proceso estructurado de medición para cuantificar atributos de calidad y seleccionar métricas apropiadas.
    
3. **Analizar** la relación entre métricas, criterios y factores de calidad para proponer indicadores de calidad en un proyecto concreto.
    
4. **Evaluar y crear** un plan de aseguramiento de la calidad que combine actividades de verificación y validación en función de riesgos.
    

**Subcapítulos y actividades**

|Subcapítulo|Breve descripción|Actividades prácticas|
|---|---|---|
|**1.1 Ciclo de vida y aseguramiento de la calidad**|Introducción a procesos de desarrollo y roles de QA.|Taller: análisis de un proyecto real (p. ej., de software libre) para identificar puntos de control de calidad y elaboración de un **mapa de proceso** (3 horas).|
|**1.2 Métricas, medidas e indicadores**|Definición de métrica, medida e indicador.|Laboratorio: aplicar el proceso de medición formal para definir indicadores de usabilidad, fiabilidad y mantenibilidad en un módulo asignado.|
|**1.3 Fundamentos de verificación y validación**|Distinción entre verificación (¿construimos el producto correctamente?) y validación (¿construimos el producto correcto?).|Estudio de caso guiado: revisión de un documento de requisitos y diseño de un plan de verificación/validación con roles rotativos (clientes, QA, desarrolladores).|
|**1.4 Control de calidad y aspectos de calidad**|Factores y criterios de calidad: usabilidad, fiabilidad, eficiencia, mantenibilidad, portabilidad y testabilidad.|Ejercicio colaborativo: crear rúbricas para evaluar cada factor en un proyecto ficticio.|

**Evaluación y cronograma**

- **Semana 1:** Seminario magistral interactivo sobre medición; taller de mapeo del proceso.
    
- **Semana 2:** Laboratorio de métricas y medidas; entrega de un informe con indicadores definidos; retroalimentación formativa.
    
- **Semana 3:** Discusión de estudio de caso de QA; evaluación formativa mediante rúbrica; **evaluación sumativa** (laboratorio de medición) ponderada 15 %.
    

### Capítulo 2 – Verificación estática y especificación orientada a comportamiento (sem. 4‑7)

**Objetivos de aprendizaje**

1. **Recordar** las diferencias entre pruebas estáticas y dinámicas[kiuwan.com](https://www.kiuwan.com/blog/static-vs-dynamic-testing-guide/#:~:text=Static%20vs,the%20difference).
    
2. **Aplicar** técnicas de revisión e inspección para detectar defectos antes de la ejecución del software[kiuwan.com](https://www.kiuwan.com/blog/static-vs-dynamic-testing-guide/#:~:text=What%20is%20static%20testing%3F).
    
3. **Analizar y crear** criterios de aceptación y escenarios BDD utilizando lenguaje gherkin[mdpi.com](https://www.mdpi.com/2674-113X/3/3/14#:~:text=In%20order%20to%20promote%20collaboration,14).
    
4. **Evaluar** código mediante herramientas de análisis estático e identificar _smells_ y antipatrones; proponer refactorizaciones.
    

**Subcapítulos y actividades**

|Subcapítulo|Breve descripción|Actividades prácticas|
|---|---|---|
|**2.1 Calidad en etapas de análisis, diseño y codificación**|Uso de revisión de requerimientos, diseño y código.|Laboratorio: realizar revisión de requisitos de un módulo y crear checklist de inspección.|
|**2.2 Smells y antipatrones**|Identificación de _code smells_ y patrones de diseño deficientes.|Sesión de refactorización en parejas utilizando un repositorio con código defectuoso; redacción de informe de mejora.|
|**2.3 Técnicas de revisión e inspección**|Walkthroughs, peer review, inspecciones formales[kiuwan.com](https://www.kiuwan.com/blog/static-vs-dynamic-testing-guide/#:~:text=What%20is%20static%20testing%3F).|Simulación de rol: realizar una inspección formal con roles de moderador, autor y revisor.|
|**2.4 Prácticas de desarrollo para aseguramiento de calidad**|ATDD, BDD y especificación de criterios de aceptación; introducción a gherkin[mdpi.com](https://www.mdpi.com/2674-113X/3/3/14#:~:text=In%20order%20to%20promote%20collaboration,14).|Mini‑proyecto: diseñar criterios de aceptación para una funcionalidad y formalizarlos en gherkin; ejecutar pruebas de aceptación manuales y automatizadas (por ejemplo con Cucumber).|

**Evaluación y cronograma**

- **Semana 4:** Introducción a revisiones e inspecciones; práctica con revisión de requisitos; feedback en clase.
    
- **Semana 5:** Taller de refactorización y smells; entrega de informe de mejora (10 %).
    
- **Semana 6:** Simulación de inspección formal y retroalimentación; se registra participación y manejo de roles.
    
- **Semana 7:** **Evaluación sumativa** mediante mini‑proyecto BDD (20 %): criterios de aceptación, escenarios gherkin y demostración de pruebas.
    

### Capítulo 3 – Pruebas dinámicas y TDD (sem. 8‑11)

**Objetivos de aprendizaje**

1. **Explicar** los principios de las pruebas dinámicas, incluyendo pruebas unitarias, de integración y de sistema[kiuwan.com](https://www.kiuwan.com/blog/static-vs-dynamic-testing-guide/#:~:text=What%20is%20dynamic%20testing%3F).
    
2. **Aplicar** el ciclo **red‑green‑refactor** de TDD para desarrollar software con mayor calidad y productividad[beei.org](https://beei.org/index.php/EEI/article/viewFile/2533/1599#:~:text=Over%20recent%20years%2C%20software%20teams,team%20productivity%20than%20NON_TDD%20developers).
    
3. **Utilizar** técnicas de pruebas de caja negra, blanca y gris; e introducir pruebas fuzz y mocking.
    
4. **Evaluar** la cobertura de pruebas y la complejidad ciclomática; interpretar métricas para mejorar la calidad.
    

**Subcapítulos y actividades**

|Subcapítulo|Breve descripción|Actividades prácticas|
|---|---|---|
|**3.1 Especificación dirigida por ejemplos (SBE)**|Definición de ejemplos concretos como base de pruebas y documentación.|Taller: diseñar tablas de ejemplos y transformarlas en pruebas automatizadas.|
|**3.2 Desarrollo dirigido por pruebas (TDD)**|Conceptos de TDD: red‑green‑refactor, pequeña iteración[beei.org](https://beei.org/index.php/EEI/article/viewFile/2533/1599#:~:text=Over%20recent%20years%2C%20software%20teams,team%20productivity%20than%20NON_TDD%20developers).|Laboratorio: implementar un módulo sencillo (p. ej., calculadora) utilizando TDD; medir cobertura y complejidad.|
|**3.3 Técnicas de pruebas (caja negra/blanca/gris)**|Métodos de diseño de casos de prueba y uso de mocks y fuzz testing.|Ejercicio: desarrollar pruebas para un servicio web, aplicando diferentes técnicas y analizando resultados.|

**Evaluación y cronograma**

- **Semana 8:** Introducción a pruebas dinámicas y SBE; desarrollo de ejemplos y pruebas automatizadas.
    
- **Semana 9:** Laboratorio TDD – entrega de código y pruebas con métricas de cobertura (15 %).
    
- **Semana 10:** Sesión sobre técnicas de pruebas y mocking; ejercicio evaluado en grupos.
    
- **Semana 11:** **Evaluación sumativa**: proyecto individual de pruebas dinámicas (20 %), donde cada estudiante diseña, implementa y analiza un conjunto de pruebas para un componente.
    

### Capítulo 4 – Automatización, métricas y proyecto integrador (sem. 12‑16)

**Objetivos de aprendizaje**

1. **Aplicar** técnicas de automatización de pruebas, integración continua y entrega continua.
    
2. **Analizar** métricas de cobertura, defect density y tiempo de respuesta para estimar la calidad y el riesgo.
    
3. **Gestionar** un proyecto de pruebas completo, asignando tareas, controlando riesgos y utilizando herramientas colaborativas.
    
4. **Crear** una solución de V&V para un proyecto real (p. ej., aplicación web universitaria) y presentarla a clientes simulados.
    

**Subcapítulos y actividades**

|Subcapítulo|Breve descripción|Actividades prácticas|
|---|---|---|
|**4.1 Automatización y herramientas**|Herramientas de automatización (Selenium, Cypress), integración continua (GitLab CI), pruebas de rendimiento.|Laboratorio: configurar un pipeline CI/CD con ejecución de pruebas automáticas y generación de reportes.|
|**4.2 Estimación de esfuerzos y riesgos**|Métodos de estimación de pruebas y análisis de riesgos; outsourcing y tercerización.|Ejercicio: elaborar un plan de pruebas con estimaciones de esfuerzo y mitigación de riesgos; estudio de costos de outsourcing.|
|**4.3 Proyecto integrador**|Desarrollo de un proyecto en equipos (3‑4 estudiantes) que abarque todo el ciclo de V&V.|Se asigna un proyecto de software realista; cada equipo define criterios de aceptación, aplica BDD/TDD, automatiza pruebas y presenta resultados.|

**Evaluación y cronograma**

- **Semana 12:** Laboratorio de automatización; creación de pipeline y scripts de pruebas.
    
- **Semana 13:** Taller de estimación y riesgos; presentación de plan.
    
- **Semana 14‑15:** Trabajo en proyecto integrador con tutorías semanales; entregas quincenales de avance (10 % cada una).
    
- **Semana 16:** Presentación final del proyecto frente a un jurado simulado; evaluación con rúbrica (30 %).
    

### Sistema de evaluación y rúbricas

El sistema de evaluación combina **evaluaciones formativas** (retroalimentación constante en laboratorios y talleres) y **evaluaciones sumativas** limitadas a 2‑3 por capítulo. Las rúbricas se centran en competencias, como se ilustra a continuación para el proyecto final:

|Criterio|Excelente (4)|Bueno (3)|Aceptable (2)|Insuficiente (1)|
|---|---|---|---|---|
|**Plan de pruebas y criterios de aceptación**|Cubre todos los requisitos, con escenarios BDD claros y completos.|Cubre la mayoría de requisitos, algunos escenarios pueden mejorar.|Cubre solo parte de los requisitos; falta claridad en criterios.|Incompleto o confuso; no se aplican BDD/ATDD.|
|**Cobertura y automatización**|Alta cobertura (>80 %), pruebas automatizadas en CI/CD; resultados reproducibles.|Cobertura media (60‑80 %), algunas pruebas manuales.|Cobertura baja (<60 %), automatización parcial.|Sin datos de cobertura ni automatización.|
|**Calidad del código y refactorización**|Código limpio, modular; aplicación coherente de TDD; documentación completa.|Código estructurado; algunas áreas mejorables.|Código con redundancia o falta de modularidad.|Código desorganizado; no sigue prácticas de TDD.|
|**Trabajo en equipo y presentación**|Coordinación efectiva, roles claros; presentación profesional con argumentos basados en métricas.|Colaboración adecuada; presentación comprensible.|Evidencias de coordinación limitada; presentación confusa.|Desorganización evidente; falta de presentación estructurada.|






Estimado/a FIS-LAB,

Espero que se encuentre bien. Me dirijo a usted en nombre de los estudiantes que participan en el proyecto de titulación titulado "Optimización del Proceso de Revisión Sistemática de la Literatura (SLR)", bajo mi dirección. El objetivo de este proyecto es desarrollar una aplicación web que permita optimizar las actividades de los investigadores involucrados en el proceso de SLR, centralizando, esquematizando y estandarizando las tareas asociadas.

La Revisión Sistemática de la Literatura (SLR) es una metodología clave en la investigación científica que permite identificar, evaluar e interpretar la totalidad de la investigación disponible sobre un tema de interés. Este proceso es fundamental para garantizar la calidad y la reproducibilidad de los resultados científicos, y se lleva a cabo mediante varias etapas que incluyen la formulación de preguntas de investigación, selección de estudios, recuperación de datos, y análisis de los resultados obtenidos.

Para el desarrollo, pruebas y despliegue de la aplicación, requerimos utilizar los recursos de servidor proporcionados por el laboratorio, específicamente la infraestructura VDI con Ubuntu. Este entorno es crucial para alojar la aplicación y garantizar que los servicios necesarios para su funcionamiento estén disponibles de manera continua y eficiente.

El uso del VDI permitirá alojar nuestra aplicación web, que abarcará diferentes módulos del proceso SLR (diseño, selección, descarga de metadatos y documentos, extracción e interpretación). Además, será necesario que el entorno VDI proporcione acceso a herramientas de procesamiento de datos, web scraping, bases de datos y soporte para el uso de IA en varios módulos. También requerimos que el VDI soporte el acceso simultáneo de los miembros del equipo, permitiendo la colaboración en tiempo real y la ejecución de tareas de procesamiento de datos de manera eficiente.

De acuerdo con el estándar proporcionado por el laboratorio, consideramos que este plan cumple con los requisitos necesarios para el despliegue exitoso de la aplicación. Creemos que con estos recursos será posible garantizar el éxito del proyecto y el cumplimiento de los objetivos planteados.

Agradeceríamos su apoyo en la asignación de estos recursos y quedamos atentos a cualquier requerimiento adicional para formalizar la solicitud.

Quedo a su disposición para cualquier consulta o detalle adicional.

Atentamente,  
