

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_app/services/auth.dart';

import '../../models/users.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class edit_other_information extends StatefulWidget {
  final List<Symptom> thislist;
  edit_other_information({this.thislist});
  @override
  _addSymptomsState createState() => _addSymptomsState();
}
final _formKey = GlobalKey<FormState>();
class _addSymptomsState extends State<edit_other_information> {
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String error = '';

  String initValue="Select your Birth Date";
  bool isDateSelected= false;
  DateTime birthDate; // instance of DateTime
  String birthDateInString = "MM/DD/YYYY";
  String weight = "";
  String height = "";
  String genderIn="male";
  final FirebaseAuth auth = FirebaseAuth.instance;
  var dateValue = TextEditingController();

  bool isSwitched = false;
  bool isSwitchedLifestyle = false;
  bool isSwitchedSmoker = false;
  bool isSwitchedDrinker = false;

  String goal = '';
  DateTime prescriptionDate;
  var startDate = TextEditingController();
  String startdate = "";
  List <bool> isSelected = [true, false];
  String unitstatus = '';
  String unitStatus = "kg";
  String valueLifestyle;

  List<String> listLifestyle = <String>[
    'Sedentary',
    'Light Active',
    'Moderately Active',
    'Very Active',
    'Extremely Active'
  ];

  String valueAlcohol;

  List<String> listAlcohol = <String>[
    'Never',
    'Rarely',
    'Sometimes',
    'Often',
    'Always'
  ];


  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

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
                'Edit Other Information',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Divider(),
              SizedBox(height: 8),



              DropdownButton(
                dropdownColor: Colors.white,
                hint: Text("My Lifestyle: "),
                icon: Icon(Icons.arrow_drop_down),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                ),
                iconSize: 36,
                isExpanded: true,
                underline: SizedBox(),
                value: valueLifestyle,
                onChanged: (newValue){
                  setState(() {
                    valueLifestyle = newValue;

                  });

                },

                items: listLifestyle.map((valueItem){
                  return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem)
                  );
                },
                ).toList(),

              ),

              SwitchListTile(
                title: Text('Show Lifestyles'),
                subtitle: Text('What Lifestyles?'),
                secondary: Icon(Icons.accessibility_new_outlined, size: 34.0, color: Colors.green),
                controlAffinity: ListTileControlAffinity.trailing,
                value: isSwitchedLifestyle,
                onChanged: (value){
                  setState(() {
                    isSwitchedLifestyle = value;

                  });
                },
              ),
              Visibility(
                visible: isSwitchedLifestyle,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _createDataTable(),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 8,
              ),
              SwitchListTile(
                title: Text('Smoking'),
                subtitle: Text('I am a smoker'),
                secondary: Icon(Icons.smoking_rooms, size: 34.0, color: Colors.red),
                controlAffinity: ListTileControlAffinity.trailing,
                value: isSwitchedSmoker,
                onChanged: (value){
                  setState(() {
                    isSwitchedSmoker = value;

                  });
                },
              ),
              Visibility(
                visible: isSwitchedSmoker,
                child: TextFormField(
                  showCursor: true,
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
                    hintText: "Average sticks per day?",
                    prefixIcon: Icon(
                      Icons.smoking_rooms,
                      color: Color(0xFF666666),
                      size: 22,
                    ),
                  ),
                  validator: (val) => val.isEmpty ? 'Number of sticks' : null,
                  onChanged: (val){
                    setState(() => goal = val);

                  },
                ),
              ),
              DropdownButton(
                dropdownColor: Colors.white,
                hint: Text("When do I drink Alcohol? "),
                icon: Icon(Icons.arrow_drop_down),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                ),
                iconSize: 36,
                isExpanded: true,
                underline: SizedBox(),
                value: valueAlcohol,
                onChanged: (newValue){
                  setState(() {
                    valueAlcohol = newValue;

                  });

                },

                items: listAlcohol.map((valueItem){
                  return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem)
                  );
                },
                ).toList(),

              ),


              SizedBox(
                height: 8,
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
                      Navigator.pop(context, widget.thislist);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed:() {
                      try{
                        final User user = auth.currentUser;
                        final uid = user.uid;
                        final personalInfoRef = databaseReference.child('users/' + uid + '/vitals/additional_info/');
                        // personalInfoRef.update({"lifestyle": valueLifestyle,
                        //   "average_stick": goal,
                        //   "alcohol_freq": valueAlcohol});
                        if(valueLifestyle != null)
                          personalInfoRef.update({"lifestyle": valueLifestyle});
                        if(valueLifestyle != null)
                          personalInfoRef.update({"average_stick": goal});
                        if(valueLifestyle != null)
                          personalInfoRef.update({"alcohol_freq": valueAlcohol});
                        print("Edited Medical History Successfully! " + uid);
                        otherChanged newO = new otherChanged(valueLifestyle.toString(), goal.toString(), valueAlcohol.toString());
                        print("INFOS");
                        print(newO.valueLifestyle + " " + newO.goal + ' ' + newO.valueAlc);
                        Navigator.pop(context, newO);
                      } catch(e) {
                        print("you got an error! $e");
                      }
                    },

                  )
                ],
              ),


            ]

        ),


      ),



    );




  }






  String getText (String date){
    var dateTime = DateTime.parse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r$hours:$min";
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
