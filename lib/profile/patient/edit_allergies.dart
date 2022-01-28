import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class edit_allergies extends StatefulWidget {
  @override
  _AllergiesState createState() => _AllergiesState();
}


class _AllergiesState extends State<edit_allergies> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String error = '';

  //added for allergies
  TextEditingController _nameController;
  TextEditingController _nameControllerFoods;
  TextEditingController _nameControllerDrugs;
  TextEditingController _nameControllerOthers;
  static List<String> foodList = [null];
  static List<String> drugList = [null];
  static List<String> otherList = [null];



  String initValue="Select your Birth Date";
  bool isDateSelected= false;
  DateTime birthDate; // instance of DateTime
  String birthDateInString = "MM/DD/YYYY";
  String weight = "";
  String height = "";
  String genderIn="male";
  final FirebaseAuth auth = FirebaseAuth.instance;
  var dateValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white70,
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: InkWell(
                  child: Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Icon(Icons.close),
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              Flexible(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 300,
                      height: 90,
                      alignment: Alignment.center,
                      child: Text("Allergies",
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: defaultFontFamily,
                            fontSize: 30,
                            fontStyle: FontStyle.normal,
                          )),
                    ),

                    SizedBox(height: 20,),
                    Text('Food Allergies', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                    ..._getFoodAllergies(),
                    SizedBox(height: 20,),
                    Text('Drug Allergies', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                    ..._getDrugs(),
                    SizedBox(height: 20,),
                    Text('Other Allergies', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                    ..._getOthers(),
                    SizedBox(height: 40,),
                    FlatButton(
                      onPressed: (){
                        try{
                          if(_formKey.currentState.validate()){
                            _formKey.currentState.save();
                          }
                          final User user = auth.currentUser;
                          final uid = user.uid;
                          final infoRef = databaseReference.child('users/' + uid + '/vitals/additional_info/');
                          if(foodList != null){
                            // for(int i = 0; i < foodList.length; i++){
                            //   foodRef.set({"food_allergy " + i.toString(): foodList[i]});
                            // }
                            infoRef.update({"foodAller": foodList});
                          }
                          if(drugList != null){
                            // for(int i = 0; i < drugList.length; i++){
                            //   drugRef.set({"drug_allergy " + i.toString(): drugList[i]});
                            // }
                            infoRef.update({"drugAller": drugList});
                          }
                          if(otherList != null){
                            // for(int i = 0; i < otherList.length; i++){
                            //   otherRef.set({"other_allergy " + i.toString(): otherList[i]});
                            // }
                            infoRef.update({"otherAller": otherList});
                          }
                          allergyChanged newA = new allergyChanged(foodList, drugList, otherList);
                          Navigator.pop(context, newA);
                        } catch(e) {
                          print("you got an error! $e");
                        }

                      },
                      child: Text('Edit'),
                      color: Colors.green,
                    ),

                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  List<Widget> _getFoodAllergies(){
    List<Widget> foodsTextFields = [];
    for(int i=0; i<foodList.length; i++){
      foodsTextFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(child: FoodTextFields(i)),
                SizedBox(width: 16,),
                // we need add button at last friends row
                _addRemoveButtonFood(i == foodList.length-1, i),
              ],
            ),
          )
      );
    }
    return foodsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButtonFood(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          foodList.insert(0, null);
        }
        else foodList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }

  //drugs after this
  /// get firends text-fields
  List<Widget> _getDrugs(){
    List<Widget> drugsTextFields = [];
    for(int i=0; i<drugList.length; i++){
      drugsTextFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(child: DrugsTextFields(i)),
                SizedBox(width: 16,),
                // we need add button at last friends row
                _addRemoveButtonDrugs(i == drugList.length-1, i),
              ],
            ),
          )
      );
    }
    return drugsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButtonDrugs(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          drugList.insert(0, null);
        }
        else drugList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }

  //Others after this
  /// get others text-fields
  List<Widget> _getOthers(){
    List<Widget> othersTextFields = [];
    for(int i=0; i<otherList.length; i++){
      othersTextFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(child: OtherTextFields(i)),
                SizedBox(width: 16,),
                // we need add button at last friends row
                _addRemoveButtonOther(i == otherList.length-1, i),
              ],
            ),
          )
      );
    }
    return othersTextFields;
  }

  /// add / remove button
  Widget _addRemoveButtonOther(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          otherList.insert(0, null);
        }
        else otherList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }


}

class FoodTextFields extends StatefulWidget {
  final int index;
  FoodTextFields(this.index);
  @override
  _FoodTextFieldsState createState() => _FoodTextFieldsState();
}

class DrugsTextFields extends StatefulWidget {
  final int index;
  DrugsTextFields(this.index);
  @override
  _DrugsTextFieldsState createState() => _DrugsTextFieldsState();
}

class OtherTextFields extends StatefulWidget {
  final int index;
  OtherTextFields(this.index);
  @override
  _OtherTextFieldsState createState() => _OtherTextFieldsState();
}




class _FoodTextFieldsState extends State<FoodTextFields> {
  TextEditingController _nameControllerFoods;

  @override
  void initState() {
    super.initState();
    _nameControllerFoods = TextEditingController();
  }

  @override
  void dispose() {
    _nameControllerFoods.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameControllerFoods.text = _AllergiesState.foodList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerFoods,
      onChanged: (v) => _AllergiesState.foodList[widget.index] = v,
      decoration: InputDecoration(
          hintText: 'Enter your Food Allergies'
      ),
      validator: (f){
        if(f.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }


}

//drugs after this
class _DrugsTextFieldsState extends State<DrugsTextFields> {
  TextEditingController _nameControllerDrugs;

  @override
  void initState() {
    super.initState();
    _nameControllerDrugs = TextEditingController();
  }

  @override
  void dispose() {
    _nameControllerDrugs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameControllerDrugs.text = _AllergiesState.drugList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerDrugs,
      onChanged: (v) => _AllergiesState.drugList[widget.index] = v,
      decoration: InputDecoration(
          hintText: 'Enter your Medicine Allergies'
      ),
      validator: (v){
        if(v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}

//others after this

class _OtherTextFieldsState extends State<OtherTextFields> {
  TextEditingController _nameControllerOthers;

  @override
  void initState() {
    super.initState();
    _nameControllerOthers = TextEditingController();
  }

  @override
  void dispose() {
    _nameControllerOthers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameControllerOthers.text = _AllergiesState.otherList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameControllerOthers,
      onChanged: (v) => _AllergiesState.otherList[widget.index] = v,
      decoration: InputDecoration(
          hintText: 'Enter your Other Allergies'
      ),
      validator: (v){
        if(v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}

