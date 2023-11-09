import 'package:daily_video_reminders/custom_progress_indicator.dart';
import 'package:daily_video_reminders/dropdown_chip.dart';
import 'package:daily_video_reminders/habit_card.dart';
import 'package:daily_video_reminders/pages/create_habit/color_picker_dialog.dart';
import 'package:daily_video_reminders/theme/theme.dart';
import 'package:daily_video_reminders/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../data/habit.dart';
import '../../data/unit_type.dart';
import '../../validators/form_validator.dart'; // Include this package for color picker

class CreateHabitPage extends StatefulWidget {
  @override
  _CreateHabitPageState createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  final _formKey = GlobalKey<FormState>();
  Habit habit = Habit.empty();
  bool get complete => progress == 100;
  int get progress {
    int _progress = 100;
    if (habit.title.isEmpty) {
      _progress -= 40;
    }
    if (habit.description.isEmpty) {
      _progress -= 20;
    }
    if (habit.valueGoal == 0) {
      _progress -= 10;
    }
    if (habit.unitIncrement == 0) {
      _progress -= 10;
    }
    if (habit.emoji.isEmpty) {
      _progress -= 10;
    }
    if (habit.streakEmoji.isEmpty) {
      _progress -= 5;
    }
    if (habit.hexColor.isEmpty) {
      _progress -= 5;
    }

    return _progress;
  }

  Widget formField() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Enter your message',
          labelStyle: TextStyle(
            color: Colors.blueGrey, // Label color
            fontWeight: FontWeight.bold, // Label weight
          ),
          hintText: 'Type something...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500, // Hint text color
          ),
          prefixIcon: Icon(
            Icons.message, // Icon at the beginning of the TextFormField
            color: Colors.lightBlue,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.insert_emoticon, // Icon at the end of the TextFormField
              color: Colors.lightBlue,
            ),
            onPressed: () {
              // Define the action when the icon is pressed
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.lightBlue.shade200, // Color of the border
              width: 2.0, // Width of the border
            ),
            borderRadius: BorderRadius.circular(10.0), // Border corner radius
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors
                  .lightBlue, // Color of the border when the TextFormField is focused
              width:
                  2.5, // Width of the border when the TextFormField is focused
            ),
            borderRadius: BorderRadius.circular(
                15.0), // Border corner radius when the TextFormField is focused
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors
                  .red, // Color of the border when the TextFormField has an error
              width:
                  2.0, // Width of the border when the TextFormField has an error
            ),
            borderRadius: BorderRadius.circular(
                10.0), // Border corner radius when the TextFormField has an error
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red
                  .shade700, // Color of the border when the TextFormField is focused and has an error
              width:
                  2.5, // Width of the border when the TextFormField is focused and has an error
            ),
            borderRadius: BorderRadius.circular(
                15.0), // Border corner radius when the TextFormField is focused and has an error
          ),
          filled: true, // If true, the text field will be filled with fillColor
          fillColor: Colors.blue.shade50, // The color of the fill when enabled
          contentPadding:
              EdgeInsets.all(16.0), // Inner padding of the TextFormField
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {});
  }

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _incrementFocus = FocusNode();
  final FocusNode _unitTypeFocus = FocusNode();
  final FocusNode _goalFocus = FocusNode();
  final FocusNode _emojiFocus = FocusNode();
  final FocusNode _streakEmojiFocus = FocusNode();
  final FocusNode _colorFocus = FocusNode();

  // You might want to initialize these if they have default values
  Color currentColor = Colors.limeAccent;

  // Add any other state variables or controllers you might need

  void onPickColor(Color color) {
    setState(() {
      habit = habit.copyWith(
          hexColor: '#${color.value.toRadixString(16).padLeft(8, '0')}');
    });
    Navigator.of(context).pop();
  }
  void setHabit(Habit habit){
    setState(() {
      this.habit = habit;
    });
  }

  void pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ColorPickerDialog(onSubmit: (color) => onPickColor(color));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _getCompleteIndicator(),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Create Habit",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                Expanded(
                  child: Container(),
                ),
                CloseButton(
                  color: rubyDark,
                  style: ButtonStyle(
                    iconSize: MaterialStateProperty.all(32),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  width: 4,
                ),
              ],
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(8.0),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomFormField(
                        focusNode: _titleFocus,
                        label: "Habit",
                        onChanged: (val) =>
                            setHabit(habit.copyWith(title: val)),
                        validator: (str) =>
                            FormValidator.nonEmpty(str, "Habit"),
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_descriptionFocus),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomFormField(
                        focusNode: _descriptionFocus,
                        label: "Commitment",
                        onChanged: (val) =>
                            setHabit(habit.copyWith(title: val)),
                        validator: (str) =>
                            FormValidator.nonEmpty(str, "Commitment"),
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_incrementFocus),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomFormField(
                        focusNode: _incrementFocus,
                        label: "Increment",
                        onChanged: (val) =>
                            setHabit(habit.copyWith(title: val)),
                        validator: (str) =>
                            FormValidator.nonEmpty(str, "Increment"),
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_goalFocus),
                      ),
                    ),
                    HabitCard(
                      habit: habit,
                      voidCallback: () {
                        pickColor();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCompleteIndicator() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomProgressIndicator(
                size: ProgressIndicatorSize.medium,
                value: progress.toDouble(),
                label: (progress).toStringAsPrecision(3) + "%",
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: complete ? rubyLight : Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: TextButton(
                    child: Text(
                      complete ? "Submit" : "Completing...",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
