import 'package:my_app/discussion_board/specific_post_patient_view.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/models/nutritionixApi.dart';


import 'package:flutter/material.dart';

import '../../fitness_app_theme.dart';

class discussion_patient_view extends StatefulWidget {
  @override
  _discussionPatientViewState createState() => _discussionPatientViewState();
}

final _formKey = GlobalKey<FormState>();
List<Common> result = [];
List<double> calories = [];
class _discussionPatientViewState extends State<discussion_patient_view>
    with TickerProviderStateMixin {

  String search="";
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();

  final AuthService _auth = AuthService();

  double topBarOpacity = 0.0;
  @override
  void initState() {
    super.initState();
  }


  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(milliseconds: 5000), () {
    //   setState(() {
    //     print("FULL SET STATE");
    //   });
    // });
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: const Text('Discussion', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,


        ),
        body:  Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 28, 24, 28),
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
                              child: Text( "Posts",
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
                  ],
                ),
                SizedBox(height: 10.0),
                SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 14),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => specific_post_patient_view()
                                      )
                                  );
                                },
                                child: Container(
                                  height: 180,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [BoxShadow(
                                          color: Colors.black26.withOpacity(0.05),
                                          offset: Offset(0.0,6.0),
                                          blurRadius: 10.0,
                                          spreadRadius: 0.10
                                      )]
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          height: 70,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    backgroundImage: AssetImage('assets/images/heart_icon.png'),
                                                    radius: 22,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                          width: MediaQuery.of(context).size.width * 0.65,
                                                          child: Text(
                                                            "Painful Heart. What to do?",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 2.0),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              'Dr.' + "Johnny Sins",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            SizedBox(width: 15),
                                                            Text(
                                                              "12/29/2021 11:09",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 300,

                                          child: Text(
                                            'wwewewewewewewewewewewewewew',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.reply,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 4.0),
                                                Text(
                                                  "4 replies",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),

    );
  }

}
