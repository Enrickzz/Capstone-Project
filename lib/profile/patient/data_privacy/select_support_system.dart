
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class select_support_system extends StatefulWidget {
  final List<dynamic> d_names;
  final List<String> d_uid;
  select_support_system({this.d_names, this.d_uid, this.instance});
  final String instance;
  @override
  _selectSupportSystemState createState() => _selectSupportSystemState();
}
final _formKey = GlobalKey<FormState>();

class _selectSupportSystemState extends State<select_support_system> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  int index = 0;
  List<String> d_uid;
  List<dynamic> d_names;

  var dateValue = TextEditingController();
  String valueChooseMedicineSupplement;
  List<String> listMedicineSupplement =[];

  @override
  void initState() {
    super.initState();
    d_names = widget.d_names;
    d_uid = widget.d_uid;
    Future.delayed(const Duration(milliseconds: 1000), (){
      for(int i = 0; i < d_names.length; i++){
        listMedicineSupplement.add(d_names[i].toString());
      }
      print("list medicine supplement length " + listMedicineSupplement.length.toString());
      setState(() {
        print("setstate");
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;
    print(listMedicineSupplement);
    return Container(
        key: _formKey,
        color:Color(0xff757575),
        child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft:Radius.circular(20),
                topRight:Radius.circular(20),
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Select Emergency Contact',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width:0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Support System: ",
                    ),
                    isExpanded: true,
                    value: valueChooseMedicineSupplement,
                    onChanged: (newValue){
                      setState(() {
                        valueChooseMedicineSupplement = newValue;
                      });
                    },
                    items: listMedicineSupplement.map((valueItem){
                      return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem)
                      );
                    },
                    ).toList(),
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() async {
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final readLeadDoc = databaseReference.child('users/' + uid + '/personal_info/');
                            for(int i = 0; i < d_names.length; i++){
                              if(d_names[i] == valueChooseMedicineSupplement){
                                index = i;
                              }
                            }
                            readLeadDoc.once().then((DataSnapshot datasnapshot) {
                              final leaddocRef = databaseReference.child('users/' + uid + '/personal_info/');
                              leaddocRef.update({"emergency_contact": d_uid[index]});
                              print("Updated Emergency Contact! " + d_uid[index]);
                            });
                          } catch(e) {
                            print("you got an error! $e");
                          }
                          Navigator.pop(context, d_uid[index]);
                        },
                      )
                    ],
                  ),

                ]
            )
        )

    );
  }
}

