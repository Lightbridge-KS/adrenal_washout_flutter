import 'package:flutter/material.dart';

/// A widget that displays calculation results for Adrenal CT Washout
class ResultsSection extends StatelessWidget {
  /// The formatted Absolute Percentage Washout (APW) result
  final String apwResult;
  
  /// The formatted Relative Percentage Washout (RPW) result
  final String rpwResult;
  
  /// The Non-Contrast HU value used in the calculation
  final double? ncValue;
  
  /// The Enhanced HU value used in the calculation
  final double? enhancedValue;
  
  /// The Delayed HU value used in the calculation
  final double? delayedValue;

  /// Creates a ResultsSection widget
  /// 
  /// Requires the calculation results (apwResult, rpwResult) and
  /// optionally the input values that were used for calculation.
  const ResultsSection({
    super.key,
    required this.apwResult,
    required this.rpwResult,
    this.ncValue,
    this.enhancedValue,
    this.delayedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adrenal CT Washout:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'APW = $apwResult',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'RPW = $rpwResult',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (ncValue != null || enhancedValue != null || delayedValue != null) ...[
              Text(
                '- NC: ${ncValue?.toStringAsFixed(1) ?? 'N/A'} HU',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                '- Enhanced: ${enhancedValue?.toStringAsFixed(1) ?? 'N/A'} HU',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                '- Delayed: ${delayedValue?.toStringAsFixed(1) ?? 'N/A'} HU',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}