import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicapp1/services/oauth2_login.dart';
// import 'package:musicapp1/dicontainer.dart';
// import 'package:musicapp1/services/oauth2_login.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  // signIn() async {
  //   await GoogleSigninApi.login();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.brown.shade800.withOpacity(0.8),
            Colors.brown.shade200.withOpacity(0.8)
          ])),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    "assets/images/mubimba_splash_logo.png",
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'mubimba',
                  style: GoogleFonts.rubikBubbles(fontSize: 50),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Offline music',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  'The way you would love it!',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.white),
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: const Text('Quick Start')),
                FutureBuilder(
                  future: SignUpApi.initializeFirebase(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error on firebase initialization');
                    }
                    return ElevatedButton.icon(
                      onPressed: () async {
                        final user = await SignUpApi.login(context: context);
                        // print('${user!.email}, ${user.photoURL}');
                        if (user == null) {
                          const SnackBar(
                            backgroundColor: Colors.black,
                            content: Text(
                              'Error in authenticating user',
                              style: TextStyle(
                                  color: Colors.redAccent, letterSpacing: 0.5),
                            ),
                          );
                        } else {
                          Get.toNamed('/home', arguments: user);
                        }
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                      ),
                      label: const Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.brown,
                          minimumSize: const Size(double.infinity, 60)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//https://www.youtube.com/watch?v=E5WgU6ERZzA