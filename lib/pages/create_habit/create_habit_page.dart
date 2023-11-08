import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../data/unit_type.dart'; // Include this package for color picker

class CreateHabitPage extends StatefulWidget {
  @override
  _CreateHabitPageState createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  final _formKey = GlobalKey<FormState>();
  late int id;
  late String title;
  late int value = 0;
  late int valueGoal;
  late String description;
  late UnitType unitType = UnitType.boolean;
  late String emoji;
  late String metricOne;
  late String hexColor;
  late String metricTwo;
  late String metricThree;
  late DateTime createDate;
  late DateTime updateDate;

  // You might want to initialize these if they have default values
  Color currentColor = Colors.limeAccent;

  // Add any other state variables or controllers you might need

  void changeColor(Color color) {
    setState(() => currentColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Habit'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) {
                title = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(height: 8.0),
            // ... Repeat similar TextFormField widgets for each field
            // For UnitType dropdown:
            DropdownButtonFormField<UnitType>(
              value: unitType,
              decoration: InputDecoration(
                labelText: 'Unit Type',
                border: OutlineInputBorder(),
              ),
              onChanged: (UnitType? newValue) {
                setState(() {
                  unitType = newValue!;
                });
              },
              items: UnitType.values.map((UnitType classType) {
                return new DropdownMenuItem<UnitType>(
                  value: classType,
                  child: new Text(classType.toString().split('.').last),
                );
              }).toList(),
              onSaved: (value) {
                unitType = value!;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a unit type';
                }
                return null;
              },
            ),
            // For createDate and updateDate pickers:
            // Implement date pickers that set the value of createDate and updateDate
            // For hexColor color picker:
            ElevatedButton(
              child: Text('Pick a color'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Pick a color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: currentColor,
                          onColorChanged: changeColor,
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('Got it'),
                          onPressed: () {
                            setState(() => hexColor = '#${currentColor.value.toRadixString(16).padLeft(8, '0')}');
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SizedBox(height: 8.0),
            // Add other form fields here
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Save the form data to the database or state
                }
              },
              child: Text('Submit Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
