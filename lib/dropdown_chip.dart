import 'package:flutter/material.dart';

// Define the DropdownChip as a generic StatefulWidget
class DropdownChip<T> extends StatefulWidget {
  const DropdownChip({
    required this.items,
    required this.onSelected,
    this.selectedItem,
    super.key,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.color,
  });
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final List<T> items; // The list of items of type T
  final T? selectedItem; // The currently selected item of type T
  final ValueChanged<T?> onSelected; // Callback when an item is selected

  @override
  _DropdownChipState<T> createState() => _DropdownChipState<T>();
}

// The corresponding State class is also generic
class _DropdownChipState<T> extends State<DropdownChip<T>> {
  T? selectedValue;

  Color get _color => widget.color ?? Theme.of(context).colorScheme.primary;
  Color get _textColor =>
      widget.textColor ?? Theme.of(context).colorScheme.onPrimary;
  Color get _borderColor =>
      widget.borderColor ?? Theme.of(context).colorScheme.outline;
  Color get _backgroundColor =>
      widget.backgroundColor ?? Theme.of(context).colorScheme.outline;
  @override
  void initState() {
    super.initState();
    // Initialize the selectedValue with the widget's selectedItem
    selectedValue = widget.selectedItem ?? widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: _backgroundColor,
            border: Border.all(color: _borderColor),
            borderRadius: BorderRadius.circular(50),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: selectedValue,
              icon: Icon(
                Icons.arrow_drop_down,
                color: _textColor,
              ),
              dropdownColor: _borderColor,
              items: widget.items.map<DropdownMenuItem<T>>((T value) {
                return DropdownMenuItem<T>(
                  value: value,

                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: _textColor,
                    ),
                  ), // Assuming toString gives a meaningful representation
                );
              }).toList(),
              onChanged: (T? newValue) {
                setState(() {
                  selectedValue = newValue;
                });
                widget.onSelected(newValue);
              },
            ),
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}
