
import 'package:firebase_auth/firebase_auth.dart';

// Authentication Service for Sign In, SignOut and Reset Password Methods.
class AuthService {
  final FirebaseAuth auth;
  AuthService({
    required this.auth,
  });

  // Listen for User State Change using Stream
  Stream<User?> get user {
    return auth.authStateChanges();
  }

}
