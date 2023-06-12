import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'At StartEmpireWire, we are committed to protecting your privacy.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This Privacy Policy outlines how we collect, use, store, and disclose your personal information when you use our website and mobile app. By accessing or using StartEmpireWire, you consent to the practices described in this policy.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Information We Collect:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We may collect personal information such as your name, email address, and other relevant details when you register an account, subscribe to our newsletter, or engage in certain activities on StartEmpireWire. We may also collect non-personal information such as your IP address, browser type, and device information for analytical and security purposes.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Use of Information:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We use the information collected to provide, maintain, and improve our services. This includes delivering personalized content, responding to inquiries, sending newsletters or notifications, and analyzing user trends. We may also use aggregated and anonymized data for research and marketing purposes.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Information Sharing:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We may share your personal information with trusted third-party service providers who assist us in delivering our services, such as hosting providers, analytics providers, and email delivery services. We ensure that these providers adhere to appropriate data protection standards. We will not sell, rent, or lease your personal information to third parties without your consent, unless required by law.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Cookies and Tracking Technologies:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'StartEmpireWire uses cookies and similar tracking technologies to enhance your user experience and collect information about your usage patterns. You have the option to disable cookies through your browser settings, but please note that certain features of our website may not function properly as a result.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Security:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We implement appropriate security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. However, no data transmission over the internet or electronic storage method is 100% secure. While we strive to protect your information, we cannot guarantee absolute security.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              "Children's Privacy:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'StartEmpireWire is not intended for use by individuals under the age of 16. We do not knowingly collect personal information from children. If you believe that we have inadvertently collected information from a child, please contact us, and we will promptly take appropriate actions to delete the information.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'External Links:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Our website and mobile app may contain links to third-party websites. We are not responsible for the privacy practices or content of these external sites. We encourage you to review the privacy policies of any third-party sites you visit.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Changes to the Privacy Policy:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'StartEmpireWire reserves the right to update or modify this Privacy Policy at any time. Any changes will be effective immediately upon posting the updated policy on our website. It is your responsibility to review this policy periodically. Continued use of StartEmpireWire after any modifications constitutes acceptance of the revised policy.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'If you have any questions or concerns about this Privacy Policy, please contact us at [contact email].',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
