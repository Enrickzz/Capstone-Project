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
  bool symptom_isActive;

  Symptom({this.symptom_name, this.intesity_lvl, this.symptom_felt, this.symptom_date, this.symptom_time, this.symptom_isActive});

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
    return symptom_isActive;
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
    symptom_isActive = status;
  }



}

class Medication {
  String medicine_name;
  double medicine_dosage;
  String medicine_type;
  DateTime medicine_date;
  DateTime medicine_time;
  bool medicine_isActive;



  Medication({this.medicine_name, this.medicine_type, this.medicine_dosage, this.medicine_date, this.medicine_time});
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
  DateTime get getTime{
    return medicine_time;
  }
  bool get getisActive{
    return medicine_isActive;
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
  void setTime (DateTime date){
    medicine_date = date;
  }
  void setisActive (bool status) {
    medicine_isActive = status;
  }
}

class Medication_Prescription{
  String generic_name;
  String branded_name;
  DateTime startdate;
  DateTime enddate;
  String intake_time;
  String special_instruction;

  Medication_Prescription({this.generic_name, this.branded_name, this.startdate, this.enddate, this.intake_time, this.special_instruction});

  String get getGName{
    return generic_name;
  }
  String get GetBName{
    return branded_name;
  }
  String get GetIntake_time{
    return intake_time;
  }
  String get getSpecial_instruction{
    return special_instruction;
  }
  DateTime get getSDate{
    return startdate;
  }
  DateTime get getEDate{
    return enddate;
  }
  void setGName (String temp){
    generic_name = temp;
  }
  void setBName (String temp){
    branded_name = temp;
  }
  void setIntake_time (String temp){
    intake_time = temp;
  }
  void setSpecial_instruction (String temp){
    special_instruction = temp;
  }

}

class Lab_Result {
  String labResult_name;
  String labResult_note;
  DateTime labResult_date;
  DateTime labResult_time;

  Lab_Result({this.labResult_name,this.labResult_note, this.labResult_date, this.labResult_time});

  String get getName{
    return labResult_name;
  }
  String get getNote{
    return labResult_note;
  }
  DateTime get getDate{
    return labResult_date;
  }
  DateTime get getTime{
    return labResult_time;
  }
  void setName (String temp){
    labResult_name = temp;
  }
  void setNote (String temp){
    labResult_note = temp;
  }
  void setDate (DateTime date){
    labResult_date = date;
  }
  void setTime (DateTime date){
    labResult_time = date;
  }
}

class Blood_Pressure {
  String systolic_pressure;
  String diastolic_pressure;
  String pressure_level;
  DateTime bp_date;
  DateTime bp_time;

  Blood_Pressure ({this.systolic_pressure, this.diastolic_pressure,this.pressure_level, this.bp_date, this.bp_time});

  String get getSys_pres{
    return systolic_pressure;
  }
  String get getDia_pres{
    return diastolic_pressure;
  }
  String get getLvl_pres{
    return pressure_level;
  }
  DateTime get getDate{
    return bp_date;
  }
  DateTime get getTime{
    return bp_time;
  }
  void setSys_pres (String temp){
    systolic_pressure = temp;
  }
  void setDia_pres (String temp){
    diastolic_pressure = temp;
  }
  void setLvl_pres (String temp){
    pressure_level = temp;
  }
  void setDate (DateTime date){
    bp_date = date;
  }
  void setTime (DateTime date){
    bp_time = date;
  }

}

class Heart_Rate {
  int bpm;
  String hr_status;
  DateTime hr_date;
  DateTime hr_time;

  Heart_Rate({this.bpm, this.hr_status,this.hr_date, this.hr_time});

  int get getBPM{
    return bpm;
  }
  String get getisResting{
    return hr_status;
  }
  DateTime get getDate{
    return hr_date;
  }
  DateTime get getTime{
    return hr_time;
  }
  void setBPM (int integer){
    bpm = integer;
  }
  void setisResting (String status){
    hr_status = status;
  }
  void setDate (DateTime date){
    hr_date = date;
  }
  void setTime (DateTime date){
    hr_time = date;
  }

}

class Body_Temperature {
  String unit;
  double temperature;
  DateTime bt_date;
  DateTime bt_time;

  Body_Temperature({this.unit, this.temperature,this.bt_date, this.bt_time});

  String get getUnit{
    return unit;
  }
  double get getTemperature{
    return temperature;
  }
  DateTime get getDate{
    return bt_date;
  }
  DateTime get getTime{
    return bt_time;
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
  void setTime (DateTime date){
    bt_time = date;
  }

}

class Oxygen_Saturation {
  int oxygen_saturation;
  String oxygen_status;
  DateTime os_date;
  DateTime os_time;

  Oxygen_Saturation({this.oxygen_saturation,this.oxygen_status, this.os_date, this.os_time});

  int get getOxygenSaturation{
    return oxygen_saturation;
  }
  String get getOxygenStatus{
    return oxygen_status;
  }
  DateTime get getDate{
    return os_date;
  }
  DateTime get getTime{
    return os_time;
  }
  void setTemperature (int temp){
    this.oxygen_saturation = temp;
  }
  void setOxygenStatus (String temp){
    this.oxygen_status = temp;
  }
  void setDate (DateTime date){
    os_date = date;
  }
  void setTime (DateTime date){
    os_time = date;
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
  String bloodGlucose_unit = "";
  String bloodGlucose_status = "";
  DateTime bloodGlucose_date;
  DateTime bloodGlucose_time;

  Blood_Glucose({this.glucose, this.bloodGlucose_unit, this.bloodGlucose_status, this.bloodGlucose_date, this.bloodGlucose_time});

  double get getGlucose {
    return glucose;
  }
  String get getStatus {
    return bloodGlucose_status;
  }
  String get getUnitStatus {
    return bloodGlucose_unit;
  }
  DateTime get getDate{
    return bloodGlucose_date;
  }
  DateTime get getTime{
    return bloodGlucose_time;
  }
  void setGlucose (double number){
    glucose = number;
  }
  void setStatus (String temp){
    bloodGlucose_unit = temp;
  }
  void setDate (DateTime date){
    bloodGlucose_date = date;
  }
  void setTime (DateTime date){
    bloodGlucose_time = date;
  }

}