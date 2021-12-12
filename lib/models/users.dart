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
  set setName (String name){
    symptom_name = name;
  }
  set setIntensity_lvl (int level){
    intesity_lvl = level;
  }
  set setFelt (String felt){
    symptom_felt = felt;
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
  set setName (String name){
    medicine_name = name;
  }
  set setDosage (double level){
    medicine_dosage = level;
  }
  set setType (String felt){
    medicine_type = felt;
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
  set setName (String name){
    labResult_name = name;
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
  set setSys_pres (String sys){
    systolic_pressure = sys;
  }
  set setDia_pres (String dia){
    diastolic_pressure = dia;
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
  set setBPM (int bpm){
    this.bpm = bpm;
  }
  set setisResting (bool isresting){
    isResting = isresting;
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
  set setUnit (String unit){
    this.unit = unit;
  }
  set setTemperature (double temperature){
    this.temperature = temperature;
  }
  set setDate (DateTime date){
    bt_date = date;
  }
}

class Oxygen_Saturation {
  double oxygen_saturation;
  DateTime os_date;

  Oxygen_Saturation({this.oxygen_saturation, this.os_date});

  double get getOxygenSaturation{
    return oxygen_saturation;
  }
  DateTime get getDate{
    return os_date;
  }
  set setTemperature (double oxygen_saturation){
    this.oxygen_saturation = oxygen_saturation;
  }
  set setDate (DateTime date){
    os_date = date;
  }

}