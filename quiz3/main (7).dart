import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  double bmi = 0.0;
  String category = "";

  Color getBMIColor(String cat) {
    switch (cat) {
      case "Underweight":
        return Colors.orangeAccent;
      case "Normal":
        return Colors.greenAccent;
      case "Overweight":
        return Colors.deepOrangeAccent;
      case "Obese":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  String getCategory(double bmiValue) {
    if (bmiValue < 18.5) return "Underweight";
    if (bmiValue >= 18.5 && bmiValue < 25) return "Normal";
    if (bmiValue >= 25 && bmiValue < 30) return "Overweight";
    return "Obese";
  }

  void calculateBMI() {
    if (heightController.text.isEmpty || weightController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Fill all fields")));
      return;
    }

    double h = double.parse(heightController.text) / 100;
    double w = double.parse(weightController.text);

    setState(() {
      bmi = w / (h * h);
      category = getCategory(bmi);
    });
  }

  @override
  Widget build(BuildContext context) {
    double progressValue =
        bmi == 0 ? 0.0 : (bmi / 40).clamp(0.0, 1.0); // progress circle

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffffa726), Color(0xff43a047)], // Orange → Green
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "BMI Calculator",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 30),

                  // AGE INPUT
                  _input("Enter Age", ageController),
                  _input("Enter Height (cm)", heightController),
                  _input("Enter Weight (kg)", weightController),

                  const SizedBox(height: 20),

                  // CALCULATE BUTTON
                  ElevatedButton(
                    onPressed: calculateBMI,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Calculate BMI',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // BMI RESULT
                  const Text(
                    "Your BMI",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 120,
                    width: 120,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            value: progressValue,
                            strokeWidth: 10,
                            backgroundColor: Colors.white30,
                            color: getBMIColor(category),
                          ),
                        ),
                        Center(
                          child: Text(
                            bmi == 0 ? "" : bmi.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: getBMIColor(category),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 20,
                      color: getBMIColor(category),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Column(
                    children: [
                      Text('Lower than 18.5   → Underweight',
                          style: TextStyle(color: Colors.white70)),
                      Text('18.5 up to 25     → Normal',
                          style: TextStyle(color: Colors.white70)),
                      Text('25 up to 30       → Overweight',
                          style: TextStyle(color: Colors.white70)),
                      Text('30+               → Obese',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}
