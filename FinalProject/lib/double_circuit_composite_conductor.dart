import 'package:flutter/material.dart';
import 'dart:math';

class DoubleCircuitCompositeConductorScreen extends StatefulWidget {
  @override
  _DoubleCircuitCompositeConductorScreenState createState() =>
      _DoubleCircuitCompositeConductorScreenState();
}

class _DoubleCircuitCompositeConductorScreenState
    extends State<DoubleCircuitCompositeConductorScreen> {
  TextEditingController distanceAController = TextEditingController();
  TextEditingController distanceBController = TextEditingController();
  TextEditingController distanceCController = TextEditingController();
  TextEditingController verticalDistanceABController = TextEditingController();
  TextEditingController verticalDistanceBCController = TextEditingController();
  TextEditingController verticalDistanceCAController = TextEditingController();

  String selectedConductorType = 'warving';

  TextEditingController inductanceController = TextEditingController();
  TextEditingController capacitanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Double Circuit Composite Conductor'),
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
                  'assets/image4.png', // Adjust the asset path
                  // fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: distanceAController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Distance between conductor A and A* (m)'),
              ),
              TextField(
                controller: distanceBController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Distance between conductor B and B* (m)'),
              ),
              TextField(
                controller: distanceCController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Distance between conductor C and C* (m)'),
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
              TextField(
                controller: verticalDistanceCAController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Vertical distance b/w conductor C and A (m)'),
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
                onPressed: () {
                  calculateResults();
                },
                child: Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateResults() {
    double d1 = double.parse(distanceAController.text);
    double d2 = double.parse(distanceBController.text);
    double d3 = double.parse(distanceCController.text);
    double v1 = double.parse(verticalDistanceABController.text);
    double v2 = double.parse(verticalDistanceBCController.text);
    double v3 = double.parse(verticalDistanceCAController.text);

    Map<String, double> radii = getRadii(selectedConductorType);

    num dab = pow(
        (pow(v1, 2) + pow((d1 - d2) / 2, 2)) *
            (pow(v1, 2) + pow(d1 - (d1 - d2) / 2, 2)),
        0.25);
    num dbc = pow(
        (pow(v2, 2) + pow((d3 - d2) / 2, 2)) *
            (pow(v2, 2) + pow(d3 - (d3 - d2) / 2, 2)),
        0.25);
    num dca = pow((pow(v3, 2) + pow(d3, 2)) * pow(v3, 2), 0.25);
    num Deq = pow((dab * dbc * dca), 1 / 3);
    num dsa = sqrt(radii['rL']! * d1); // ds(a-a')
    num dsb = sqrt(radii['rL']! * d2); // ds(b-b')
    num dsc = sqrt(radii['rL']! * d3); // ds(c-c')
    num Ds = pow((dsa * dsb * dsc), 1 / 3);
    num L = 2 * pow(10, -7) * log(Deq / Ds);

    inductanceController.text = L.toStringAsExponential(5);

    num dsca = sqrt(radii['rC']! * d1);
    num dscb = sqrt(radii['rC']! * d2);
    num dscc = sqrt(radii['rC']! * d3);
    num Dsc = pow((dsca * dscb * dscc), 1 / 3);
    num k = 8.85 * pow(10, -12);
    num C = (2 * pi * k) / log(Deq / Dsc);
    capacitanceController.text = C.toStringAsExponential(5);
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
