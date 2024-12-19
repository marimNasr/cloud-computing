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


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  static String routeName = "sign_in";

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  GlobalKey<FormState> fKeyP = GlobalKey<FormState>();


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
                      height: MediaQuery.of(context).size.height * 0.3, // Set height for the wavy container
                      color: Color.fromARGB(255, 211, 189, 234), // Background color
                    ),
                  ),
                  SingleChildScrollView(
                    child: BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    if(state is SignInSuccess){
      if(FirebaseAuth.instance.currentUser!.emailVerified){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Sign In Success")),
        );
        Navigator.pushReplacementNamed(context, ChannelsPage.routeName);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please Verify Your Email")),
        );
      }
    }else if (state is SignInError){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(state.error)
        )
      );
    }
  },
  builder: (context, state) {
    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0), // Add some padding
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              const SizedBox(width: 15),
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   const Text(
                                     "Welcome",
                                     style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 45,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                   Text("Back",
                                     style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 45,
                                       fontWeight: FontWeight.bold,)
                                     )
                                  ]
                               )
                            ],
                          ),
                          const SizedBox(height: 80),
                          const Text("Sign In",
                            style: TextStyle(
                              color: Color.fromARGB(255, 179, 62, 121),
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            )),
                          const SizedBox(height: 30),
                          CustomTextfrom(
                            labelText: "Email",
                            controller: context.read<AuthCubit>().email,
                            fKey: fKey,
                            textColor: Colors.black,
                          ),
                          const SizedBox(height: 20),
                          SecretTextform(
                            labelText: "Password",
                            controller: context.read<AuthCubit>().pass,
                            fKey: fKeyP,
                            controller_parent: null,
                            textColor: Colors.black,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("if you don't have an account"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, SignUp.routeName);
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 110,165,175),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          state is SignInLoading ? const CircularProgressIndicator() : MaterialButton(
                            color: Color.fromARGB(255, 153,108,250),
                            onPressed: () {
                              if (fKey.currentState!.validate() && fKeyP.currentState!.validate()) {
                                context.read<AuthCubit>().signIn();
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Color.fromARGB(255, 228, 211, 248),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          AnotherOptions(size: 20),
                        ],
                      ),
                    );
  },
),
                  ),
                ],
              ),
            ),
          );
  }
}
