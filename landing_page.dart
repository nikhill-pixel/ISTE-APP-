import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages, unused_import
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'calendar_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, required bool isDarkMode});

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<String> _profilePics = [
    'assets/images/pfps/1.png',
    'assets/images/pfps/2.png',
    'assets/images/pfps/3.png',
    'assets/images/pfps/4.png',
    'assets/images/pfps/5.png',
    'assets/images/pfps/6.png',
    'assets/images/pfps/7.png',
    'assets/images/pfps/8.png',
    'assets/images/pfps/9.png',
    'assets/images/pfps/10.png',
    'assets/images/pfps/11.png',
    'assets/images/pfps/12.png',
  ];

  // Currently selected profile picture
  String _selectedProfilePic = 'assets/images/mepic.png';

  void _selectProfilePicture() async {
    String? chosenPfp = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Profile Picture'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _profilePics.map((pic) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context, pic),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(pic),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (chosenPfp != null) {
      setState(() {
        _selectedProfilePic = chosenPfp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('I S T E'),
        centerTitle: true,
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // Navigate to the calendar page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.lightBlue[100],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 250,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.lightBlue[200],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _selectProfilePicture,
                    child: CircleAvatar(
                      radius: 74,
                      backgroundImage: AssetImage(_selectedProfilePic),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'ABHIMANYU BINU',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'NUB',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Upcoming events',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  eventTile('Square one'),
                  eventTile('RR party'),
                  eventTile('KSS session'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget eventTile(String eventName) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 16),
          Text(
            eventName,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
