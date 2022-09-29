import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_video/ui/pages/main_page.dart';
import 'package:social_video/ui/pages/sign_up_page.dart';

import '../../common/common_widget.dart';
import '../../controller/password_visibility_controller.dart';
import '../../controller/user_auth_controller.dart';
import '../../util/common_utils.dart';
import '../../util/navigator_utils.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_SignInPageState');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                    'Hello Again!',
                    style: loginTitleStyle(),
                  ),
                  Text(
                    'Welcome',
                    style: loginTitleStyle(),
                  ),
                  Text(
                    'back',
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
          child: const Text('Sign In'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await stateController.signInWithEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                  (e) => showErrorDialog(context, 'Failed to sign in', e));
              if (stateController.loginState ==
                  ApplicationLoginState.loggedIn) {
                if (!mounted) return;
                NavigatorUtils.pushAndRemoveUntil(context, const MainPage());
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
            stateController.loginState = ApplicationLoginState.register;
            NavigatorUtils.pushAndRemoveUntil(context, (const SignUpPage()));
          },
          child: const Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Don\'t have an account?',
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
