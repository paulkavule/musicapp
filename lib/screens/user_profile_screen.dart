import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicapp1/services/oauth2_login.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);
  User get user => Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
              colors: [
            Colors.brown.shade800.withOpacity(0.8),
            Colors.brown.shade200.withOpacity(0.8)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  user.photoURL!, fit: BoxFit.fitHeight,
                  // 'https://images.freeimages.com/images/large-previews/889/chef-1318790.jpg'
                  // 'https://cdn.pixabay.com/photo/2022/10/17/15/44/bird-7528089_960_720.jpg'
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                user.displayName!,
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  user.emailVerified
                      ? const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 30,
                        )
                      : const Icon(
                          Icons.email,
                          color: Colors.white,
                          size: 30,
                        ),
                  Text(
                    user.emailVerified ? 'Verified' : 'Not Verified',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
              Text(
                user.email!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  SignUpApi.signOut(context: context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent.shade200,
                    elevation: 0.1),
                child: Text(
                  'Sign Out',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
