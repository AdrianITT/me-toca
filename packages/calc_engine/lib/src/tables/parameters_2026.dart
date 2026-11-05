import '../money.dart';
import '../parameters.dart';

/// Official ISR tables for 2026 (Anexo 8 RMF 2026, section B.V).
///
/// All amounts are in cents. The first lower limit is one cent, as published.
const List<IsrBracket> isrMonthly2026 = [
  IsrBracket(
    lower: Money(1),
    upper: Money(84459),
    fixed: Money(0),
    rateBp: 192,
  ),
  IsrBracket(
    lower: Money(84460),
    upper: Money(716851),
    fixed: Money(1622),
    rateBp: 640,
  ),
  IsrBracket(
    lower: Money(716852),
    upper: Money(1259802),
    fixed: Money(42095),
    rateBp: 1088,
  ),
  IsrBracket(
    lower: Money(1259803),
    upper: Money(1464464),
    fixed: Money(101168),
    rateBp: 1600,
  ),
  IsrBracket(
    lower: Money(1464465),
    upper: Money(1753364),
    fixed: Money(133914),
    rateBp: 1792,
  ),
  IsrBracket(
    lower: Money(1753365),
    upper: Money(3536283),
    fixed: Money(185684),
    rateBp: 2136,
  ),
  IsrBracket(
    lower: Money(3536284),
    upper: Money(5573668),
    fixed: Money(566516),
    rateBp: 2352,
  ),
  IsrBracket(
    lower: Money(5573669),
    upper: Money(10641050),
    fixed: Money(1045709),
    rateBp: 3000,
  ),
  IsrBracket(
    lower: Money(10641051),
    upper: Money(14188066),
    fixed: Money(2565923),
    rateBp: 3200,
  ),
  IsrBracket(
    lower: Money(14188067),
    upper: Money(42564199),
    fixed: Money(3700969),
    rateBp: 3400,
  ),
  IsrBracket(lower: Money(42564200), fixed: Money(13348854), rateBp: 3500),
];

const List<IsrBracket> isrFifteenDay2026 = [
  IsrBracket(
    lower: Money(1),
    upper: Money(41670),
    fixed: Money(0),
    rateBp: 192,
  ),
  IsrBracket(
    lower: Money(41671),
    upper: Money(353715),
    fixed: Money(795),
    rateBp: 640,
  ),
  IsrBracket(
    lower: Money(353716),
    upper: Money(621615),
    fixed: Money(20775),
    rateBp: 1088,
  ),
  IsrBracket(
    lower: Money(621616),
    upper: Money(722595),
    fixed: Money(49920),
    rateBp: 1600,
  ),
  IsrBracket(
    lower: Money(722596),
    upper: Money(865140),
    fixed: Money(66075),
    rateBp: 1792,
  ),
  IsrBracket(
    lower: Money(865141),
    upper: Money(1744875),
    fixed: Money(91620),
    rateBp: 2136,
  ),
  IsrBracket(
    lower: Money(1744876),
    upper: Money(2750160),
    fixed: Money(279525),
    rateBp: 2352,
  ),
  IsrBracket(
    lower: Money(2750161),
    upper: Money(5250525),
    fixed: Money(515970),
    rateBp: 3000,
  ),
  IsrBracket(
    lower: Money(5250526),
    upper: Money(7000695),
    fixed: Money(1266075),
    rateBp: 3200,
  ),
  IsrBracket(
    lower: Money(7000696),
    upper: Money(21002070),
    fixed: Money(1826130),
    rateBp: 3400,
  ),
  IsrBracket(lower: Money(21002071), fixed: Money(6586605), rateBp: 3500),
];

const List<IsrBracket> isrSevenDay2026 = [
  IsrBracket(
    lower: Money(1),
    upper: Money(19446),
    fixed: Money(0),
    rateBp: 192,
  ),
  IsrBracket(
    lower: Money(19447),
    upper: Money(165067),
    fixed: Money(371),
    rateBp: 640,
  ),
  IsrBracket(
    lower: Money(165068),
    upper: Money(290087),
    fixed: Money(9695),
    rateBp: 1088,
  ),
  IsrBracket(
    lower: Money(290088),
    upper: Money(337211),
    fixed: Money(23296),
    rateBp: 1600,
  ),
  IsrBracket(
    lower: Money(337212),
    upper: Money(403732),
    fixed: Money(30835),
    rateBp: 1792,
  ),
  IsrBracket(
    lower: Money(403733),
    upper: Money(814275),
    fixed: Money(42756),
    rateBp: 2136,
  ),
  IsrBracket(
    lower: Money(814276),
    upper: Money(1283408),
    fixed: Money(130445),
    rateBp: 2352,
  ),
  IsrBracket(
    lower: Money(1283409),
    upper: Money(2450245),
    fixed: Money(240786),
    rateBp: 3000,
  ),
  IsrBracket(
    lower: Money(2450246),
    upper: Money(3266991),
    fixed: Money(590835),
    rateBp: 3200,
  ),
  IsrBracket(
    lower: Money(3266992),
    upper: Money(9800966),
    fixed: Money(852194),
    rateBp: 3400,
  ),
  IsrBracket(lower: Money(9800967), fixed: Money(3073749), rateBp: 3500),
];

const Uma uma2025 = Uma(
  daily: Money(11314),
  monthly: Money(343946),
  annual: Money(4127352),
);

const Uma uma2026 = Uma(
  daily: Money(11731),
  monthly: Money(356622),
  annual: Money(4279464),
);

const MinimumWage minimumWage2026 = MinimumWage(
  general: Money(31504),
  border: Money(44087),
);

/// January 2026 still uses the 2025 UMA and the January subsidy.
final LegalParameters parameters2026January = LegalParameters(
  id: '2026-01',
  validFrom: DateTime.utc(2026, 1, 1),
  validTo: DateTime.utc(2026, 1, 31),
  uma: uma2025,
  minimumWage: minimumWage2026,
  isrMonthly: isrMonthly2026,
  isrFifteenDay: isrFifteenDay2026,
  isrSevenDay: isrSevenDay2026,
  subsidyMonthly: const Money(53621),
  subsidyIncomeCap: const Money(1149266),
  aguinaldoMinDays: 15,
  borderStimulusActive: false,
  vacationPremiumBp: 2500,
  primaAntiguedadDays: 12,
  primaAntiguedadCap: 2,
  severanceBaseDays: 90,
  severanceDaysPerYear: 20,
  source: 'Anexo 8 RMF 2026 (DOF 28-dic-2025); DOF 31-dic-2025; INEGI UMA 2025; CONASAMI 2026',
  verified: true,
);

/// From February 2026 the 2026 UMA and the February subsidy apply.
final LegalParameters parameters2026February = LegalParameters(
  id: '2026-02',
  validFrom: DateTime.utc(2026, 2, 1),
  validTo: DateTime.utc(2026, 12, 31),
  uma: uma2026,
  minimumWage: minimumWage2026,
  isrMonthly: isrMonthly2026,
  isrFifteenDay: isrFifteenDay2026,
  isrSevenDay: isrSevenDay2026,
  subsidyMonthly: const Money(53565),
  subsidyIncomeCap: const Money(1149266),
  aguinaldoMinDays: 15,
  borderStimulusActive: false,
  vacationPremiumBp: 2500,
  primaAntiguedadDays: 12,
  primaAntiguedadCap: 2,
  severanceBaseDays: 90,
  severanceDaysPerYear: 20,
  source: 'Anexo 8 RMF 2026 (DOF 28-dic-2025); DOF 31-dic-2025; INEGI UMA 2026; CONASAMI 2026',
  verified: true,
);
