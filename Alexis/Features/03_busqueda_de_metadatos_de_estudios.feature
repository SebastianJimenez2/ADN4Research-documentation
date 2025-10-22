# language: es
@modulo:busqueda @componente:consolidacion
Característica: Consolidación de metadatos en registros canónicos
  Como investigador
  Quiero consolidar los metadatos de los estudios que descubrí
  Para disponer de un registro canónico con información completa y trazable

        Antecedentes:
            Dada una estrategia previamente normalizada
              Y un descubrimiento previo asociado a esa estrategia

        Escenario: Consolidación exitosa con todos los metadatos esenciales
            Dado el estudio "st-101" del descubrimiento previo
              Y el estudio tiene metadatos disponibles en múltiples fuentes
             Cuando el sistema consolida los metadatos del estudio
             Entonces el registro canónico incluye valores para todos los campos esenciales
                  | campo              |
                  | título             |
                  | autores            |
                  | año_publicación    |
                  | resumen            |
                  | palabras_clave     |
                  | identificador_DOI  |
                  | fuente_publicación |
                  | idioma             |
              Y cada campo registra su fuente de procedencia
              Y el estudio queda con estado "consolidado"

        Escenario: Consolidación sin DOI utiliza identificador alternativo
            Dado el estudio "st-102" del descubrimiento previo
              Y ninguna fuente provee DOI para el estudio
             Cuando el sistema consolida los metadatos del estudio
             Entonces el registro canónico incluye "título", "autores" y "año_publicación"
              Y el campo "identificador_DOI" queda vacío
              Y el registro incluye un identificador alternativo válido
              Y el estudio queda con estado "consolidado"

        Escenario: Resolución de conflictos por precedencia de fuentes
            Dado el estudio "st-110" del descubrimiento previo
              Y la fuente A reporta el título "Deep Learning for Software" y año 2021
              Y la fuente B reporta el título "Deep Learning for Software Engineering" y año 2022
             Cuando el sistema consolida los metadatos del estudio
             Entonces el registro canónico usa los valores de la fuente con mayor precedencia
              Y se registra qué fuentes fueron descartadas y por qué

        Escenario: Consolidación parcial con metadatos incompletos
            Dado el estudio "st-120" del descubrimiento previo
              Y solo están disponibles "título", "autores", "año_publicación" y "resumen"
             Cuando el sistema consolida los metadatos del estudio
             Entonces el registro canónico incluye los campos disponibles
              Y los campos restantes quedan vacíos
              Y cada campo disponible registra su fuente de procedencia
              Y el estudio queda con estado "consolidado"

        Escenario: Fallo de consolidación por metadatos insuficientes
            Dado el estudio "st-125" del descubrimiento previo
              Y solo se obtiene el título del estudio
             Cuando el sistema intenta consolidar los metadatos del estudio
             Entonces el estudio queda con estado "no_consolidado"
              Y se registra el motivo "metadatos_insuficientes"