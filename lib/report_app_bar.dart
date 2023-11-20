import 'package:mementoh/dropdown_chip.dart';
import 'package:mementoh/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportAppBar extends StatelessWidget {
  const ReportAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    String day = DateFormat('EEEE').format(DateTime.now());

    return Stack(
      children: [
        Row(
          children: [
            Text(
              "Weekly",
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Monthly",
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "Yearly",
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: DropdownChip<String>(
                items: ["Filters", "Sort"],
                onSelected: (String? value) {},
                selectedItem: "Filters",
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
