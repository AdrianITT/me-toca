import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'calc_result_view.dart';

/// Holds the last calculation for the result and explanation screens.
///
/// Only one result is kept in memory: the flow is linear and history is a
/// separate, later feature.
class CalcResultController extends Notifier<CalcResultView?> {
  @override
  CalcResultView? build() => null;

  void update(CalcResultView result) => state = result;

  void clear() => state = null;
}

final calcResultProvider =
    NotifierProvider<CalcResultController, CalcResultView?>(
      CalcResultController.new,
    );
