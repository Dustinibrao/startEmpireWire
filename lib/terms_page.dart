import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Effective Date: June 12, 2023',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'These Terms of Service outline the rules and guidelines for using our website and mobile app. By accessing or using StartEmpireWire, you agree to comply with these terms. If you do not agree with any part of these terms, please refrain from using our services.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Content:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'All content on StartEmpireWire, including articles, images, and videos, is for informational purposes only. The views expressed in the content belong to the respective authors and do not necessarily reflect the views of StartEmpireWire.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Intellectual Property:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'All intellectual property rights, including copyrights and trademarks, associated with StartEmpireWire\'s content, logo, and brand belong to StartEmpireWire. You may not reproduce, distribute, modify, or use any of our intellectual property without prior written permission.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'User Contributions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'StartEmpireWire allows users to contribute comments and engage in discussions. By posting or submitting content on StartEmpireWire, you grant us a non-exclusive, royalty-free, worldwide license to use, reproduce, and distribute your content. You are responsible for the content you post and must not violate any laws or infringe upon the rights of others.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Links to Third-Party Websites:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'StartEmpireWire may contain links to third-party websites or services. We are not responsible for the content, accuracy, or practices of these external sites. Visiting and using third-party websites are at your own risk, and we recommend reviewing their respective terms of service and privacy policies.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Disclaimer:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'StartEmpireWire strives to provide accurate and up-to-date information. However, we do not warrant the completeness, reliability, or accuracy of the content on our platform. Any reliance on the information provided is at your own risk. StartEmpireWire shall not be held liable for any direct, indirect, or consequential damages arising from the use of our platform.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Modification of Terms:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'StartEmpireWire reserves the right to modify these Terms of Service at any time. Any changes will be effective immediately upon posting the updated terms on our website. It is your responsibility to review the terms periodically. Continued use of StartEmpireWire after any modifications constitutes acceptance of the revised terms.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Governing Law:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'These Terms of Service are governed by and interpreted in accordance with the laws of [your jurisdiction]. Any disputes arising from these terms shall be subject to the exclusive jurisdiction of the courts in [your jurisdiction].',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'If you have any questions or concerns about these terms, please contact us at [contact email].',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
