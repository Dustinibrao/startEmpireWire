import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testing/new_home_page.dart';
import 'package:testing/listen_page.dart';
import 'package:testing/coupon_page.dart';
import 'package:testing/read_page.dart';
import 'package:testing/watch_page.dart';
import 'package:testing/discuss_page.dart';
import 'package:testing/search_page.dart';
// import 'package:testing/menu_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: MaterialColor(Colors.black.value, const {
        50: Colors.black,
        100: Colors.black,
        200: Colors.black,
        300: Colors.black,
        400: Colors.black,
        500: Colors.black,
        600: Colors.black,
        700: Colors.black,
        800: Colors.black,
        900: Colors.black,
      })),
      home: RootPage(),
      routes: {
        '/home': (context) => RootPage(),
      },
    );
  }
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = [
    const HomePage(),
    const ReadPage(),
    const ListenPage(),
    const WatchPage(),
    const DiscussPage(),
    CouponTemplate(),
    // MenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: currentPage == 0
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // Open the hamburger menu
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              title: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/start.png',
                  height: 80.0,
                  fit: BoxFit.contain,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(context: context, delegate: SearchPage());
                  },
                ),
              ],
            )
          : null,
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 88,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Stack(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.rocket_launch_sharp,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              color: Colors.white,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Login'),
                    onTap: () {
                      // Update the UI based on the item selected
                      // then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('News'),
                    onTap: () {
                      // Update the UI based on the item selected
                      // then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Shows'),
                    onTap: () {
                      // Update the UI based on the item selected
                      // then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.black,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.facebookF,
                        ),
                        color: Colors.white,
                        onPressed: () => {},
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.twitter,
                        ),
                        color: Colors.white,
                        onPressed: () => {},
                      ),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.instagram,
                        ),
                        color: Colors.white,
                        onPressed: () => {},
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '© 2023 Startempire Wire',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: pages[currentPage],
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     debugPrint("floating action button");
      //   },
      //   child: const Icon(Icons.add),
      // ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.black,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: "", // Home
            selectedIcon: Icon(
              Icons.home,
              color: Color(0xffff6a6f),
            ),
          ),
          NavigationDestination(
            icon: Icon(
              Icons.speaker_notes,
              color: Colors.white,
            ),
            label: "", // Read
            selectedIcon: Icon(
              Icons.speaker_notes,
              color: Color(0xffff6a6f),
            ),
          ),
          NavigationDestination(
            icon: Icon(
              Icons.headphones,
              color: Colors.white,
            ),
            label: "", // Listen
            selectedIcon: Icon(
              Icons.headphones,
              color: Color(0xffff6a6f),
            ),
          ),
          NavigationDestination(
            icon: Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
            label: "", // Watch
            selectedIcon: Icon(
              Icons.play_arrow,
              color: Color(0xffff6a6f),
            ),
          ),
          NavigationDestination(
            icon: Icon(
              Icons.question_answer,
              color: Colors.white,
            ),
            label: "", // Discuss
            selectedIcon: Icon(
              Icons.question_answer,
              color: Color(0xffff6a6f),
            ),
          ),
          NavigationDestination(
            icon: Icon(
              Icons.credit_card,
              color: Colors.white,
            ),
            label: "", // Merch
            selectedIcon: Icon(
              Icons.credit_card,
              color: Color(0xffff6a6f),
            ),
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
