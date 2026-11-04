# Me Toca — Plan del motor de cálculo

> **Documento histórico.** Su contenido ya está integrado en `../../plan-calculadoras-laborales-mx.md` (secciones 8 y 9).
> Si hay conflicto, manda el plan único. No editar este archivo.

## 1. Alcance

**MVP (fase 1):** aguinaldo, vacaciones, finiquito, ISR mensual e IVA.
**Fase 2:** ISR anual estimado, escenarios guardados, PDF.
**Fuera:** IMSS, Infonavit, nómina con CFDI, RESICO, plataformas digitales, otros países.

El motor es un paquete Dart puro, sin Flutter, sin red y sin almacenamiento. La UI solo captura datos y muestra resultados; no contiene fórmulas.

## 2. Principios

1. **Dinero en centavos (`int`).** Nunca `double` para pesos.
2. **Parámetros por fecha de vigencia**, no por año del calendario.
3. **Ninguna constante legal dentro de una fórmula.** Todo sale de la tabla del periodo.
4. **Cada resultado se explica.** Devuelve pasos con etiqueta, texto y monto.
5. **Si no hay tabla vigente, no se calcula.** Error explícito, nunca un número aproximado.
6. **Determinista.** Sin `DateTime.now()` dentro del motor; la fecha entra como dato.

## 3. Modelo de datos

```text
LegalParameters
  id                  "2026-02"
  validFrom           2026-02-01
  validTo             2026-12-31
  uma                 diaria 117.31 · mensual 3,566.22 · anual 42,794.64
  salarioMinimo       general 315.04 · frontera 440.87
  tarifaIsrMensual    11 tramos (límite inferior, superior, cuota fija, %)
  subsidioEmpleo      monto 535.65 · tope de ingreso 11,492.66
  aguinaldoMinimo     15 días
  primaVacacional     25%
  primaAntiguedad     12 días por año · tope 2 salarios mínimos
  fuente              texto y fecha de consulta
  isrVerificado       sí / no
```

Reglas:

- Cada ejercicio conserva su tabla. Nunca se sobrescribe la anterior.
- `ParameterRepository.forDate(fecha)` devuelve la tabla vigente o el error `sinParametrosParaFecha`.
- **Enero y febrero pueden usar tablas distintas.** La UMA cambia el 1 de febrero; salario mínimo e ISR, el 1 de enero.
- Una tabla marcada como no verificada no debe alimentar ISR ni exenciones: el motor devuelve `parametrosSinVerificar`.

## 4. Reglas transversales

### Dinero y redondeo

- Multiplicar por tasa en **puntos base**: 16% = 1600, 25% = 2500.
- Redondeo **half-up al centavo**, una sola vez por concepto.
- Los totales suman los conceptos **ya redondeados**, para que el desglose cuadre con el total.
- El motor nunca formatea moneda; la UI decide el formato.

### Días y fechas

- Fechas sin hora, en UTC a medianoche.
- Días trabajados **contando ambos extremos**: del 1 de enero al 31 de diciembre = 365.
- Año bisiesto: denominador 366 solo si el periodo completo es bisiesto.
- Periodo por defecto del aguinaldo: 1 de enero al 31 de diciembre del año que el usuario elija.
- Si el ingreso es posterior al inicio del periodo, se cuentan solo los días desde el ingreso.

### Validaciones humanas

| Caso | Mensaje |
|---|---|
| Baja anterior al ingreso | “La fecha de baja no puede ser anterior a la de ingreso.” |
| Salario en cero o negativo | “Escribe un salario mayor a cero.” |
| Periodo invertido | “La fecha final debe ser posterior a la inicial.” |
| Año sin tabla | “Todavía no tenemos las tablas de ese año. Revisa la fecha.” |
| Tabla sin verificar | “Estamos revisando las tablas de ese periodo. Intenta más tarde.” |

## 5. Calculadoras

### 5.1 Aguinaldo

**Entradas:** fecha de ingreso, periodo (inicio/fin), salario diario, días de aguinaldo (15 por defecto, editable si el contrato da más).

**Fórmula:**

```text
días trabajados   = días entre max(ingreso, inicio) y fin, inclusive
aguinaldo         = salario diario × días trabajados × días de aguinaldo / días del periodo
exento            = min(aguinaldo, 30 UMA diarias)
gravado           = aguinaldo − exento
```

**Salidas:** monto, exento, gravado, días trabajados y pasos.

**Casos límite:** ingreso el último día del periodo (1 día); empleado con menos de un año; contrato con 20 o 30 días; periodo que cruza año (se parte en dos cálculos).

**Fuente:** Art. 87 LFT · Art. 93 LISR.

### 5.2 Vacaciones

**Entradas:** años cumplidos, salario diario, días ya tomados.

**Tabla del Art. 76 LFT:**

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

**Fórmula:**

```text
días pendientes   = días por antigüedad − días tomados
pago vacaciones   = salario diario × días pendientes
prima vacacional  = pago vacaciones × 25%
total             = pago vacaciones + prima vacacional
```

**Salidas:** días que corresponden, días pendientes, pago, prima y total.

**Casos límite:** menos de un año (proporcional, se resuelve en finiquito); días tomados mayores a los que corresponden (pendiente = 0, nunca negativo); antigüedad mayor a 35 años (se mantiene en 32).

**Fuente:** Arts. 76 y 80 LFT.

### 5.3 Finiquito

**Entradas:** fecha de ingreso, fecha de baja, salario diario, días de vacaciones tomados, salarios pendientes, tipo de separación.

**Tipo de separación:** renuncia · despido injustificado · despido justificado · término de contrato · mutuo consentimiento.

**Conceptos:**

| Concepto | Regla |
|---|---|
| Salarios devengados | Dato que captura el usuario (días o monto) |
| Aguinaldo proporcional | Días del año trabajados / 365 × 15 × salario diario |
| Vacaciones pendientes | Días del año en curso × proporción trabajada − días tomados |
| Prima vacacional | 25% de las vacaciones pendientes |
| Prima de antigüedad | 12 días por año, salario tope 2 SM. En renuncia, solo con 15 años o más |
| Indemnización | 3 meses + 20 días por año, solo en despido injustificado |

**Reglas finas:**

- La prima de antigüedad usa el salario diario **topado a 2 salarios mínimos** (general o frontera según la zona).
- Años completos para prima de antigüedad; la fracción de año se paga proporcional solo si la ley lo permite (documentar la decisión y mostrarla).
- Los días de vacaciones pendientes se calculan con el derecho del **año en curso**, no del año anterior.
- El finiquito no incluye ISR en el MVP: solo muestra el desglose bruto. La retención se explica aparte.
- Si el usuario elige “despido injustificado”, la indemnización se muestra como concepto separado y marcada como “si aplica”.

**Fuente:** Arts. 76, 80, 87, 162, 48 y 50 LFT.

### 5.4 ISR mensual

**Entradas:** ingreso gravable mensual, periodo (para elegir tarifa), tipo de ingreso (sueldos).

**Fórmula:**

```text
buscar tramo donde límite inferior ≤ ingreso ≤ límite superior
isr = cuota fija + (ingreso − límite inferior) × tasa del tramo
isr a cargo = max(0, isr − subsidio al empleo)   si ingreso ≤ tope con subsidio
```

**Salidas:** tramo, tasa marginal, tasa efectiva, ISR causado, subsidio aplicado, ISR a retener.

**Casos límite:** ingreso en el límite exacto de un tramo (pertenece al tramo superior solo si el límite inferior es mayor); ingreso bajo que queda en cero por subsidio; ingreso arriba del último tramo; enero con tabla distinta.

**Pendiente bloqueante:** contrastar los 11 renglones contra el Anexo 8 de la RMF 2026 (DOF 28-dic-2025) antes de programar. La tabla actual viene de una fuente secundaria.

**Fuente:** Art. 96 LISR · Decreto de subsidio al empleo.

### 5.5 IVA

**Entradas:** monto, si el monto ya incluye IVA, región (general 16% o frontera 8%).

**Fórmulas:**

```text
si el monto no incluye IVA:
  iva   = monto × tasa
  total = monto + iva

si el monto ya incluye IVA:
  base = monto × 10000 / (10000 + tasa)
  iva  = monto − base
```

**Salidas:** base, IVA, total y tasa aplicada.

**Casos límite:** monto cero; desglose desde total (la base se redondea y el IVA es la diferencia, para que sumen exacto); frontera.

**Fuente:** Art. 2 LIVA · Decreto de región fronteriza.

## 6. Matriz de pruebas

Valores calculados a mano. Todos deben coincidir al centavo.

### Aguinaldo

| Caso | Datos | Esperado |
|---|---|---|
| Año completo | Ingreso 2020-01-01, periodo 2026, SD $500 | $7,500.00 · exento $3,519.30 · gravado $3,980.70 |
| Proporcional | Ingreso 2026-07-01, periodo 2026, SD $500 | 184 días · $3,780.82 |
| Un día | Ingreso 2026-12-31, SD $500 | $20.55 |
| Contrato 20 días | Año completo, SD $500 | $10,000.00 |

### Vacaciones

| Caso | Datos | Esperado |
|---|---|---|
| Año 1 | SD $500 | 12 días · $6,000.00 · prima $1,500.00 · total $7,500.00 |
| Año 10 | SD $500 | 22 días · $11,000.00 |
| Año 11 | SD $500 | 24 días |
| Año 25 | SD $500 | 28 días |
| Año 31 | SD $500 | 32 días |
| Días tomados | Año 1, tomados 5 | 7 días · $3,500.00 |

### Finiquito

Renuncia, ingreso 2024-03-01, baja 2026-11-30, SD $500, sin vacaciones tomadas, salarios pendientes $2,300.00:

| Concepto | Esperado |
|---|---|
| Salarios pendientes | $2,300.00 |
| Aguinaldo proporcional (334 días) | $6,863.01 |
| Vacaciones proporcionales (16 × 275 / 365) | $6,027.40 |
| Prima vacacional | $1,506.85 |
| Prima de antigüedad (renuncia, 2 años) | $0.00 |
| **Total** | **$16,697.26** |

### ISR

| Caso | Datos | Esperado |
|---|---|---|
| Tramo 5 | Gravable $15,000.00 | ISR $1,402.82 |
| Sin retención | Gravable $8,222.75 | ISR $0.00 (subsidio cubre exacto) |
| Último tramo | Gravable $500,000.00 | Cuota fija + 35% del excedente |

### IVA

| Caso | Datos | Esperado |
|---|---|---|
| General desde base | $1,000.00 | IVA $160.00 · total $1,160.00 |
| General desde total | $1,160.00 | base $1,000.00 · IVA $160.00 |
| Frontera desde base | $1,000.00 | IVA $80.00 · total $1,080.00 |

### Parámetros

| Caso | Esperado |
|---|---|
| 2026-02-01 | Tabla 2026-02 |
| 2026-12-31 | Tabla 2026-02 |
| 2026-01-15 | Error: falta tabla de enero |
| 2027-01-01 | Error: falta tabla 2027 |

## 7. Verificaciones pendientes antes de programar

1. **Tarifa de ISR 2026** contra el PDF oficial del SAT (Anexo 8 RMF 2026). Los 11 renglones.
2. **Subsidio al empleo de enero 2026:** confirmar si el decreto nuevo aplica desde el 1 de enero o desde febrero.
3. **UMA 2025** para el cálculo de enero (exenciones), si se decide soportar ese mes.
4. **Salario mínimo de frontera:** confirmar zona fronteriza vigente y si el usuario puede elegirla manualmente.
5. **Prima de antigüedad proporcional:** confirmar criterio para fracciones de año antes de mostrarla.
6. **Vacaciones proporcionales:** confirmar si se usa 365 o los días del año de servicio.

## 8. Fases

| Fase | Contenido | Criterio de salida |
|---|---|---|
| M1 | Dinero, fechas, parámetros, aguinaldo, vacaciones, IVA | Pruebas de la matriz en verde |
| M2 | Finiquito completo por tipo de separación | Caso base y 5 tipos de separación probados |
| M3 | ISR mensual verificado | Tabla oficial contrastada y 3 casos en verde |
| M4 | Explicaciones y formato de pasos | Cada resultado explica su fórmula sin jerga |
| Fase 2 | ISR anual estimado y escenarios | Después de publicar el MVP |

## 9. Decisiones abiertas

- ¿El aguinaldo se calcula por año calendario o por aniversario? Propuesta: calendario para el MVP, aniversario en finiquito.
- ¿La prima de antigüedad se paga proporcional en renuncia con menos de 15 años? La ley no da derecho; mostrar $0 y explicarlo.
- ¿El finiquito muestra ISR estimado? Propuesta: no en el MVP; solo bruto y nota.
- ¿Se soportan años anteriores? Propuesta: solo 2026 al publicar, con la estructura lista para agregar tablas.
