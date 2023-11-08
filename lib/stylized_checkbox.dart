import 'package:flutter/material.dart';

class StylizedCheckbox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onTap;

  StylizedCheckbox({required this.isChecked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .outline
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
                  size: 20,
                ),
              )
            : null,
      ),
    );
  }
}
