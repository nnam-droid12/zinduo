import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:zinduo/home.dart';
import 'package:zinduo/user_login.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final client = Client()
      .setEndpoint('https://cloud.appwrite.io/v1') // Your API Endpoint
      .setProject('64899d39467825fdf608'); // Your project ID

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  String passwordErrorMessage = '';

  Future<void> registerUser() async {
    final password = passwordController.text;
    if (password.length < 8) {
      setState(() {
        passwordErrorMessage = 'Minimum 8 characters required';
      });
      return;
    }
    try {
      final account = Account(client);
      await account.create(
        userId: ID.unique(),
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => UserLogin(name: nameController.text)),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Registration error: $e');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.shade800,
                  Colors.green.shade400,
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'Zinduo',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        if (value.length >= 8) {
                          setState(() {
                            passwordErrorMessage = '';
                          });
                        }
                      },
                    ),
                  ),
                  if (passwordErrorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        passwordErrorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: registerUser,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      backgroundColor: Colors.white, // Custom button color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18.0), // Custom border radius
                      ),
                    ),
                    child: const Text('Register',
                        style: TextStyle(
                          color: Colors.green,
                        )),
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserLogin(name: nameController.text)),
                      );
                    },
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
          ),
        ],
      ),
    );
  }
}
