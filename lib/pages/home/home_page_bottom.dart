import 'package:daily_video_reminders/data/bottom_sheet_state.dart';
import 'package:daily_video_reminders/data/db.dart';
import 'package:daily_video_reminders/habit_grid.dart';
import 'package:daily_video_reminders/pages/video/_video_preview_deprecated.dart';
import 'package:daily_video_reminders/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../data/habit_entry.dart';
import '../video/video_preview_page.dart';

class HomePageBottom extends StatelessWidget {
  final double value1;
  final double value2;
  final double value3;
  final double value4;
  final double value5;
  final double value6;
  final BottomSheetState bottomSheetState;

  HomePageBottom({
    required this.value1,
    required this.value2,
    required this.value3,
    required this.value4,
    required this.value5,
    required this.value6,
    required this.bottomSheetState,
  });
  Widget customSlider(double value, Color color) {
    return LinearProgressIndicator(
      value: value,
      color: color,
      minHeight: 8,
      backgroundColor: color.withOpacity(.3),
    );
  }

  TextStyle get midTextStyle {
    return TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold);
  }

  bool get small => bottomSheetState == BottomSheetState.hidden;
  bool get mid => bottomSheetState == BottomSheetState.collapsed;
  bool get large => bottomSheetState == BottomSheetState.expanded;

  Widget _horizontalLabelText(String text) {
    return Visibility(
      visible: mid,
      child: Row(
        children: [
          Text(text, style: midTextStyle),
        ],
      ),
    );
  }

  double sheetHeight(BuildContext context) {
    if (small) {
      return kToolbarHeight;
    } else if (mid) {
      return MediaQuery.of(context).size.height * .8;
    } else {
      return MediaQuery.of(context).size.height - kToolbarHeight;
    }
  }



  Widget _list(BuildContext context) {
    if (!large) return Container();
    return VideoPreviewPage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      height: sheetHeight(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: _list(context),
                ),
                _buildHorizontalProgressBars(),
              ],
            ),
            flex: 4,
          ),
          Expanded(
            child: _buildVerticalProgressBars(),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalProgressBars() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // daily
        SizedBox(
          height: 8,
        ),
        _horizontalLabelText("Daily"),

        customSlider(value1, emerald),
        SizedBox(
          height: 8,
        ),
        // monthly
        _horizontalLabelText("Monthly"),
        customSlider(value2, emerald),
        SizedBox(
          height: 8,
        ),
        // annual
        _horizontalLabelText("Annual"),
        customSlider(value3, emerald),
      ],
    );
  }

  Widget _buildVerticalProgressBars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildVerticalProgressBar(value4, rubyDark),
        _buildVerticalProgressBar(value5, goldDark),
        _buildVerticalProgressBar(value6, emeraldDark),
      ],
    );
  }

  Widget _buildVerticalProgressBar(double value, Color color) {
    return RotatedBox(
      quarterTurns: 3,
      child: customSlider(value, color),
    );
  }
}
