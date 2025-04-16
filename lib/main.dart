import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'src/adrenal_wash.dart';
import 'src/widgets/input_section.dart';
import 'src/widgets/results_section.dart';

// For controlling window size on desktop platforms
import 'package:window_size/window_size.dart';

void main() {
  // This is important to ensure bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set window size only for desktop platforms
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowTitle('Adrenal CT Washout Calculator');
    setWindowMinSize(const Size(400, 630));
    setWindowMaxSize(const Size(800, 800));
    
    // You can also set the initial window size
    setWindowFrame(const Rect.fromLTWH(0, 0, 400, 630));
  }
  
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