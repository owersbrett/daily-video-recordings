import 'package:flutter/material.dart';
import 'package:mementohr/pages/home/custom_circular_indicator_v2.dart';
import 'package:mementohr/pages/home/now_data.dart';
import 'package:mementohr/pages/home/orbital_indicator.dart';
import 'package:mementohr/pages/home/orbital_page.dart';
import 'package:mementohr/widgets/custom_circular_indicator.dart';
import '../../bloc/experience/experience.dart';
import '../../bloc/habits/habits.dart';
import '../../navigation/navigation.dart';

class Mementohr extends StatefulWidget {
  const Mementohr({
    Key? key,
    required this.onStart,
    required this.nowData,
  }) : super(key: key);
  final Function onStart;
  final NowData nowData;

  @override
  State<Mementohr> createState() => _MementohState();
}

class _MementohState extends State<Mementohr> {
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
        child: orbitalIndicator(percentageToNextLevel, size, level),
      );
  Widget orbitalIndicatorPage(double percentageToNextLevel, int level) => OrbitalPage(
        tag: experienceTag,
        progress: percentageToNextLevel,
        hero: hero(percentageToNextLevel, Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width), level),
      );
  Widget orbitalIndicator(double percentageToNextLevel, Size size, int level) => BlocBuilder<HabitsBloc, HabitsState>(
        builder: (context, state) {
          return OrbitalIndicator(
            progress: percentageToNextLevel,
            key: const ValueKey("weekday-hero"),
            size: size,
            centerText: level.toString(),
            incrementCount: state.todaysHabitEntries.length,
          );
        },
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
              // mainAxisSize: MainAxisSize.min, // To center the column content vertically
              // crossAxisAlignment: CrossAxisAlignment.center, // To center the column content horizontally
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Center(
                  child: Text(
                    'Mementohr',
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
                const SizedBox(height: 16), // Space between subtitle and button
                // CustomCircularIndicator(
                //   expanded: true,
                //   score: (percentageToNextLevel * 100).toInt(),
                //   key: const ValueKey("weekday-hero"),
                //   textColor: Colors.white,
                //   centerValue: level.toString(),
                //   title: "Level",
                // ),
                GestureDetector(
                    onTap: () {
                      Navigation.createRoute(orbitalIndicatorPage(percentageToNextLevel, level), context, AnimationEnum.fadeIn);
                    },
                    child: hero(percentageToNextLevel, Size(300,300), level)),
                // CustomProgressIndicator(progress: percentageToNextLevel * 100, ),
                const SizedBox(height: 18), // Space between subtitle and button
                // const SizedBox(height: 18), // Space between subtitle and button
                // const Center(
                //   child: Text(
                //     "Welcome to Mementohr",
                //     style: TextStyle(color: Colors.white, fontSize: 20),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // const SizedBox(height: 12), // Space between subtitle and button
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Features:",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: 12), // Space between subtitle and button
                    Text("- Add Habits To Track Consistency", style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(height: 12), // Space between subtitle and button
                    Text("- Upload Videos To Leave Mementos", style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(height: 12), // Space between subtitle and button
                    Text("- Gain Experience To Level Up", style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(height: 12), // Space between subtitle and button
                    Text("- Access Weekly Reports", style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
                // GestureDetector(
                //   onHorizontalDragUpdate: _updateDuration,
                //   child: TextButton(
                //     onPressed: () => widget.onStart(),
                //     child: Text(
                //       widget.nowData.formatDuration(remainingTime),
                //       style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
