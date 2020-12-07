import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import 'package:provider/provider.dart';
import "screens/chat_screen.dart";
import "screens/auth_screen.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.deepPurple,
        backgroundColor: Colors.pink,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: "WeTalk",
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => UserProvider(),
          ),
        ],
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapShot) {
            if (userSnapShot.hasData) {
              return ChatScreen();
            } else {
              return AuthScreen();
            }
          },
        ),
      ),
    );
  }
}
