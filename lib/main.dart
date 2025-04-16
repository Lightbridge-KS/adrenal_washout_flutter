import 'package:flutter/material.dart';
import 'src/adrenal_wash.dart';

void main() {
  runApp(const AdrenalWashoutApp());
}

class AdrenalWashoutApp extends StatelessWidget {
  const AdrenalWashoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adrenal CT Washout Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
      home: const AdrenalWashoutCalculatorScreen(),
    );
  }
}

class AdrenalWashoutCalculatorScreen extends StatefulWidget {
  const AdrenalWashoutCalculatorScreen({super.key});

  @override
  State<AdrenalWashoutCalculatorScreen> createState() => _AdrenalWashoutCalculatorScreenState();
}

class _AdrenalWashoutCalculatorScreenState extends State<AdrenalWashoutCalculatorScreen> {
  // Results data
  String apwResult = '';
  String rpwResult = '';
  double? ncValue;
  double? enhancedValue;
  double? delayedValue;

  // Input controllers - kept here to collect the data
  final TextEditingController _ncController = TextEditingController();
  final TextEditingController _enhancedController = TextEditingController();
  final TextEditingController _delayedController = TextEditingController();

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _ncController.dispose();
    _enhancedController.dispose();
    _delayedController.dispose();
    super.dispose();
  }

  // Calculate washout values
  void _calculateWashout() {
    setState(() {
      // Parse the values, handling empty strings
      ncValue = _ncController.text.isNotEmpty ? double.tryParse(_ncController.text) : null;
      enhancedValue = _enhancedController.text.isNotEmpty ? double.tryParse(_enhancedController.text) : null;
      delayedValue = _delayedController.text.isNotEmpty ? double.tryParse(_delayedController.text) : null;

      // Calculate APW if all required values are present
      if (ncValue != null && enhancedValue != null && delayedValue != null) {
        try {
          final apw = AdrenalWashoutCalculator.calcApw(
            nc: ncValue!,
            enh: enhancedValue!,
            delayed: delayedValue!,
          );
          apwResult = '${apw.toStringAsFixed(1)}%';
        } catch (e) {
          apwResult = 'Not calculable';
        }
      } else {
        apwResult = 'Not calculable';
      }

      // Calculate RPW if all required values are present
      if (enhancedValue != null && delayedValue != null) {
        try {
          final rpw = AdrenalWashoutCalculator.calcRpw(
            enh: enhancedValue!,
            delayed: delayedValue!,
          );
          rpwResult = '${rpw.toStringAsFixed(1)}%';
        } catch (e) {
          rpwResult = 'Not calculable';
        }
      } else {
        rpwResult = 'Not calculable';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Adrenal CT Washout Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Section Widget
              InputSection(
                ncController: _ncController,
                enhancedController: _enhancedController,
                delayedController: _delayedController,
              ),
              
              const SizedBox(height: 16),
              
              // Results Section Widget
              ResultsSection(
                apwResult: apwResult,
                rpwResult: rpwResult,
                ncValue: ncValue,
                enhancedValue: enhancedValue,
                delayedValue: delayedValue,
              ),
              
              const SizedBox(height: 16),
              
              // Calculate Button - kept in the main screen to connect inputs and outputs
              ElevatedButton(
                onPressed: _calculateWashout,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputSection extends StatelessWidget {
  final TextEditingController ncController;
  final TextEditingController enhancedController;
  final TextEditingController delayedController;

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

  // Helper method to build an input row
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

class ResultsSection extends StatelessWidget {
  final String apwResult;
  final String rpwResult;
  final double? ncValue;
  final double? enhancedValue;
  final double? delayedValue;

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