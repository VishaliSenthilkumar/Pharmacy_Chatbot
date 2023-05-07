import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Theme.of(context).primaryColor,
      child: Center(
        child: SpinKitChasingDots(
          color: Theme.of(context).backgroundColor,
          size: 90.0,
        ),
      ),
    );
  }
}
