/// Vacation days per completed year of service (Art. 76 LFT, 2023 reform).
///
/// The table is stable law, not a yearly parameter. Entitlement for a service
/// year is looked up with the completed years at the start of that year.
int vacationDaysForCompletedYears(int years) {
  if (years <= 1) {
    return 12;
  }
  if (years <= 5) {
    return 12 + (years - 1) * 2;
  }
  if (years <= 10) {
    return 22;
  }
  if (years <= 15) {
    return 24;
  }
  if (years <= 20) {
    return 26;
  }
  if (years <= 25) {
    return 28;
  }
  if (years <= 30) {
    return 30;
  }
  return 32;
}
