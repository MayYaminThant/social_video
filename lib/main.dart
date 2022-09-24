import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_video/controller/bottom_nav_controller.dart';
import 'package:social_video/controller/password_visibility_controller.dart';
import 'package:social_video/ui/pages/sign_in_page.dart';
import 'package:social_video/ui/pages/sign_up_page.dart';

import 'controller/user_auth_controller.dart';
import 'ui/pages/main_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyMultiProvider());
}

class MyMultiProvider extends StatelessWidget {
  const MyMultiProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PasswordVisibilityController()),
        ChangeNotifierProvider(create: (_) => AuthStateController()),
        ChangeNotifierProvider(create: (_) => BottomNavController(0)),
      ],
      child: const MyMain(),
    );
  }
}

class MyMain extends StatefulWidget {
  const MyMain({super.key});

  @override
  State<MyMain> createState() => _MyMainState();
}

class _MyMainState extends State<MyMain> {
  ApplicationLoginState? loginState;
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loginState == null
          ? const Center(child: CircularProgressIndicator())
          : (loginState == ApplicationLoginState.loggedIn)
              ? const MainPage()
              : (loginState == ApplicationLoginState.register
                  ? const SignUpPage()
                  : const SignInPage()),
    );
  }

  Future<void> init() async {
    loginState = await context.read<AuthStateController>().init();

    setState(() {});
  }
}
