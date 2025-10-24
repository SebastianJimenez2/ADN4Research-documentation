# language: es
@modulo:busqueda @componente:texto-completo @mvp
Característica: Disponibilidad de texto completo de artículos
  Como investigador
  Quiero acceder al texto completo de los artículos consolidados
  Para continuar con la revisión y extracción de evidencia


  Antecedentes:
    Dada una estrategia normalizada con descubrimiento previo
    Y existen estudios con registro canónico en estado "consolidado"
    Y hay una política activa de validación de archivos (formato permitido y verificación de integridad)

  @texto-completo @exitoso
  Escenario: Obtención exitosa desde el origen editorial
    Dado el estudio "st-201" está "consolidado" y el enlace editorial ofrece texto completo
    Cuando el sistema obtiene el archivo y supera la validación de integridad
    Entonces el estudio pasa a "texto_completo_disponible"
    Y el origen del texto queda registrado como "editorial"
    Y se registra la huella de integridad del archivo
    Y la traza del intento incluye fuentes consultadas, evidencia del éxito y timestamp

  @texto-completo @manual
  Escenario: Carga manual habilita disponibilidad inmediata
    Dado el estudio "st-220" está en "texto_no_disponible"
    Y el investigador aporta un archivo de texto completo
    Cuando el sistema valida formato e integridad y adjunta el archivo al estudio
    Entonces el estudio pasa a "texto_completo_disponible"
    Y el origen del texto queda registrado como "manual"
    Y la traza conserva el motivo previo de indisponibilidad y registra la corrección con timestamp

  @texto-completo @indisponible
  Esquema del escenario: Indisponibilidad de texto completo (motivos frecuentes)
    Dado el estudio "<estudio_id>" está "consolidado"
    Y el intento de obtener el texto completo desde el origen editorial falla por "<motivo>"
    Cuando el sistema registra la indisponibilidad
    Entonces el estudio queda en "texto_no_disponible" con motivo "<motivo>"
    Y la traza del intento incluye fuentes consultadas y evidencia del fallo
    Y se sugiere "<sugerencia>" como siguiente acción

    Ejemplos:
      | estudio_id | motivo             | sugerencia           |
      | st-210     | acceso_restringido | carga_manual         |
      | st-211     | enlace_invalido    | reintento            |
      | st-212     | embargo_editorial  | esperar_fin_embargo  |




