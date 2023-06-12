import 'package:flutter/material.dart';

class StandardsAndPoliciesPage extends StatelessWidget {
  const StandardsAndPoliciesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Standards and Policies'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Standards and Policies',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to StartEmpireWire! Our platform follows certain standards and policies to ensure a positive and inclusive experience for all users. By accessing or using StartEmpireWire, you agree to abide by the following guidelines:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '1. Respectful and Appropriate Behavior',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Treat others with respect and courtesy. Do not engage in any form of harassment, hate speech, or discriminatory behavior. Be mindful of cultural differences and maintain a welcoming environment for everyone.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '2. Compliance with Laws',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Adhere to all applicable laws and regulations when using StartEmpireWire. Do not engage in any illegal activities or promote illegal content.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '3. Protection of Intellectual Property',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Respect the intellectual property rights of others. Do not infringe upon copyrights, trademarks, or any other proprietary rights.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '4. User-generated Content',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'When posting user-generated content on StartEmpireWire, ensure that it does not violate any laws or the rights of others. Do not share false information, engage in spamming, or post malicious content.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              '5. Security and Privacy',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Protect your account credentials and personal information. Do not attempt to gain unauthorized access to other users\' accounts or engage in any activities that compromise the security and privacy of StartEmpireWire users.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Failure to comply with these standards and policies may result in the suspension or termination of your account. StartEmpireWire reserves the right to take appropriate actions for any violations.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'If you have any questions or concerns about our standards and policies, please contact us at [contact email].',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
