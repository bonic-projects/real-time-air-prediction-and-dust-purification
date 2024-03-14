import 'package:flutter/material.dart';

class AutoSwitch extends StatelessWidget {
  final bool isAuto;
  final Function(bool) onClick;
  const AutoSwitch({super.key, required this.isAuto, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isAuto,
      activeColor: const Color.fromARGB(255, 47, 85, 108),
      onChanged: onClick,
    );
  }
}
