import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class set_up extends StatefulWidget {
  @override
  _set_upState createState() => _set_upState();
}


class _set_upState extends State<set_up> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];
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

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {


    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SingleChildScrollView(
    //     padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
    //     child: Column(
    //       children: [
    //         SizedBox(height: 40.0),
    //         Container(
    //           margin: EdgeInsets.only(top: 70.0),
    //           alignment: Alignment.topLeft,
    //           child:  Text( "Create Account,", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    //           ),
    //         ),
    //         Container(
    //
    //           alignment: Alignment.topLeft,
    //           child:  Text( "Sign up to get started!", style: TextStyle( color: Colors.grey, ),
    //           ),
    //         ),
    //         Container(
    //
    //             child: Column(
    //               children: [
    //                 SizedBox(height: 15.0),
    //                 Form(
    //                     key: _formKey,
    //                     child: Column(
    //                       children: [
    //                         Container(
    //                           child: TextFormField(
    //                             showCursor: true,
    //                             decoration: InputDecoration(
    //                               border: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //                                 borderSide: BorderSide(
    //                                   width:0,
    //                                   style: BorderStyle.none,
    //                                 ),
    //                               ),
    //                               filled: true,
    //                               fillColor: Color(0xFFF2F3F5),
    //                               hintStyle: TextStyle(
    //                                   color: Color(0xFF666666),
    //                                   fontFamily: defaultFontFamily,
    //                                   fontSize: defaultFontSize),
    //                               hintText: "First Name",
    //                             ),
    //                             validator: (val) => val.isEmpty ? 'Enter First Name' : null,
    //                             onChanged: (val){
    //                               setState(() => firstname = val);
    //                             },
    //                           ),
    //                         ),
    //                         SizedBox(height: 8.0),
    //                         Container(
    //                           child: TextFormField(
    //                             showCursor: true,
    //                             decoration: InputDecoration(
    //                               border: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //                                 borderSide: BorderSide(
    //                                   width:0,
    //                                   style: BorderStyle.none,
    //                                 ),
    //                               ),
    //                               filled: true,
    //                               fillColor: Color(0xFFF2F3F5),
    //                               hintStyle: TextStyle(
    //                                   color: Color(0xFF666666),
    //                                   fontFamily: defaultFontFamily,
    //                                   fontSize: defaultFontSize),
    //                               hintText: "Last Name",
    //                             ),
    //                             validator: (val) => val.isEmpty ? 'Enter Last Name' : null,
    //                             onChanged: (val){
    //                               setState(() => lastname = val);
    //                             },
    //                           ),
    //                         ),
    //                         SizedBox(height: 8.0),
    //                         Container(
    //                           child: TextFormField(
    //                             showCursor: true,
    //                             decoration: InputDecoration(
    //                               border: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //                                 borderSide: BorderSide(
    //                                   width:0,
    //                                   style: BorderStyle.none,
    //                                 ),
    //                               ),
    //                               filled: true,
    //                               prefixIcon: Icon(
    //                                 Icons.mail,
    //                                 color: Color(0xFF666666),
    //                                 size: defaultIconSize,
    //                               ),
    //                               fillColor: Color(0xFFF2F3F5),
    //                               hintStyle: TextStyle(
    //                                   color: Color(0xFF666666),
    //                                   fontFamily: defaultFontFamily,
    //                                   fontSize: defaultFontSize),
    //                               hintText: "Email Address",
    //                             ),
    //                             validator: (val) => val.isEmpty ? 'Enter Email Address' : null,
    //                             onChanged: (val){
    //                               setState(() => email = val);
    //                             },
    //                           ),
    //                         ),
    //                         SizedBox(height: 8.0),
    //                         Container(
    //                           child: TextFormField(
    //                             obscureText: true,
    //                             showCursor: true,
    //                             decoration: InputDecoration(
    //                               border: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //                                 borderSide: BorderSide(
    //                                   width: 0,
    //                                   style: BorderStyle.none,
    //                                 ),
    //                               ),
    //                               filled: true,
    //                               prefixIcon: Icon(
    //                                 Icons.lock,
    //                                 color: Color(0xFF666666),
    //                                 size: defaultIconSize,
    //                               ),
    //                               suffixIcon: Icon(
    //                                 Icons.remove_red_eye,
    //                                 color: Color(0xFF666666),
    //                                 size: defaultIconSize,
    //                               ),
    //                               fillColor: Color(0xFFF2F3F5),
    //                               hintStyle: TextStyle(
    //                                 color: Color(0xFF666666),
    //                                 fontFamily: defaultFontFamily,
    //                                 fontSize: defaultFontSize,
    //                               ),
    //                               hintText: "Password",
    //                             ),
    //                             validator: (val) => val.length < 6 ? 'Minimum password length should be 6 characters' : null,
    //                             onChanged: (val){
    //                               setState(() => password = val);
    //                             },
    //                           ),
    //                         ),
    //                         SizedBox(height: 8.0),
    //                         Container(
    //                           child: TextFormField(
    //                             obscureText: true,
    //                             showCursor: true,
    //                             decoration: InputDecoration(
    //                               border: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //                                 borderSide: BorderSide(
    //                                   width: 0,
    //                                   style: BorderStyle.none,
    //                                 ),
    //                               ),
    //                               filled: true,
    //                               prefixIcon: Icon(
    //                                 Icons.lock,
    //                                 color: Color(0xFF666666),
    //                                 size: defaultIconSize,
    //                               ),
    //                               suffixIcon: Icon(
    //                                 Icons.remove_red_eye,
    //                                 color: Color(0xFF666666),
    //                                 size: defaultIconSize,
    //                               ),
    //                               fillColor: Color(0xFFF2F3F5),
    //                               hintStyle: TextStyle(
    //                                 color: Color(0xFF666666),
    //                                 fontFamily: defaultFontFamily,
    //                                 fontSize: defaultFontSize,
    //                               ),
    //                               hintText: "Confirm Password",
    //                             ),
    //                             validator: (val) {
    //                               if(val.isEmpty)
    //                                 return 'Enter Confirm Password';
    //                               if(val != password)
    //                                 return 'Passwords Do Not Match';
    //                               return null;
    //                             },
    //                             onChanged: (val){
    //                             },
    //                           ),
    //                         ),
    //                         SizedBox(height: 18.0),
    //                         Container(
    //                           child: ElevatedButton(
    //                             child: Padding(
    //                               padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
    //                               child: Text('Sign Up', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    //                               ),
    //                             ),
    //                             onPressed: () async{
    //                               if(_formKey.currentState.validate()){
    //                                 dynamic result = await _auth.registerUser(lastname, firstname, email,password);
    //                                 if(result == null){
    //                                   setState(() => error = 'Sign Up Failed');
    //                                 }else{
    //                                   setState(() => error = '');
    //                                 }
    //                               }
    //                               try{
    //                                 final User user = auth.currentUser;
    //                                 final uid = user.uid;
    //                                 final usersRef = databaseReference.child('users/' + uid + '/personal_info');
    //
    //                                 print("user registered Sucessfully!");
    //
    //                               } catch(e) {
    //                                 print("you got an error! $e");
    //                               }
    //
    //                             },
    //                           ),
    //                         ),
    //                         SizedBox(height: 12.0),
    //                         Text(
    //                           error,
    //                           style: TextStyle(color: Colors.red),
    //                         ),
    //                         SizedBox(
    //                           height: 8,
    //                         ),
    //                       ],
    //                     )
    //                 ),
    //               ],
    //             )
    //         ),
    //         Container(
    //           margin: EdgeInsets.fromLTRB(10,20,10,20),
    //           child: Text.rich(
    //               TextSpan(
    //                   children: [
    //                     TextSpan(text: "Already have an account? "),
    //                     TextSpan(
    //                       text: 'Sign In',
    //                       recognizer: TapGestureRecognizer()
    //                         ..onTap = (){
    //                           Navigator.pop(context);
    //                         },
    //                       style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
    //                     ),
    //                   ]
    //               )
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    List<Step> getSteps() => [
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: Text(''),
        content: Container(
          child: Form(
            key: formKeys[0],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300,
                  height: 90,
                  alignment: Alignment.center,
                  child: Text("Additional Information",
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: defaultFontFamily,
                        fontSize: 30,
                        fontStyle: FontStyle.normal,
                      )),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: ()async{
                    final datePick= await showDatePicker(
                        context: context,
                        initialDate: new DateTime.now(),
                        firstDate: new DateTime(1900),
                        lastDate: new DateTime(2100)
                    );
                    if(datePick!=null && datePick!=birthDate){
                      setState(() {
                        birthDate=datePick;
                        isDateSelected=true;

                        // put it here
                        birthDateInString = "${birthDate.month}/${birthDate.day}/${birthDate.year}";
                        dateValue.text = birthDateInString;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dateValue,
                      showCursor: false,
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
                        hintText: "Birthday",
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Color(0xFF666666),
                          size: defaultIconSize,
                        ),
                      ),
                      validator: (val) => val.isEmpty ? 'Select Birthday' : null,
                      onChanged: (val){

                        print(dateValue);
                        setState((){
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  showCursor: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.accessibility_rounded,
                      color: Color(0xFF666666),
                      size: defaultIconSize,
                    ),
                    fillColor: Color(0xFFF2F3F5),
                    hintStyle: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: defaultFontFamily,
                        fontSize: defaultFontSize),
                    hintText: "Weight in KG",
                  ),
                  validator: (val) => val.isEmpty ? 'Enter Weight in KG' : null,
                  onChanged: (val){
                    setState(() => weight = val);
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly],
                  // validator: (val) => val.isEmpty ? 'Enter Email' : null,
                  // onChanged: (val){
                  //   setState(() => genderIn = val);
                  // },
                ),SizedBox(
                  height: 8,
                ),
                TextFormField(
                  showCursor: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.accessibility_rounded,
                      color: Color(0xFF666666),
                      size: defaultIconSize,
                    ),
                    fillColor: Color(0xFFF2F3F5),
                    hintStyle: TextStyle(
                        color: Color(0xFF666666),
                        fontFamily: defaultFontFamily,
                        fontSize: defaultFontSize),
                    hintText: "Height in cm",
                  ),
                  validator: (val) => val.isEmpty ? 'Enter Height in cm' : null,
                  onChanged: (val){
                    setState(() => height = val);
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly],
                  // validator: (val) => val.isEmpty ? 'Enter Email' : null,
                  // onChanged: (val){
                  //   setState(() => genderIn = val);
                  // },
                ),SizedBox(
                  height: 8,
                ),
                GenderPickerWithImage(
                  showOtherGender: true,
                  verticalAlignedText: true,
                  selectedGender: Gender.Male,
                  selectedGenderTextStyle: TextStyle(
                      color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
                  unSelectedGenderTextStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.normal),
                  onChanged: (Gender gender) {
                    print(gender);
                    List<String> strArr = gender.toString().split(".");
                    genderIn = strArr[1];
                  },
                  equallyAligned: true,
                  animationDuration: Duration(milliseconds: 300),
                  isCircular: true,
                  // default : true,
                  opacityOfGradient: 0.4,
                  padding: const EdgeInsets.all(3),
                  size: 50, //default : 40
                ),
              ],
            ),
          ),
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: Text(''),
        content: Container(),
      ),
      Step(
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 2,
        title: Text(''),
        content: Container(),
      ),
      Step(
        state: currentStep > 3 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 3,
        title: Text(''),
        content: Container(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Set Up Your Account'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        steps: getSteps(),
        currentStep: currentStep,
        onStepContinue: () {
          final isLastStep = currentStep == getSteps().length - 1;
          print(currentStep);

          if (isLastStep) {
            print("Completed");

            try{
              final User user = auth.currentUser;
              final uid = user.uid;
              final usersRef = databaseReference.child('users/' + uid + '/vitals/additional_info');
              final loginRef = databaseReference.child('users/' + uid + '/personal_info');
              usersRef.set({"birthday": birthDateInString.toString(), "gender": genderIn.toString(), "weight": weight.toString(), "height":height.toString(),"BMI": "0"});
              print("Additional information collected!");
              loginRef.update({"isFirstTime": "false"});

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => mainScreen()),
              );
            } catch(e) {
              print("you got an error! $e");
            }
              print("birthday: " + birthDateInString.toString() + "gender: " + genderIn.toString() + "weight " + weight.toString() + "height " + height.toString() + "BMI 0");

            // send data to DB

          } else {
            if (formKeys[0].currentState.validate() && currentStep == 0)
            setState(() => currentStep += 1);

          }
        },
        onStepTapped: (step) {
          setState(() {
            currentStep = step;
          });
          // if (formKeys[0].currentState.validate() && currentStep == 0) {
          //   setState(() {
          //     currentStep = step;
          //   });
          // } else if (currentStep == 1) {
          //   setState(() {
          //     currentStep = step;
          //   });
          // } else if (currentStep == 2) {
          //   setState(() {
          //     currentStep = step;
          //   });
          // } else if (currentStep == 3) {
          //   setState(() {
          //     currentStep = step;
          //   });
          // }
        },
        onStepCancel:
            currentStep == 0 ? null : () => setState(() => currentStep -= 1),


        // controlsBuilder: (context, {onStepContinue, onStepCancel}) {
        //   final isLastStep = currentStep == getSteps().length - 1;
        //   print(currentStep);
        //
        //   return Container(
        //     margin: EdgeInsets.only(top: 30),
        //       child: Row(
        //         children: [
        //           if (currentStep != 0)
        //           Expanded(
        //             child: ElevatedButton(
        //               onPressed: onStepCancel,
        //               child: const Text('BACK'),
        //             ),
        //           ),
        //           const SizedBox(width: 12),
        //           Expanded(
        //             child: ElevatedButton(
        //               onPressed: onStepContinue,
        //               child: Text(isLastStep ? 'CONFIRM' : 'NEXT'),
        //             ),
        //           ),
        //         ],
        //       ),
        //   );
        // },

      ),
    );
  }
}
