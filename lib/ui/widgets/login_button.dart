import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginButton extends StatelessWidget {
  LoginButton({
    Key? key,
    required this.buttonType,
    required this.title,
    required this.backgroundColor,
    required this.onPressed,
  });

  final List<String> supportedServices = ["google", "kakao"];
  final String buttonType;
  final String title;
  final Color backgroundColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      width: 60.w,
      height: 5.h,
      child: supportedServices.contains(buttonType)
          ? IconButton(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Brand(
                    buttonType == "google" ? Brands.google : Brands.kakaotalk,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                await onPressed();
              },
            )
          : Text("Not Supported Service With $buttonType"),
    );
  }
}
