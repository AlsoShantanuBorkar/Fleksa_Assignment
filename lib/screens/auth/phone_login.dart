import 'dart:developer';

import 'package:eatarian_assignment/services/auth/auth_service.dart';
import 'package:eatarian_assignment/widgets/pinput_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pinput/pinput.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key, required this.authInstance});
  final AuthService authInstance;
  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController buttonTextController = TextEditingController();
  bool isVisible = false;
  String verificationID = "";
  @override
  void initState() {
    phoneNumberController.text = "";
    pinController.text = "";
    buttonTextController.text = "Send OTP";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: InternationalPhoneNumberInput(
                    spaceBetweenSelectorAndTextField: 1,
                    inputDecoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Phone Number",
                    ),
                    onInputChanged: (value) {
                      phoneNumberController.text = value.phoneNumber!;
                    },
                  )),
              const SizedBox(
                height: 20,
              ),

              // OTP Input
              Visibility(
                  visible: isVisible,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Enter OTP",
                        style: GoogleFonts.outfit(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "We've Sent the code verification to your phone number",
                          style: GoogleFonts.outfit(
                            color: Colors.grey.shade800,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Pinput(
                        onCompleted: ((value) => pinController.text = value),
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () async {
                    if (!isVisible && phoneNumberController.text.length >= 10) {
                      try {
                        await widget.authInstance.auth.verifyPhoneNumber(
                          phoneNumber: phoneNumberController.text,
                          timeout: const Duration(seconds: 120),
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {
                            await widget.authInstance.auth
                                .signInWithCredential(credential);
                          },
                          verificationFailed: (FirebaseAuthException e) {
                            log(e.toString());
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            setState(() {
                              isVisible = true;
                              buttonTextController.text = "Verify OTP";
                              verificationID = verificationId;
                            });
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      } on FirebaseAuthException catch (e) {
                        log(e.message.toString());
                      }
                    } else if (isVisible && pinController.text.length == 6) {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationID,
                              smsCode: pinController.text);

                      await widget.authInstance.auth
                          .signInWithCredential(credential)
                          .then((value) {});
                    }
                  },
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
                      buttonTextController.text,
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
