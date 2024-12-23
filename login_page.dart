import 'package:flutter/material.dart';
import 'landing_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'WELCOME TO ISTE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/iste_logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 100.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LandingPage(isDarkMode: false),
                  ),
                );
              },
              child: const Text(
                'Log in',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Log in with:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            IconButton(
              icon: Image.asset(
                'assets/images/google.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              iconSize: 50,
              onPressed: () {
                // Handle Google login
              },
            ),
          ],
        ),
      ),
    );
  }
}
