import 'package:calc_engine/calc_engine.dart';

const List<String> _units = [
  'cero',
  'uno',
  'dos',
  'tres',
  'cuatro',
  'cinco',
  'seis',
  'siete',
  'ocho',
  'nueve',
  'diez',
  'once',
  'doce',
  'trece',
  'catorce',
  'quince',
  'dieciséis',
  'diecisiete',
  'dieciocho',
  'diecinueve',
];

const List<String> _twenties = [
  'veinte',
  'veintiuno',
  'veintidós',
  'veintitrés',
  'veinticuatro',
  'veinticinco',
  'veintiséis',
  'veintisiete',
  'veintiocho',
  'veintinueve',
];

const List<String> _tens = [
  '',
  '',
  'veinte',
  'treinta',
  'cuarenta',
  'cincuenta',
  'sesenta',
  'setenta',
  'ochenta',
  'noventa',
];

const List<String> _hundreds = [
  '',
  'ciento',
  'doscientos',
  'trescientos',
  'cuatrocientos',
  'quinientos',
  'seiscientos',
  'setecientos',
  'ochocientos',
  'novecientos',
];

String _underOneHundred(int number) {
  if (number < 20) {
    return _units[number];
  }
  if (number < 30) {
    return _twenties[number - 20];
  }
  final tens = number ~/ 10;
  final units = number % 10;
  return units == 0 ? _tens[tens] : '${_tens[tens]} y ${_units[units]}';
}

String _underOneThousand(int number) {
  if (number < 100) {
    return _underOneHundred(number);
  }
  if (number == 100) {
    return 'cien';
  }
  final hundreds = number ~/ 100;
  final rest = number % 100;
  return rest == 0
      ? _hundreds[hundreds]
      : '${_hundreds[hundreds]} ${_underOneHundred(rest)}';
}

/// Spanish apocope before "mil" and "millones".
String _apocopate(String words) {
  if (words.endsWith('veintiuno')) {
    return '${words.substring(0, words.length - 9)}veintiún';
  }
  if (words.endsWith(' y uno')) {
    return '${words.substring(0, words.length - 6)} y un';
  }
  if (words == 'uno') {
    return 'un';
  }
  return words;
}

String _numberToWords(int number) {
  if (number < 1000) {
    return _underOneThousand(number);
  }
  if (number < 1000000) {
    final thousands = number ~/ 1000;
    final rest = number % 1000;
    final prefix = thousands == 1
        ? 'mil'
        : '${_apocopate(_underOneThousand(thousands))} mil';
    return rest == 0 ? prefix : '$prefix ${_underOneThousand(rest)}';
  }
  if (number < 1000000000) {
    final millions = number ~/ 1000000;
    final rest = number % 1000000;
    final prefix = millions == 1
        ? 'un millón'
        : '${_apocopate(_underOneThousand(millions))} millones';
    return rest == 0 ? prefix : '$prefix ${_numberToWords(rest)}';
  }
  return number.toString();
}

/// Spoken representation used by Semantics on money values.
String moneyToWordsEs(Money money) {
  final absolute = money.cents.abs();
  final pesos = absolute ~/ 100;
  final cents = absolute % 100;
  final buffer = StringBuffer();
  if (money.isNegative) {
    buffer.write('menos ');
  }
  final pesosWords = _apocopate(_numberToWords(pesos));
  buffer.write(pesosWords);
  if (pesos >= 1000000 && pesos % 1000000 == 0) {
    buffer.write(' de pesos');
  } else {
    buffer.write(pesos == 1 ? ' peso' : ' pesos');
  }
  if (cents > 0) {
    buffer.write(' con ${_numberToWords(cents)} ');
    buffer.write(cents == 1 ? 'centavo' : 'centavos');
  }
  return buffer.toString();
}
