import 'package:flutter/material.dart';
import 'single_circuit_unbundled.dart';
import 'single_circuit_bundled.dart';
import 'double_circuit_unbundled_type2.dart';
import 'double_circuit_composite_conductor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  Widget buildAuthenticationButton(
      BuildContext context, String label, String route) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff61fd66),
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'TRANSMISSION LINE INDUCTANCE AND CAPACITANCE CALCULATION',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xfffff7a6),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildImageCard(context, 'Single Circuit Unbundled Conductor', 0),
              buildImageCard(context, 'Single Circuit Bundled Conductor', 1),
              buildImageCard(context, 'Double Circuit Unbundled Conductor', 2),
              buildImageCard(context, 'Double Circuit Composite Conductor', 3),
              SizedBox(height: 20),
              buildAuthenticationButton(context, 'Switch Account', 'Login'),
            ],
          ),
        ),
      ),
    );
  }

  String getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Single Circuit Unbundled Conductor';
      case 1:
        return 'Single Circuit Bundled Condcutor';
      case 2:
        return 'Double Circuit Unbundled Conductor';
      case 3:
        return 'Double Circuit Composite Conductor';
      default:
        return 'Unknown Label';
    }
  }

  Widget buildImageCard(BuildContext context, String label, int index) {
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        navigateToScreen(context, index);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: screenHeight * 0.35,
              child: Image.asset(
                'assets/image${index + 1}.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: screenHeight * 0.03,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SingleCircuitUnbundledScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SingleCircuitBundledScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DoubleCircuitUnbundledType2Screen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DoubleCircuitCompositeConductorScreen()),
        );
        break;
      default:
        break;
    }
  }
}
