import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField(
      {super.key,
      required this.focusNode,
      required this.label,
      required this.onChanged,
      required this.validator,
      required this.onEditingComplete,
      this.keyboardType = TextInputType.text,
      this.initialValue,
      this.value,
      this.enabled = true});
  final TextEditingController? value;
  final bool enabled;
  final TextInputType keyboardType;
  final String? initialValue;

  final FocusNode focusNode;
  final String label;
  final Function(String) onChanged;
  final String? Function(String?) validator;
  final Function? onEditingComplete;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool cleared = false;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller = widget.value ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        enabled: widget.enabled,
        initialValue: widget.initialValue,
        onTap: () {
          if (!cleared) {
            setState(() {
              cleared = true;
              controller.clear();
            });
          }
        },
        controller: controller,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              controller.clear();
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1, color: Colors.black), color: Colors.black),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        inputFormatters: [
          SentenceCaseInputFormatter(),
        ],
        onChanged: widget.onChanged,
        cursorColor: Colors.black,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        validator: widget.validator,
        onEditingComplete: () {
          if (widget.onEditingComplete != null) {
            widget.onEditingComplete!();
          }
        });
  }
}

class SentenceCaseInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Capitalize the first letter of each sentence
    final text = _capitalizeSentences(newValue.text);
    return TextEditingValue(
      text: text,
      selection: newValue.selection,
    );
  }

  String _capitalizeSentences(String input) {
    if (input.isEmpty) return input;

    final sentences = input.split(RegExp(r'(?<=[.!?])\s+'));
    final capitalizedSentences = sentences.map((sentence) => _capitalizeFirstLetter(sentence));
    return capitalizedSentences.join(' ');
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
