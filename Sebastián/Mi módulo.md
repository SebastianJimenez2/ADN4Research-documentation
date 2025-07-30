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
- Con los metadatos recibidos, se procede a hacer la revisión de los mismos (titulo, abstract, keywords) #PAPER:
- Se hace una revisión por pares para validación de la revisión #INVESTIGADOR.
  + El número de metadatos se divide para el total de investigadores y se sortea aleatoriamente. #PAPERINVESTIGADOR
  + Un revisor revisa su total de papers asignados a más del total asignados a su revisor par #PAPERINVESTIGADOR 
- Se compara el estado del paper y se establece una concordancia entre el revisor y su revisor par #PAPER
  + Si ambos revisores aprobaron el paper, el paper queda aprobado directamente #PAPER
  + Si un revisor lo aprobó y el otro lo rechazó, se hace una discusión para llegar a una concordancia #PAPER
>[!Note]
>La aprobación o el rechazo del paper debe ser justificado en base al criterio de exclusión o inclusión, sea el caso.
- Se ofrece los metadatos aprobados al modulo de descarga para recibir los papers completos #PAPER
- El total de papers completos es repartido equitativamente y aleatoriamente entre todos los revisores (revisión individual) #PAPERINVESTIGADOR 
- Cada revisor aprueba o rechaza el paper completo siguiendo los mismos criterios de inclusión o exclusión #INVESTIGADOR 
- Se descartan los rechazados y se ofrece los aprobados al siguiente módulo. #PAPER 
>[!Note]
>En la aprobación y rechazo de papers, discrepancia entre revisores con su par puede interferir IA para sugerencias de aprobado o rechazado

>[!Note]
>Los resultados de metadatos aprobados o rechazados, de papers aprobados o rechazados con sus respectivas justificaciones (criterios) deben ser almacenados para la construction del diagrama PRISMA
# Diagrama de PRISMA
![[Pasted image 20250505075302.png]]