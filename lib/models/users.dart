import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

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
  DateTime symptom_time;
  bool isActive;

  Symptom({this.symptom_name, this.intesity_lvl, this.symptom_felt, this.symptom_date, this.symptom_time, this.isActive});

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
  DateTime get getTime{
    return symptom_time;
  }
  bool get getisActive{
    return isActive;
  }

  void setName (String temp){
    symptom_name = temp;
  }
  void setIntensity_lvl (int integer){
    intesity_lvl = integer;
  }
  void setFelt (String temp){
    symptom_felt = temp;
  }
  void setDate (DateTime date){
    symptom_date = date;
  }
  void setTime (DateTime date){
    symptom_date = date;
  }
  void setisActive (bool status) {
   isActive = status;
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
  void setName (String temp){
    medicine_name = temp;
  }
  void setDosage (double number){
    medicine_dosage = number;
  }
  void setType (String temp){
    medicine_type = temp;
  }
  void setDate (DateTime date){
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
  void setName (String temp){
    labResult_name = temp;
  }
  void setDate (DateTime date){
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
  void setSys_pres (String temp){
    systolic_pressure = temp;
  }
  void setDia_pres (String temp){
    diastolic_pressure = temp;
  }
  void setDate (DateTime date){
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
  void setBPM (int integer){
    bpm = integer;
  }
  void setisResting (bool status){
    isResting = status;
  }
  void setDate (DateTime date){
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
  void setUnit (String temp){
    unit = temp;
  }
  void setTemperature (double number){
    temperature = number;
  }
  void setDate (DateTime date){
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
  void setTemperature (int oxygen_saturation){
    this.oxygen_saturation = oxygen_saturation;
  }
  void setDate (DateTime date){
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
  void setTotalCholesterol (double number){
    total_cholesterol = number;
  }
  void setldlCholesterol (double number){
    ldl_cholesterol = number;
  }
  void sethdlCholesterol (double number){
    hdl_cholesterol = number;
  }
  void setTriglycerides (double number){
    triglycerides = number;
  }
  void setDate (DateTime date){
    cholesterol_date = date;
  }
}

class Blood_Glucose {
  double glucose = 0;
  String status = "";
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
  void setGlucose (double number){
    glucose = number;
  }
  void setStatus (String temp){
    status = temp;
  }
  void setDate (DateTime date){
    bloodGlucose_date = date;
  }

}