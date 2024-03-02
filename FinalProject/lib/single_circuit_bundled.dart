import 'package:flutter/material.dart';
import 'dart:math';

class SingleCircuitBundledScreen extends StatefulWidget {
  @override
  _SingleCircuitBundledScreenState createState() =>
      _SingleCircuitBundledScreenState();
}

class _SingleCircuitBundledScreenState
    extends State<SingleCircuitBundledScreen> {
  TextEditingController distanceABController = TextEditingController();
  TextEditingController distanceBCController = TextEditingController();
  TextEditingController distanceACController = TextEditingController();
  TextEditingController distanceBetweenBundledConductorsController =
      TextEditingController();
  String selectedConductorType = 'warving'; // Default value for rC

  TextEditingController _inductanceController = TextEditingController();
  TextEditingController _capacitanceController = TextEditingController();

  double rL = 0.3831;
  double rC = 0.609;

  void calculateResults() {
    double d1 = double.parse(distanceABController.text);
    double d2 = double.parse(distanceBCController.text);
    double d3 = double.parse(distanceACController.text);
    double distanceBetweenBundledConductors =
        double.parse(distanceBetweenBundledConductorsController.text);

    Map<String, double> radii = getRadii(selectedConductorType);

    num Dm = pow((d1 * d2 * d3), (1 / 3));
    num j = (radii['rL'] ?? 0.0) * distanceBetweenBundledConductors;
    num Ds = pow((j), (1 / 2));
    num L = 2e-7 * log(Dm / Ds);
    num E0 = 8.85 * pow(10, -12);
    num k = (radii['rC'] ?? 0.0) * distanceBetweenBundledConductors;
    num DsC = pow((k), (1 / 2));
    num C = (2 * pi * E0) / log(Dm / DsC);
    _inductanceController.text = L.toStringAsExponential(5);
    _capacitanceController.text = C.toStringAsExponential(5);

    // Display results using a dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Results'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('OUTPUT INDUCTANCE'),
              Text('L= ${_inductanceController.text} [H/m]'),
              SizedBox(height: 8),
              Text('OUTPUT CAPACITANCE'),
              Text('C= ${_capacitanceController.text} [F/m]'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single Circuit Bundled'),
        backgroundColor: Color(0xff61fd66), // Set app bar color
      ),
      backgroundColor: Color(0xfffff7a6), // Set background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Image.asset(
                  'assets/image2.png', // Adjust the asset path
                  // fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: distanceABController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Distance between conductor A and B (m)'),
              ),
              TextField(
                controller: distanceBCController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Distance between conductor B and C (m)'),
              ),
              TextField(
                controller: distanceACController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Distance between conductor A and C (m)'),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedConductorType,
                items: [
                  DropdownMenuItem(
                    child: Text('Warving'),
                    value: 'warving',
                  ),
                  DropdownMenuItem(
                    child: Text('Drake'),
                    value: 'drake',
                  ),
                  DropdownMenuItem(
                    child: Text('Dove'),
                    value: 'dove',
                  ),
                  DropdownMenuItem(
                    child: Text('Ostrich'),
                    value: 'ostrich',
                  ),
                  DropdownMenuItem(
                    child: Text('Rail'),
                    value: 'rail',
                  ),
                  DropdownMenuItem(
                    child: Text('Pheasant'),
                    value: 'pheasant',
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedConductorType = value!;
                  });
                },
                hint: Text('Select Conductor Type'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: distanceBetweenBundledConductorsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Distance Between Bundled Conductors (m)'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: calculateResults,
                child: Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, double> getRadii(String x) {
  switch (x.toLowerCase()) {
    case 'warving':
      return {'rL': 0.3831, 'rC': 0.609};
    case 'drake':
      return {'rL': 0.01143, 'rC': 0.014};
    case 'dove':
      return {'rL': 0.0314, 'rC': 0.927};
    case 'ostrich':
      return {'rL': 0.00697, 'rC': 0.008636};
    case 'rail':
      return {'rL': 0.0386, 'rC': 1.165};
    case 'pheasant':
      return {'rL': 0.01417, 'rC': 0.01762};
    default:
      return {'rL': 0.0, 'rC': 0.0};
  }
}
