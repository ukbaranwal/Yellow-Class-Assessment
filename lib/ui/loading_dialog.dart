import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          RefreshProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
