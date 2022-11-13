import 'package:eatarian_assignment/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({super.key, required this.authInstance});
  final AuthService authInstance;

  @override
  State<EmailLogin> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<EmailLogin> with WidgetsBindingObserver {
  TextEditingController emailController = TextEditingController();

  bool isVisible = false;
  @override
  void initState() {
    emailController.text = "";
    widget.authInstance.initDynamicLinks(createSharedPreferences);
    super.initState();
  }

  // Shared Preferences instance to access local storage
  Future<SharedPreferences> createSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    final authInstance = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Email ID",
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                  visible: isVisible,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "We've Sent the the verification link to your email",
                          style: GoogleFonts.outfit(
                            color: Colors.grey.shade800,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: (() async {
                    setState(() {
                      isVisible = true;
                    });
                    final SharedPreferences localStorage =
                        await createSharedPreferences();
                    // Store Email from file storage
                    localStorage.setString("userEmail", emailController.text);
                    // Send Verification Email to User
                    return await authInstance.auth.sendSignInLinkToEmail(
                        email: emailController.text,
                        actionCodeSettings: ActionCodeSettings(
                          url: 'https://eatarian.page.link/nYJz',
                          handleCodeInApp: true,
                          androidPackageName: 'com.example.eatarian_assignment',
                          androidMinimumVersion: "1",
                        ));
                  }),
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.yellow.shade100,
                          Colors.amber.shade400,
                        ],
                      ),
                    ),
                    child: Text(
                      'Verify Email',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "By clicking Login, You accept our ",
                  style: GoogleFonts.roboto(
                      color: Colors.black, fontWeight: FontWeight.w500),
                  children: [
                    TextSpan(
                      text: "\nTerms & Conditions",
                      style: GoogleFonts.roboto(
                        color: Colors.blue.shade500,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
