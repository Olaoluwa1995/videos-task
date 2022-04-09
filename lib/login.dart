import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:videos/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: MaterialButton(
            color: Colors.indigo,
            textColor: Colors.white,
            child: const Text('Sign In With Google'),
            onPressed: () async {
              await _googleSignIn.signIn();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            }),
      ),
    );
  }
}
