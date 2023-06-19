import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:testing/new_home_page.dart';
import 'package:testing/listen_page.dart';
import 'package:testing/coupon_page.dart';
import 'package:testing/read_page.dart';
import 'package:testing/watch_page.dart';
import 'package:testing/discuss_page.dart';
import 'package:testing/search_page.dart';
import 'package:testing/login_page.dart';
import 'package:testing/about_page.dart';
import 'package:testing/terms_page.dart';
import 'package:testing/privacy_policies.dart';
import 'package:testing/standards_and_policies.dart';
import 'package:testing/support_page.dart';

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
      home: const RootPage(),
      routes: {
        '/home': (context) => const RootPage(),
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
    PodcastHomePage(),
    const ReadPage(),
    ListenPage(),
    const WatchPage(),
    const DiscussPage(),
    CouponTemplate(),
    const AboutPage(),
    const TermsPage(),
    const PrivacyPolicyPage(),
    const StandardsAndPoliciesPage(),
    const SupportPage(),
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
          children: [
            Expanded(
              // child: SingleChildScrollView(
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
                    title: const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'News',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      // Update the UI based on the item selected
                      // then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: const [
                        Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text('U.S'),
                      ],
                    ),
                    onTap: () {
                      // Add the desired action or navigation here
                      // For example:
                      // LaunchURL('https://example.com/news/u.s');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: const [
                        Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text('Media'),
                      ],
                    ),
                    onTap: () {
                      // Add the desired action or navigation here
                      // For example:
                      // LaunchURL('https://example.com/news/u.s');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: const [
                        Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text('U.S'),
                      ],
                    ),
                    onTap: () {
                      // Add the desired action or navigation here
                      // For example:
                      // LaunchURL('https://example.com/news/u.s');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: const [
                        Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text('Media'),
                      ],
                    ),
                    onTap: () {
                      // Add the desired action or navigation here
                      // For example:
                      // LaunchURL('https://example.com/news/u.s');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: const [
                        Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text('U.S'),
                      ],
                    ),
                    onTap: () {
                      // Add the desired action or navigation here
                      // For example:
                      // LaunchURL('https://example.com/news/u.s');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: const [
                        Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text('Media'),
                      ],
                    ),
                    onTap: () {
                      // Add the desired action or navigation here
                      // For example:
                      // LaunchURL('https://example.com/news/u.s');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Shows',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      // Update the UI based on the item selected
                      // then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              // ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Handle startempirewire.com tap
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 11),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'StartempireWire.com',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const StandardsAndPoliciesPage(),
                        ),
                      );
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Standards and Policies',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyPage(),
                        ),
                      );
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Privacy Policies',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsPage(),
                        ),
                      );
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Terms',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutPage(),
                        ),
                      );
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'About',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SupportPage(),
                        ),
                      );
                    },
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Support',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
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
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.youtube,
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
