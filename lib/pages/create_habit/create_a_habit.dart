import 'package:flutter/services.dart';
import 'package:habit_planet/pages/create_habit/display_habit_card.dart';
import 'package:habit_planet/service/admin_service.dart';
import 'package:habit_planet/theme/theme.dart';
import 'package:habit_planet/tooltip_text.dart';
import 'package:habit_planet/util/color_util.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:habit_planet/data/frequency_type.dart';
import 'package:habit_planet/pages/create_habit/color_picker_dialog.dart';
import 'package:habit_planet/pages/video/dvr_close_button.dart';
import 'package:habit_planet/widgets/custom_form_field.dart';
import 'package:habit_planet/widgets/stylized_checkbox.dart';
import '../../bloc/habits/habits.dart';
import '../../bloc/user/user_bloc.dart';
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
  int habitsIndex = 0;
  final TextEditingController _emojiController = TextEditingController(text: StringUtil.getRandomEmoji());
  final TextEditingController _streakEmojiController = TextEditingController(text: "🔥");
  FocusNode emojiFocusNode = FocusNode();
  FocusNode streakEmojiFocusNode = FocusNode();
  bool emojiShowing = false;

  bool hasCompletedHabit = false;
  bool hasFocusedOnFrequency = false;
  TextEditingController _colorTextEdittingController = TextEditingController();
  bool hasFocusedOnColor = false;
  Habit habit = Habit.empty(ColorUtil.randomColor());
  bool get complete => progress == 100;
  int get progress {
    int _progress = 0;
    if (habit.stringValue.isNotEmpty) _progress += 35;
    if (habit.hexColor.isNotEmpty) _progress += 35;
    if (habit.emoji.isNotEmpty) _progress += 30;

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

  List<Habit> get exampleHabits => AdminService.get50Habits(BlocProvider.of<UserBloc>(context).state.user.id!, true);

  void onPickColor(Color color) {
    setState(() {
      habit = habit.copyWith(hexColor: '#${color.value.toRadixString(16).padLeft(8, '0')}');
      _colorTextEdittingController.text = ColorUtil.getStringFromHex(ColorUtil.getColorFromHex(habit.hexColor));
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _frequencyController.text = "Daily";
    habit = habit.copyWith(
      stringValue: _stringValueController.text,
      valueGoal: 1,
      suffix: "",
      frequencyType: FrequencyType.daily,
      hexColor: ColorUtil.randomColor().toHex(),
      emoji: _emojiController.text,
      streakEmoji: _streakEmojiController.text,
    );
    _colorTextEdittingController.text = ColorUtil.getStringFromHex(ColorUtil.getColorFromHex(habit.hexColor));
    // _stringValueFocus.requestFocus();
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: progress >= 70,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FloatingActionButton(
                  heroTag: "Create a habit",
                  backgroundColor: darkEmerald,
                  onPressed: () {
                    Logger.root.info("Habit: $habit");
                    if (_formKey.currentState?.validate() ?? false) {
                      BlocProvider.of<HabitsBloc>(context).add(AddHabit(habit.copyWith(emoji: _emojiController.text), widget.dateToAddHabit));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Icon(
                    Icons.save,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
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
                  "Create a Habit",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Expanded(
                  child: Container(),
                ),
                DVRCloseButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                    },
                    positioned: false,
                    color: Colors.black),
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
                            habit = AdminService.getRandomHabit(BlocProvider.of<UserBloc>(context).state.user.id!);
                            _stringValueController.text = habit.stringValue;

                            _colorTextEdittingController.text = ColorUtil.getStringFromHex(ColorUtil.getColorFromHex(habit.hexColor));
                            _frequencyController.text = habit.frequencyType.toUiString();
                            _emojiController.text = habit.emoji;
                            _streakEmojiController.text = habit.streakEmoji;
                          });
                        }
                      },
                      child: Tooltip(
                        message: TooltipText.getHabitCardTooltip(habit.stringValue),
                        child: DisplayHabitCard(
                          habitEntity: HabitEntity(habit: habit, habitEntries: const [], habitEntryNotes: const []),
                          progress: progress,
                          checkable: false,
                          streakEmoji: habit.streakEmoji,
                          emoji: habit.emoji,
                        ),
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
                          value: _colorTextEdittingController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomFormField(
                        focusNode: emojiFocusNode,
                        label: "Emoji",
                        onChanged: (val) {
                          setHabit(habit.copyWith(emoji: val));
                        },
                        validator: (str) => FormValidator.mustBeEmojiOrSingleCharacter(str, "Emoji"),
                        onEditingComplete: () => FocusScope.of(context).unfocus(),
                        value: _emojiController,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomFormField(
                        focusNode: streakEmojiFocusNode,
                        label: "Streak Emoji",
                        onChanged: (val) {
                          setHabit(habit.copyWith(streakEmoji: val));
                        },
                        validator: (str) => FormValidator.mustBeEmojiOrSingleCharacter(str, "Streak Emoji"),
                        onEditingComplete: () => FocusScope.of(context).unfocus(),
                        value: _streakEmojiController,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Visibility(
                    //           visible: progress >= 70,
                    //           child: InkWell(
                    //             onTap: () {
                    //               Logger.root.info("Habit: $habit");
                    //               if (_formKey.currentState?.validate() ?? false) {
                    //                 BlocProvider.of<HabitsBloc>(context)
                    //                     .add(AddHabit(habit.copyWith(emoji: emojiController.text), widget.dateToAddHabit));
                    //                 Navigator.of(context).pop();
                    //               }
                    //             },
                    //             child: Material(
                    //               borderRadius: BorderRadius.circular(16),
                    //               elevation: 5,
                    //               child: Container(
                    //                 decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(10),
                    //                     border: Border.all(color: Colors.black, width: 2),
                    //                     color: Colors.white),
                    //                 height: MediaQuery.of(context).size.height * .2,
                    //                 child: Center(
                    //                     child: Text(
                    //                   "Add",
                    //                   style: TextStyle(
                    //                       fontSize: 32,
                    //                       fontWeight: FontWeight.bold,
                    //                       color: Colors.white,
                    //                       shadows: StringUtil.outlinedText(strokeWidth: 1)),
                    //                 )),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),

                    ...frequencyRows()
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
        validator: (str) => FormValidator.nonEmpty(str, "Habit"),
        onEditingComplete: () {
          setState(() {
            if (habit.stringValue.isNotEmpty) hasCompletedHabit = true;
          });
          FocusScope.of(context).requestFocus(_quantityFocus);
        },
      ),
    );
  }

  List<Widget> frequencyRows() {
    return FrequencyType.values.map((e) => frequencyRow(e)).toList();
  }

  Widget frequencyRow(FrequencyType type) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        setHabit(habit.copyWith(frequencyType: type));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StylizedCheckbox(
              isChecked: habit.frequencyType == type,
              onTap: () {
                HapticFeedback.lightImpact();
                setHabit(habit.copyWith(frequencyType: type));
              },
              size: const Size(50, 50),
            ),
            const SizedBox(width: 8),
            Text(type.toUiString()),
          ],
        ),
      ),
    );
  }
}
