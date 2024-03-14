import 'package:flutter/material.dart';

import '../../common/app_colors.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final bool isLoading;
  final bool? isDisabled;
  final Color? color;
  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.isLoading,
    this.isDisabled,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : TextButton(
              onPressed: isDisabled != null && isDisabled! ? null : onTap,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 120),
                child: Container(
                    decoration: BoxDecoration(
                        color: color ?? kcPrimaryColor,
                        // border: Border.all(
                        //   color: kcPrimaryColor,
                        // ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
            ),
    );
  }
}
