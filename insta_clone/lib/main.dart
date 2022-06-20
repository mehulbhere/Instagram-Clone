import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/providers/theme_model.dart';
import 'package:insta_clone/responsive/mobile_screen_layout.dart';
import 'package:insta_clone/responsive/responsive_layout_screen.dart';
import 'package:insta_clone/responsive/web_screen_layout.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/screens/signup_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/customProgess.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ThemeModel())
        ],
        child: Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Insta Clone',
            theme: themeNotifier.isDark
                ?
                // ThemeData.dark().copyWith(
                //     scaffoldBackgroundColor: mobileBgColor,
                //     primaryColor: mobilePColor,
                //     textTheme:
                //         ThemeData.dark().textTheme.apply(fontFamily: "Roboto"))
                ThemeData.dark().copyWith(
                    scaffoldBackgroundColor: mobileBgColor,
                    primaryColorLight: mobileAColor,
                    primaryColor: mobilePColor,
                    backgroundColor: mobileBgColor,
                    cardColor: mobileCardColorLight,
                    dividerColor: mobileBgColor,
                    bottomAppBarColor: mobileBgColor,
                    primaryColorDark: mobileSecondaryColor,
                    textTheme:
                        ThemeData.dark().textTheme.apply(fontFamily: "Roboto"))
                : ThemeData.light().copyWith(
                    scaffoldBackgroundColor: mobilePColor,
                    primaryColorLight: mobileAColor,
                    primaryColor: mobileBgColor,
                    backgroundColor: mobilePColor,
                    cardColor: mobileCardColorLight,
                    dividerColor: mobileBgColor,
                    bottomAppBarColor: mobilePColor,
                    primaryColorDark: mobileCardColorLight,
                    textTheme: ThemeData.light()
                        .textTheme
                        .apply(fontFamily: "Roboto")),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                //connection done
                if (snapshot.connectionState == ConnectionState.active) {
                  //user is authenticated
                  if (snapshot.hasData) {
                    return const ResponsiveLayout(
                        mobileScreenLayout: MobileScreenLayout(),
                        webScreenLayout: WebScreenLayout());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error"));
                  }
                }
                // connection still processing
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CustomProgess(),
                  );
                }
                return const LoginScreen();
              },
            ),
          );
        }));
  }
}
