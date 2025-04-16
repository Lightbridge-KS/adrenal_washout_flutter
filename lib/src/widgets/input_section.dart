import 'package:flutter/material.dart';

/// A widget that displays input fields for Adrenal CT Washout calculation
class InputSection extends StatelessWidget {
  /// Controller for the Non-Contrast HU input field
  final TextEditingController ncController;
  
  /// Controller for the Enhanced HU input field
  final TextEditingController enhancedController;
  
  /// Controller for the Delayed HU input field
  final TextEditingController delayedController;

  /// Creates an InputSection widget
  /// 
  /// Requires controllers for all three input fields: Non-Contrast,
  /// Enhanced, and Delayed HU values.
  const InputSection({
    super.key,
    required this.ncController,
    required this.enhancedController,
    required this.delayedController,
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
            const Center(
              child: Text(
                'Input HU',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Non-Contrast Input
            _buildInputRow(
              label: 'Non Contrast (HU):',
              controller: ncController,
            ),
            const SizedBox(height: 12),
            // Enhanced Input
            _buildInputRow(
              label: 'Enhanced (HU):',
              controller: enhancedController,
            ),
            const SizedBox(height: 12),
            // Delayed Input
            _buildInputRow(
              label: 'Delayed (HU):',
              controller: delayedController,
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build a consistent input row
  /// 
  /// Each row consists of a label and a text input field
  Widget _buildInputRow({
    required String label,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: '(HU)',
            ),
          ),
        ),
      ],
    );
  }
}