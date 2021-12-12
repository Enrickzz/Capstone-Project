import 'package:firebase_database/firebase_database.dart';

class Users{
  final String uid;
  String firstname;
  String lastname;
  String email;
  String password;

  Users({this.uid});
}

class Symptom {
  String symptom_name;
  int intesity_lvl;
  String symptom_felt;
  DateTime symptom_date;

  Symptom({this.symptom_name, this.intesity_lvl, this.symptom_felt, this.symptom_date});

  String get getName{
    return symptom_name;
  }
  int get getIntensity_lvl{
    return intesity_lvl;
  }
  String get getFelt{
    return symptom_felt;
  }
  DateTime get getDate{
    return symptom_date;
  }
  set setName (String temp){
    symptom_name = temp;
  }
  set setIntensity_lvl (int integer){
    intesity_lvl = integer;
  }
  set setFelt (String temp){
    symptom_felt = temp;
  }
  set setDate (DateTime date){
    symptom_date = date;
  }

}

class Medication {
  String medicine_name;
  double medicine_dosage;
  DateTime medicine_date;
  String medicine_type;


  Medication({this.medicine_name, this.medicine_type, this.medicine_dosage, this.medicine_date});
  // Medication(this.medicine_name, this.medicine_type, this.medicine_dosage, this.medicine_date);

  String get getName{
    return medicine_name;
  }
  double get getDosage{
    return medicine_dosage;
  }
  String get getType{
    return medicine_type;
  }
  DateTime get getDate{
    return medicine_date;
  }
  set setName (String temp){
    medicine_name = temp;
  }
  set setDosage (double number){
    medicine_dosage = number;
  }
  set setType (String temp){
    medicine_type = temp;
  }
  set setDate (DateTime date){
    medicine_date = date;
  }
}

class Lab_Result {
  String labResult_name;
  DateTime labResult_date;

  Lab_Result({this.labResult_name, this.labResult_date});

  String get getName{
    return labResult_name;
  }
  DateTime get getDate{
    return labResult_date;
  }
  set setName (String temp){
    labResult_name = temp;
  }
  set setDate (DateTime date){
    labResult_date = date;
  }
}

class Blood_Pressure {
  String systolic_pressure;
  String diastolic_pressure;
  DateTime bp_date;

  Blood_Pressure ({this.systolic_pressure, this.diastolic_pressure, this.bp_date});

  String get getSys_pres{
    return systolic_pressure;
  }
  String get getDia_pres{
    return diastolic_pressure;
  }
  DateTime get getDate{
    return bp_date;
  }
  set setSys_pres (String temp){
    systolic_pressure = temp;
  }
  set setDia_pres (String temp){
    diastolic_pressure = temp;
  }
  set setDate (DateTime date){
    bp_date = date;
  }

}

class Heart_Rate {
  int bpm;
  bool isResting;
  DateTime hr_date;

  Heart_Rate({this.bpm, this.isResting,this.hr_date});

  int get getBPM{
    return bpm;
  }
  bool get getisResting{
    return isResting;
  }
  DateTime get getDate{
    return hr_date;
  }
  set setBPM (int integer){
    bpm = integer;
  }
  set setisResting (bool status){
    isResting = status;
  }
  set setDate (DateTime date){
    hr_date = date;
  }

}

class Body_Temperature {
  String unit;
  double temperature;
  DateTime bt_date;

  Body_Temperature({this.unit, this.temperature,this.bt_date});

  String get getUnit{
    return unit;
  }
  double get getTemperature{
    return temperature;
  }
  DateTime get getDate{
    return bt_date;
  }
  set setUnit (String temp){
    unit = temp;
  }
  set setTemperature (double number){
    temperature = number;
  }
  set setDate (DateTime date){
    bt_date = date;
  }
}

class Oxygen_Saturation {
  int oxygen_saturation;
  DateTime os_date;

  Oxygen_Saturation({this.oxygen_saturation, this.os_date});

  int get getOxygenSaturation{
    return oxygen_saturation;
  }
  DateTime get getDate{
    return os_date;
  }
  set setTemperature (int oxygen_saturation){
    this.oxygen_saturation = oxygen_saturation;
  }
  set setDate (DateTime date){
    os_date = date;
  }

}

class Blood_Cholesterol {
  double total_cholesterol;
  double ldl_cholesterol;
  double hdl_cholesterol;
  double triglycerides;
  DateTime cholesterol_date;

  Blood_Cholesterol({this.total_cholesterol, this.ldl_cholesterol, this.hdl_cholesterol, this.triglycerides, this.cholesterol_date});

  double get getTotalCholesterol {
    return total_cholesterol;
  }
  double get getldlCholesterol {
    return ldl_cholesterol;
  }
  double get gethdlCholesterol {
    return hdl_cholesterol;
  }
  double get getTriglycerides {
    return triglycerides;
  }
  DateTime get getDate{
    return cholesterol_date;
  }
  set setTotalCholesterol (double number){
    total_cholesterol = number;
  }
  set setldlCholesterol (double number){
    ldl_cholesterol = number;
  }
  set sethdlCholesterol (double number){
    hdl_cholesterol = number;
  }
  set setTriglycerides (double number){
    triglycerides = number;
  }
  set setDate (DateTime date){
    cholesterol_date = date;
  }
}

class Blood_Glucose {
  double glucose = 0;
  String status = '';
  DateTime bloodGlucose_date;
  Blood_Glucose({this.glucose, this.status, this.bloodGlucose_date});

  double get getGlucose {
    return glucose;
  }

  String get getStatus {
    return status;
  }

  DateTime get getDate{
    return bloodGlucose_date;
  }
  set setGlucose (double number){
    glucose = number;
  }
  set setStatus (String temp){
    status = temp;
  }
  set setDate (DateTime date){
    bloodGlucose_date = date;
  }

}