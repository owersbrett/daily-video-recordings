import 'package:mementohr/pages/create_habit/display_habit_card.dart';
import 'package:mementohr/util/color_util.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mementohr/data/frequency_type.dart';
import 'package:mementohr/pages/create_habit/color_picker_dialog.dart';
import 'package:mementohr/pages/video/dvr_close_button.dart';
import 'package:mementohr/widgets/custom_form_field.dart';
import 'package:mementohr/widgets/stylized_checkbox.dart';
import '../../bloc/habits/habits.dart';
import '../../data/habit.dart';
import '../../data/habit_entity.dart';
import '../../util/string_util.dart';
import '../../validators/form_validator.dart'; // Include this package for color picker

class UpdateHabitPage extends StatefulWidget {
  const UpdateHabitPage({super.key, required this.dateToAddHabit, required this.habit});
  final Habit habit;
  final DateTime dateToAddHabit;
  @override
  _UpdateHabitPageState createState() => _UpdateHabitPageState();
}

class _UpdateHabitPageState extends State<UpdateHabitPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emojiController = TextEditingController();
  bool emojiShowing = false;

  bool hasCompletedHabit = false;
  bool hasFocusedOnFrequency = false;
  TextEditingController colorTextEdittingController = TextEditingController(text: "Red");
  bool hasFocusedOnColor = false;
  Habit habit = Habit.empty();
  bool get complete => progress == 100;
  int get progress {
    int _progress = 100;
    if (habit.stringValue.isEmpty) {
      _progress -= 50;
    }

    return _progress;
  }

  Widget formField() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: 'Enter your message',
          labelStyle: const TextStyle(
            color: Colors.blueGrey, // Label color
            fontWeight: FontWeight.bold, // Label weight
          ),
          hintText: 'Type something...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500, // Hint text color
          ),
          prefixIcon: const Icon(
            Icons.message, // Icon at the beginning of the TextFormField
            color: Colors.lightBlue,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
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
            borderSide: const BorderSide(
              color: Colors.lightBlue, // Color of the border when the TextFormField is focused
              width: 2.5, // Width of the border when the TextFormField is focused
            ),
            borderRadius: BorderRadius.circular(15.0), // Border corner radius when the TextFormField is focused
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
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
          contentPadding: const EdgeInsets.all(16.0), // Inner padding of the TextFormField
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (value) {});
  }

  final FocusNode _stringValueFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _suffixFocus = FocusNode();
  final FocusNode _frequencyFocus = FocusNode();
  Color currentColor = Colors.limeAccent;

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
    habit = widget.habit;
    _stringValueController.text = habit.stringValue;
    emojiController.text = habit.emoji;
    colorTextEdittingController.text = ColorUtil.getStringFromHex(ColorUtil.getColorFromHex(habit.hexColor));
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

  final TextEditingController _stringValueController = TextEditingController(text: "");
  final TextEditingController _frequencyController = TextEditingController();

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
                const SizedBox(
                  width: 12,
                ),
                const Text(
                  "Update a Habit",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Expanded(
                  child: Container(),
                ),
                DVRCloseButton(onPressed: () => Navigator.of(context).pop(), positioned: false, color: Colors.black),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
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
                        habitEntity: HabitEntity(habit: habit, habitEntries: const [], habitEntryNotes: const []),
                        progress: progress,
                        checkable: false,
                        streakEmoji: habit.streakEmoji,
                        emoji: habit.emoji,
                      ),
                    ),
                    _habitField(context),
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
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            emojiShowing = !emojiShowing;
                            emojiController.clear();
                          });
                          setHabit(habit.copyWith(emoji: ""));
                        },
                        child: CustomFormField(
                          focusNode: FocusNode(),
                          label: "Emoji",
                          enabled: false,
                          onChanged: (val) {},
                          validator: (str) => FormValidator.nonEmpty(str, "Emoji"),
                          onEditingComplete: () => FocusScope.of(context).unfocus(),
                          value: emojiController,
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
                                  BlocProvider.of<HabitsBloc>(context).add(UpdateHabit(habit));
                                  Navigator.of(context).pop();
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(16),
                                  elevation: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black, width: 2),
                                        color: Colors.white),
                                    height: MediaQuery.of(context).size.height * .2,
                                    child: Center(
                                        child: Text(
                                      "Update",
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: StringUtil.outlinedText(strokeWidth: 1)),
                                    )),
                                  ),
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
                        const Text("Daily: "),
                        StylizedCheckbox(
                          isChecked: habit.frequencyType == FrequencyType.daily,
                          onTap: () {
                            setHabit(habit.copyWith(frequencyType: FrequencyType.daily));
                          },
                          size: const Size(50, 50),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Every Other Day: "),
                          StylizedCheckbox(
                            isChecked: habit.frequencyType == FrequencyType.everyOtherDay,
                            onTap: () {
                              setHabit(habit.copyWith(frequencyType: FrequencyType.everyOtherDay));
                            },
                            size: const Size(50, 50),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Weekly: "),
                        StylizedCheckbox(
                          isChecked: habit.frequencyType == FrequencyType.weekly,
                          onTap: () {
                            setHabit(habit.copyWith(frequencyType: FrequencyType.weekly));
                          },
                          size: const Size(50, 50),
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
}
