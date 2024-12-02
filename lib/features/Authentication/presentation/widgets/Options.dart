import 'dart:ffi';
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
              return ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().signInWithGoogle();

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 153,108,250), // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Adjust padding
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.g_mobiledata,
                      color: Color.fromARGB(255, 228, 211, 248), // Google icon color
                      size: 30, // Adjust icon size
                    ),
                    SizedBox(width: 8), // Space between icon and text
                    Text(
                      "Sign in with Google",
                      style: TextStyle(
                        color: Color.fromARGB(255, 228, 211, 248), // Text color
                        fontSize: 16, // Text size
                      ),
                    ),
                  ],
                ),
              );

            },
          ),
        ]
    );
  }
}
