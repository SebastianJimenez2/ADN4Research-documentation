# language: es
@modulo:busqueda @componente:texto_completo
Característica: Disponibilidad de texto completo de artículos
  Como investigador
  Quiero acceder al texto completo de los artículos consolidados
  Para continuar con la revisión y extracción de evidencia

        Antecedentes:
            Dada una estrategia previamente normalizada
              Y un descubrimiento previo asociado a esa estrategia
              Y existen estudios con registro canónico en estado "consolidado"

        Escenario: Texto completo obtenido exitosamente
            Dado el estudio "st-201" está "consolidado" y tiene texto completo disponible
             Cuando el sistema obtiene el texto completo del estudio
             Entonces el estudio queda con estado "texto_completo_disponible"
              Y se registra el origen del texto completo
              Y la traza indica las fuentes consultadas

        Esquema del escenario: Texto completo no disponible por diferentes motivos
            Dado el estudio "<estudio_id>" está "consolidado"
              Y el intento de obtener el texto completo falla por "<motivo>"
             Cuando el sistema registra la indisponibilidad
             Entonces el estudio queda con estado "texto_no_disponible" y motivo "<motivo>"
              Y se sugiere alternativa de reintento o carga manual

        Ejemplos:
                  | estudio_id | motivo             |
                  | st-210     | acceso_restringido |
                  | st-211     | enlace_invalido    |
                  | st-212     | embargo_editorial  |

        Escenario: Carga manual habilita disponibilidad inmediata
            Dado el estudio "st-220" está en estado "texto_no_disponible"
             Cuando el investigador aporta el archivo de texto completo
             Entonces el estudio pasa a "texto_completo_disponible"
              Y el origen del texto queda registrado como "manual"
              Y la traza conserva el motivo previo de indisponibilidad

        Escenario: Integridad inválida evita exponer el archivo
            Dado el estudio "st-230" tiene un archivo de texto completo asociado
              Y se detecta que el archivo tiene integridad inválida
             Cuando el sistema verifica la disponibilidad del texto completo
             Entonces el estudio pasa a "texto_no_disponible" con motivo "integridad_invalida"
              Y se sugiere reintento o nueva carga manual