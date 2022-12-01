import 'package:bindr_app/search_screen/search_screen.dart';
import 'package:bindr_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:bindr_app/welcome_screen/welcome_body.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Text('LOADING', textDirection: TextDirection.ltr));
        } else if (snapshot.hasError) {
          // ignore: avoid_print
          print(snapshot.error);
          return const Center(
              child: Text('Error:', textDirection: TextDirection.ltr));
        } else if (!snapshot.hasData) {
          //if not logged in
          return Scaffold(
            body: WelcomeBody(),
            backgroundColor: Theme.of(context).canvasColor,
          );
        } else {
          //if logged in

          return FutureBuilder(
              future: AuthService().isVerified(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const Text("LOADING"));
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Text("Error"); //Shouldn't reach here
                } else if (snapshot.data!) {
                  return SearchScreen();
                } else {
                  return Scaffold(
                    body: WelcomeBody(),
                    backgroundColor: Theme.of(context).canvasColor,
                  );
                }
              }));

          // var result = AuthService().isVerified().then((value) {
          //   if (value) {
          //     return SearchScreen();
          //   } else {
          //     return Scaffold(
          //       body: WelcomeBody(),
          //       backgroundColor: Theme.of(context).canvasColor,
          //     );
          //   }
          // });
          // return result;
        }
      },
    );
  }
}
