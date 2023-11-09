// import 'package:flutter/material.dart';

// class CustomSlider extends StatefulWidget {
//   final int valueGoal; // Your habit.valueGoal
//   final int min;
//   final int max;
//   final Function(int increment) onChange;

//   CustomSlider({
//     Key? key,
//     required this.valueGoal,
//     this.min = 0, // Assuming your slider starts at 0
//     required this.max,
//     required void Function(int increment) this.onChange,
//   }) : super(key: key);

//   @override
//   _CustomSliderState createState() => _CustomSliderState();
// }

// class _CustomSliderState extends State<CustomSlider> {
//   double _currentSliderValue = 1;

//   @override
//   void initState() {
//     super.initState();
//     _currentSliderValue = widget.min.toDouble(); // Start with the minimum value
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Slider(
//       value: _currentSliderValue,
//       min: widget.min.toDouble() == 0 ? 1 : widget.min.toDouble(),
//       max: widget.max.toDouble(),
//       divisions: (widget.max - widget.min) ~/ widget.valueGoal,
//       label: _currentSliderValue.round().toString(),
//       onChanged: (value) {
//         setState(() {
//           // Round the value to the nearest increment that is divisible by valueGoal
//           _currentSliderValue =
//               (value / widget.valueGoal).round() * widget.valueGoal.toDouble();
//           widget.onChange(_currentSliderValue.toInt());
//         });
//       },
//     );
//   }
// }
