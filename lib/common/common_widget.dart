import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_video/util/navigator_utils.dart';

import '../util/screen_size_utils.dart';

Color? get black45 {
  return Colors.black45;
}

Color? get black12 {
  return Colors.black12;
}

SizedBox get sizeBoxBetweenColumnCells {
  return const SizedBox(height: 10);
}

getLoginHeaderUI(BuildContext context, List<Widget> children) {
  double height = ScreenSizeUtil.screenHeight(context);
  return Padding(
    padding: const EdgeInsets.all(17.0),
    child: SizedBox(
      width: double.infinity,
      height: height * 0.25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: children,
      ),
    ),
  );
}

TextStyle loginTitleStyle() {
  return getTitleStyle(Colors.black);
}

getTitleStyle(Color color) {
  return GoogleFonts.dmSerifDisplay(
    fontWeight: FontWeight.w700,
    color: color,
    fontSize: 30,
  );
}

loginParentBody(
  GlobalKey<FormState> formKey,
  String? errorString,
  List<Widget> children,
) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            children: children,
          ),
        )
      ],
    ),
  );
}

commonLoginTextFeild(
  TextEditingController textController,
  InputDecoration decoration,
  String? Function(String?) validator,
) {
  return commonLoginTextFeildWithPsw(
    textController,
    false,
    false,
    decoration,
    validator,
  );
}

commonLoginTextFeildWithPsw(
  TextEditingController textController,
  bool isShowIcon,
  bool isShowPassword,
  InputDecoration decoration,
  String? Function(String?) validator,
) {
  return Container(
    height: 55,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: black12!,
          offset: const Offset(
            3.0,
            3.0,
          ),
          blurRadius: 5.0,
          spreadRadius: 1.0,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ],
    ),
    child: Center(
      child: TextFormField(
        cursorColor: black45,
        controller: textController,
        decoration: decoration,
        validator: validator,
        obscureText: isShowIcon ? !isShowPassword : false,
      ),
    ),
  );
}

InputDecoration loginTextFeildDecoration() {
  return loginTextFeildDecorationIncludePsw(false, false, () {});
}

InputDecoration loginTextFeildDecorationIncludePsw(
    showIcon, showPassword, VoidCallback voidCallback) {
  return InputDecoration(
    hintText: 'Email Address',
    hintStyle: TextStyle(
      color: Colors.black.withOpacity(0.3),
      fontWeight: FontWeight.bold,
    ),
    fillColor: Colors.white,
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding:
        const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
    suffixIcon: (showIcon
        ? GestureDetector(
            onTap: voidCallback,
            child: Icon(
              showPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.black54,
            ),
          )
        : null),
  );
}

void showErrorDialog(BuildContext context, String title, Exception e) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontSize: 24),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                '${(e as dynamic).message}',
                style: const TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        actions: [
          StyledButton(
              child: const Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                NavigatorUtils.pop(context);
              })
        ],
      );
    },
  );
}

class StyledButton extends StatelessWidget {
  const StyledButton({super.key, required this.child, required this.onPressed});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black.withOpacity(0.85),
            textStyle: const TextStyle(
              fontSize: 16.5,
            ),
          ),
          child: child,
        ),
      );
}
