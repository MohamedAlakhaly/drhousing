
// import 'package:flutter/material.dart';
// import 'package:chimay_house/core/functions/helper_functions.dart';

// class CustomDateTimePickerWidget extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final void Function()? onTap;
//   const CustomDateTimePickerWidget({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = HelperFunctions.isDarkMode(context);

//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         prefixIcon: Icon(Icons.calendar_today),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide:
//               BorderSide(color: isDarkMode ? Colors.white : Colors.black),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide:
//               BorderSide(color: isDarkMode ? Colors.white : Colors.black),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(20),
//           borderSide:
//               BorderSide(color: isDarkMode ? Colors.white : Colors.black),
//         ),
//       ),
//       readOnly: true,
//       onTap: onTap,
//     );
//   }
// }

