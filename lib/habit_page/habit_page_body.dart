import 'package:flutter/cupertino.dart';

class HabitPageBody extends StatelessWidget {
  const HabitPageBody({super.key, required this.days, required this.habits});
  final List<Widget> days;
  final List<Widget> habits;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: days,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Expanded(
              child: ListView(children: habits),
            ),
          ],
        ));
  }
}