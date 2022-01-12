import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import '../../additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import '../../dialogs/policy_dialog.dart';
import '../../fitness_app_theme.dart';




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: sleep_score(title: 'Flutter Demo Home Page'),
    );
  }
}

class sleep_score extends StatefulWidget {
  sleep_score({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HealthTeamState createState() => _HealthTeamState();
}
final FirebaseAuth auth = FirebaseAuth.instance;
class _HealthTeamState extends State<sleep_score> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  List<String> weights = [];


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
  final User user = auth.currentUser;

  @override
  Widget build(BuildContext context) {
    bool isClipped = false;
    return Scaffold(
        appBar: AppBar(
          title: Text('Sleep Score'),
        ),
        body:  Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 28, 24, 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget>[
                            Expanded(
                              child: Text( "What is Sleep Score?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:Color(0xFF4A6572),
                                  )
                              ),
                            ),
                            InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                onTap: () {},
                                // child: Padding(
                                // padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: <Widget>[
                                    // Text( "Edit",
                                    //     style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.normal,
                                    //       color:Color(0xFF2633C5),
                                    //     )
                                    // ),
                                    // SizedBox(
                                    //   height: 38,
                                    //   width: 26,
                                    //   // child: Icon(
                                    //   //   Icons.arrow_forward,
                                    //   //   color: FitnessAppTheme.darkText,
                                    //   //   size: 18,
                                    //   // ),
                                    // ),
                                  ],
                                )
                              // )
                            )
                          ]
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                        // height: 500, if may contact number and email
                        // margin: EdgeInsets.only(bottom: 50),
                        child: Stack(
                            children: [
                              Positioned(
                                  child: Material(
                                    child: Center(
                                      child: Container(
                                          width: 340,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  blurRadius: 20.0)],
                                          )
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(

                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Your overall sleep score is a sum of your individual scores in sleep duration, sleep quality, and restoration, for a total score of up to 100. Most people get a score between 72 and 83.\n\nSleep score ranges are:",
                                              style: TextStyle(
                                                fontSize:18,
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                            SizedBox(height: 10,),

                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.panorama_wide_angle_select_outlined,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(width: 20,),
                                                Text('Excellent: 90-100')
                                              ],
                                            ),
                                            SizedBox(height: 5,),

                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.panorama_wide_angle_select_outlined,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(width: 20,),
                                                Text('Good: 80-89')
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.panorama_wide_angle_select_outlined,
                                                  color: Colors.orangeAccent,
                                                ),
                                                SizedBox(width: 20,),
                                                Text('Fair: 60-79')
                                              ],
                                            ),
                                            SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.panorama_wide_angle_select_outlined,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 20,),
                                                Text('Poor: Less than 60')
                                              ],
                                            ),
                                            SizedBox(height: 12),

                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: DataTable(
                                                columns: [

                                                  DataColumn(
                                                    label: Text(
                                                      'Sleep Score Item',

                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Description',

                                                    ),
                                                  ),

                                                ],
                                                rows: [
                                                  DataRow(cells: [

                                                    DataCell(
                                                      Text(
                                                        'Duration: Time asleep\nand awake',



                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                          child: Text('The more you \nsleep the better \nthe score',
                                                    )),
                                                    ),

                                                  ]),
                                                  DataRow(cells: [

                                                    DataCell(
                                                      Text(
                                                        'Quality: Deep & \nREM sleep',
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 5,



                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                          child: Text('Longer hours spent \nin these sleep stages\nimproves the score',
                                                          )),
                                                    ),

                                                  ]),
                                                  DataRow(cells: [

                                                    DataCell(
                                                      Text(
                                                        'Restoration: Sleeping\nheart rate &\nrestlessness',



                                                      ),
                                                    ),
                                                    DataCell(
                                                      Center(
                                                          child: Text('High sleeping heart\nrate and movement\nlowers the score.',
                                                          )),
                                                    ),

                                                  ]),
                                                ],
                                              ),
                                            ),




                                          ]
                                      ),
                                    ),
                                  ))
                            ]
                        )
                    ),
                  ],
                ),

              ],
            ),
          ),
        )
    );


  }

  DataTable _createDataTable() {
    return DataTable(columns: _createColumns(), rows: _createRows());
  }
  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text(' ')),
      DataColumn(label: Text('Exercise Load')),
      DataColumn(label: Text('Exercise/Sports/Work'))
    ];
  }
  List<DataRow> _createRows() {
    return [
      DataRow(cells: [
        DataCell(Text('Sedentary')),
        DataCell(Text('None/Little')),
        DataCell(Text('None'))
      ]),
      DataRow(cells: [
        DataCell(Text('Lightly Active')),
        DataCell(Text('Light')),
        DataCell(Text('1-3 days a week'))
      ]),
      DataRow(cells: [
        DataCell(Text('Moderately Active')),
        DataCell(Text('Moderate')),
        DataCell(Text('3-5 days a week'))
      ]),
      DataRow(cells: [
        DataCell(Text('Very Active')),
        DataCell(Text('Hard')),
        DataCell(Text('6-7 days a week'))
      ]),
      DataRow(cells: [
        DataCell(Text('Extremely Active')),
        DataCell(Text('Very Hard')),
        DataCell(Text('Physical Labor'))
      ])

    ];
  }


}