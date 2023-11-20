// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mementoh/pages/create_habit/display_habit_card.dart';
import 'package:mementoh/util/color_util.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'package:mementoh/data/frequency_type.dart';
import 'package:mementoh/habit_card.dart';
import 'package:mementoh/pages/create_habit/color_picker_dialog.dart';
import 'package:mementoh/pages/create_habit/selector_dialog.dart';
import 'package:mementoh/pages/video/dvr_close_button.dart';
import 'package:mementoh/theme/theme.dart';
import 'package:mementoh/widgets/custom_form_field.dart';
import 'package:mementoh/widgets/stylized_checkbox.dart';

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

  bool hasCompletedHabit = false;
  bool hasFocusedOnFrequency = false;
  TextEditingController colorTextEdittingController = TextEditingController(text: "Red");
  bool hasFocusedOnColor = false;
  Habit habit = Habit.empty();
  bool get complete => progress == 100;
  int get progress {
    int _progress = 0;
    if (hasCompletedHabit) _progress += 35;
    if (habit.hexColor.isNotEmpty) _progress += 35;
    _progress += 30;

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

  final FocusNode _stringValueFocus = FocusNode();
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
      colorTextEdittingController.text = ColorUtil.getStringFromHex(ColorUtil.getColorFromHex(habit.hexColor));
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _frequencyController.text = "Daily";
    habit = habit.copyWith(
        stringValue: _stringValueController.text, valueGoal: 1, suffix: "", frequencyType: FrequencyType.daily, hexColor: Colors.red.toHex());

    _stringValueFocus.requestFocus();
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
        return ColorPickerDialog(
          onSubmit: (color) => onPickColor(color),
          initialColor: ColorUtil.getColorFromHex(habit.hexColor),
        );
      },
    );
  }

  bool get focused => _stringValueFocus.hasFocus || _quantityFocus.hasFocus || _suffixFocus.hasFocus;

  TextEditingController _stringValueController = TextEditingController(text: "");
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
                  "Create a Habit",
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
                    _habitField(context),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: GestureDetector(
                    //     onTap: () {

                    //       showDialog(
                    //           context: context,
                    //           builder: (ctx) {
                    //             return SelectorDialog(
                    //               values: FrequencyType.values.map((e) => e.toUiString()).toList(),
                    //               onSelect: (String prettyString) {
                    //                 setState(() {
                    //                   _frequencyController.text = prettyString;
                    //                 });
                    //                 setHabit(
                    //                   habit.copyWith(
                    //                       frequencyType: FrequencyType.values.where((element) => element.toUiString() == prettyString).first),
                    //                 );
                    //                 Navigator.of(context).pop();
                    //               },
                    //             );
                    //           });
                    //     },
                    //     child: CustomFormField(
                    //       focusNode: _frequencyFocus,
                    //       label: "Frequency",
                    //       enabled: false,
                    //       onChanged: (val) {
                    //         setState(() {
                    //           hasFocusedOnFrequency = true;
                    //         });
                    //         setHabit(habit.copyWith(stringValue: val));
                    //       },
                    //       validator: (str) => FormValidator.nonEmpty(str, "Frequency"),
                    //       onEditingComplete: () => FocusScope.of(context).unfocus(),
                    //       value: _frequencyController,
                    //     ),
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          pickColor();
                        },
                        child: CustomFormField(
                          focusNode: _frequencyFocus,
                          label: "Color",
                          enabled: false,
                          onChanged: (val) {
                            setState(() {
                              hasFocusedOnFrequency = true;
                            });
                            setHabit(habit.copyWith(stringValue: val));
                          },
                          validator: (str) => FormValidator.nonEmpty(str, "Color"),
                          onEditingComplete: () => FocusScope.of(context).unfocus(),
                          value: colorTextEdittingController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Visibility(
                              visible: progress >= 70,
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Daily: "),
                        StylizedCheckbox(
                          isChecked: habit.frequencyType == FrequencyType.daily,
                          onTap: () {
                            setHabit(habit.copyWith(frequencyType: FrequencyType.daily));
                          },
                          size: Size(50, 50),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Every Other Day: "),
                          StylizedCheckbox(
                            isChecked: habit.frequencyType == FrequencyType.everyOtherDay,
                            onTap: () {
                              setHabit(habit.copyWith(frequencyType: FrequencyType.everyOtherDay));
                            },
                            size: Size(50, 50),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Weekly: "),
                        StylizedCheckbox(
                          isChecked: habit.frequencyType == FrequencyType.weekly,
                          onTap: () {
                            setHabit(habit.copyWith(frequencyType: FrequencyType.weekly));
                          },
                          size: Size(50, 50),
                        ),
                      ],
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

  Padding _habitField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomFormField(
        value: _stringValueController,
        focusNode: _stringValueFocus,
        label: "Habit",
        onChanged: (val) {
          setHabit(habit.copyWith(stringValue: val));
        },
        validator: (str) => FormValidator.nonEmpty(str, "stringValue"),
        onEditingComplete: () {
          setState(() {
            if (habit.stringValue.isNotEmpty) hasCompletedHabit = true;
          });
          FocusScope.of(context).requestFocus(_quantityFocus);
        },
      ),
    );
  }

  Padding _selectColor(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomFormField(
        value: _stringValueController,
        focusNode: _stringValueFocus,
        label: "Habit",
        enabled: false,
        onChanged: (val) {},
        validator: (str) => null,
        onEditingComplete: () {},
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
