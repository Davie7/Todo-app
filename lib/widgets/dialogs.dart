import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    duration: Duration(milliseconds: 1200),
    elevation: 10,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(5),
      topRight: Radius.circular(5),
    )),
    backgroundColor: Colors.purple,
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void deletionSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    duration: Duration(milliseconds: 1500),
    elevation: 10,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(5),
      topRight: Radius.circular(5),
    )),
    backgroundColor: Colors.purple,
    content: Text(message),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
