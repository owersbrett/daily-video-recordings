import 'package:mementoh/widgets/dropdown_chip.dart';
import 'package:flutter/material.dart';

class ReportAppBar extends StatelessWidget {
  const ReportAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            const Text(
              "Weekly",
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 4,
            ),
            const Text(
              "Monthly",
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(
              width: 4,
            ),
            const Text(
              "Yearly",
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: DropdownChip<String>(
                items: const ["Filters", "Sort"],
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
