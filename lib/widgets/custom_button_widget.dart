
import 'package:cbt_software_win/core/helper/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final dynamic onPress;
  final double width;
  final double height;
  final String label;
  final Color? backgroundColor;
  final bool hasCustomBackgroundColor;
  const CustomButton({super.key, this.backgroundColor, required this.hasCustomBackgroundColor, required this.height, required this.label, required this.onPress, required this.width});
  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      
      child: ElevatedButton(
        onPressed: onPress, 
      
      style: ElevatedButton.styleFrom(
        backgroundColor: hasCustomBackgroundColor ? backgroundColor : appBackgroundColorVeryOpaque,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
        )
      ),
      
      child: Text(label, style: const TextStyle(color: Colors.white),)),
    );
  }
}
