# Me Toca

Calculadora laboral y fiscal para México. Aguinaldo, finiquito, vacaciones, ISR e IVA.
Funciona sin internet y sin registro.

**Estado:** planeación cerrada. Todavía no hay código.

## Empezar aquí

El archivo [`plan-calculadoras-laborales-mx.md`](plan-calculadoras-laborales-mx.md) es la fuente de verdad del proyecto: producto, cifras legales verificadas, contrato del motor, matriz de pruebas, pantallas, tokens visuales, arquitectura y prompt de arranque.

Si algo no está en el plan, no se implementa sin actualizarlo primero.

## Orden de construcción

1. `packages/calc_engine` — motor Dart puro, dinero en centavos, parámetros por fecha de vigencia. Verde en pruebas antes de tocar UI.
2. `app` — tema, componentes base y pantallas.
3. Historial, ajustes, glosario.
4. Anuncios, compra Pro, PDF y compartir.

## Estructura

```text
app/                 Flutter (Android primero)
packages/calc_engine Dart puro, sin dependencias de Flutter
docs/archive/        Borradores ya absorbidos por el plan
```

## Reglas que no se rompen

- Dinero en centavos (`int`), nunca `double`.
- Parámetros legales por fecha de vigencia, nunca por año del calendario.
- Si no hay tabla para la fecha, error. Nunca un número aproximado.
- Todo resultado se explica paso a paso.
- Sin backend, sin cuentas, sin analytics de terceros.
- Sin anuncios en resultado, explicación ni PDF.
