import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DVRCloseButton extends StatelessWidget {
  const DVRCloseButton({super.key, required this.onPressed});
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8,
      top: kToolbarHeight,
      child: Container(
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: () async {
            onPressed();
          },
          icon: Icon(Icons.close),
          color: Colors.white,
          iconSize: 35,
        ),
      ),
    );
  }
}
