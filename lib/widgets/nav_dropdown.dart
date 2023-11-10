// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class NavDropdownItem {
//   final String value;
//   final IconData iconData;
//   final Function callback;

//   const NavDropdownItem(
//       {required this.iconData, required this.value, required this.callback});
// }

// // Define the NavDropdown as a generic StatefulWidget
// class NavDropdown extends StatefulWidget {
//   const NavDropdown({
//     required this.items,
//     required this.selectedItem,
//     super.key,
//     this.borderColor,
//     this.backgroundColor,
//     this.textColor,
//     this.color,
//   });
//   final Color? color;
//   final Color? textColor;
//   final Color? borderColor;
//   final Color? backgroundColor;
//   final Function onSelected;
//   final NavDropdownItem selectedItem; // The currently selected item of type T
//   final List<NavDropdownItem> items; // The list of items of type T

//   @override
//   _NavDropdownState createState() => _NavDropdownState();
// }

// // The corresponding State class is also generic
// class _NavDropdownState extends State<NavDropdown> {
//   NavDropdownItem? selectedValue;

//   Color get _color => widget.color ?? Theme.of(context).colorScheme.primary;
//   Color get _textColor =>
//       widget.textColor ?? Theme.of(context).colorScheme.onPrimary;
//   Color get _borderColor =>
//       widget.borderColor ?? Theme.of(context).colorScheme.outline;
//   Color get _backgroundColor =>
//       widget.backgroundColor ?? Theme.of(context).colorScheme.outline;
//   @override
//   void initState() {
//     super.initState();
//     selectedValue = widget.selectedItem;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           decoration: BoxDecoration(
//             color: _backgroundColor,
//             border: Border.all(color: _borderColor),
//             borderRadius: BorderRadius.circular(50),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<NavDropdownItem>(
//               value: selectedValue,
//               icon: Icon(
//                 CupertinoIcons.add,
//                 color: _textColor,
//               ),
//               dropdownColor: _borderColor,
//               items: widget.items.map<DropdownMenuItem<NavDropdownItem>>((NavDropdownItem value) {
//                 return DropdownMenuItem<NavDropdownItem>(
//                   value: value,

//                   child: Text(
//                     value.toString(),
//                     style: TextStyle(
//                       color: _textColor,
//                     ),
//                   ), // Assuming toString gives a meaningful representation
//                 );
//               }).toList(),
//               onChanged: (NavDropdownItem? newValue) {
//                 setState(() {
//                   selectedValue = newValue;
//                 });
//                 widget.onSelected(newValue);
//               },
//             ),
//           ),
//         ),
//         Expanded(
//           child: Container(),
//         ),
//       ],
//     );
//   }
// }
