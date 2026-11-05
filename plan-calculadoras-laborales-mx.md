# Plan de producto y construcción — Me Toca

> **Documento único de planeación.** Sirve para empezar a construir con cualquier IA o desarrollador.
> **Fecha:** 4 de noviembre de 2026
> **Estado:** Planeación cerrada. Motor y las cinco calculadoras implementados.
> **Verificación legal:** cerrada el 4 de noviembre de 2026 contra DOF, SAT, INEGI y CONASAMI. Único punto no verificable (IVA 8% fronterizo) quedó **deshabilitado por diseño**, no como pendiente.

---

## 0. Cómo usar este documento

1. Este archivo es la **fuente de verdad**. Si algo cambia, se actualiza aquí primero.
2. Las cifras legales de la sección 8 están verificadas. **No se cambian sin fuente oficial nueva.**
3. El motor se construye antes que la UI. La sección 9 es el contrato del motor.
4. La UI se construye con la sección 10 (pantallas) y la 11 (dirección visual). No se inventan estilos fuera de ahí.
5. La sección 19 trae el prompt de arranque para otra IA.

---

## 1. Ficha del proyecto

| Campo | Decisión |
|---|---|
| Producto | **Me Toca** — calculadoras laborales y fiscales para México |
| Calculadoras MVP | Aguinaldo, finiquito, vacaciones, ISR e IVA |
| Plataformas | Android (MVP) → iOS (fase 2) |
| Stack | Flutter + Riverpod + go_router |
| Backend | Ninguno. 100% local, sin cuentas |
| Modelo | Gratis con banner + Pro de pago único |
| Anuncios | AdMob, solo banner adaptativo |
| Package | `com.metoca.app` |
| Mercado inicial | México, español |
| Equipo | 1 desarrollador |
| Precio Pro | MX$79 (pago único) |

### Objetivos

1. **Fácil de usar:** calcular en menos de 60 segundos, sin manual.
2. **Fácil de comprender:** cada resultado se explica paso a paso, con fórmula y fundamento legal.
3. **Confiable:** tablas oficiales versionadas por fecha de vigencia, con fuente visible.

---

## 2. Problema y oportunidad

En México, millones de trabajadores y patrones necesitan calcular prestaciones laborales y no saben hacerlo:

- Un trabajador no sabe cuánto le toca de finiquito y acepta lo que le den.
- Alguien renunció y quiere saber su aguinaldo proporcional y vacaciones pendientes.
- Un patrón pequeño calcula nómina a mano y se equivoca con ISR o prima vacacional.
- Un contador necesita una referencia rápida para validar un cálculo.
- Un estudiante de derecho o contabilidad necesita entender el procedimiento.

Las apps existentes resuelven **una** calculadora, muestran un número sin explicación, están llenas de anuncios y muchas tienen calificaciones mediocres.

### Oportunidad

Nadie domina la categoría. Las apps más descargadas rondan las **10 mil descargas**, hay fragmentación y poca calidad percibida. Una app que reúna las cinco calculadoras, explique cada resultado, funcione sin internet, no abuse de anuncios y se vea profesional puede quedarse con la categoría.

---

## 3. Mercado (Google Play México)

**Método:** búsquedas en Play México (`hl=es`, `gl=MX`) el 4 de noviembre de 2026. Las descargas son rangos de Play, no cifras exactas.

| App | Desarrollador | Descargas | Rating | Modelo |
|---|---|---|---|---|
| Finiquito Liquidación 2026 MX | BisonTek MC | 10 mil+ | 4.0 (78) | Anuncios |
| Calculadora IVA México | DiordiApps | 10 mil+ | 4.8 (78) | Anuncios |
| Calculadora de Aguinaldo en MX | Jiovanna Manriquez | 5 mil+ | 3.8 (13) | Anuncios |
| Calculadora I.S.R. | LosDoramas | 5 mil+ | 4.0 (23) | Anuncios |
| Labora: Calculadora Laboral MX | DataEdgeMX | 1 mil+ | 5.0 (13) | Anuncios + compras |
| Calculadora SAT \| MX | SergioSkar | 1 mil+ | s/d | Anuncios |
| Tu Finiquito Mexicano | Israel Perales | 500+ | s/d | Anuncios |
| Mi Finiquito | Freelance Developer IAM | 500+ | 4.7 (12) | Anuncios |
| Calculadora Liquidación México | Misael Ladislao Lara | 100+ | s/d | Anuncios + compras |
| Calculadora ISR Confiapp | ConfiApp | 100+ | s/d | s/d |
| MiFiniquito - Calculadora LFT | studioZentry | 50+ | s/d | s/d |
| IVA Mexico - calculadora | sm development | 100+ | s/d | Anuncios + compras |
| Calculadora IVA México 2026 | Aydias | 5+ | s/d | Anuncios |
| Calc Laboral: Prestaciones | Oscar Eduardo González | 1+ | s/d | Pago ($39) |

### Conclusiones

- Existen entre **20 y 30 apps** relacionadas; ninguna supera el rango de **10 mil+**.
- Ninguna combina bien las cinco calculadoras.
- Predominan anuncios y resultados sin explicación.
- Vacaciones laborales casi no existe como categoría.
- Varias están desactualizadas o usan tablas viejas.

### Gaps a explotar

1. Explicación del resultado, no solo el número.
2. Las cinco calculadoras en una app.
3. Anuncios mínimos.
4. Funciona sin internet.
5. Diseño profesional y modo oscuro.
6. Compartir resultado en texto (Free) y PDF (Pro).
7. Base legal visible: artículo, fórmula y fecha de actualización.

---

## 4. Usuarios y momentos

| Perfil | Necesidad | Frecuencia |
|---|---|---|
| Trabajador que renuncia o es despedido | Saber cuánto le corresponde | Alta, momento crítico |
| Trabajador activo | Aguinaldo, vacaciones y salario neto | Estacional |
| Patrón o negocio pequeño | Prestaciones y retenciones | Mensual |
| Contador o RH | Validar cálculos y explicar al cliente | Recurrente |
| Estudiante | Entender cómo se calcula | Educativa |

**Momentos:** diciembre (aguinaldo), renuncia o despido (finiquito), aniversario laboral (vacaciones), cada mes (ISR), cada factura (IVA).

---

## 5. Principios de producto

1. **Un resultado, no una hoja de cálculo.** Número grande y desglose debajo.
2. **Tres pasos máximo:** datos → resultado → entender.
3. **Lenguaje de persona.** “Te tocan”, no “monto acumulado”.
4. **Siempre explicar.** “¿Cómo se calculó?” con fórmula, conceptos y artículo.
5. **Sin registro.** Abres y calculas.
6. **Sin internet.** Todo local.
7. **Sin juzgar.** No se pregunta si renunciaste para “venderte” algo.
8. **Disclaimer claro.** Herramienta de referencia, no asesoría legal.
9. **Si no hay tabla vigente, no se calcula.** Nunca un número aproximado.

---

## 6. Alcance del MVP

### Incluye

- Aguinaldo (proporcional y anual).
- Vacaciones (días por antigüedad, pendientes y prima).
- Finiquito (por tipo de separación, con desglose de finiquito y liquidación).
- ISR mensual, quincenal y semanal (tarifas oficiales 2026).
- IVA (16%, 0% y exento; agregar y desglosar). El 8% fronterizo queda detrás de un flag apagado.
- Historial local: 10 cálculos en Free, ilimitado en Pro.
- Compartir texto en Free y PDF en Pro.
- Modo claro y oscuro.
- Glosario.
- Aviso legal y versión de tablas.
- Banner discreto en Free; resultado y explicación siempre limpios.

### Fuera del MVP

- ISR anual (fase 2).
- Declaración anual, RESICO, actividad empresarial, plataformas digitales.
- IMSS, Infonavit, SAR y aportaciones.
- Nómina completa con CFDI.
- Liquidaciones de otros países.
- Cuentas, nube o sincronización.
- iOS.
- Analytics de terceros (solo Play Console y contadores locales).

---

## 7. Calculadoras — especificación funcional

> Regla general: máximo 5 campos visibles por calculadora; los extras van en “Opciones avanzadas”.

### 7.1 Aguinaldo

**Entradas**

| Campo | Tipo | Default |
|---|---|---|
| Salario mensual bruto | moneda | vacío |
| Fecha de ingreso | fecha | vacío |
| Fecha de cálculo o salida | fecha | hoy |
| Días de aguinaldo de la empresa | entero (avanzado) | 15 |

**Salidas**

- Aguinaldo proporcional.
- Días trabajados en el periodo.
- Salario diario.
- Parte exenta (30 UMA) y parte gravada.
- Pasos del cálculo.

**Reglas**

- Mínimo legal: 15 días por año (Art. 87 LFT).
- Proporcional por días laborados dentro del periodo.
- Exención: 30 UMA (Art. 93 LISR).
- Si la empresa da más días, se respeta.
- Periodo por defecto: 1 de enero al 31 de diciembre del año de la fecha de cálculo.
- Si el ingreso es posterior al 1 de enero, se cuentan solo los días desde el ingreso.

**Fórmula**

```text
días trabajados = días entre max(ingreso, inicio) y fin, contando ambos
aguinaldo = salario diario × días trabajados × días de aguinaldo / días del periodo
exento = min(aguinaldo, 30 × UMA diaria)
gravado = aguinaldo − exento
```

**Ejemplo:** ingreso 2020-01-01, periodo 2026, salario diario $500 → **$7,500.00**; exento $3,519.30; gravado $3,980.70.

---

### 7.2 Vacaciones

**Entradas**

| Campo | Tipo | Default |
|---|---|---|
| Fecha de ingreso | fecha | vacío |
| Fecha de corte | fecha | hoy |
| Salario mensual bruto | moneda | vacío |
| Días de vacaciones ya tomados | entero | 0 |

**Salidas**

- Días que corresponden por antigüedad.
- Días pendientes.
- Pago de vacaciones.
- Prima vacacional (25%).
- Total.
- Tabla de referencia de los próximos años.

**Tabla del Art. 76 LFT (reforma 2023)**

| Años cumplidos | Días |
|---|---|
| 1 | 12 |
| 2 | 14 |
| 3 | 16 |
| 4 | 18 |
| 5 | 20 |
| 6–10 | 22 |
| 11–15 | 24 |
| 16–20 | 26 |
| 21–25 | 28 |
| 26–30 | 30 |
| 31–35 | 32 |

**Fórmula**

```text
días pendientes = días por antigüedad − días tomados   (nunca menor a 0)
pago vacaciones = salario diario × días pendientes
prima vacacional = pago vacaciones × 25%
total = pago vacaciones + prima vacacional
```

**Casos límite:** menos de un año (se resuelve en finiquito); días tomados mayores a los que corresponden (pendiente 0); antigüedad mayor a 35 años (se mantiene en 32).

**Ejemplo:** año 1, salario diario $500 → 12 días, **$6,000.00**, prima **$1,500.00**, total **$7,500.00**.

---

### 7.3 Finiquito

**Entradas**

| Campo | Tipo | Default |
|---|---|---|
| Salario mensual bruto | moneda | vacío |
| Fecha de ingreso | fecha | vacío |
| Fecha de baja | fecha | hoy |
| Tipo de salida | selector | renuncia |
| Días de vacaciones tomados | entero | 0 |
| Salarios pendientes | moneda (avanzado) | $0 |

**Tipo de salida:** renuncia · despido injustificado · despido justificado · término de contrato · mutuo consentimiento.

**Conceptos**

| Concepto | Regla |
|---|---|
| Salarios devengados | Dato que captura el usuario |
| Aguinaldo proporcional | Días del año calendario / 365 × 15 × salario diario |
| Vacaciones pendientes | Derecho del año de servicio en curso × proporción / días del año de servicio − tomadas |
| Prima vacacional | 25% de las vacaciones |
| Prima de antigüedad | 12 días por año, salario topado a 2 SM |
| Indemnización | 3 meses + 20 días por año, solo despido injustificado |

**Reglas finas**

- **Prima de antigüedad en renuncia:** solo si tiene **15 años o más** (Art. 162 LFT). Con menos, $0 y se explica.
- La prima de antigüedad se paga también en despido justificado, despido injustificado, término de contrato y mutuo consentimiento.
- Salario base de la prima: salario diario **topado a 2 salarios mínimos** (general $630.08 o frontera $881.74 al día).
- Años completos + fracción proporcional. La fracción se calcula con los días del año de servicio en curso.
- La indemnización del despido injustificado es **3 meses (90 días) + 20 días por año**, con fracción proporcional.
- **Finiquito y liquidación se muestran separados.** Finiquito = prestaciones devengadas; liquidación = indemnización.
- No se calcula ISR sobre el finiquito en el MVP. Se muestra bruto y una nota.
- El resultado es estimado; puede variar por contrato, convenio o juicio.

**Ejemplo base:** renuncia, ingreso 2024-03-01, baja 2026-11-30, salario diario $500, sin vacaciones tomadas, salarios pendientes $2,300.00.

| Concepto | Monto |
|---|---|
| Salarios pendientes | $2,300.00 |
| Aguinaldo proporcional (334 días) | $6,863.01 |
| Vacaciones proporcionales (16 × 275 / 365) | $6,027.40 |
| Prima vacacional | $1,506.85 |
| Prima de antigüedad (renuncia, 2 años) | $0.00 |
| **Total finiquito** | **$16,697.26** |

**Mismo caso, despido injustificado:**

| Concepto | Monto |
|---|---|
| Finiquito | $16,697.26 |
| Prima de antigüedad (33.0411 días) | $16,520.55 |
| Indemnización (145.0685 días) | $72,534.25 |
| **Total** | **$105,752.06** |

---

### 7.4 ISR

**Entradas**

| Campo | Tipo | Default |
|---|---|---|
| Ingreso gravable del periodo | moneda | vacío |
| Periodo de pago | mensual / quincenal / semanal | mensual |

**Salidas**

- Base gravable.
- Tramo, límite inferior, excedente, cuota fija y tasa.
- ISR causado.
- Subsidio al empleo aplicado.
- ISR a retener.
- Tasa efectiva.
- Salario neto estimado (si el ingreso es bruto).

**Fórmula**

```text
buscar tramo: límite inferior ≤ ingreso ≤ límite superior
isr = cuota fija + (ingreso − límite inferior) × tasa
subsidio = monto mensual (o proporcional al periodo) si ingreso ≤ tope
isr a retener = max(0, isr − subsidio)
tasa efectiva = isr a retener / ingreso
```

**Reglas**

- Tarifa oficial del Anexo 8 RMF 2026, **verificada** (sección 8.3).
- Mensual: tabla de 30 días. Quincenal: tabla de 15 días. Semanal: tabla de 7 días. No se divide la tabla mensual.
- Subsidio: monto único mensual, **no tabla de rangos**. Ver 8.4.
- Si el ingreso supera $11,492.66 mensuales (o su equivalente proporcional), no hay subsidio.
- El subsidio no es reembolsable: solo reduce el ISR a cargo, nunca genera saldo a favor.
- No mezclar con RESICO, actividad empresarial ni ISR anual.
- Advertir que no sustituye el cálculo del patrón.

**Ejemplos**

| Ingreso | ISR causado | Subsidio | A retener |
|---|---|---|---|
| $8,222.75 | $535.65 | $535.65 | **$0.00** |
| $10,000.00 | $729.02 | $535.65 | **$193.37** |
| $11,492.66 | $891.42 | $535.65 | **$355.77** |
| $11,492.67 | $891.42 | $0.00 | **$891.42** |
| $15,000.00 | $1,402.82 | $0.00 | **$1,402.82** |
| $500,000.00 | $159,513.84 | $0.00 | **$159,513.84** |
| $7,500.00 quincenal | $709.86 | $0.00 | **$709.86** |
| $2,000.00 semanal | $134.96 | $123.34 | **$11.62** |

> El salto de $355.77 a $891.42 al cruzar $11,492.66 es real: el subsidio desaparece por completo. La app debe explicarlo.
>
> **El tope también se prorratea**, con la misma base de 30.4 días que el subsidio: quincenal $5,670.72 y semanal $2,646.34. Un ingreso arriba del tope del periodo no lleva subsidio, aunque el ISR causado sea menor. Por eso $7,500.00 quincenales se quedan en $709.86: equivalen a $15,000.00 mensuales.

---

### 7.5 IVA

**Entradas**

| Campo | Tipo | Default |
|---|---|---|
| Monto | moneda | vacío |
| Modo | agregar IVA / desglosar IVA | agregar |
| Tasa | 16% / 0% / exento | 16% |

**Salidas**

- Subtotal, IVA y total.
- Explicación de la tasa.
- Diferencia entre 0% y exento.

**Fórmulas**

```text
agregar:    iva = monto × tasa; total = monto + iva
desglosar:  base = monto × 10000 / (10000 + tasa); iva = monto − base
```

**Reglas**

- 16% general (Art. 2 LIVA).
- 0% es acto gravado con tasa cero; exento no causa IVA. Se explican distinto.
- **8% fronterizo: no se ofrece en el MVP.** El decreto de estímulos de la región fronteriza no se pudo verificar como vigente para 2026, así que no entra al motor. Ver 8.6 y la decisión en 18.
- Sin retenciones de IVA en el MVP.

**Ejemplos:** $1,000 + 16% = IVA $160.00, total $1,160.00. $1,160 desglosado = base $1,000.00, IVA $160.00. $1,000 a 0% = IVA $0.00, total $1,000.00.

---

### 7.6 Funciones transversales

- Historial local: 10 en Free, ilimitado en Pro.
- Compartir texto en Free; PDF con desglose en Pro.
- Modo oscuro.
- Glosario.
- Aviso legal y fecha de vigencia de tablas.
- Onboarding de una pantalla, sin registro.
- Banner discreto en inicio y captura; nunca en resultado, explicación o PDF.

---

## 8. Parámetros y verificación legal

> **Verificado el 4 de noviembre de 2026.** Fuentes al final de la sección.

### 8.0 Estado de verificación

| Dato | Estado | Uso en el motor |
|---|---|---|
| UMA 2025 y 2026 | Verificado (INEGI / DOF) | Activo |
| Salario mínimo 2026 general y frontera | Verificado (CONASAMI) | Activo |
| Tarifa ISR 2026 (11 tramos, 30/15/7 días) | Verificado (Anexo 8 RMF 2026) | Activo |
| Subsidio al empleo 2026 (enero y feb–dic) | Verificado (DOF 31-dic-2025) | Activo |
| Exenciones 30 y 15 UMA | Derivado de UMA verificada | Activo |
| Reglas LFT (arts. 48, 50, 76, 80, 87, 162) | Verificado (texto vigente) | Activo |
| IVA 16%, 0%, exento | Verificado (LIVA) | Activo |
| IVA 8% fronterizo | **No verificable para 2026** | **Deshabilitado** |

Regla: si un dato no está verificado, no se usa. No hay excepciones ni “valores provisionales”.

### 8.1 UMA

| Concepto | Valor | Vigencia |
|---|---|---|
| UMA diaria 2026 | **$117.31** | 1 feb 2026 – 31 ene 2027 |
| UMA mensual 2026 | **$3,566.22** | 1 feb 2026 – 31 ene 2027 |
| UMA anual 2026 | **$42,794.64** | 1 feb 2026 – 31 ene 2027 |
| UMA diaria 2025 | **$113.14** | 1 feb 2025 – 31 ene 2026 |
| UMA mensual 2025 | **$3,439.46** | 1 feb 2025 – 31 ene 2026 |
| UMA anual 2025 | **$41,273.52** | 1 feb 2025 – 31 ene 2026 |

**Ojo:** la UMA mensual es diaria × **30.4**; la anual es mensual × 12 (no diaria × 365). Por eso $42,794.64 y no $42,818.15.

### 8.2 Salario mínimo 2026

| Zona | Diario | Vigencia |
|---|---|---|
| General | **$315.04** | 1 ene 2026 |
| Zona Libre de la Frontera Norte | **$440.87** | 1 ene 2026 |

### 8.3 Tarifa mensual de ISR 2026 (Art. 96 LISR)

**Verificada contra el PDF oficial del Anexo 8 de la RMF 2026 (DOF 28-dic-2025), sección B.V.** Los 11 renglones coinciden exactamente.

| Tramo | Límite inferior | Límite superior | Cuota fija | % sobre excedente |
|---|---|---|---|---|
| 1 | $0.01 | $844.59 | $0.00 | 1.92% |
| 2 | $844.60 | $7,168.51 | $16.22 | 6.40% |
| 3 | $7,168.52 | $12,598.02 | $420.95 | 10.88% |
| 4 | $12,598.03 | $14,644.64 | $1,011.68 | 16.00% |
| 5 | $14,644.65 | $17,533.64 | $1,339.14 | 17.92% |
| 6 | $17,533.65 | $35,362.83 | $1,856.84 | 21.36% |
| 7 | $35,362.84 | $55,736.68 | $5,665.16 | 23.52% |
| 8 | $55,736.69 | $106,410.50 | $10,457.09 | 30.00% |
| 9 | $106,410.51 | $141,880.66 | $25,659.23 | 32.00% |
| 10 | $141,880.67 | $425,641.99 | $37,009.69 | 34.00% |
| 11 | $425,642.00 | en adelante | $133,488.54 | 35.00% |

La misma tabla aplica de enero a diciembre de 2026. Las tablas de 7, 10 y 15 días están en el Anexo A.

### 8.4 Subsidio al empleo 2026

**Verificado contra el DOF del 31-dic-2025.** Desde la reforma de 2024 **ya no existe tabla de rangos**: es un **monto mensual único** que se resta del ISR causado.

| Periodo | Cálculo | Monto | Tope de ingreso |
|---|---|---|---|
| Enero 2026 | 15.59% × UMA mensual 2025 ($3,439.46) | **$536.21** | $11,492.66 |
| Feb–dic 2026 | 15.02% × UMA mensual 2026 ($3,566.22) | **$535.65** | $11,492.66 |

**Reglas**

- Solo si el ingreso mensual gravable ≤ $11,492.66.
- El tope se prorratea con la misma base de 30.4 días que el subsidio: quincenal $5,670.72 y semanal $2,646.34.
- Se resta del ISR causado; si el subsidio es mayor, el ISR a retener es $0 (no hay devolución).
- Para periodos menores a un mes se prorratea: `monto mensual / 30.4 × días del periodo`. Quincenal: $264.30 (feb–dic) o $264.58 (enero). Semanal: $123.34 o $123.47.
- No se considera para primas de antigüedad, retiro, indemnizaciones ni pagos por separación.

**Aclaración importante:** el considerando del decreto menciona “$536.22” calculado con una UMA estimada. El texto operativo ordena multiplicar la UMA mensual vigente por 15.02%, lo que con la UMA publicada da **$535.65**. Se usa $535.65. **No usar $536.22 ni la tabla de rangos de años anteriores.**

### 8.5 Exenciones y topes

| Concepto | Regla | Monto 2026 |
|---|---|---|
| Exención de aguinaldo | 30 UMA diarias | $3,519.30 |
| Exención de prima vacacional y PTU | 15 UMA diarias | $1,759.65 |
| Tope de prima de antigüedad | 2 salarios mínimos generales | $630.08/día |
| Tope de prima de antigüedad (frontera) | 2 salarios mínimos de frontera | $881.74/día |

En enero de 2026 las exenciones usan UMA 2025: 30 UMA = **$3,394.20**; 15 UMA = **$1,697.10**.

### 8.6 IVA

| Tasa | Fundamento | Estado |
|---|---|---|
| 16% general | Art. 2 LIVA | Verificado |
| 8% región fronteriza | Decreto de estímulos fiscales región fronteriza | **No habilitado: vigencia 2026 no verificada** |
| 0% | Art. 2 LIVA | Verificado |
| Exento | Art. 9 LIVA | Verificado |

### 8.7 Reglas laborales (LFT)

| Concepto | Regla | Fuente |
|---|---|---|
| Aguinaldo mínimo | 15 días por año | Art. 87 |
| Vacaciones | 12 días año 1; +2 por año hasta 20; +2 cada 5 años después | Art. 76 (reforma 2023) |
| Prima vacacional | 25% sobre el salario de los días | Art. 80 |
| Prima de antigüedad | 12 días por año; tope 2 SM; en renuncia solo con 15 años | Art. 162 |
| Indemnización | 3 meses + 20 días por año | Arts. 48 y 50 |

### 8.8 Vigencias que el motor debe manejar

- **Enero 2026** usa UMA 2025 y subsidio $536.21; la tarifa de ISR y el salario mínimo ya son 2026.
- **Febrero 2026** cambia UMA y subsidio.
- Salario mínimo e ISR cambian el **1 de enero**; UMA cambia el **1 de febrero**.
- El cálculo elige parámetros por **fecha del hecho**, no por año del calendario.
- Si no existe tabla para la fecha, se devuelve error; nunca se aproxima.

### 8.9 Fuentes

| Tema | Fuente | Fecha |
|---|---|---|
| Tarifa ISR 2026 | SAT, Anexo 8 RMF 2026, sección B.V: `https://www.sat.gob.mx/minisitio/NormatividadRMFyRGCE/documentos2026/rmf/anexos/Anexo-8-RMF-2026_DOF-28122025.pdf` | DOF 28-dic-2025 |
| Subsidio al empleo | DOF, Decreto que modifica el subsidio para el empleo: `https://dof.gob.mx/nota_detalle.php?codigo=5777649&fecha=31/12/2025` | DOF 31-dic-2025 |
| UMA 2026 | INEGI, valor publicado el 8-ene-2026; DOF 9-ene-2026 | Vigente 1-feb-2026 |
| Salario mínimo 2026 | CONASAMI, “Incremento a los Salarios Mínimos para 2026” | 3-dic-2025 |
| LFT | Arts. 48, 50, 76, 80, 87, 162 | Vigente |
| LISR | Arts. 93, 96 | Vigente |
| LIVA | Arts. 2, 9 | Vigente |

---

## 9. Motor de cálculo

### 9.1 Principios

1. **Dart puro.** Sin Flutter, sin red, sin almacenamiento.
2. **Dinero en centavos (`int`).** Nunca `double`.
3. **Parámetros por fecha de vigencia.**
4. **Cero constantes legales dentro de las fórmulas.**
5. **Cada resultado devuelve pasos explicables.**
6. **Determinista.** Sin `DateTime.now()` dentro del motor.
7. **Si falta tabla, error tipado.**

### 9.2 Dinero y redondeo

- `Money(cents)`, inmutable.
- Tasas en **puntos base**: 16% = 1600, 25% = 2500, 1.92% = 192.
- Redondeo **half-up al centavo**, una sola vez por concepto.
- Los totales suman los conceptos **ya redondeados**.
- El motor no formatea moneda; la UI decide el formato.
- Para proporcionales: `monto = valor × numerador / denominador` en una sola operación, sin redondear días intermedios.

### 9.3 Fechas

- `DateTime.utc(a, m, d)` a medianoche.
- Días trabajados contando ambos extremos: 1 ene–31 dic = 365.
- Año bisiesto: 366 solo si el periodo completo es bisiesto.
- Aguinaldo: año calendario. Vacaciones y prima de antigüedad: año de servicio (aniversario).

### 9.4 Modelo de datos

```text
LegalParameters
  id                  "2026-01" | "2026-02"
  validFrom           DateTime
  validTo             DateTime
  uma                 { daily, monthly, annual }        // centavos
  minimumWage         { general, border }              // centavos
  isrMonthly          List<IsrBracket>                 // 30 días
  isrFifteenDay       List<IsrBracket>                 // 15 días
  isrSevenDay         List<IsrBracket>                 // 7 días
  subsidyMonthly      int                              // centavos
  subsidyIncomeCap    int                              // centavos
  aguinaldoMinDays    15
  borderStimulusActive false   // IVA 8%: apagado hasta verificar decreto
  vacationPremiumBp   2500
  primaAntiguedadDays 12
  primaAntiguedadCap  2
  source              String
  verified            bool
```

```text
IsrBracket
  lower     Money
  upper     Money?      // null en el último
  fixed     Money
  rateBp    int
```

**Juegos de parámetros**

| id | validFrom | validTo | UMA | Subsidio |
|---|---|---|---|---|
| 2026-01 | 2026-01-01 | 2026-01-31 | 2025 | $536.21 |
| 2026-02 | 2026-02-01 | 2026-12-31 | 2026 | $535.65 |

Salario mínimo e ISR son los mismos en ambos. Solo cambian UMA, exenciones y subsidio.

### 9.5 API pública

```text
ParameterRepository.forDate(date) -> CalcOutcome<LegalParameters>

calculateAguinaldo(AguinaldoInput, LegalParameters) -> CalcOutcome<AguinaldoResult>
calculateVacaciones(VacacionesInput, LegalParameters) -> CalcOutcome<VacacionesResult>
calculateFiniquito(FiniquitoInput, LegalParameters) -> CalcOutcome<FiniquitoResult>
calculateIsr(IsrInput, LegalParameters) -> CalcOutcome<IsrResult>
calculateIva(IvaInput) -> CalcOutcome<IvaResult>
```

Cada resultado incluye `List<CalcStep>` con `label`, `detail` (en palabras) y `amount`.

### 9.6 Errores

| Código | Cuándo |
|---|---|
| `invalidInput` | Fechas invertidas, salario ≤ 0, días negativos |
| `noParametersForDate` | No hay tabla para la fecha |
| `unverifiedParameters` | La tabla existe pero no está verificada |
| `unsupportedPeriod` | Periodo de pago no soportado |

Mensajes humanos:

- “La fecha de baja no puede ser anterior a la de ingreso.”
- “Escribe un salario mayor a cero.”
- “Todavía no tenemos las tablas de ese año. Revisa la fecha.”

### 9.7 Matriz de pruebas

**Aguinaldo**

| Caso | Datos | Esperado |
|---|---|---|
| Año completo | Ingreso 2020-01-01, periodo 2026, SD $500 | $7,500.00; exento $3,519.30; gravado $3,980.70 |
| Proporcional | Ingreso 2026-07-01, periodo 2026, SD $500 | 184 días; $3,780.82 |
| Un día | Ingreso 2026-12-31, SD $500 | $20.55 |
| Contrato 20 días | Año completo, SD $500 | $10,000.00 |
| Enero | Año completo, SD $500 | exento $3,394.20; gravado $4,105.80 |

**Vacaciones**

| Caso | Datos | Esperado |
|---|---|---|
| Año 1 | SD $500 | 12 días; $6,000.00; prima $1,500.00 |
| Año 10 | SD $500 | 22 días; $11,000.00 |
| Año 11 | SD $500 | 24 días |
| Año 25 | SD $500 | 28 días |
| Año 31 | SD $500 | 32 días |
| Tomados 5 | Año 1, SD $500 | 7 días; $3,500.00; prima $875.00 |

**Finiquito**

| Caso | Datos | Esperado |
|---|---|---|
| Renuncia | 2024-03-01 a 2026-11-30, SD $500, pendientes $2,300 | $16,697.26 |
| Despido injustificado | Mismo caso | $105,752.06 |
| Renuncia con 15+ años | Prima de antigüedad sí aplica | 12 días/año topados |
| Renuncia con <15 años | Prima de antigüedad | $0.00 |

**ISR**

| Caso | Entrada | Esperado |
|---|---|---|
| Sin retención | $8,222.75 | $0.00 |
| Tramo 3 | $10,000.00 | $193.37 |
| Tope de subsidio | $11,492.66 | $355.77 |
| Cliff | $11,492.67 | $891.42 |
| Tramo 5 | $15,000.00 | $1,402.82 |
| Último tramo | $500,000.00 | $159,513.84 |
| Quincenal | $7,500.00 | $709.86 |
| Semanal | $2,000.00 | $11.62 |

**IVA**

| Caso | Entrada | Esperado |
|---|---|---|
| General | $1,000.00 | IVA $160.00; total $1,160.00 |
| Desglose | $1,160.00 | base $1,000.00; IVA $160.00 |
| Cero | $1,000.00 | IVA $0.00; total $1,000.00 |
| Cero | $1,000.00 | IVA $0.00; total $1,000.00 |
| Exento | $1,000.00 | sin IVA; total $1,000.00 |
| Frontera apagada | 8% solicitado | Opción no disponible (`borderStimulusActive: false`) |

**Parámetros**

| Fecha | Esperado |
|---|---|
| 2026-01-15 | 2026-01 |
| 2026-02-01 | 2026-02 |
| 2026-12-31 | 2026-02 |
| 2025-12-31 | error |
| 2027-01-01 | error |

---

## 10. Experiencia de usuario

### 10.1 Flujo

```text
Inicio → Calculadora → Resultado → Explicación
                  ↘ Historial
Inicio → Ajustes → Pro / Fuentes / Privacidad
```

Sin pantallas intermedias de carga. Resultado en menos de un segundo.

### 10.2 Pantallas

#### Inicio

- Título: “¿Cuánto te toca?”
- Subtítulo: “Calcula lo que te corresponde. Sin registro.”
- Cinco tarjetas con icono, nombre y una línea:
  - **Aguinaldo** — “Lo que te toca en diciembre.”
  - **Finiquito** — “Si renuncias o te despiden.”
  - **Vacaciones** — “Días y prima vacacional.”
  - **ISR** — “Lo que te retienen del sueldo.”
  - **IVA** — “Agrega o desglosa el IVA.”
- Accesos a historial y ajustes en la barra superior.
- Banner al fondo, fuera del área de contenido.

#### Captura (común)

- Barra superior con regreso y título de la calculadora.
- Campos agrupados de 2 en 2, margen lateral 20.
- Ayuda contextual en una línea bajo el campo.
- Botón primario fijo abajo: “Calcular”.
- Validación al enviar; el primer error recibe foco.
- Sin anuncios que tapen campos.

#### Resultado (común)

- Héroe: “Te tocan” + monto en Fraunces 44–56 + contexto (“de finiquito”).
- Subline: “Cálculo estimado con las tablas de 2026.”
- Desglose en filas con concepto y monto.
- Botón secundario “¿Cómo se calculó?”.
- Acción “Compartir” (texto en Free, PDF en Pro).
- Aviso legal al final, pequeño pero legible.
- **Sin anuncios.**

#### Explicación

- Fórmula en palabras.
- Pasos con los números del usuario.
- Tarjeta “Fundamento” con artículo y fuente.
- “Qué no incluye”.
- **Sin anuncios.**

#### Historial

- Agrupado por mes.
- Cada fila: tipo, fecha y monto.
- Deslizar para borrar.
- En Free, aviso al llegar a 10: “Guarda hasta 10 cálculos. Pro los guarda todos.”
- Estado vacío con acción para calcular.

#### Glosario

- Lista alfabética.
- Cada término: definición de una frase y ejemplo.
- Términos: UMA, salario diario, SDI, prima vacacional, prima de antigüedad, gravado, exento, tasa marginal, tasa efectiva, finiquito, liquidación, ISR, IVA.

#### Ajustes

- Apariencia: sistema / claro / oscuro.
- Zona salarial: general / frontera.
- Tablas: “2026, vigente desde el 1 de febrero” + enlace a fuentes.
- Privacidad, términos, licencias.
- Pro: comprar o restaurar.
- Versión.

#### Pro

- Titular: “Me Toca Pro. Una vez. Para siempre.”
- Beneficios: sin anuncios, PDF con desglose, historial ilimitado, escenarios guardados.
- Precio MX$79.
- “Comprar una vez” y “Restaurar compra”.
- Sin suscripción, sin cuenta.

### 10.3 Copy

- Segunda persona: “Te tocan”, “Así se calculó”, “Revisa tu fecha de ingreso”.
- Montos con contexto: “$8,450.00 de finiquito”.
- Errores que dicen qué hacer.
- Nada de “el usuario”, “cómputo”, “conforme a la normatividad”.
- El aviso legal nunca se esconde.

### 10.4 Estados

Cada pantalla define: normal, cargando (solo compra/PDF), vacío (historial), error de validación, error de tabla y sin conexión (la app funciona igual; solo la compra y los anuncios la necesitan).

### 10.5 Anuncios

- Solo banner adaptativo anclado abajo.
- Sí: inicio y captura.
- No: resultado, explicación, PDF, Pro.
- Consentimiento UMP al primer arranque.
- Anuncios de prueba en desarrollo.
- Al comprar Pro, el banner desaparece de inmediato y no vuelve tras restaurar.

---

## 11. Dirección visual

### 11.1 Personalidad

**Suave pero moderno. Cálido, claro y tranquilo.**

No es un banco ni un despacho. Es una libreta buena y una calculadora que sí entiendes: papel cálido, tinta suave, números grandes y una sola idea por pantalla.

| Atributo | Sí | No |
|---|---|---|
| Cálido | Fondo papel, acentos durazno | Azul corporativo, gris frío |
| Moderno | Radios grandes, aire, tipografía con carácter | Gradientes neón, glassmorphism |
| Claro | Un número protagonista, lenguaje de persona | Tablas densas, jerga sin explicar |
| Confiable | Fuente legal visible, fecha de vigencia | Promesas absolutas |
| Tranquilo | Movimiento corto, sin rebotes | Animaciones largas, confeti |

**Audiencia:** 22–55 años, alfabetización digital variable, muchas veces en un momento emocional. Nada de asumir que saben qué es UMA o SDI.

**Momento de uso:** de pie, con una mano, con prisa, a veces con datos incompletos. Todo en una pantalla y en menos de un minuto.

### 11.2 Mood board en palabras

Papel marfil · tinta verde bosque · durazno maduro · sombra de tarde · bordes redondeados · números tabulares · una línea que explica · espacio en blanco · etiqueta pequeña en mayúsculas · sello de “vigente 2026”.

Evitar: morado fintech, tarjetas con blur, iconos de línea mezclados con relleno, degradados decorativos, dorado “premium”.

### 11.3 Color

**Claro**

| Token | Hex | Uso |
|---|---|---|
| `canvas` | `#FBF7F0` | Fondo general |
| `surface` | `#FFFFFF` | Tarjetas, campos, hojas |
| `surfaceAlt` | `#F4EEE3` | Bloques secundarios, chips |
| `ink` | `#1E2A24` | Texto principal |
| `inkMuted` | `#5C6B62` | Texto secundario (mín. 4.5:1) |
| `primary` | `#2F6B4F` | Acción principal, montos positivos |
| `primarySoft` | `#DCEBE2` | Selección, badges |
| `accent` | `#E98A5C` | Acento humano, foco |
| `accentSoft` | `#FCE7DA` | Avisos suaves |
| `border` | `#E8E0D3` | Bordes de 1 px |
| `success` | `#2F7D5B` | Confirmación |
| `warning` | `#B87333` | Falta un dato, tabla por vencer |
| `error` | `#C2453F` | Error de validación |

**Oscuro**

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

Reglas: nunca negro ni blanco puros; un solo acento por pantalla; el color nunca es el único mensaje; sin degradados salvo un lavado cálido ≤ 8% detrás del héroe del inicio.

### 11.4 Tipografía

| Rol | Familia | Pesos | Uso |
|---|---|---|---|
| Display | **Fraunces** (soft) | 600, 700 | Títulos y monto resultado |
| UI | **Manrope** | 400, 500, 600, 700 | Todo lo demás |

- Monto grande en Fraunces 700 con **cifras tabulares**.
- Etiquetas de sección: Manrope 600, 12 px, mayúsculas, `letterSpacing: 0.6`, `inkMuted`.
- Cuerpo: Manrope 400/500, 15–16 px, altura 1.45.
- Máximo dos pesos por pantalla.
- Escala: 12 · 14 · 16 · 20 · 24 · 32 · 44 · 56.
- Fuentes empaquetadas en `assets/fonts/`; nada de `google_fonts` en runtime.

### 11.5 Espacio, radios y sombras

**Espacio (base 4):** 4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 56.
Margen lateral 20; entre bloques 24; dentro de bloque 12; objetivo táctil mínimo 48.

| Radio | Valor | Uso |
|---|---|---|
| `rSm` | 10 | Chips |
| `rMd` | 16 | Campos |
| `rLg` | 24 | Tarjetas |
| `rXl` | 32 | Héroe y hoja inferior |
| `rFull` | 999 | Botones píldora |

**Sombras:** solo dos, tintadas de verde.

```text
sm: 0 1 2  rgba(30,42,36,0.06)
md: 0 8 24 rgba(30,42,36,0.08)
```

En oscuro no hay sombras: se separa con `surfaceAlt` y borde de 1 px.

### 11.6 Componentes

| Componente | Regla |
|---|---|
| `AppButton` | Píldora, 52 de alto, `primary` lleno. Secundario: contorno. Un primario por pantalla. |
| `AppCard` | `surface`, `rLg`, sombra `sm`, padding 20. Toda la tarjeta es táctil. |
| `AppTextField` | `rMd`, fondo `surfaceAlt`, borde `primary` al enfocar, sufijo “MXN” o “días”. |
| `AppMoney` | Cifras tabulares, `$` pequeño en `inkMuted`, miles y dos decimales. |
| `AppBadge` | Píldora `primarySoft`, texto `primary` 12 px. |
| `AppBanner` | Banner adaptativo abajo, separado 8 px del contenido. |
| `AppEmptyState` | Ilustración mínima, título y una acción. |
| `AppErrorState` | Texto humano + qué hacer. |

Estados obligatorios: normal, presionado, enfocado, deshabilitado, cargando, error. Probar con el texto más largo y fuente al 200%.

### 11.7 Movimiento

- 160–220 ms, `easeOutCubic`. Sin rebotes.
- Conteo del monto una vez (300 ms) solo si el sistema no pide movimiento reducido.
- Cambio de pantalla: fundido + desplazamiento de 8 px.
- Nada en loop.

### 11.8 Accesibilidad

- Contraste 4.5:1 texto y 3:1 gráficos.
- `Semantics` en montos: “Ocho mil cuatrocientos cincuenta pesos”.
- Escala de fuente al 200% sin recortes; los montos hacen wrap.
- Nunca comunicar solo con color.
- Objetivo táctil 48 × 48.

### 11.9 Icono y tienda

- Icono: monograma “MT” o una tilde dentro de una forma redondeada, sobre `primary`, con un punto `accent`. Sin calculadora genérica, sin billetes.
- Capturas: fondo `canvas`, un resultado real grande y una frase por captura. Que no se parezcan a las de “Labora”.
- Nada de texto dorado ni insignias falsas.

---

## 12. Arquitectura técnica

### 12.1 Stack

| Pieza | Elección | Por qué |
|---|---|---|
| Framework | Flutter 3.47+ / Dart 3.13+ | Ya instalado, Android-first |
| Estado | `flutter_riverpod` | Simple, testeable, sin boilerplate |
| Rutas | `go_router` | Declarativo, deep links después |
| Persistencia | `shared_preferences` (JSON) | Historial y ajustes pequeños, sin DB |
| Compras | `in_app_purchase` | Paquete oficial de Flutter |
| Anuncios | `google_mobile_ads` + UMP | Estándar de Google |
| PDF | `pdf` + `printing` / `share_plus` | PDF local y compartir |
| Fechas | `intl` | Formato es-MX |
| Fuentes | assets locales | Offline real |

**Sin:** backend, Firebase, analytics de terceros, login, base de datos remota.

### 12.2 Estructura

```text
me-toca/
  app/
    lib/
      main.dart
      app/
        router.dart
        theme/
          app_colors.dart
          app_typography.dart
          app_spacing.dart
          app_radii.dart
          app_shadows.dart
          theme.dart
      core/
        format/money_format.dart
        legal/parameter_repository.dart
        storage/history_repository.dart
        storage/settings_repository.dart
        purchases/pro_controller.dart
        ads/ad_service.dart
        sharing/share_service.dart
        pdf/pdf_service.dart
      features/
        home/
        aguinaldo/
        finiquito/
        vacaciones/
        isr/
        iva/
        result/
        explanation/
        history/
        glossary/
        settings/
        paywall/
      shared/
        widgets/
        models/
    assets/
      fonts/
      icon/
    test/
    integration_test/
  packages/
    calc_engine/
      lib/
        calc_engine.dart
        src/
          money.dart
          dates.dart
          parameters.dart
          result.dart
          calculators/
          tables/
      test/
```

### 12.3 Dependencias

| Paquete | Uso | Justificación |
|---|---|---|
| `flutter_riverpod` | Estado | Testeable, sin magia |
| `go_router` | Navegación | Una pila, deep links |
| `shared_preferences` | Historial y ajustes | Suficiente para < 1,000 registros |
| `in_app_purchase` | Pro | Oficial |
| `google_mobile_ads` | Banner + UMP | Único proveedor |
| `pdf` | Documento | Local |
| `printing` | Compartir/imprimir PDF | Integración nativa |
| `share_plus` | Compartir texto | Estándar |
| `intl` | Fechas es-MX | Localización |
| `url_launcher` | Fuentes y privacidad | Abrir enlaces |

No agregar paquetes sin justificarlo aquí.

### 12.4 Datos locales

```text
settings
  theme: system | light | dark
  zone: general | border
  pro: bool
  consentDone: bool

history
  id, type, date, inputSummary, amount, paramsId
```

- Historial máximo 10 en Free; en Pro sin límite.
- Borrar todo desde ajustes.
- Nada sale del teléfono.

### 12.5 Sin backend

- Cálculo y datos en el dispositivo.
- La compra se valida con Google Play; se guarda el recibo localmente.
- Restaurar compra disponible siempre.

### 12.6 CI

GitHub Actions:

```text
flutter analyze
flutter test
flutter build apk --release
```

- Keystore fuera del repo.
- Play App Signing.
- Reporte de tamaño del APK.

---

## 13. Modelo de negocio

| Plan | Qué incluye | Precio |
|---|---|---|
| **Gratis** | Las cinco calculadoras, explicaciones, modo oscuro, historial de 10 y compartir texto. Con banner | $0 |
| **Pro** | Sin anuncios, PDF con desglose, historial ilimitado, escenarios guardados | **MX$79 pago único** |

### Reglas

- **Sin suscripción.** Es una utilidad de uso ocasional.
- **Pro no bloquea calculadoras.** Todo lo esencial es gratis.
- **Restaurar compra** obligatorio.
- **El PDF es el gancho de Pro.**
- Validar precio en beta; ajustar solo con datos.

### Por qué no solo anuncios

El eCPM en México es bajo. Con 10 mil usuarios activos, el ingreso por anuncios es de decenas de dólares al mes. Los anuncios en una app de dinero reducen la confianza justo cuando se calcula un finiquito.

### Por qué no solo pago

La categoría está acostumbrada al gratis con anuncios. Cobrar desde el inicio limita las descargas y el ASO necesita volumen.

---

## 14. Legal y privacidad

- **Aviso visible:** “Herramienta de referencia. No sustituye asesoría legal, contable ni la determinación de la autoridad.”
- **Fuente por concepto:** artículo, decreto y fecha de última actualización.
- **No usar sellos oficiales** ni logos de SAT, STPS o IMSS.
- **No prometer exactitud absoluta.**
- **Política de privacidad publicada**, aunque no se recolecten datos.
- **Sin permisos innecesarios.**
- **Anuncios:** declarar “contiene anuncios” y la recolección de datos de AdMob; enlazar la política de Google.
- **Datos de ejemplo** claramente marcados.

### Privacidad y Play

- No se piden cuentas, correo ni ubicación.
- AdMob recolecta identificadores del dispositivo para anuncios.
- UMP para consentimiento; en México no es obligatorio, pero se implementa.
- Data safety: “Device or other IDs” sí (anuncios); “App activity” no; “Location” no.
- Enlace a la política de privacidad en la ficha y en ajustes.

### Riesgos legales

| Riesgo | Mitigación |
|---|---|
| Tabla vieja | Versionado, aviso de vigencia, pruebas por fecha |
| Usuario toma el resultado como definitivo | Disclaimer en resultado, PDF y tienda |
| Reclamo por “asesoría” | Lenguaje de referencia, no de dictamen |
| Uso de marcas del gobierno | Sin escudos ni nombres oficiales |
| Datos personales | No se recolectan; política clara |

---

## 15. Roadmap

| Fase | Entregable | Estimación |
|---|---|---|
| **0** | Identidad, prototipo de 3 pantallas, proyecto Flutter | 1 semana |
| **1** | Motor: dinero, fechas, parámetros, aguinaldo, vacaciones, IVA | 2–3 semanas |
| **2** | Finiquito e ISR con tablas 2026 | 2–3 semanas |
| **3** | UI completa, resultados explicados, glosario | 2–3 semanas |
| **4** | PDF, compartir, modo oscuro, ajustes, anuncios y Pro | 2 semanas |
| **5** | Beta cerrada, correcciones, ficha de Play | 1–2 semanas |
| **MVP** | Android en beta pública | **10–15 semanas** |
| **Fase 2** | ISR anual + iOS | 4–6 semanas |

---

## 16. QA y definición de MVP terminado

### Pruebas

- Unitarias del motor: toda la matriz de 9.7.
- Widget: cada pantalla en claro y oscuro, fuente al 200%, texto largo.
- Integración: compra simulada, restaurar, historial lleno.
- Manual: 10 cálculos reales contra casos conocidos.
- Dispositivos: un gama baja Android 10+, un gama media, un gama alta.

### Definition of Done

1. Las cinco calculadoras funcionan con tablas 2026 y fuentes visibles.
2. Cada resultado muestra desglose y explicación.
3. La app funciona sin internet y sin registro.
4. Compartir texto en Free y PDF en Pro.
5. Banner en Free y compra Pro sin anuncios, con restauración.
6. Modo oscuro.
7. Aviso legal y política de privacidad publicados.
8. Pruebas unitarias de todos los casos límite.
9. Sin `double` para dinero.
10. Publicada en Play en beta cerrada.

---

## 17. Riesgos del proyecto

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| Tablas fiscales desactualizadas | Alta | Alto | Versionado por fecha, revisión cada enero y febrero |
| Competencia con más recursos | Media | Medio | Claridad y las cinco calculadoras |
| Estacionalidad | Alta | Medio | Campañas en diciembre y temporada de renuncias |
| Baja conversión a Pro | Media | Medio | Free útil; Pro por comodidad |
| Reclamo legal por un cálculo | Baja | Alto | Disclaimer, fuentes y pruebas |
| ASO difícil por “calculadora” | Media | Medio | Posicionar “finiquito México”, “aguinaldo proporcional” |
| Cambio de reforma laboral | Media | Medio | Motor separado de la UI |
| Nombre poco distintivo | Alta | Medio | Icono y capturas distintos; ASO específico |
| Anuncios que ahuyentan | Media | Medio | Solo banner, nunca en resultado; Pro sin anuncios |

---

## 18. Decisiones y pendientes

### Tomadas

1. **Nombre:** Me Toca. Package `com.metoca.app`.
2. **Marca:** no se registra. Se acepta el riesgo; se diferencia por icono, capturas y ASO.
3. **ISR:** mensual, quincenal y semanal en el MVP; anual en fase 2.
4. **Modelo:** gratis con banner + Pro MX$79 pago único.
5. **Pro:** sin anuncios, PDF, historial ilimitado, escenarios.
6. **Historial:** 10 en Free, ilimitado en Pro.
7. **Anuncios:** AdMob, solo banner adaptativo.
8. **Parámetros 2026:** verificados (sección 8).
9. **Subsidio:** monto único, no tabla de rangos.
10. **Idioma:** solo español en el MVP.
11. **Analytics:** ninguno de terceros; solo Play Console y contadores locales.
12. **Zona salarial:** selección manual en ajustes (general por defecto).
13. **IVA 8% fronterizo:** no se ofrece en el MVP. El decreto de estímulos de la región fronteriza no se pudo verificar para 2026. El motor declara `IvaRate.border` pero lo deja tras `borderStimulusActive: false`; se activa solo con decreto vigente verificado y su propia prueba. Ningún valor legal sin verificar llega a un resultado.

### Pendientes antes de publicar

1. **Package libre:** confirmar `com.metoca.app` en Play Console.
2. **Aviso de privacidad:** redactar y publicar URL.
3. **UMP:** configurar mensaje de consentimiento en AdMob.
4. **Play Console:** marcar “contiene anuncios” y llenar Data safety.
5. **Precio:** validar MX$79 en beta.
6. **Prima de antigüedad proporcional:** confirmar criterio con un abogado laboral antes de publicar el finiquito. La propuesta es pagar fracción proporcional y explicarlo.
7. **Tablas 2027:** preparar el juego de parámetros en enero de 2027; UMA en febrero.
8. **Decreto fronterizo:** si aparece uno vigente para 2026, verificarlo y activar el 8% con prueba nueva.

---

## 19. Handoff para la IA

Copia esto como primer mensaje:

```text
Actúa como ingeniero Flutter senior. Vamos a construir "Me Toca", una app
Android de calculadoras laborales y fiscales para México.

Lee completo el archivo plan-calculadoras-laborales-mx.md. Es la fuente de
verdad. No cambies ninguna cifra legal de la sección 8 sin una fuente oficial
nueva. No inventes estilos fuera de la sección 11.

Orden de trabajo:
1. Crea el proyecto Flutter en me-toca/app y el paquete Dart puro en
   me-toca/packages/calc_engine.
2. Implementa primero el motor y haz que pasen todas las pruebas de la
   sección 9.7. Nada de UI hasta que el motor esté en verde.
3. Implementa el tema y los componentes base de la sección 11.
4. Implementa las pantallas de la sección 10, empezando por inicio,
   aguinaldo, resultado y explicación.
5. Agrega historial, ajustes, IVA, vacaciones, finiquito e ISR.
6. Agrega anuncios, compra Pro, PDF y compartir al final.

Reglas:
- Dinero en centavos (int), nunca double.
- Parámetros por fecha de vigencia, no por año.
- Si no hay tabla para la fecha, error; nunca aproximar.
- Cada resultado devuelve pasos explicables.
- Sin backend, sin cuentas, sin analytics de terceros.
- Español de México en la UI; identificadores y comentarios en inglés.
- Ejecuta flutter analyze y flutter test antes de dar algo por terminado.

Empieza creando la estructura y el motor. Pregúntame solo si falta una
decisión de producto; para lo técnico, decide y documenta.
```

### Orden exacto de implementación

1. `calc_engine`: `Money`, fechas, `LegalParameters`, tablas 2026-01 y 2026-02.
2. Aguinaldo + pruebas.
3. Vacaciones + pruebas.
4. IVA + pruebas.
5. Finiquito + pruebas.
6. ISR + pruebas.
7. Tema y tokens.
8. Inicio, aguinaldo, resultado, explicación.
9. Vacaciones, IVA, finiquito, ISR.
10. Historial, ajustes, glosario.
11. Pro, anuncios, PDF, compartir.
12. Beta.

### Reglas para no romper el producto

- No poner anuncios en resultado, explicación ni PDF.
- No pedir registro.
- No usar tablas viejas “porque se ven parecidas”.
- No redondear el total en vez de los conceptos.
- No mostrar un número sin explicación.
- No usar `Colors.blue` ni el template por defecto.
- No agregar dependencias sin justificarlas en la sección 12.3.

---

## Anexo A. Tarifas ISR 2026

### A.1 Mensual (30 días) — Art. 96

| Límite inferior | Límite superior | Cuota fija | % excedente |
|---|---|---|---|
| 0.01 | 844.59 | 0.00 | 1.92 |
| 844.60 | 7,168.51 | 16.22 | 6.40 |
| 7,168.52 | 12,598.02 | 420.95 | 10.88 |
| 12,598.03 | 14,644.64 | 1,011.68 | 16.00 |
| 14,644.65 | 17,533.64 | 1,339.14 | 17.92 |
| 17,533.65 | 35,362.83 | 1,856.84 | 21.36 |
| 35,362.84 | 55,736.68 | 5,665.16 | 23.52 |
| 55,736.69 | 106,410.50 | 10,457.09 | 30.00 |
| 106,410.51 | 141,880.66 | 25,659.23 | 32.00 |
| 141,880.67 | 425,641.99 | 37,009.69 | 34.00 |
| 425,642.00 | en adelante | 133,488.54 | 35.00 |

### A.2 Quincenal (15 días)

| Límite inferior | Límite superior | Cuota fija | % excedente |
|---|---|---|---|
| 0.01 | 416.70 | 0.00 | 1.92 |
| 416.71 | 3,537.15 | 7.95 | 6.40 |
| 3,537.16 | 6,216.15 | 207.75 | 10.88 |
| 6,216.16 | 7,225.95 | 499.20 | 16.00 |
| 7,225.96 | 8,651.40 | 660.75 | 17.92 |
| 8,651.41 | 17,448.75 | 916.20 | 21.36 |
| 17,448.76 | 27,501.60 | 2,795.25 | 23.52 |
| 27,501.61 | 52,505.25 | 5,159.70 | 30.00 |
| 52,505.26 | 70,006.95 | 12,660.75 | 32.00 |
| 70,006.96 | 210,020.70 | 18,261.30 | 34.00 |
| 210,020.71 | en adelante | 65,866.05 | 35.00 |

### A.3 Semanal (7 días)

| Límite inferior | Límite superior | Cuota fija | % excedente |
|---|---|---|---|
| 0.01 | 194.46 | 0.00 | 1.92 |
| 194.47 | 1,650.67 | 3.71 | 6.40 |
| 1,650.68 | 2,900.87 | 96.95 | 10.88 |
| 2,900.88 | 3,372.11 | 232.96 | 16.00 |
| 3,372.12 | 4,037.32 | 308.35 | 17.92 |
| 4,037.33 | 8,142.75 | 427.56 | 21.36 |
| 8,142.76 | 12,834.08 | 1,304.45 | 23.52 |
| 12,834.09 | 24,502.45 | 2,407.86 | 30.00 |
| 24,502.46 | 32,669.91 | 5,908.35 | 32.00 |
| 32,669.92 | 98,009.66 | 8,521.94 | 34.00 |
| 98,009.67 | en adelante | 30,737.49 | 35.00 |

---

## Anexo B. Glosario

| Término | Definición |
|---|---|
| **UMA** | Unidad de Medida y Actualización. Referencia en pesos para multas, topes y exenciones. Cambia el 1 de febrero. |
| **Salario diario** | Salario mensual / 30 (o el que corresponda por jornada). |
| **SDI** | Salario diario integrado: salario diario + prestaciones. Fuera del MVP. |
| **Aguinaldo** | Prestación anual mínima de 15 días de salario. |
| **Prima vacacional** | 25% adicional sobre el salario de los días de vacaciones. |
| **Prima de antigüedad** | 12 días de salario por año, con tope de 2 salarios mínimos. |
| **Finiquito** | Prestaciones devengadas al terminar la relación laboral. |
| **Liquidación** | Indemnización por despido injustificado: 3 meses + 20 días por año. |
| **Gravado** | Parte del ingreso que causa impuesto. |
| **Exento** | Parte del ingreso que no causa impuesto. |
| **Tasa marginal** | Porcentaje del tramo que aplica al excedente. |
| **Tasa efectiva** | ISR a retener dividido entre el ingreso. |
| **ISR** | Impuesto sobre la Renta. |
| **IVA** | Impuesto al Valor Agregado. |

---

## Anexo C. Búsquedas de mercado

| Término | Apps relevantes |
|---|---|
| calculadora aguinaldo | Calculadora de Aguinaldo en MX (5 mil+), genéricas |
| calculadora finiquito | Finiquito Liquidación 2026 MX (10 mil+), Tu Finiquito Mexicano (500+), Mi Finiquito (500+), MiFiniquito LFT (50+) |
| calculadora laboral mexico | Labora MX (1 mil+), Calculadora Laboral, Liquidación México (100+), Calc Laboral ($39), Calculadora SAT MX (1 mil+) |
| calculadora vacaciones | Solo cuentas regresivas; ninguna laboral clara |
| calculadora isr | Calculadora I.S.R. (5 mil+), ISR Confiapp (100+), SAT MX (1 mil+) |
| calculadora iva mexico | Calculadora IVA México (10 mil+), IVA Mexico (100+), IVA México 2026 (5+) |

---

*Fin del documento. Si algo no está aquí, no se implementa sin actualizarlo primero.*
