import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press for option 1
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Getting Started'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press for option 2
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Using your Startempire Wire+ Membership'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press for option 3
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Troubleshooting'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press for option 4
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Startempire Wire Shop'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press for option 5
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Get Inloved'),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: buildLink('Authors', () {
                  // Handle Authors tap
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: buildLink('Advertise with Us', () {
                  // Handle Advertise with Us tap
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: buildLink('Book Our Speakers', () {
                  // Handle Book Our Speakers tap
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: buildLink('Do Not Sell My Personal Information', () {
                  // Handle Do Not Sell My Personal Information tap
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: buildLink('Legal', () {
                  // Handle Legal tap
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: buildLink('Shipping and Returns', () {
                  // Handle Shipping and Returns tap
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: buildLink('Careers', () {
                  // Handle Careers tap
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: buildLink('Media and Press Inquiries', () {
                  // Handle Media and Press Inquiries tap
                }),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle Facebook icon press
                    },
                    icon: const Icon(FontAwesomeIcons.facebookF),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle Twitter icon press
                    },
                    icon: const Icon(FontAwesomeIcons.twitter),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle Instagram icon press
                    },
                    icon: const Icon(FontAwesomeIcons.instagram),
                  ),
                  IconButton(
                    onPressed: () {
                      // Handle Instagram icon press
                    },
                    icon: const Icon(FontAwesomeIcons.youtube),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Need to Contact Us?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Submit a Support Request button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                  ),
                  child: const Text('Submit a Support Request'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLink(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
