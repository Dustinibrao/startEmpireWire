import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Welcome to StartEmpireWire',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Your go-to source for the latest news and updates on all things related to the startup and technology industry. Our mission is to deliver timely and insightful content that informs and inspires entrepreneurs, innovators, and tech enthusiasts worldwide.',
              ),
              SizedBox(height: 24),
              Text(
                'Our Team',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'At StartEmpireWire, we have a passionate team of experienced writers, editors, and industry experts dedicated to bringing you high-quality news and analysis. Our team strives to deliver accurate, engaging, and thought-provoking articles that highlight the latest trends, breakthroughs, and success stories in the startup ecosystem.',
              ),
              SizedBox(height: 24),
              Text(
                'What We Cover',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We cover a wide range of topics, including:',
              ),
              SizedBox(height: 8),
              Text(
                  '• Startup News: Stay up to date with the latest news from the startup world, including funding announcements, product launches, acquisitions, and more.'),
              Text(
                  '• Technology Trends: Explore the cutting-edge technologies shaping industries, such as artificial intelligence, blockchain, cybersecurity, and more.'),
              Text(
                  '• Entrepreneurship Insights: Gain valuable insights and tips from successful entrepreneurs, thought leaders, and industry experts to help you navigate the entrepreneurial journey.'),
              Text(
                  '• Investor Perspectives: Discover investment trends, venture capital news, and insights from investors shaping the startup landscape.'),
              Text(
                  '• Startup Spotlight: Dive into the stories behind successful startups and learn from their journeys, challenges, and triumphs.'),
              SizedBox(height: 24),
              Text(
                'Stay Connected',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'To stay connected with StartEmpireWire and never miss an update, download our mobile app available on both iOS and Android platforms. Follow us on social media, subscribe to our newsletter, and join our vibrant community of tech enthusiasts.',
              ),
              SizedBox(height: 24),
              Text(
                'We appreciate your support and trust in us as your reliable source of startup and technology news. If you have any feedback, suggestions, or inquiries, please don\'t hesitate to reach out to us.',
              ),
              SizedBox(height: 24),
              Text(
                'Thank you for being a part of the StartEmpireWire community!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
