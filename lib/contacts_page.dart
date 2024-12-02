// contacts_page.dart
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
  }

  @override
  Widget build(BuildContext context) {
    final aboutDescription =
        "The journey to bring Average At Best online has been a true partnership. "
        "Our team of students has worked closely with the brand’s founder to turn their vision into a fully-functional website. "
        "With a shared love for running and the brand's inclusive approach, we’ve collaborated to create a digital experience that matches the spirit of Average At Best: for runners who are just getting started or those who’ve been running for years. "
        "It’s been a rewarding process of teamwork, learning, and bringing a vision to life.";

    final teamMembers = [
      {
        'name': 'Katelyn Campbell',
        'role': 'Front-end/Mobile Dev',
        'tasks': 'Created About & Home Page',
        'image': 'assets/katelyn.jpg',
        'linkedin': 'https://www.linkedin.com/in/katelynsoups/',
      },
      {
        'name': 'Noah Fuhrman',
        'role': 'Project Manager/Front-end',
        'tasks': 'MERN Set Up & Created Products Page',
        'image': 'assets/noah.jpg',
        'linkedin': 'https://www.linkedin.com/in/noah-f-893a78237/',
      },
      {
        'name': 'Randy Nguyen',
        'role': 'Front-end',
        'tasks': 'Created Navigation Bar & About Page',
        'image': 'assets/randy.jpg',
        'linkedin':
            'https://www.linkedin.com/in/randy-nguyen-software-developer22/',
      },
      {
        'name': 'Nick Piazza',
        'role': 'Front-end',
        'tasks': 'Created Cart Page',
        'image': 'assets/nick.jpg',
        'linkedin': 'https://www.linkedin.com/in/nickpiazza26/',
      },
      {
        'name': 'Santos Solanet',
        'role': 'API',
        'tasks': 'Created API Portion',
        'image': 'assets/santoscutie.jpg',
        'linkedin': 'https://www.linkedin.com/in/santos-solanet',
      },
      {
        'name': 'Ashton Becker',
        'role': 'Database',
        'tasks': 'Created Database',
        'image': 'assets/ashtoncutiepatootie.jpg',
        'linkedin':
            'https://www.linkedin.com/in/ashton-becker?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app',
      },
      {
        'name': 'Jacob Adams',
        'role': 'Mobile Developer',
        'tasks': 'Created Mobile App',
        'image': 'assets/jacob.jpg',
        'linkedin': 'https://www.linkedin.com/in/jacobka1219/',
      },
      {
        'name': 'Joshua Orlian',
        'role': 'Founder',
        'tasks': 'Created the Brand',
        'image': 'assets/joshua.jpg',
        'linkedin': 'https://www.linkedin.com/in/joshorlian/',
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Meet the AAB Team',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    aboutDescription,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: teamMembers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust for mobile view
                childAspectRatio: 0.6,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final member = teamMembers[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage(member['image'] as String),
                        ),
                        Text(
                          member['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          member['role'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          member['tasks'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/icons/LI-In-Bug.png',
                            width: 32,
                            height: 32,
                          ),
                          onPressed: () {
                            // Open LinkedIn profile
                            final url = member['linkedin'] as String;
                            _launchURL(url);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
