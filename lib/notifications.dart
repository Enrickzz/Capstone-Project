import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import 'additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import 'dialogs/policy_dialog.dart';
import 'fitness_app_theme.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class notifications extends StatefulWidget {
  @override
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> with SingleTickerProviderStateMixin {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 2, vsync: this);
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
              text: 'Notifications',
            ),
            Tab(
              text: 'Recommendations',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: FitnessAppTheme.background,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("Personal Information"),
                        subtitle: Text("Hello World! asdasdasd ad ad a da adsa d a sda sd a  a asd asdasdasd ad sad  asdasda adsadasda adadasdasdaas asdasda asdasdas da asdasdaad ad asd a da ad asd"),
                        onTap:(){

                        },
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal:
                        16.0),
                      ),

                      ListTile(
                        title: Text("Medical History"),
                        subtitle: Text("Hello World! asdasdasd ad ad a da adsa d a sda sd a  a asd asdasdasd ad sad"),
                        onTap:(){

                        },
                        dense: true,
                      ),

                      ListTile(
                        title: Text("Manage Support System"),
                        onTap:(){

                        },
                        dense: true,
                      ),

                      ListTile(
                        title: Text("Manage Healthcare Team"),
                        onTap:(){

                        },
                      ),
                    ],
                  ),
                ),
            ),
          ),
          Container(
            color: FitnessAppTheme.background,
          ),
        ],
      ),
    );
  }
}
