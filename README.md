# Me Toca

Calculadora laboral y fiscal para México. Aguinaldo, finiquito, vacaciones, ISR e IVA.
Funciona sin internet y sin registro.

**Estado:** motor en verde (48 pruebas) y las cinco calculadoras con captura, resultado, explicación, historial, ajustes, glosario y onboarding. Faltan anuncios, Pro, PDF y compartir.

## Empezar aquí

El archivo [`plan-calculadoras-laborales-mx.md`](plan-calculadoras-laborales-mx.md) es la fuente de verdad del proyecto: producto, cifras legales verificadas, contrato del motor, matriz de pruebas, pantallas, tokens visuales, arquitectura y prompt de arranque.

Si algo no está en el plan, no se implementa sin actualizarlo primero.

## Orden de construcción

1. `packages/calc_engine` — motor Dart puro, dinero en centavos, parámetros por fecha de vigencia. **Hecho:** las cinco calculadoras y la matriz de pruebas de la sección 9.7 están en verde.
2. `app` — tema, componentes base y pantallas. **Hecho:** tokens claro/oscuro, tipografía Fraunces + Manrope, componentes base y las cinco calculadoras (aguinaldo, finiquito, vacaciones, ISR e IVA) con una capa de resultado/explicación compartida.
3. Historial, ajustes, glosario.
4. Anuncios, compra Pro, PDF y compartir.

## Correr

```bash
cd packages/calc_engine && dart test    # motor
cd app && flutter test                  # UI y formato
cd app && flutter run                   # requiere Android SDK
```

## Estructura

```text
app/                 Flutter (Android primero)
packages/calc_engine Dart puro, sin dependencias de Flutter
docs/archive/        Borradores ya absorbidos por el plan
```

## Capturas

Las capturas se agregarán cuando la app se pueda correr en un dispositivo.
La dirección visual está documentada en la sección 11 del plan.

## Licencia

El código se distribuye bajo la licencia MIT (ver `LICENSE`).
Las fuentes Fraunces y Manrope se distribuyen bajo la SIL Open Font License 1.1
(ver `app/assets/licenses/`).

- Dinero en centavos (`int`), nunca `double`.
- Parámetros legales por fecha de vigencia, nunca por año del calendario.
- Si no hay tabla para la fecha, error. Nunca un número aproximado.
- Todo resultado se explica paso a paso.
- Sin backend, sin cuentas, sin analytics de terceros.
- Sin anuncios en resultado, explicación ni PDF.
