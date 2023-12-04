import 'package:flutter/material.dart';
import 'package:habitbit/pages/home/custom_circular_indicator_v2.dart';
import 'package:habitbit/pages/home/now_data.dart';
import 'package:habitbit/pages/home/orbital_indicator.dart';
import 'package:habitbit/pages/home/orbital_page.dart';
import 'package:habitbit/pages/home/orbital_state.dart';
import 'package:habitbit/widgets/custom_circular_indicator.dart';
import '../../bloc/experience/experience.dart';
import '../../bloc/habits/habits.dart';
import '../../navigation/navigation.dart';

class Habitbit extends StatefulWidget {
  const Habitbit({
    Key? key,
    required this.onStart,
    required this.nowData,
  }) : super(key: key);
  final Function onStart;
  final NowData nowData;

  @override
  State<Habitbit> createState() => _HabitbitState();
}

class _HabitbitState extends State<Habitbit> {
  static String experienceTag = "experience-hero";
  DateTime get currentTime => DateTime.now();
  Duration countdownDuration = const Duration(hours: 1);
  Duration get remainingTime => countdownDuration - currentTime.difference(widget.nowData.startTimerTimer ?? DateTime.now());
  double get remainingDurationExpressedAsDouble => remainingTime.inSeconds / countdownDuration.inSeconds;

  double getremainingDurationPercentage(Duration originalDuration, Duration remainingDuration) {
    if (originalDuration.inSeconds == 0) {
      return 0; // Avoid division by zero
    }
    double percentage = (remainingDuration.inSeconds / originalDuration.inSeconds) * 100;
    return percentage.clamp(0, 100); // Ensures the value is between 0 and 100
  }

  Hero hero(double percentageToNextLevel, [Size size = const Size(300, 300), int level = 1]) => Hero(
      tag: experienceTag,
      child: BlocBuilder<HabitsBloc, HabitsState>(
        builder: (context, state) {
          return OrbitalIndicator(
            currentTicks: state.todaysHabitEntries.fold(0, (previousValue, element) => (previousValue + (element.booleanValue ? 1 : 0))),
            progress: percentageToNextLevel,
            key: const ValueKey("weekday-hero"),
            centerText: level.toString(),
            totalTicks: state.todaysHabitEntries.length,
            size: size,
          );
        },
      ));
  Widget orbitalIndicatorPage(double percentageToNextLevel, int level) => OrbitalPage(
        tag: experienceTag,
        progress: percentageToNextLevel,
        hero: hero(percentageToNextLevel, Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height), level),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExperienceBloc, ExperienceState>(
      builder: (context, state) {
        var level = state.currentLevel();
        var percentageToNextLevel = state.percentageToNextLevel();
        return Container(
          padding: const EdgeInsets.all(10), // Add padding if needed
          child: Center(
            child: ListView(
              children: <Widget>[
                const Center(
                  child: Text(
                    'Habitbit',
                    style: TextStyle(
                        fontSize: 24, // Adjust the font size as needed
                        fontWeight: FontWeight.bold, // Make the title bold
                        color: Colors.white),
                  ),
                ),
                Text(
                  'Habit Tracker',
                  style: TextStyle(
                    fontSize: 16, // Adjust the font size as needed
                    color: Colors.grey[600], // Adjust the color as needed
                  ),
                  textAlign: TextAlign.center, // Center align the subtitle text
                ),
                const SizedBox(height: 16), // Space between subtitle and button
                Center(
                  child: Text(
                    widget.nowData.getWeekAndSeason(widget.nowData.currentTime),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigation.createRoute(orbitalIndicatorPage(percentageToNextLevel, level), context, AnimationEnum.fadeIn);
                  },
                  child: hero(percentageToNextLevel, Size(300, 300), level),
                ),
                const SizedBox(height: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text("Features:", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center)
                    ]),
                    SizedBox(height: 12), // Space between subtitle and button
                    Text("- Add Habits To Track Consistency", style: TextStyle(color: Colors.white, fontSize: 14)),
                    SizedBox(height: 12), // Space between subtitle and button
                    Text("- Upload Videos To Leave Mementos", style: TextStyle(color: Colors.white, fontSize: 14)),
                    SizedBox(height: 12), // Space between subtitle and button
                    Text("- Gain Experience To Level Up", style: TextStyle(color: Colors.white, fontSize: 14)),
                    SizedBox(height: 12), // Space between subtitle and button
                    Text("- Access Weekly Reports", style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
