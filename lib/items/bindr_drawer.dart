import 'package:flutter/material.dart';
import 'package:bindr_app/items/constants.dart';
import '../sell_screen/sell.dart';
import '../welcome_screen/welcome.dart';
import '../services/auth.dart';

class BindrDrawer extends StatelessWidget {
  BindrDrawer({super.key});
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: logobackground,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: const Text(
              "Hi <USERNAME FROM DATABASE HERE>!",
              style: TextStyle(
                  color: pink, fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          SizedBox(
            child: Image(
                image:
                    Image.asset("assets/bindr_images/Bindr_logo_.png").image),
          ),
          ListTile(
            leading: const Icon(
              Icons.co_present_rounded,
              color: pink,
            ),
            title: const Text("PROFILE",
                style: TextStyle(color: pink, fontSize: 20)),
            onTap: () {
              //Navigator.of(context).popAndPushNamed('/profile');
            }, // waiting for profile page
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border_rounded, color: pink),
            title: const Text("BOOKMARKS",
                style: TextStyle(color: pink, fontSize: 20)),
            onTap: () {
              //Navigator.of(context).popAndPushNamed('/bookmarks');
            }, // waiting for bookmarks page
          ),
          ListTile(
            leading: const Icon(Icons.search_rounded, color: pink),
            title: const Text("SEARCH",
                style: TextStyle(color: pink, fontSize: 20)),
            onTap: () {
              Navigator.of(context).popAndPushNamed('/search');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_outlined, color: pink),
            title: const Text("SELL BOOK",
                style: TextStyle(color: pink, fontSize: 20)),
            onTap: () {
              Navigator.of(context).popAndPushNamed('/sell');
            },
          ),
          ListTile(
            leading: const Icon(Icons.article_outlined, color: pink),
            title: const Text("SETTINGS",
                style: TextStyle(color: pink, fontSize: 20)),
            onTap: () {
              //Navigator.of(context).popAndPushNamed('/settings');
            }, // waiting for settings page
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded, color: pink),
            title: const Text("SIGN OUT",
                style: TextStyle(color: pink, fontSize: 20)),
            onTap: () async {
              await auth.signOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Welcome()),
                  (route) => false);
            },
          )
        ],
      ),
    );
  }
}
