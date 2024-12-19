import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../analytics/analytics.dart';
import '../../data/userModel.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String? verifyID;
  /////////////////////////////////////////////////////////
  TextEditingController emailup = TextEditingController();
  TextEditingController phoneup = TextEditingController();
  TextEditingController passup = TextEditingController();
  TextEditingController cpassup = TextEditingController();
  TextEditingController nameup = TextEditingController();
  final user = FirebaseFirestore.instance.collection("User");
  FirebaseAuth auth = FirebaseAuth.instance;


  signUp() async{
    try{
      emit(SignUpLoading());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailup.text, password: passup.text);
      userModel User = userModel(
        name: nameup.text,
        email: emailup.text,
        password: passup.text,
        phone: phoneup.text,
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
      final prefs = await SharedPreferences.getInstance();
      bool isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

      if (isFirstLogin) {
        await logFirstLogin(); // Log the first-time login event
        prefs.setBool('isFirstLogin', false); // Set the first-login flag to false
      }
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

  signInWithPhone() async {
    emit(PhoneSignInLoading());
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+201091404811",  // Ensure this is the correct phone number format
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically sign in the user if verification is completed
          await FirebaseAuth.instance.signInWithCredential(credential);
          emit(PhoneVerificationSuccess());
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(PhoneSignInError("Verification failed: ${e.message}"));
        },
        codeSent: (String verificationId, int? resendToken) async {
          verifyID = verificationId;
          emit(PhoneSignInSuccess());
          // Optionally, show the OTP input field and inform the user to enter the OTP manually.
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // This is where you should put your timeout handling logic
          verifyID = verificationId;
          emit(PhoneAutoRetrievalTimeout(verificationId));
          // Optionally allow the user to retry or input code manually.
        },
      );
    } catch (e) {
      emit(PhoneSignInError("Error during phone sign-in: $e"));
    }
  }

// Function to verify the OTP code entered by the user
  sentCode() async {
    emit(PhoneVerificationLoading());
    try {
      if (otpController.text.isEmpty) {
        emit(PhoneVerificationError("Please enter the OTP code"));
        return;
      }

      if (verifyID == null) {
        emit(PhoneVerificationError("Verification ID is null. Restart the process."));
        return;
      }

      // Create a PhoneAuthCredential with the verification ID and OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verifyID!,
        smsCode: otpController.text,
      );

      // Sign the user in with the credential
      await auth.signInWithCredential(credential);
      emit(PhoneVerificationSuccess());
    } catch (e) {
      emit(PhoneVerificationError("OTP verification failed: $e"));
    }
  }



  addUser(userModel UserModel) {
    String uid = FirebaseAuth.instance.currentUser!.uid;  // Get the UID of the current user

    user.doc(uid).set({
        "name":UserModel.name,
        "email":UserModel.email,
        "phone": UserModel.phone,
        "password":UserModel.password,
         "channels":UserModel.channels
      });
  }


}

