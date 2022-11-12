import 'package:eatarian_assignment/screens/auth/email_login.dart';
import 'package:eatarian_assignment/screens/auth/phone_login.dart';
import 'package:eatarian_assignment/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  LoginTabState createState() => LoginTabState();
}

class LoginTabState extends State<LoginTab> {
  @override
  Widget build(BuildContext context) {
    final AuthService authInstance = Provider.of<AuthService>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          toolbarHeight: 100,
        ),
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: GoogleFonts.outfit(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Please enter your Phone or Email",
                            style: GoogleFonts.outfit(
                              color: Colors.grey.shade800,
                              fontSize: 20,
                              letterSpacing: 1
                            ),
                          ),
                        ),
                      ]),
                ),
              ),

              
              SizedBox(
                height: 60,
                child: AppBar(
                  elevation: 10,
                  backgroundColor: Colors.white,
                  bottom: TabBar(
                    indicatorWeight: 6,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    indicatorColor: Colors.amber.shade200,
                    tabs: [
                      Tab(
                        child: Text(
                          "Phone Number",
                          style: GoogleFonts.outfit(
                            
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Email",
                          style: GoogleFonts.outfit(
                            letterSpacing: 1,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              
               Expanded(
                child: TabBarView(
                  children: [
                    const PhoneLogin(),
                    EmailLogin(authInstance: authInstance)
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
