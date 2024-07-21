import 'package:flutter/cupertino.dart';


Widget loader( {required double radius,required Color color}) {
  return CupertinoActivityIndicator(
    color: color,
    radius: radius,
  );
}
