import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  ProfilePage(this.userId);

  @override
  Widget build(BuildContext context) {
    return Text(userId);
  }
}