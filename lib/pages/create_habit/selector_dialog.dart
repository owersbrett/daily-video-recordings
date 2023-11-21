import 'package:flutter/material.dart';

class SelectorDialog extends StatelessWidget {
  const SelectorDialog(
      {super.key, required this.values, required this.onSelect});
  final List<String> values;
  final Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(

                child: ListView.builder(
                    itemCount: values.length,
                    itemBuilder: (ctx, i) {
                      return ListTile(
                          onTap: () {
                            onSelect(values[i]);
                          },
                          title: Material(
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  values[i],
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ));
                    })),
          ],
        ),
      ),
    );
  }
}
