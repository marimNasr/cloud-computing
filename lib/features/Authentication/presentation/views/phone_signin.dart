import 'dart:developer';

import 'package:cloudtask2/features/Authentication/presentation/views/signUp.dart';
import 'package:cloudtask2/features/Home/presentation/views/channel_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../chat/presentation/views/chat_screen.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/Options.dart';
import '../widgets/custom_TextFrom.dart';
import '../widgets/secret_textForm.dart';
import '../widgets/wavyContainer.dart';

class phone_SignIn extends StatefulWidget {
  const phone_SignIn({super.key});

  static String routeName = "Phone_signin";

  @override
  State<phone_SignIn> createState() => _phone_SignInState();
}


class _phone_SignInState extends State<phone_SignIn> {
  GlobalKey<FormState> SKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 248, 215, 223),
        body: Stack(
          children: [
            ClipPath(
              clipper: wavyContainer(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: Color.fromARGB(255, 211, 189, 234),
              ),
            ),
            SingleChildScrollView(
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is SignInSuccess) {
                    if (FirebaseAuth.instance.currentUser!.emailVerified) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Sign In Success")),
                      );
                      Navigator.pushReplacementNamed(context, ChannelsPage.routeName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please Verify Your Email")),
                      );
                    }
                  } else if (state is SignInError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  } else if (state is PhoneSignInError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Back",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 80),
                        const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Color.fromARGB(255, 179, 62, 121),
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomTextfrom(
                          labelText: "Phone",
                          controller: context.read<AuthCubit>().phone,
                          fKey: SKey,
                          textColor: Colors.black,
                        ),
                        state is SignInLoading
                            ? const CircularProgressIndicator()
                            : MaterialButton(
                          color: Color.fromARGB(255, 153, 108, 250),
                          onPressed: () {
                            if (SKey.currentState!.validate()) {
                              context.read<AuthCubit>().signInWithPhone();
                              //showAboutDialog(context: context);
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            "Send Code",
                            style: TextStyle(
                              color: Color.fromARGB(255, 228, 211, 248),
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


  // Function to show OTP dialog
  void showOtpDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter OTP"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: context.read<AuthCubit>().otpController,
                decoration: const InputDecoration(
                  labelText: "OTP",
                  hintText: "Enter the code sent to your phone",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String otpCode = context.read<AuthCubit>().otpController.text.trim();
                if (otpCode.isNotEmpty) {
                  // You can use this OTP code to verify and link the phone number

                  Navigator.pop(context); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter the OTP code")),
                  );
                }
              },
              child: const Text("Verify"),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthCubit>().sentCode();
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );

}
