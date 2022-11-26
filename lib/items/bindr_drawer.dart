import 'package:flutter/material.dart';
import 'package:bindr_app/items/constants.dart';
import '../welcome_screen/welcome.dart';
import '../services/auth.dart';

const pages = ["MY POSTS", "BOOKMARKS", "SEARCH", "SELL BOOK", "SETTINGS"];
const icons = [
  Icons.co_present_rounded,
  Icons.bookmark_border_rounded,
  Icons.search_rounded,
  Icons.book_outlined,
  Icons.settings_rounded,
];
const routes = ['/my_posts', '/bookmarks', '/search', '/sell', '/settings'];

class BindrDrawer extends StatelessWidget {
  final String currentPage;
  BindrDrawer({required this.currentPage, super.key});
  final auth = AuthService();

  bool condition = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: logobackground,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            alignment: Alignment.center,
          ),
          const SizedBox(
            height: 35,
          ),
          SizedBox(
            child: Image(
                image:
                    Image.asset("assets/bindr_images/Bindr_logo_.png").image),
          ),
          ListView.builder(
            itemCount: pages.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              condition = currentPage == pages[index];
              return ListTile(
                leading: Icon(
                  icons[index],
                  color: condition ? Colors.black : pink,
                ),
                tileColor: condition ? pink : null,
                title: Text(pages[index],
                    style: TextStyle(
                        color: condition ? Colors.black : pink, fontSize: 20)),
                onTap: condition
                    ? () {}
                    : () {
                        Navigator.of(context)
                          ..pop()
                          ..pop()
                          ..pushNamed(routes[index]);
                      },
              );
            },
          )
        ],
      ),
    );
  }
}
