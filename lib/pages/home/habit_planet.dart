import 'package:flutter/material.dart';
import 'package:habit_planet/pages/home/now_data.dart';
import 'package:habit_planet/pages/home/orbital_indicator.dart';
import 'package:habit_planet/pages/home/orbital_page.dart';
import '../../bloc/experience/experience.dart';
import '../../data/repositories/habit_entry_repository.dart';
import '../../navigation/navigation.dart';

class HabitPlanet extends StatefulWidget {
  const HabitPlanet({
    Key? key,
    required this.onStart,
    required this.nowData,
  }) : super(key: key);
  final Function onStart;
  final NowData nowData;

  @override
  State<HabitPlanet> createState() => _HabitPlanetState();
}

class _HabitPlanetState extends State<HabitPlanet> {
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

  Hero hero(double percentageToNextLevel, [Size size = const Size(300, 300), int level = 1]) {
    return Hero(
        tag: experienceTag,
        child: FutureBuilder(
          future: RepositoryProvider.of<IHabitEntryRepository>(context).getTodaysNumeratorAndDemoninator(DateTime.now()),
          builder: (context, data) {
            int numerator = 0;
            int denominator = 1;
            if (data.hasData) {
              numerator = data.data?[0] ?? 0;
              denominator = data.data?[1] ?? 1;
              if (denominator == 0) {
                denominator = 1;
              }
            }
            return OrbitalIndicator(
              currentTicks: numerator,
              progress: percentageToNextLevel,
              key: const ValueKey("weekday-hero"),
              centerText: level.toString(),
              totalTicks: denominator,
              size: size,
            );
          },
        ));
  }

  Widget orbitalIndicatorPage(double percentageToNextLevel, int level) => OrbitalPage(
        tag: experienceTag,
        progress: percentageToNextLevel,
        hero: hero(percentageToNextLevel, Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height), level),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExperienceBloc, ExperienceState>(
      builder: (context, state) {
        var level = state.getCurrentLevel();
        var percentageToNextLevel = state.percentageToNextLevel();
        return Container(
          padding: const EdgeInsets.all(10), // Add padding if needed
          child: Center(
            child: ListView(
              children: <Widget>[
                const Center(
                  child: Text(
                    'Habit Planet',
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
                  child: hero(percentageToNextLevel, const Size(300, 300), level),
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
