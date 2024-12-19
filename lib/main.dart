
import 'package:cloudtask2/features/Home/presentation/views/channel_screen.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/Authentication/presentation/cubit/auth_cubit.dart';
import 'features/Authentication/presentation/views/phone_signin.dart';
import 'features/Authentication/presentation/views/signIn.dart';
import 'features/Authentication/presentation/views/signUp.dart';
import 'features/analytics/analytics.dart';
import 'features/chat/presentation/views/chat_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        routes: {
          SignIn.routeName: (context) => const SignIn(),
          SignUp.routeName: (context) => const SignUp(),
          chatPage.routeName: (context) => const chatPage(),
          ChannelsPage.routeName: (context) => const ChannelsPage(),
          phone_SignIn.routeName : (context) => const phone_SignIn(),
        },
        initialRoute: SignIn.routeName,
      ),
    );
  }
}

