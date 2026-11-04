# Me Toca — Dirección visual

> **Documento histórico.** Su contenido ya está integrado en `../plan-calculadoras-laborales-mx.md` (secciones 10 y 11).
> Si hay conflicto, manda el plan único. No editar este archivo.

## 1. Personalidad

**Suave pero moderno. Cálido, claro y tranquilo.**

Me Toca no es un banco ni un despacho. Es la app que te dice, sin rodeos, cuánto te toca. Debe sentirse como una libreta buena y una calculadora que sí entiendes: papel cálido, tinta suave, números grandes y una sola idea por pantalla.

| Atributo | Sí | No |
|---|---|---|
| Cálido | Fondo papel, acentos durazno | Azul corporativo, gris frío |
| Moderno | Radios grandes, aire, tipografía con carácter | Gradientes neón, glassmorphism |
| Claro | Un número protagonista, lenguaje de persona | Tablas densas, jerga fiscal sin explicar |
| Confiable | Fuente legal visible, fecha de vigencia | Promesas absolutas, “100% exacto” |
| Tranquilo | Movimiento corto, sin rebotes | Animaciones largas, confeti, ruido |

**Audiencia:** trabajadores en México de 22 a 55 años, con alfabetización digital variable, muchas veces en un momento emocional (renuncia, despido, aguinaldo que no llega). Nada de asumir que saben qué es UMA, SDI o prima vacacional.

**Momento de uso:** de pie, con una mano, con prisa, a veces con datos incompletos. Todo debe resolverse en una pantalla y en menos de un minuto.

## 2. Mood board en palabras

Papel marfil · tinta verde bosque · durazno maduro · sombra de tarde · bordes redondeados · números tabulares · una línea que explica · espacio en blanco · etiqueta pequeña en mayúsculas · sello de “vigente 2026”.

Evitar explícitamente: morado fintech, tarjetas flotantes con blur, iconos de línea mezclados con relleno, degradados decorativos, dorado “premium”.

## 3. Color

### Claro

| Token | Hex | Uso |
|---|---|---|
| `canvas` | `#FBF7F0` | Fondo general |
| `surface` | `#FFFFFF` | Tarjetas, campos, hojas |
| `surfaceAlt` | `#F4EEE3` | Bloques secundarios, chips |
| `ink` | `#1E2A24` | Texto principal |
| `inkMuted` | `#5C6B62` | Texto secundario (mín. 4.5:1) |
| `primary` | `#2F6B4F` | Acción principal, montos positivos |
| `primarySoft` | `#DCEBE2` | Fondo de selección, badges |
| `accent` | `#E98A5C` | Acento humano, foco, “te toca” |
| `accentSoft` | `#FCE7DA` | Fondo de avisos suaves |
| `border` | `#E8E0D3` | Bordes de 1 px |
| `success` | `#2F7D5B` | Confirmación |
| `warning` | `#B87333` | Falta un dato, tabla por vencer |
| `error` | `#C2453F` | Error de validación |

### Oscuro

| Token | Hex |
|---|---|
| `canvas` | `#121614` |
| `surface` | `#1A211D` |
| `surfaceAlt` | `#232C27` |
| `ink` | `#F3EEE5` |
| `inkMuted` | `#A9B5AD` |
| `primary` | `#7FC8A3` |
| `primarySoft` | `#25382F` |
| `accent` | `#F2A87E` |
| `accentSoft` | `#3A2A21` |
| `border` | `#2E3833` |

Reglas:

- Nunca negro puro ni blanco puro.
- El color no es el único portador de significado: siempre acompañar con texto o icono.
- Un solo acento por pantalla. El acento no se usa para botones secundarios.
- Nada de degradados, salvo un lavado cálido muy tenue (≤ 8% de opacidad) detrás del bloque héroe del inicio.

## 4. Tipografía

Dos familias, ambas empaquetadas para uso offline (nada de descargar fuentes en tiempo de ejecución).

| Rol | Familia | Pesos | Uso |
|---|---|---|---|
| Display | **Fraunces** (soft) | 600, 700 | Títulos de pantalla y el número resultado |
| UI | **Manrope** | 400, 500, 600, 700 | Todo lo demás |

- El monto grande va en Fraunces 700 con **cifras tabulares** (`fontFeatures: [FontFeature.tabularFigures()]`), para que no “baile” al cambiar.
- Etiquetas de sección: Manrope 600, 12 px, mayúsculas, `letterSpacing: 0.6`, color `inkMuted`.
- Cuerpo: Manrope 400/500, 15–16 px, altura de línea 1.45.
- Nunca más de dos pesos por pantalla.
- Escala: 12 · 14 · 16 · 20 · 24 · 32 · 44 · 56.

## 5. Espacio, radios y sombras

**Escala de espacio (base 4):** 4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 56.

- Margen lateral de pantalla: 20.
- Separación entre bloques: 24. Dentro de un bloque: 12.
- Alto mínimo de objetivo táctil: 48.

**Radios:**

| Token | Valor | Uso |
|---|---|---|
| `rSm` | 10 | Chips, etiquetas |
| `rMd` | 16 | Campos de texto |
| `rLg` | 24 | Tarjetas |
| `rXl` | 32 | Hoja inferior, bloque héroe |
| `rFull` | 999 | Botones tipo píldora |

**Sombras:** solo dos niveles, tintadas de verde, nunca grises.

```
sm: 0 1 2  rgba(30,42,36,0.06)
md: 0 8 24 rgba(30,42,36,0.08)
```

En modo oscuro no hay sombras: se separa con `surfaceAlt` y borde de 1 px.

## 6. Estructura de pantalla

Regla de oro: **un foco y una acción principal por pantalla.**

1. **Inicio** — saludo corto (“¿Cuánto te toca?”), cinco tarjetas con icono, nombre y una línea de qué resuelve. Sin banner dentro del área de contenido.
2. **Captura** — máximo 5 campos, agrupados de 2 en 2, con valor por defecto cuando exista. Ayuda contextual en una línea bajo el campo, no en tooltip.
3. **Resultado** — el monto como héroe (Fraunces, 44–56), una línea de contexto, desglose en filas, “¿Cómo se calculó?” y “Compartir”. Aquí **no hay anuncios**.
4. **Explicación** — fórmula en lenguaje claro, el artículo legal y un ejemplo con los números del usuario. Sin anuncios.
5. **Glosario** — lista alfabética, cada término con definición de una frase y un ejemplo.
6. **Ajustes** — tema, versión de tablas, fuentes, aviso legal, Pro.

Navegación: una sola pila. El resultado siempre se puede compartir sin cuenta. Nunca pantallas intermedias de carga ni intersticiales.

## 7. Componentes base

| Componente | Regla |
|---|---|
| `AppButton` | Píldora, 52 de alto, `primary` lleno. Secundario: contorno `border` sobre `surface`. Un solo primario por pantalla. |
| `AppCard` | `surface`, `rLg`, sombra `sm`, padding 20. Tocar toda la tarjeta, no solo el texto. |
| `AppTextField` | `rMd`, fondo `surfaceAlt`, borde que se vuelve `primary` al enfocar, sufijo “MXN” o “días”. |
| `AppMoney` | Cifras tabulares, `$` pequeño y en `inkMuted`, separador de miles, dos decimales. |
| `AppBadge` | Píldora `primarySoft`, texto `primary` 12 px. Para “Vigente 2026”. |
| `AppBanner` | Anuncio adaptativo anclado abajo, separado del contenido por 8 px. Nunca sobre el resultado. |
| `AppEmptyState` | Ilustración mínima de una línea, título y una acción. |
| `AppErrorState` | Texto humano + qué hacer. Nunca “Error 422”. |

Estados obligatorios en cada componente: normal, presionado, enfocado, deshabilitado, cargando y error. Probar con el texto más largo y con escala de fuente al 200%.

## 8. Movimiento

- Duración 160–220 ms, `easeOutCubic`. Sin rebotes, sin `elastic`.
- El monto aparece con un conteo una sola vez (300 ms). Si el sistema pide movimiento reducido, aparece directo.
- Cambios de pantalla: fundido corto + desplazamiento de 8 px.
- Nada de animaciones en loop ni shimmer decorativo.

## 9. Voz y tono

- Segunda persona: “Te tocan”, “Así se calculó”, “Revisa tu fecha de ingreso”.
- Nada de “el usuario”, “cómputo”, “conforme a la normatividad aplicable”.
- Los montos siempre con contexto: no `$8,450.00`, sino `$8,450.00 de finiquito`.
- Errores que dicen qué hacer: “La fecha de baja no puede ser anterior a la de ingreso. Corrige una de las dos.”
- El aviso legal va al final, pequeño pero legible, nunca escondido.

## 10. Accesibilidad

- Contraste mínimo 4.5:1 en texto y 3:1 en elementos gráficos.
- Todo con `Semantics`: el monto se lee como “Ocho mil cuatrocientos cincuenta pesos”.
- Escala de fuente hasta 200% sin cortes; los montos hacen wrap, no se recortan.
- Nunca comunicar solo con color.
- Área táctil mínima 48 × 48.

## 11. Icono y tienda

- Icono: monograma “MT” o una tilde dentro de una forma redondeada, sobre `primary`, con un punto `accent`. Sin calculadora genérica, sin billetes.
- Capturas: fondo `canvas`, un resultado real grande y una frase por captura. Que no se parezcan a las de “Labora”.
- Nada de texto dorado ni insignias falsas.

## 12. Lo que nunca se hace

- Anuncios en resultado, explicación o PDF.
- Modales de calificación después de un cálculo.
- Pedir cuenta, correo o conexión.
- Mostrar una tabla vencida sin avisar.
- Mezclar iconos de línea y relleno en la misma pantalla.
- Usar rojo para montos que el usuario recibe.
