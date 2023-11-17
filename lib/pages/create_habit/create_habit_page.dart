// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:daily_video_reminders/pages/create_habit/display_habit_card.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'package:daily_video_reminders/data/frequency_type.dart';
import 'package:daily_video_reminders/habit_card.dart';
import 'package:daily_video_reminders/pages/create_habit/color_picker_dialog.dart';
import 'package:daily_video_reminders/pages/create_habit/selector_dialog.dart';
import 'package:daily_video_reminders/pages/video/dvr_close_button.dart';
import 'package:daily_video_reminders/theme/theme.dart';
import 'package:daily_video_reminders/widgets/custom_form_field.dart';

import '../../bloc/habits/habits.dart';
import '../../data/db.dart';
import '../../data/habit.dart';
import '../../data/habit_entity.dart';
import '../../util/string_util.dart';
import '../../validators/form_validator.dart'; // Include this package for color picker

class CreateHabitPage extends StatefulWidget {
  const CreateHabitPage({super.key, required this.dateToAddHabit});
  final DateTime dateToAddHabit;
  @override
  _CreateHabitPageState createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  final _formKey = GlobalKey<FormState>();

  bool hasFocusedOnVerb = false;
  bool hasFocusedOnQuantity = false;
  bool hasFocusedOnSuffix = false;
  bool hasFocusedOnFrequency = false;
  bool hasFocusedOnColor = false;
  Habit habit = Habit.empty();
  bool get complete => progress == 100;
  int get progress {
    int _progress = 0;
    if (hasFocusedOnColor) _progress += 20;
    if (hasFocusedOnVerb) _progress += 20;
    if (hasFocusedOnQuantity) _progress += 20;
    if (hasFocusedOnSuffix) _progress += 20;
    if (hasFocusedOnFrequency) _progress += 20;

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
              color: Colors.lightBlue, // Color of the border when the TextFormField is focused
              width: 2.5, // Width of the border when the TextFormField is focused
            ),
            borderRadius: BorderRadius.circular(15.0), // Border corner radius when the TextFormField is focused
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red, // Color of the border when the TextFormField has an error
              width: 2.0, // Width of the border when the TextFormField has an error
            ),
            borderRadius: BorderRadius.circular(10.0), // Border corner radius when the TextFormField has an error
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red.shade700, // Color of the border when the TextFormField is focused and has an error
              width: 2.5, // Width of the border when the TextFormField is focused and has an error
            ),
            borderRadius: BorderRadius.circular(15.0), // Border corner radius when the TextFormField is focused and has an error
          ),
          filled: true, // If true, the text field will be filled with fillColor
          fillColor: Colors.blue.shade50, // The color of the fill when enabled
          contentPadding: EdgeInsets.all(16.0), // Inner padding of the TextFormField
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {});
  }

  final FocusNode _verbFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _suffixFocus = FocusNode();
  final FocusNode _unitTypeFocus = FocusNode();
  final FocusNode _frequencyFocus = FocusNode();
  final FocusNode _goalFocus = FocusNode();
  final FocusNode _emojiFocus = FocusNode();
  final FocusNode _streakEmojiFocus = FocusNode();
  final FocusNode _colorFocus = FocusNode();

  // You might want to initialize these if they have default values
  Color currentColor = Colors.limeAccent;

  // Add any other state variables or controllers you might need

  void onPickColor(Color color) {
    setState(() {
      habit = habit.copyWith(hexColor: '#${color.value.toRadixString(16).padLeft(8, '0')}');
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _frequencyController.text = "Daily";
    habit = habit.copyWith(verb: _verbController.text, valueGoal: 10, suffix: "Pages", frequencyType: FrequencyType.daily);
    _verbFocus.requestFocus();
  }

  void setHabit(Habit habit) {
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

  bool get focused => _verbFocus.hasFocus || _quantityFocus.hasFocus || _suffixFocus.hasFocus;

  TextEditingController _verbController = TextEditingController(text: "Read");
  TextEditingController _quantityController = TextEditingController(text: "10");
  TextEditingController _suffixController = TextEditingController(text: "Pages");
  TextEditingController _frequencyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton:
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
                  "Track a Habit",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Expanded(
                  child: Container(),
                ),
                DVRCloseButton(onPressed: () => Navigator.of(context).pop(), positioned: false, color: Colors.black),
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
                    GestureDetector(
                      onTap: () {
                        if (focused) {
                          FocusScope.of(context).unfocus();
                        } else {
                          setState(() {
                            hasFocusedOnColor = true;
                          });
                          pickColor();
                        }
                      },
                      child: DisplayHabitCard(
                        habitEntity: HabitEntity(habit: habit, habitEntries: [], habitEntryNotes: []),
                        progress: progress,
                        checkable: false,
                      ),
                    ),
                    _verbField(context),
                    _quantityField(context),
                    _suffixField(context),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return SelectorDialog(
                                  values: FrequencyType.values.map((e) => e.toPrettyString()).toList(),
                                  onSelect: (String prettyString) {
                                    setState(() {
                                      _frequencyController.text = prettyString;
                                    });
                                    setHabit(
                                      habit.copyWith(
                                          frequencyType: FrequencyType.values.where((element) => element.toPrettyString() == prettyString).first),
                                    );
                                    Navigator.of(context).pop();
                                  },
                                );
                              });
                        },
                        child: CustomFormField(
                          focusNode: _frequencyFocus,
                          label: "Frequency",
                          enabled: false,
                          onChanged: (val) {
                            setState(() {
                              hasFocusedOnFrequency = true;
                            });
                            setHabit(habit.copyWith(verb: val));
                          },
                          validator: (str) => FormValidator.nonEmpty(str, "Frequency"),
                          onEditingComplete: () => FocusScope.of(context).unfocus(),
                          value: _frequencyController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Visibility(
                              visible: progress >= 80,
                              child: InkWell(
                                onTap: () {
                                  Logger.root.info("Habit: $habit");
                                  BlocProvider.of<HabitsBloc>(context).add(AddHabit(habit, widget.dateToAddHabit));
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black, width: 2),
                                      color: emeraldLight),
                                  height: MediaQuery.of(context).size.height * .2,
                                  child: Center(
                                      child: Text(
                                    "Add",
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: StringUtil.outlinedText(strokeWidth: 1)),
                                  )),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _suffixField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomFormField(
          focusNode: _suffixFocus,
          value: _suffixController,
          label: "Suffix",
          onChanged: (val) {
            setState(() {
              hasFocusedOnSuffix = true;
            });
            setHabit(habit.copyWith(suffix: val));
          },
          validator: (str) => FormValidator.nonEmpty(str, "Suffix"),
          onEditingComplete: () {
            setState(() {
              hasFocusedOnFrequency = true;
            });
            FocusScope.of(context).unfocus();
          }),
    );
  }

  Padding _quantityField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomFormField(
        focusNode: _quantityFocus,
        label: "Quantity",
        value: _quantityController,
        onChanged: (val) {
          setState(() {
            hasFocusedOnQuantity = true;
          });
          setHabit(habit.copyWith(valueGoal: int.tryParse(val)));
        },
        validator: (str) => FormValidator.mustBeAnInt(str, "Quantity"),
        onEditingComplete: () {
          setState(() {
            hasFocusedOnSuffix = true;
          });
          FocusScope.of(context).requestFocus(_suffixFocus);
        },
      ),
    );
  }

  Padding _verbField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomFormField(
        value: _verbController,
        focusNode: _verbFocus,
        label: "Verb",
        onChanged: (val) {
          setState(() {
            hasFocusedOnVerb = true;
          });
          setHabit(habit.copyWith(verb: val));
        },
        validator: (str) => FormValidator.nonEmpty(str, "Verb"),
        onEditingComplete: () {
          setState(() {
            hasFocusedOnQuantity = true;
          });
          FocusScope.of(context).requestFocus(_quantityFocus);
        },
      ),
    );
  }

  Widget _getCompleteIndicator() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(30),
                  color: complete ? rubyLight : Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
