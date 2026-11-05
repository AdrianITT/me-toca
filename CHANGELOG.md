# Changelog

All notable changes to Me Toca are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- GitHub Actions workflow for `flutter analyze` and `flutter test`.
- MIT license for the code (fonts remain under SIL OFL 1.1).

## [0.1.0] - 2026-11-05

### Added
- Pure Dart calculation engine (`packages/calc_engine`) with money in cents,
  date-based legal parameters and explained steps:
  - Aguinaldo (proportional and annual).
  - Finiquito (resignation, unjustified/justified dismissal, contract end,
    mutual agreement), separating finiquito from seniority premium and severance.
  - Vacaciones (days by seniority, pending days, vacation pay, 25% premium).
  - ISR (monthly, biweekly, weekly tables; employment subsidy with prorated cap).
  - IVA (16%, 0% and exempt; add or break down).
- Flutter app (`app/`) with light/dark themes, Fraunces + Manrope fonts bundled
  locally, token-based UI and 48 dp touch targets.
- Screens: home, aguinaldo, finiquito, vacaciones, ISR, IVA, shared result and
  explanation, history, settings, glossary, onboarding.
- Local storage for settings and history (10 entries in Free).
- 48 engine tests and 24 app tests, all green.
- Plan document and README as the single source of truth.

### Changed
- Subsidy income cap is prorated with the same 30.4-day base as the subsidy
  (monthly \$11,492.66, biweekly \$5,670.72, weekly \$2,646.34).
- Finiquito subtotal excludes the seniority premium, shown as its own line.
- Added `severanceBaseDays` (90) and `severanceDaysPerYear` (20) to
  `LegalParameters`.

### Fixed
- Vacation calculator under one year returns `invalidInput` pointing to
  finiquito instead of an approximate value.
- Header overflow at 200% text scale on the home screen.
- Semantics handle disposal in the result screen test.
