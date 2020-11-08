import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yellow_class_video_app/ui/home_page.dart';
import 'package:yellow_class_video_app/util/custom_toast.dart';
import 'package:yellow_class_video_app/util/strings_en.dart';

import 'loading_dialog.dart';

class GoogleAuthSignIn extends StatefulWidget {
  @override
  _GoogleAuthSignInState createState() => _GoogleAuthSignInState();
}

class _GoogleAuthSignInState extends State<GoogleAuthSignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
            ),
            Center(
              child: Image.asset(
                'assets/yellow_class.png',
                height: 150,
                width: 150,
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 200,
              ),
            ),
            Container(
              padding: EdgeInsets.all(50),
              child: OutlineButton(
                onPressed: () {
                  signInWithGoogle();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/google.png',
                        height: 32,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        Strings.sign_in_with_google,
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0X00FFFFFF),
      builder: (context) {
        return LoadingDialog();
      },
    );
  }

  Future<String> signInWithGoogle() async {
    showLoadingDialog();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      Navigator.pop(context);
      return null;
    }
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      CustomToast.show('${Strings.welcome} ${user.displayName}', context);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
      return '$user';
    }
    Navigator.pop(context);
    return null;
  }
}
