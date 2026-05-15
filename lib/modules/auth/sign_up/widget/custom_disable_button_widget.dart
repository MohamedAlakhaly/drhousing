import 'package:flutter/material.dart';

class CustomDisableButtonWidget extends StatelessWidget {
  final Color? buttonColor;
  final void Function()? onTapButton;
  final Widget buttonChild;
  const CustomDisableButtonWidget(
      {super.key,
      this.onTapButton,
      this.buttonColor,
      required this.buttonChild});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapButton,
      child: Container(
        height: 60,
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: buttonColor,
        ),
        child: buttonChild,
      ),
    );
  }
}
