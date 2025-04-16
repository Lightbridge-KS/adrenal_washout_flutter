class AdrenalWashoutCalculator {
  /// Calculates the Absolute Percentage Washout (APW)
  static double calcApw({required double nc, required double enh, required double delayed}) {
    if (enh == nc) {
      throw ArgumentError('Enhanced and non-contrast values cannot be equal');
    }
    return (enh - delayed) / (enh - nc) * 100;
  }
  
  /// Calculates the Relative Percentage Washout (RPW)
  static double calcRpw({required double enh, required double delayed}) {
    if (enh == 0) {
      throw ArgumentError('Enhanced value cannot be zero');
    }
    return (enh - delayed) / enh * 100;
  }
}

// void main() {
//   print(AdrenalWashoutCalculator.calcApw(nc: 10, enh: 100, delayed: 60));
//   print(AdrenalWashoutCalculator.calcRpw(enh: 100, delayed: 60));
// }