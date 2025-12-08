# Fases del proceso BDD
## Especular
El equipo tiene una conversación con los interesados para identificar y entender los objetivos de negocio a alto nivel e identificar las <mark style="background: #FF5582A6;">features</mark> clave que va a ayudar a entregar ese objetivo.
Aquí llevamos a cabo: [[5. Kick-off|Kick-off]]
## Ilustrar
El equipo construye un <mark style="background: #FF5582A6;">entendimiento más profundo</mark> sobre un feature en específico, a través de conversaciones sobre ejemplos concretos de reglas de negocio.
Aquí llevamos a cabo nuestras reuniones.
## Formular
El equipo transforma esos ejemplos clave en especificaciones ejecutables.
## Automatizar
En donde los desarrolladores y testers convierte las especificaciones ejecutables en pruebas de aceptación automatizadas.
## Demostrar
Cuando el test actúa como evidencia de que el feature ha sido implementado correctamente. Aquí se verifica que un feature haga lo que se pidió que haga.
## Validar
El equipo y el negocio observan si ese feature se desarrolla en el mundo real y si entregaron el valor al negocio que prometieron.
# Objetivos del negocio
~~Optimizar las actividades de los investigadores mediante la implementación de una aplicación informática que asista al proceso SLR con la centralización, esquematización y estandarización de las tareas~~
Estandarizar la gestión de proyectos de investigación
# Descubriendo capabilities y features
Para las capabilities del proyecto se acordó lo siguiente:
1. Diseñar el proceso de la investigación
<mark style="background: #D2B3FFA6;">2. Selección de papers</mark>
2. Gestión de papers (descarga y orquesta de papers)
3. Extracción de la información
4. Interpretación de la información
## Causas encontrados
- Se perdía mucho tiempo en la fase de selección, rayyan ayudó al proceso, y solo se dedicaba tiempo a la discusión
- Se tomaba mucho tiempo en la discusión, un apartado de "comentario" ayudaba bastante pero no siempre se completaba
- Pese a que la distribución de papers era equitativa, no se consideraba carga horario de los involucrados, cantidad de hojas del paper
- Se manejaba con Excel o el proceso era muy manual
- Los investigadores tenían confusión sobre qué papers debían revisar
- No se usaban o se dejaban de lado los criterios de inclusión y exclusión al aprobar o descartar un estudio (o cuando se versionaban, se perdía trazabilidad)
- Al momento de hacer la distribución, existían papers duplicados
- <mark style="background: #FFB86CA6;">Se perdía confidencialidad y anonimato en la revisión</mark>
## Describiendo features
![[Pasted image 20250731115628.png]]
**¿Por qué estoy haciendo esto?** => Cuáles son los <mark style="background: #ADCCFFA6;">objetivos de negocio</mark>
**¿Quiénes son los actores clave?** => Comportamientos que pueden cambiar/mejorar
**¿Cómo puede cambiar el comportamiento?** => Cambios en el comportamiento que ayuden a lograr los objetivos de negocio
**¿Qué features pueden ayudar a este comportamiento a cambiar?**