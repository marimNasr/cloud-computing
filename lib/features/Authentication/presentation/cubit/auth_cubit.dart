import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../../data/userModel.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  /////////////////////////////////////////////////////////
  TextEditingController emailup = TextEditingController();
  TextEditingController passup = TextEditingController();
  TextEditingController cpassup = TextEditingController();
  TextEditingController nameup = TextEditingController();
  final user = FirebaseFirestore.instance.collection("User");


  signUp() async{
    try{
      emit(SignUpLoading());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailup.text, password: passup.text);
      userModel User = userModel(
        name: nameup.text,
        email: emailup.text,
        password: passup.text,
        channels: [],
      );
      addUser(User);
      emit(SignUpSuccess());
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
    }on FirebaseAuthException catch(e){
      emit(SignUpError(e.code));
    }catch(e){
      emit(SignUpError(e.toString()));
    }
  }

  signIn() async{
    try{
      emit(SignInLoading());
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: pass.text);
      emit(SignInSuccess());

    }on FirebaseAuthException catch(e){
      emit(SignInError(e.code));
    }catch(e){
      emit(SignInError(e.toString()));
    }
  }


  signInWithGoogle() async {
    try {
      emit(GoogleSignInLoading());
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser
          ?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(GoogleSignInSuccess());
    }catch(e){
      emit(GoogleSignInError(e.toString()));
    }
  }

  addUser(userModel UserModel) {
    String uid = FirebaseAuth.instance.currentUser!.uid;  // Get the UID of the current user

    user.doc(uid).set({
        "name":UserModel.name,
        "email":UserModel.email,
        "password":UserModel.password,
         "channels":UserModel.channels
      });
  }
}
