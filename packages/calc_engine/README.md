# calc_engine

Motor de cálculo de Me Toca. Dart puro: sin Flutter, sin red y sin
almacenamiento.

- Dinero en centavos (`int`), nunca `double`.
- Parámetros legales por fecha de vigencia (`2026-01`, `2026-02`).
- Cada resultado devuelve pasos explicables.
- Si no hay tabla para la fecha, error tipado. Nunca se aproxima.

## Uso

```dart
import 'package:calc_engine/calc_engine.dart';

final parameters = ParameterRepository.forDate(
  DateTime.utc(2026, 6, 1),
).valueOrNull!;

final outcome = calculateAguinaldo(
  AguinaldoInput(
    monthlySalary: const Money(1500000),
    hireDate: DateTime.utc(2020, 1, 1),
    calculationDate: DateTime.utc(2026, 12, 31),
  ),
  parameters,
);
```

## Pruebas

```bash
dart test
```
