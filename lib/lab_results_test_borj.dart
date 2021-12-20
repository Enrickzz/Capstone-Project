import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  static final List<String> _dropdownItems = <String>['India', 'USA'];
  static List<CountryModel> _dropdownItems = new List();
  final formKey = new GlobalKey<FormState>();

  CountryModel _dropdownValue;
  String _errorText;
  TextEditingController phoneController = new TextEditingController();
  bool _showTextField = false;
  bool _showTextField2 = false;

  String _chosenValue;
  List <String> klasifikasi = [
    'Fatality',
    'Lainnya'];
  String firstname = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _dropdownItems.add(CountryModel(country: 'India', countryCode: '+91'));
      _dropdownItems.add(CountryModel(country: 'USA', countryCode: '+1'));
      _dropdownValue = _dropdownItems[0];
      phoneController.text = _dropdownValue.countryCode;


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Demo'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
              focusColor: Colors.white,
              value: _chosenValue,
              //elevation: 5,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.blue,
              items: klasifikasi.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              hint: Text(
                "Klasifikasi Insiden",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              onChanged: (String value) {
                setState(() {
                  _chosenValue = value;
                  if (_chosenValue == 'Lainnya') {
                    _showTextField = true;
                    _showTextField2 = false;
                  }
                  if (_chosenValue == 'Fatality') {
                    _showTextField2 = true;
                    _showTextField = false;
                  }
                });
              }),
          Visibility(
              visible: _showTextField,
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

                  hintText: "First Name",
                ),
                validator: (val) => val.isEmpty ? 'Enter First Name' : null,
                onChanged: (val){
                  setState(() => firstname = val);
                },
              ),
          ),
          Visibility(
            visible: _showTextField2,
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

                hintText: "Last Name",
              ),
              validator: (val) => val.isEmpty ? 'Enter First Name' : null,
              onChanged: (val){
                setState(() => firstname = val);
              },
            ),
          ),
        ],
      )
    );
  }

  Widget _buildCountry() {
    return FormField(
      builder: (FormFieldState state) {
        return DropdownButtonHideUnderline(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new InputDecorator(
                decoration: InputDecoration(
                  filled: false,
                  hintText: 'Choose Country',
                  prefixIcon: Icon(Icons.location_on),
                  labelText:
                  _dropdownValue == null ? 'Where are you from' : 'From',
                  errorText: _errorText,
                ),
                isEmpty: _dropdownValue == null,
                child: new DropdownButton<CountryModel>(
                  value: _dropdownValue,
                  isDense: true,
                  onChanged: (CountryModel newValue) {
                    print('value change');
                    print(newValue);
                    setState(() {
                      _dropdownValue = newValue;
                      phoneController.text = _dropdownValue.countryCode;
                    });
                  },
                  items: _dropdownItems.map((CountryModel value) {
                    return DropdownMenuItem<CountryModel>(
                      value: value,
                      child: Text(value.country),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhonefiled() {
    return Row(
      children: <Widget>[
        new Expanded(
          child: new TextFormField(
            controller: phoneController,
            enabled: false,
            decoration: InputDecoration(
              filled: false,
              labelText: 'code',
              hintText: "Country code",
            ),
          ),
          flex: 2,
        ),
        new SizedBox(
          width: 10.0,
        ),
        new Expanded(
          child: new TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: false,
              labelText: 'mobile',
              hintText: "Mobile number",
              prefixIcon: new Icon(Icons.mobile_screen_share),
            ),
            onSaved: (String value) {},
          ),
          flex: 5,
        ),
      ],
    );
  }
}

class CountryModel {
  String country = '';
  String countryCode = '';

  CountryModel({
    this.country,
    this.countryCode,
  });
}
