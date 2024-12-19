import 'package:cloudtask2/features/Authentication/presentation/views/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/Options.dart';
import '../widgets/custom_TextFrom.dart';
import '../widgets/secret_textForm.dart';
import '../widgets/wavyContainer.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  static String routeName = "sign_up";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> cfKeyP = GlobalKey<FormState>();
  GlobalKey<FormState> fKey = GlobalKey<FormState>();
  GlobalKey<FormState> fKeyP = GlobalKey<FormState>();
  GlobalKey<FormState> fKeyn = GlobalKey<FormState>();
  GlobalKey<FormState> fKeyph = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 248, 215, 223),
        body: Stack( // Using Stack to position the back button
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
            if(state is SignUpSuccess){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Sign Up Success, verify your email")),
                );
              Navigator.pushReplacementNamed(context, SignIn.routeName);
            }else if (state is SignInError){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.error)
                )
              );
            }
          },
        builder: (context, state) {
        return Stack(
          children: [
            Column(
                  children: [
                    const SizedBox(height: 40),
                    const Row(
                      children: [
                        SizedBox(width: 45),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                "Create",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Account",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                                        ),
                                      ]
                                    ),
                                    SizedBox(width: 60),
                                    //Pickimage(),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 100),
                            CustomTextfrom(
                              labelText: "Name",
                              controller: context.read<AuthCubit>().nameup,
                              fKey: fKeyn,
                              textColor: Colors.black,
                            ),
                            const SizedBox(height: 20),
                            CustomTextfrom(
                              labelText: "Email",
                              controller: context.read<AuthCubit>().emailup,
                              fKey: fKey,
                              textColor: Colors.black,
                            ),
                    const SizedBox(height: 20),
                            CustomTextfrom(
                              labelText: "Phone",
                              controller: context.read<AuthCubit>().phoneup,
                              fKey: fKeyph,
                              textColor: Colors.black,
                            ),
                            const SizedBox(height: 20),
                            SecretTextform(
                              labelText: "Password",
                              controller: context.read<AuthCubit>().passup,
                              fKey: fKeyP,
                              controller_parent: null,
                              textColor: Colors.black,
                            ),
                            const SizedBox(height: 20),
                            SecretTextform(
                              labelText: "Confirm Password",
                              controller: context.read<AuthCubit>().cpassup,
                              fKey: cfKeyP,
                              controller_parent: context.read<AuthCubit>().passup,
                              textColor: Colors.black,
                            ),

                            const SizedBox(height: 50),
                             state is SignUpLoading ? const CircularProgressIndicator() : MaterialButton(
                              color: Color.fromARGB(255, 153,108,250),
                              minWidth: 150,
                              onPressed: () {
                                if (fKey.currentState!.validate() &&
                                    fKeyP.currentState!.validate() &&
                                    cfKeyP.currentState!.validate() &&
                                    fKeyn.currentState!.validate()) {
                                  context.read<AuthCubit>().signUp();

                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Color.fromARGB(255,228, 211, 248),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                    Positioned( // Back button positioned at the top left
                      top: 5,
                      left: 5,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
                        onPressed: () {
                          Navigator.of(context).pop(); // Go back to the previous screen
                        },
                      ),
                    ),
                  ],
                );
  },
),
     )
          ],
        ),
      ),
    );
  }
}
