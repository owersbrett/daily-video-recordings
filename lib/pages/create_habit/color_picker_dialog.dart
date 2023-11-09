// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    Key? key,
    required this.onSubmit,
    this.initialColor = Colors.black,
  }) : super(key: key);
  final Function(Color) onSubmit;
  final Color initialColor;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color currentColor = Colors.black;
  void changeColor(Color color) {
    setState(() => currentColor = color);
  }



  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          'Pick a color',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: changeColor,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
backgroundColor: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text('Pick', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
            ),
            onPressed: () {
              widget.onSubmit(currentColor);
            },
          ),
        ],
      ),
    );
  }
}
