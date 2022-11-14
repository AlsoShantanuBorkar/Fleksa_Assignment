import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Retrive Dynamic Link
  void initDynamicLinks(Function createSharedPreferences) async {
    final SharedPreferences localStorage = await createSharedPreferences();
    // Retrive email from local storage
    final String? userEmail = localStorage.getString("userEmail");
    // Retrive Dynamic Link used by user
   final PendingDynamicLinkData? data ;
   try {
      data =
        await FirebaseDynamicLinks.instance.getInitialLink();
   } catch (e) {
     log(e.toString());
     return;
   }
    final Uri? deepLink = data?.link;

    if (deepLink != null && userEmail != null) {
      auth.signInWithEmailLink(
          email: userEmail, emailLink: deepLink.toString());
    }
    return;
  }
}
