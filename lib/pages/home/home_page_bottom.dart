import 'package:daily_video_reminders/data/bottom_sheet_state.dart';
import 'package:daily_video_reminders/data/db.dart';
import 'package:daily_video_reminders/habit_grid.dart';
import 'package:daily_video_reminders/pages/home/mementoh.dart';
import 'package:daily_video_reminders/pages/home/now_data.dart';
import 'package:daily_video_reminders/pages/video/_video_preview_deprecated.dart';
import 'package:daily_video_reminders/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../bloc/experience/experience.dart';
import '../../data/habit_entry.dart';
import '../video/video_preview_page.dart';

class HomePageBottom extends StatelessWidget {
  final double value1;
  final double value2;
  final double value3;
  final double value4;
  final double value5;
  final double value6;
  final NowData nowData;
  final BottomSheetState bottomSheetState;
  final Function onStartTimer;

  HomePageBottom(
      {required this.value1,
      required this.value2,
      required this.value3,
      required this.value4,
      required this.value5,
      required this.value6,
      required this.nowData,
      required this.bottomSheetState,
      required this.onStartTimer});
  Widget customSlider(double value, Color color, [double minHeight = 10]) {
    return LinearProgressIndicator(
      value: value,
      color: color,
      minHeight: minHeight,
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
      visible: mid || large,
      child: Row(
        children: [
          Text(text, style: midTextStyle),
        ],
      ),
    );
  }

  double sheetHeight(BuildContext context) {
    var height = kToolbarHeight;
    if (mid) {
      height = MediaQuery.of(context).size.height * .8;
    } else if (large) {
      height = MediaQuery.of(context).size.height - kToolbarHeight;
    }
    if (MediaQuery.of(context).padding.bottom >= 0) {
      height = height + 24;
    }

    return height;
  }

  Widget _list(BuildContext context) {
    if (large) return VideoPreviewPage();
    return Container();
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
                if (mid)
                  Mementoh(
                    nowData: nowData,
                    onStart: () {
                      onStartTimer();
                    },
                  ),
                Expanded(
                  child: _list(context),
                ),
                Row(
                  children: [
                    BlocBuilder<ExperienceBloc, ExperienceState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            state.currentLevel().toString(),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                    Expanded(child: _buildHorizontalProgressBars()),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom > 0 ? 0 : 24,
                )
              ],
            ),
            flex: mid || large ? 7 : 4,
          ),
          Expanded(
            flex: mid || large ? 3 : 2,
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
        SizedBox(height: mid || large ? 5 : 8),
        _horizontalLabelText("Daily"),

        customSlider(value1, emerald),
        SizedBox(height: mid || large ? 4 : 8),
        // monthly
        _horizontalLabelText("Weekly"),
        customSlider(value2, emerald),
        SizedBox(height: mid || large ? 4 : 8),
        // annual
        _horizontalLabelText("Experience"),
        customSlider(value3, emerald),
      ],
    );
  }

  Widget _buildVerticalProgressBars() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildVerticalProgressBar(value4, rubyDark, (nowData.currentTime.second).toString()),
          _buildVerticalProgressBar(
              value5,
              goldDark,
              nowData.formattedMonth(DateTime.now()) +
                  " - " +
                  nowData.formattedMonth(DateTime(DateTime.now().year, DateTime.now().month + 1, 1).subtract(Duration(days: 1)))),
          _buildVerticalProgressBar(value6, emeraldDark, nowData.formattedDate + " / 365 Days"),
        ],
      ),
    );
  }

  Widget _buildVerticalProgressBar(double value, Color color, String label) {
    return RotatedBox(
      quarterTurns: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          mid || large
              ? Row(
                  children: [
                    SizedBox(
                      width: kToolbarHeight / 3,
                    ),
                    Text(
                      label,
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(left: kToolbarHeight / 3),
            child: customSlider(value, color, 15),
          ),
        ],
      ),
    );
  }
}
