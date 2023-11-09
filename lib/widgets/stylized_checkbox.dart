import 'package:daily_video_reminders/theme/theme.dart';
import 'package:flutter/material.dart';

class StylizedCheckbox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onTap;
  final Color color;

  StylizedCheckbox({required this.isChecked, required this.onTap, this.color = emeraldLight});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isChecked ? Theme.of(context).colorScheme.outline : color
                .withOpacity(isChecked ? 1 : 0.3),
            width: 12.0,
          ),
          color: isChecked
              ? Theme.of(context).colorScheme.outline
              : Colors.transparent,
        ),
        child: isChecked
            ? Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              )
            : null,
      ),
    );
  }
}
