import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class Users {
  final String uid;
  String firstname;
  String lastname;
  String email;
  String password;

  Users({this.uid, this.firstname, this.lastname, this.email, this.password});
}

class Additional_Info {
  DateTime birthday = new DateTime.now();
  String gender;
  double height;
  double weight;
  double bmi;
  List<String> foodAller;
  List<String> drugAller;
  List<String> otherAller;

  Additional_Info({this.bmi,this.birthday, this.gender, this.height, this.weight, this.foodAller, this.drugAller,this.otherAller});
}

class Symptom {
  String symptomName;
  int intensityLvl;
  String symptomFelt;
  DateTime symptomDate;
  DateTime symptomTime;
  bool symptomIsActive;
  String symptomTrigger;
  List<String> recurring;

  Symptom(
      {this.symptomName,
        this.intensityLvl,
        this.symptomFelt,
        this.symptomDate,
        this.symptomTime,
        this.symptomIsActive,
        this.symptomTrigger,
        this.recurring});

  Symptom.fromJson(Map<String, dynamic> json) {
    symptomName = json['symptom_name'];
    intensityLvl = int.parse(json['intensity_lvl']);
    symptomFelt = json['symptom_felt'];
    symptomDate = DateFormat("MM/dd/yyyy").parse(json['symptom_date']);
    symptomTime = DateFormat("hh:mm").parse(json['symptom_time']);
    symptomIsActive = json['symptom_isActive'];
    symptomTrigger = json['symptom_trigger'];
    recurring = json['recurring'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symptom_name'] = this.symptomName;
    data['intensity_lvl'] = this.intensityLvl;
    data['symptom_felt'] = this.symptomFelt;
    data['symptom_date'] = this.symptomDate;
    data['symptom_time'] = this.symptomTime;
    data['symptom_isActive'] = this.symptomIsActive;
    data['symptom_trigger'] = this.symptomTrigger;
    data['recurring'] = this.recurring;
    return data;
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

  Medication.fromJson(Map<String, dynamic> json) {
    medicine_name = json['symptom_name'];
    medicine_type = json['intensity_lvl'];
    medicine_dosage = double.parse(json['symptom_felt']);
    medicine_date = DateFormat("MM/dd/yyyy").parse(json['symptom_date']);
    medicine_time = DateFormat("hh:mm").parse(json['symptom_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicine_name'] = this.medicine_name;
    data['medicine_type'] = this.medicine_type;
    data['medicine_dosage'] = this.medicine_dosage;
    data['medicine_date'] = this.medicine_date;
    data['medicine_time'] = this.medicine_time;
    return data;
  }
}

class Medication_Prescription{
  String generic_name;
  String branded_name;
  double dosage;
  DateTime startdate;
  DateTime enddate;
  String intake_time;
  String special_instruction;
  String prescription_unit;

  Medication_Prescription({this.generic_name, this.branded_name,this.dosage, this.startdate, this.enddate, this.intake_time, this.special_instruction, this.prescription_unit});

  Medication_Prescription.fromJson(Map<String, dynamic> json) {
    generic_name = json['generic_name'];
    branded_name = json['branded_name'];
    dosage = double.parse(json['dosage']);
    startdate = DateFormat("MM/dd/yyyy").parse(json['startDate']);
    enddate = DateFormat("MM/dd/yyyy").parse(json['endDate']);
    intake_time = json['intake_time'];
    special_instruction = json['special_instruction'];
    prescription_unit = json['medical_prescription_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['generic_name'] = this.generic_name;
    data['branded_name'] = this.branded_name;
    data['dosage'] = this.dosage;
    data['endDate'] = this.startdate;
    data['intake_time'] = this.enddate;
    data['startDate'] = this.intake_time;
    data['special_instruction'] = this.special_instruction;
    data['medical_prescription_unit'] = this.prescription_unit;
    return data;
  }

}

class Supplement_Prescription{
  String generic_name;
  String branded_name;
  // DateTime startdate;
  // DateTime enddate;
  String intake_time;
  // String special_instruction;
  String prescription_unit;

  Supplement_Prescription({this.generic_name, this.branded_name, this.intake_time, this.prescription_unit});

  Supplement_Prescription.fromJson(Map<String, dynamic> json) {
    generic_name = json['generic_name'];
    branded_name = json['branded_name'];
    intake_time = json['intake_time'];
    prescription_unit = json['medical_prescription_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['generic_name'] = this.generic_name;
    data['branded_name'] = this.branded_name;
    data['startDate'] = this.intake_time;
    data['medical_prescription_unit'] = this.prescription_unit;
    return data;
  }

}

class Lab_Result {
  String labResult_name;
  String labResult_note;
  DateTime labResult_date;
  DateTime labResult_time;

  Lab_Result({this.labResult_name,this.labResult_note, this.labResult_date, this.labResult_time});

  Lab_Result.fromJson(Map<String, dynamic> json) {
    labResult_name = json['labResult_name'];
    labResult_note = json['labResult_note'];
    labResult_date = DateFormat("MM/dd/yyyy").parse(json['labResult_date']);
    labResult_time = DateFormat("hh:mm").parse(json['labResult_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labResult_name'] = this.labResult_name;
    data['labResult_note'] = this.labResult_note;
    data['labResult_date'] = this.labResult_date;
    data['labResult_time'] = this.labResult_time;
    return data;
  }

}

class Blood_Pressure {
  String systolic_pressure;
  String diastolic_pressure;
  String pressure_level;
  DateTime bp_date;
  DateTime bp_time;

  Blood_Pressure ({this.systolic_pressure, this.diastolic_pressure,this.pressure_level, this.bp_date, this.bp_time});

  Blood_Pressure.fromJson(Map<String, dynamic> json) {
    systolic_pressure = json['systolic_pressure'];
    diastolic_pressure = json['diastolic_pressure'];
    pressure_level = json['pressure_level'];
    bp_date = DateFormat("MM/dd/yyyy").parse(json['bp_date']);
    bp_time = DateFormat("hh:mm").parse(json['bp_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['systolic_pressure'] = this.systolic_pressure;
    data['diastolic_pressure'] = this.diastolic_pressure;
    data['pressure_level'] = this.pressure_level;
    data['bp_date'] = this.bp_date;
    data['bp_time'] = this.bp_time;
    return data;
  }

}

class Heart_Rate {
  int bpm;
  String hr_status;
  DateTime hr_date;
  DateTime hr_time;

  Heart_Rate({this.bpm, this.hr_status,this.hr_date, this.hr_time});

  Heart_Rate.fromJson(Map<String, dynamic> json) {
    bpm = int.parse(json['HR_bpm']);
    hr_status = json['hr_status'];
    hr_date = DateFormat("MM/dd/yyyy").parse(json['hr_date']);
    hr_time = DateFormat("hh:mm").parse(json['hr_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HR_bpm'] = this.bpm;
    data['hr_status'] = this.hr_status;
    data['hr_date'] = this.hr_date;
    data['hr_time'] = this.hr_time;
    return data;
  }

}

class Body_Temperature {
  String unit;
  double temperature;
  DateTime bt_date;
  DateTime bt_time;

  Body_Temperature({this.unit, this.temperature,this.bt_date, this.bt_time});

  Body_Temperature.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    temperature = double.parse(json['temperature']);
    bt_date = DateFormat("MM/dd/yyyy").parse(json['bt_date']);
    bt_time = DateFormat("hh:mm").parse(json['bt_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit'] = this.unit;
    data['temperature'] = this.temperature;
    data['bt_date'] = this.bt_date;
    data['bt_time'] = this.bt_time;
    return data;
  }

}

class Oxygen_Saturation {
  int oxygen_saturation;
  String oxygen_status;
  DateTime os_date;
  DateTime os_time;

  Oxygen_Saturation({this.oxygen_saturation,this.oxygen_status, this.os_date, this.os_time});

  Oxygen_Saturation.fromJson(Map<String, dynamic> json) {
    oxygen_saturation = int.parse(json['oxygen_saturation']);
    oxygen_status = json['oxygen_status'];
    os_date = DateFormat("MM/dd/yyyy").parse(json['os_date']);
    os_time = DateFormat("hh:mm").parse(json['os_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oxygen_saturation'] = this.oxygen_saturation;
    data['oxygen_status'] = this.oxygen_status;
    data['os_date'] = this.os_date;
    data['os_time'] = this.os_time;
    return data;
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

  Blood_Glucose.fromJson(Map<String, dynamic> json) {
    glucose = double.parse(json['glucose']);
    bloodGlucose_unit = json['unit_status'];
    bloodGlucose_status = json['glucose_status'];
    bloodGlucose_date = DateFormat("MM/dd/yyyy").parse(json['bloodGlucose_date']);
    bloodGlucose_time = DateFormat("hh:mm").parse(json['bloodGlucose_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['glucose'] = this.glucose;
    data['unit_status'] = this.bloodGlucose_unit;
    data['glucose_status'] = this.bloodGlucose_status;
    data['bloodGlucose_date'] = this.bloodGlucose_date;
    data['bloodGlucose_time'] = this.bloodGlucose_time;
    return data;
  }

}