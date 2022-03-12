
import 'package:best_flutter_ui_templates/model/user.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required User user}) : this.user = user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState(user);
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User user;
  _ProfileScreenState(this.user);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
