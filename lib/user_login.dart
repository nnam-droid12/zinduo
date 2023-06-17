import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:zinduo/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserLogin extends StatefulWidget {
  final String name;
  const UserLogin({super.key, required this.name});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {

  late Client client;
  late String appwriteEndpoint;
  late String appwriteProjectId;

  String email = '';
  String password = '';

   @override
  void initState() {
    super.initState();
    appwriteEndpoint = dotenv.env['APPWRITE_ENDPOINT'] ?? '';
    appwriteProjectId = dotenv.env['APPWRITE_PROJECT_ID'] ?? '';
    client = Client()
      .setEndpoint(appwriteEndpoint)
      .setProject(appwriteProjectId);
  }

  Future<void> loginUser() async {
    final account = Account(client);

    try {
      await account.createEmailSession(email: email, password: password);

      // User logged in successfully, redirect to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(name: widget.name)),
      );
    } catch (e) {
      // Handle login error
      // ignore: avoid_print
      print('Login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200], // Set the background color
      appBar: AppBar(
        backgroundColor: Colors.green[800], // Set the app bar color
        title: const Text('Zinduo'),
        centerTitle: true,
        elevation: 0, // Remove the app bar shadow
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: loginUser,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(18.0), // Custom border radius
                ),
              ),
              child: const Text('Login',
                  style: TextStyle(
                    color: Colors.green,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
