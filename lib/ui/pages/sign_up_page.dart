import 'package:social_video/ui/pages/sign_in_page.dart';
import 'package:social_video/util/navigator_utils.dart';

import '../../common/common_widget.dart';
import '../../controller/user_auth_controller.dart';
import '../../controller/password_visibility_controller.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/common_utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_SignUpPageState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    CommonUtils.doInFuture(() {
      context.read<PasswordVisibilityController>().isShowPassword = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 2, end: 1),
            duration: const Duration(seconds: 1),
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Column(
              children: [
                getLoginHeaderUI(context, [
                  Text(
                    'Hello!',
                    style: loginTitleStyle(),
                  ),
                  Text(
                    'Signup to',
                    style: loginTitleStyle(),
                  ),
                  Text(
                    'get started',
                    style: loginTitleStyle(),
                  ),
                ]),
                Consumer<AuthStateController>(
                  builder: (context, stateController, _) => loginParentBody(
                    _formKey,
                    stateController.errorString != null &&
                            stateController.errorString!.isNotEmpty
                        ? stateController.errorString
                        : null,
                    _children,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get _children {
    return [
      commonLoginTextFeild(
        _displayNameController,
        loginTextFeildDecoration().copyWith(
          hintText: 'User Name',
        ),
        (value) {
          if (value!.isEmpty) {
            return 'Enter your user name';
          }
          return null;
        },
      ),
      sizeBoxBetweenColumnCells,
      commonLoginTextFeild(
        _emailController,
        loginTextFeildDecoration(),
        (value) {
          if (value == null || value.isEmpty) {
            return 'Enter your email address to continue';
          }
          return null;
        },
      ),
      sizeBoxBetweenColumnCells,
      Consumer<PasswordVisibilityController>(
        builder: (context, pswController, _) => commonLoginTextFeildWithPsw(
          _passwordController,
          true,
          pswController.isShowPassword,
          loginTextFeildDecorationIncludePsw(true, pswController.isShowPassword,
              () {
            pswController.isShowPassword = !pswController.isShowPassword;
          }).copyWith(
            hintText: 'Password',
          ),
          (value) {
            if (value!.isEmpty) {
              return 'Enter your password';
            }
            return null;
          },
        ),
      ),
      sizeBoxBetweenColumnCells,
      Consumer<AuthStateController>(
        builder: (bContext, stateController, _) => StyledButton(
          child: const Text('Save'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await stateController.registerAccount(
                  _emailController.text,
                  _displayNameController.text,
                  _passwordController.text,
                  (e) =>
                      showErrorDialog(context, 'Failed to create account', e));
              if (stateController.loginState ==
                  ApplicationLoginState.emailAddress) {
                if (!mounted) return;
                NavigatorUtils.pushAndRemoveUntil(context, const SignInPage());
              }
            }
          },
        ),
      ),
      sizeBoxBetweenColumnCells,
      sizeBoxBetweenColumnCells,
      Consumer<AuthStateController>(
        builder: (context, stateController, _) => InkWell(
          onTap: () {
            stateController.errorString = '';
            stateController.loginState = ApplicationLoginState.emailAddress;
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (bContext) => const SignInPage()),
                (route) => false);
          },
          child: const Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Already have an account?',
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
