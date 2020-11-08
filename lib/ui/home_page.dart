import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yellow_class_video_app/ui/sign_in.dart';
import 'package:yellow_class_video_app/ui/video_player.dart';
import 'package:yellow_class_video_app/util/custom_toast.dart';
import 'package:yellow_class_video_app/util/strings_en.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOut() async {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            Strings.confirmation_dialog,
          ),
          content: Text(
            Strings.are_you_sure,
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(Strings.cancel),
            ),
            FlatButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                CustomToast.show(Strings.logged_out, context);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return GoogleAuthSignIn();
                  },
                ), (route) => false);
              },
              child: Text(Strings.yes),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: RaisedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return VideoPlayer(
                              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
                        },
                      ),
                    );
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                  },
                  color: Colors.black,
                  child: Text(
                    '${Strings.test_video} I',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                width: 200,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return VideoPlayer(
                              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4');
                        },
                      ),
                    );
                  },
                  color: Colors.black,
                  child: Text(
                    '${Strings.test_video} II',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                width: 200,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return VideoPlayer(
                              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4');
                        },
                      ),
                    );
                  },
                  color: Colors.black,
                  child: Text(
                    '${Strings.test_video} III',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                width: 200,
                child: RaisedButton(
                  onPressed: () {
                    signOut();
                  },
                  color: Colors.white,
                  child: Text(
                    Strings.sign_out,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
