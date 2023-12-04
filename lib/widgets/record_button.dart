import 'package:habitbit/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordingButton extends StatelessWidget {
  const RecordingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "record",
      backgroundColor: lightRuby.withOpacity(.5),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Padding(
          padding: EdgeInsets.all(2.0),
          child: Icon(
            CupertinoIcons.circle_fill,
            size: 36,
            color: lightRuby,
          ),
        ),
      ),
      onPressed: () {},
    );
  }
}
