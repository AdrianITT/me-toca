import 'package:intl/intl.dart';

String formatLongDate(DateTime date) =>
    DateFormat("d 'de' MMMM 'de' y", 'es_MX').format(date);

String formatShortDate(DateTime date) =>
    DateFormat('dd/MM/yyyy', 'es_MX').format(date);
