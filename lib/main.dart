import 'package:bindr_app/login_signup/signup.dart';
import 'package:bindr_app/my_posts/my_posts.dart';
import 'package:bindr_app/search_screen/search_screen.dart';
import 'package:bindr_app/sell_screen/sell.dart';
import 'package:bindr_app/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bindr_app/welcome_screen/welcome.dart';
import 'package:bindr_app/items/constants.dart';
import 'package:firebase_core/firebase_core.dart';

import 'login_signup/login.dart';
import 'my_bookmarks/my_bookmarks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// Lock user in portrait orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          //Check for errors
          if (snapshot.hasError) {
            // ignore: avoid_print
            print(snapshot.error);
            return const Center(
                child: Text('error', textDirection: TextDirection.ltr));
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              routes: <String, WidgetBuilder>{
                '/welcome': (BuildContext context) => Welcome(),
                '/welcome/login': (BuildContext context) => Login(),
                '/welcome/signup': (BuildContext context) => SignUp(),
                '/my_posts': (context) =>
                    const MyPosts(searchString: '', hasPosts: null),
                '/search': (BuildContext context) => SearchScreen(),
                '/sell': (BuildContext context) => SellScreen(),
                '/bookmarks': (BuildContext context) =>
                    const MyBookmarks(searchString: '', hasBookmarks: null),
                '/settings': (BuildContext context) => SettingsScreen(),
              },
              debugShowCheckedModeBanner: false,
              title: 'Bindr',
              theme: ThemeData(
                canvasColor:
                    logobackground, // use logo background so that the logo blends in
                splashColor: pink,
                primaryColor: logobackground,
              ),
              home: Welcome(),
            );
          }

          //Otherwise, show something whilst waiting for initialization to complete
          else {
            return const Center(
              child: Text(
                "Loading Resources",
                textDirection: TextDirection.ltr,
              ),
            );
          }
        });
  }
}
