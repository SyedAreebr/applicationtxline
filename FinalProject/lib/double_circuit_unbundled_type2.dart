import 'package:flutter/material.dart';
import 'dart:math';

class DoubleCircuitUnbundledType2Screen extends StatefulWidget {
  @override
  _DoubleCircuitUnbundledType2ScreenState createState() =>
      _DoubleCircuitUnbundledType2ScreenState();
}

class _DoubleCircuitUnbundledType2ScreenState
    extends State<DoubleCircuitUnbundledType2Screen> {
  TextEditingController distanceACController = TextEditingController();
  TextEditingController distanceBCController = TextEditingController();
  TextEditingController distanceABController = TextEditingController();
  TextEditingController verticalDistanceABController = TextEditingController();
  TextEditingController verticalDistanceBCController = TextEditingController();

  String selectedConductorType = 'warving';

  TextEditingController inductanceController = TextEditingController();
  TextEditingController capacitanceController = TextEditingController();

  void calculateResults() {
    double d1 = double.parse(distanceABController.text);
    // double d2 = double.parse(distanceBCController.text);
    double d3 = double.parse(distanceACController.text);
    double v1 = double.parse(verticalDistanceABController.text);
    double v2 = double.parse(verticalDistanceBCController.text);

    Map<String, double> radii = getRadii(selectedConductorType);

    num a = pow(v1 + v2, 2);
    num b = pow(d1, 2);
    num c = sqrt(a + b);
    num DsL = sqrt(radii['rL']! * c);
    num d = pow(v1, 2);
    num e = sqrt(d + a);
    num f = pow(e * e * v1 * v1, 0.25);
    num g = pow(a * d1 * d3, 0.25);
    num DmL = pow(f * f * g, 1 / 3);

    num L = 2e-7 * log(DmL / DsL);
    inductanceController.text = L.toStringAsExponential(5);

    num DmC = DmL;
    num DsC = sqrt(radii['rC']! * c);
    num k = 8.85 * pow(10, -12);
    num C = (2 * pi * k) / log(DmC / DsC);
    capacitanceController.text = C.toStringAsExponential(5);

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
              Text('L= ${inductanceController.text} [H/m]'),
              SizedBox(height: 8),
              Text('OUTPUT CAPACITANCE'),
              Text('C= ${capacitanceController.text} [F/m]'),
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
        title: Text('Double Circuit Unbundled Condcutor'),
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
                  'assets/image3.png', // Adjust the asset path
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
              TextField(
                controller: verticalDistanceABController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Vertical distance b/w conductor A and B (m)'),
              ),
              TextField(
                controller: verticalDistanceBCController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Vertical distance b/w conductor B and C (m)'),
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
}
