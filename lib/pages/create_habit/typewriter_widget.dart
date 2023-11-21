import 'dart:async';

import 'package:flutter/material.dart';

class TypewriterWidget extends StatefulWidget {
  final List<String> textList;
  final Duration typingSpeed;

  const TypewriterWidget({
    Key? key,
    required this.textList,
    this.typingSpeed = const Duration(milliseconds: 50),
  }) : super(key: key);

  @override
  _TypewriterWidgetState createState() => _TypewriterWidgetState();
}

class _TypewriterWidgetState extends State<TypewriterWidget> {
  late List<String> _texts;
  String _currentText = '';
  int _textIndex = 0;
  int _charIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _texts = widget.textList;
    _startTyping();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.typingSpeed, (timer) {
      setState(() {
        _currentText = _texts[_textIndex].substring(0, _charIndex);
        _charIndex++;
        if (_charIndex > _texts[_textIndex].length) {
          _charIndex = 0;
          _textIndex = (_textIndex + 1) % _texts.length;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(_currentText, style:  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),);
  }
}
