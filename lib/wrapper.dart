import 'package:flutter/material.dart';
import 'package:my_app/authenticate.dart';
import 'package:provider/provider.dart';
import 'mainScreen.dart';
import 'models/users.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<Users>(context);

    if(user == null){
      return Authenticate();
    } else{
      return Home();
    }
  }
}
