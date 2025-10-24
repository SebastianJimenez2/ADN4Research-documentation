# language: es
@modulo:busqueda @componente:traduccion @mvp
Característica: Traducción de estrategias de búsqueda por fuente académica
  Como investigador
  Quiero que mi estrategia de búsqueda se traduzca automáticamente a la sintaxis de Scopus e IEEE Xplore
  Para ejecutar búsquedas consistentes sin aprender la sintaxis específica de cada base de datos

  Antecedentes:
    Dada una estrategia de búsqueda normalizada estructurada
    """json
    {
      "id_estrategia": "slr_ml_software_2024",
      "terminos_principales": [
        {
          "termino": "machine learning",
          "sinonimos": ["deep learning", "ML", "artificial intelligence"]
        },
        {
          "termino": "software engineering",
          "sinonimos": ["software development", "software quality"]
        },
        {
          "termino": "bug prediction",
          "sinonimos": ["defect prediction", "fault prediction"]
        }
      ],
      "exclusiones": [
        "hardware testing",
        "gaming",
        "mobile applications"
      ],
      "filtros": {
        "año": {
          "desde": 2020,
          "hasta": 2024
        }
      }
    }
    """

  Escenario: Traducción para Scopus genera sintaxis con TITLE-ABS-KEY y AND NOT
    Cuando el sistema traduce la estrategia para "Scopus"
    Entonces la consulta traducida para Scopus es
    """
    (TITLE-ABS-KEY("machine learning" OR "deep learning" OR "ML" OR "artificial intelligence")
    AND TITLE-ABS-KEY("software engineering" OR "software development" OR "software quality")
    AND TITLE-ABS-KEY("bug prediction" OR "defect prediction" OR "fault prediction"))
    AND NOT (TITLE-ABS-KEY("hardware testing") OR TITLE-ABS-KEY("gaming") OR TITLE-ABS-KEY("mobile applications"))
    AND PUBYEAR >= 2020 AND PUBYEAR <= 2024
    """
    Y el estado de la traducción es "lista"
    Y se registra la trazabilidad de la traducción

  Escenario: Traducción para IEEE Xplore genera sintaxis con NOT y Publication Year
    Cuando el sistema traduce la estrategia para "IEEE Xplore"
    Entonces la consulta traducida para IEEE Xplore es
    """
    (("machine learning" OR "deep learning" OR "ML" OR "artificial intelligence")
    AND ("software engineering" OR "software development" OR "software quality")
    AND ("bug prediction" OR "defect prediction" OR "fault prediction"))
    NOT ("hardware testing" OR "gaming" OR "mobile applications")
    AND "Publication Year": 2020-2024
    """
    Y el estado de la traducción es "lista"
    Y se registra la trazabilidad de la traducción