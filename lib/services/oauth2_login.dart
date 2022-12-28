import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:injectable/injectable.dart';
// import '../dicontainer.dart';

// abstract class ISignUpApi {
//   Future<User?> login({required BuildContext context});
//   void signOut();
// }

// @Injectable(as: ISignUpApi)
class SignUpApi {
  static final _signIn = GoogleSignIn(scopes: ['email']);
  // final fbdbApp = getIT<FirebaseApp>();
  SignUpApi();

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  // @override
  static Future<User?> login({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      final account = await _signIn.signIn();
      if (account == null) {
        return Future.value();
      }

      final GoogleSignInAuthentication ggsignAuth =
          await account.authentication;

      final AuthCredential creds = GoogleAuthProvider.credential(
          accessToken: ggsignAuth.accessToken, idToken: ggsignAuth.idToken);

      final UserCredential ucreds = await auth.signInWithCredential(creds);

      return ucreds.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          SignUpApi.customSnackBar(
            content: 'The account already exists with a different credential.',
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          SignUpApi.customSnackBar(
            content: 'Error occurred while accessing credentials. Try again.',
          ),
        );
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SignUpApi.customSnackBar(
          content: e.toString(),
        ),
      );
    }
    return Future.value();
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  // @override
  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SignUpApi.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}
