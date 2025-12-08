# Alcance
¿Cuál es el input que recibo del módulo de descarga? Obtengo solo los estudios acorde a la cadena de búsqueda y nada más, o el módulo ya me debe entregar estos estudios excluyendo aquellos duplicados de cada motor de búsqueda usado.    
![[Pasted image 20250505075318.png]]
# Problemas encontrados (mi experiencia)
1. Papers duplicados al hacer la división
2. Versionamiento disfuncional    
3. Copias locales (se copiaba el archivo Excel en lugar de editarlo en la nube) 
4. Confusión en la revisión por pares (no sabían cuántos papers tenían que revisar pese a que estaba dividido en excel)
5. Criterios de revisión no claros (aspecto de comentarios)
6. Hallar las discrepancias se vuelve tedioso
7. Estadísticas erróneas
8. Autores que publican el mismo artículo, primero un borrador (versión preliminar) y luego el final
9. Confidencialidad, en el caso de revisión por pares
10. Dividir los papers full-text en función de las páginas ya que no todos tienen la misma carga horaria.
Todos estos problemas nacen a partir de la realización del proceso de división de forma **MANUAL**.
# Flujo de mi módulo
Para que el flujo del módulo de selección empiece se requiere lo siguiente: el módulo de diseño debe tener listos los criterios de inclusión y exclusión, el módulo de gestión de papers debe tener al menos la metadata disponible para poder mostrarla en el módulo de gestión.
- Con los metadatos recibidos, se procede a hacer la revisión de los mismos (titulo, abstract, keywords) 
>[!Note]
>Todo esto se mostrará en una vista tipo tabla que mostrará enlistado todos los metadatos para el usuario
- Se hace una revisión por pares para validación de la revisión 
  + El número de metadatos se divide para el total de investigadores y se sortea aleatoriamente. 
  +  Un revisor revisa su total de papers asignados a más del total asignados a su revisor par, por ejemplo, si existen 100 papers y 4 investigadores, la distribución es de 25 para cada uno y adicional a estos los 25 de su par, dando un total de 50. 
>[!Note]
>En este aspecto, se va a considerar la carga horaria de cada investigador, de modo que, aquellos con mayor tiempo, revisarán la metadata más cargada o en su defecto, el estudio con más hojas. Para los metadatos, se tomará en cuenta la extensión del abstract
- Se compara el estado del paper y se establece una concordancia entre el revisor y su revisor par 
  + Si ambos revisores aprobaron el paper, el paper queda aprobado directamente 
  + Si un revisor lo aprobó y el otro lo rechazó, se hace una discusión para llegar a una concordancia 
>[!Note]
>La aprobación o el rechazo del paper debe ser justificado en base al criterio de exclusión o inclusión, sea el caso. Además, para la discusión de concordancia existiría una vista en donde se enliste los papers con el estado de aprobado y el criterio correspondiente de ambos revisores
- Se ofrece los metadatos aprobados al modulo de descarga para recibir los papers completos. NO QUEREMOS RECIBIR LOS PAPERS COMPLETOS DE LA METADATA RECHAZADA 
- El total de papers completos es repartido equitativamente y aleatoriamente entre todos los revisores (revisión individual) 
>[!Note]
>En este aspecto, se va a considerar la carga horaria de cada investigador, de modo que, aquellos con mayor tiempo, revisarán la metadata más cargada o en su defecto, el estudio con más hojas. Para los metadatos, se tomará en cuenta la extensión del abstract
- Cada revisor aprueba o rechaza el paper completo y justificando en base a los criterios de inclusión o exclusión 
>[!Note]
>Dada la fase anterior sobre los metadatos, existe la posibilidad de una mejora en los criterios de inclusión y exclusión para ser aplicada en los estudios completos y focalizar más aquellos estudios que respondan a la pregunta de investigación
- Se descartan los rechazados y se ofrece los aprobados para que el módulo de gestión de papers ofrezca a quién lo necesite. 
>[!Note]
>En la aprobación y rechazo de metadata/papers y discrepancia entre revisores con su par puede interferir IA para sugerencias de aprobado o rechazado

>[!Note]
>Los resultados de metadatos aprobados o rechazados, de papers aprobados o rechazados con sus respectivas justificaciones (criterios) deben ser almacenados para la construction del diagrama PRISMA

>[!Note]
>El usuario debe poder ser capaz de guardar su progreso progresivamente, es decir, se debe estar enviando actualizaciones del estado de la metadata/papers al modulo de descarga continuamente o cada que el usuario guarde su progreso.
# Diagrama de PRISMA
![[Pasted image 20250505075302.png]]