import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import '../additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import '../dialogs/policy_dialog.dart';
import '../fitness_app_theme.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class my_meals extends StatefulWidget {
  @override
  _my_mealsState createState() => _my_mealsState();
}

class _my_mealsState extends State<my_meals> with SingleTickerProviderStateMixin {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 4, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(tabs[controller.index],
            style: TextStyle(
                color: Colors.black
            )
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: controller,
          indicatorColor: Colors.grey,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs:<Widget>[
            Tab(
              text: 'Breakfast',
            ),
            Tab(
              text: 'Lunch',
            ),
            Tab(
              text: 'Dinner',
            ),
            Tab(
              text: 'Snack',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          Container(
            color: FitnessAppTheme.background,
          ),
          Container(
            color: FitnessAppTheme.background,
          ),
          Container(
            color: FitnessAppTheme.background,
          ),
          Container(
            color: FitnessAppTheme.background,
          ),
        ],
      ),
    );
  }
}
