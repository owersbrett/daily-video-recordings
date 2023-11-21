import 'package:flutter/material.dart';

class DVRCloseButton extends StatelessWidget {
  const DVRCloseButton({super.key, required this.onPressed, this.positioned = true, this.color = Colors.white});
  final Color color;
  final bool positioned;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    if (positioned) {
      return Positioned(
        right: 8,
        top: kToolbarHeight / 2,
        child: SizedBox(
          height: 60,
          width: 60,
          child: IconButton(
            onPressed: () async {
              onPressed();
            },
            icon: const Icon(Icons.close),
            color: color,
            iconSize: 35,
          ),
        ),
      );
    }
    return SizedBox(
      height: 60,
      width: 60,
      child: IconButton(
        onPressed: () async {
          onPressed();
        },
        icon: const Icon(Icons.close),
        color: color,
        iconSize: 35,
      ),
    );
  }
}
