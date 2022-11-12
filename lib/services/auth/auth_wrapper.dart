import 'package:eatarian_assignment/services/auth/auth_service.dart';
import 'package:eatarian_assignment/widgets/login_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//  Auth Wrapper to listen to changes to User Auth State and then redirect accordingly.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final User? userData = Provider.of<User?>(context);
    final AuthService authInstance = Provider.of<AuthService>(context);
    // Redirect user to HomePage or Authenticate

    if (userData == null) {
      return const LoginTab();
    } else {
      return Scaffold(
        body: Center(
            child: ElevatedButton(
                onPressed: () {
                  authInstance.auth.signOut();
                },
                child: const Text("Sign Out"))),
      );
    }
  }
}
