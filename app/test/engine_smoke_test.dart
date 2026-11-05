import 'package:calc_engine/calc_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the calc engine is wired into the app', () {
    final parameters = ParameterRepository.forDate(DateTime.utc(2026, 6, 1))
        .valueOrNull;

    expect(parameters, isNotNull);
    expect(parameters!.id, '2026-02');
  });
}
