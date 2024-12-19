import 'dart:ffi';
import 'package:cloudtask2/features/Authentication/presentation/views/phone_signin.dart';
import 'package:cloudtask2/features/Home/presentation/views/channel_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../chat/presentation/views/chat_screen.dart';
import '../cubit/auth_cubit.dart';

class AnotherOptions extends StatelessWidget {
  const AnotherOptions({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const Text("~OR~"
            , style: TextStyle(
                color: Color.fromARGB(255, 179, 62, 121),
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),),
          SizedBox(height: size),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is GoogleSignInSuccess){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Sign In Success")),
                );
                Navigator.pushReplacementNamed(context, ChannelsPage.routeName);
              }else if (state is GoogleSignInError){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.error)
                  )
                );
              }
            },
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons evenly
                children: [
                  // Google Sign-In Button
                  Column(
                    mainAxisSize: MainAxisSize.min, // Adjust size to fit content
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<AuthCubit>().signInWithGoogle();
                        },
                        icon: Icon(
                          Icons.g_mobiledata,
                          color: Color.fromARGB(255, 165, 165, 165), // Google icon color
                          size: 70, // Larger size to balance visual weight
                        ),
                      ),
                      SizedBox(height: 8), // Space between icon and text
                      Text(
                        "Google",
                        style: TextStyle(
                          color: Color.fromARGB(255, 165, 165, 165), // Text color
                          fontSize: 16, // Adjusted text size
                          fontWeight: FontWeight.w500, // Slightly bold text for better readability
                        ),
                      ),
                    ],
                  ),

                  // Phone Sign-In Button
                  Column(
                    mainAxisSize: MainAxisSize.min, // Adjust size to fit content
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, phone_SignIn.routeName);
              },
              icon: Icon(
              Icons.phone,
              color: Color.fromARGB(255, 165, 165, 165), // Phone icon color
              size: 50, // Slightly smaller size for balance
              ),
              ),
                      ),
                      SizedBox(height: 8), // Space between icon and text
                      Text(
                        "Phone",
                        style: TextStyle(
                          color: Color.fromARGB(255, 165, 165, 165), // Text color
                          fontSize: 16, // Adjusted text size
                          fontWeight: FontWeight.w500, // Slightly bold text for better readability
                        ),
                      ),
                    ],
                  ),
                ],
              );


            },
          ),
        ]
    );
  }
}
