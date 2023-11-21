import 'package:mementoh/theme/theme.dart';
import 'package:flutter/material.dart';

class StylizedCheckbox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onTap;
  final Color color;
  final Size size;

  const StylizedCheckbox({super.key, required this.isChecked, required this.onTap, this.color = emeraldLight, this.size = const Size(80, 80)});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isChecked) {
          // AudioPlayer().play(AssetSource("audio/unpop.m4a"));
        } else {}
        onTap();
      },
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isChecked ? Theme.of(context).colorScheme.outline : color.withOpacity(isChecked ? 1 : 0.3),
            width: 12.0,
          ),
          color: isChecked ? Theme.of(context).colorScheme.outline : Colors.transparent,
        ),
        child: isChecked
            ? Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: size.height / 2,
                ),
              )
            : null,
      ),
    );
  }
}
