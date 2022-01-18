import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/exrxTEST.dart';
DateFormat format = DateFormat("MM/dd/yyyy");
class Users {
  String uid;
  String firstname;
  String lastname;
  String email;
  String password;
  String usertype;
  String specialty;
  bool isMe;
  List<Connection> connections;

  Users({this.uid, this.firstname, this.lastname, this.email, this.password, this.usertype, this.specialty, this.connections, this.isMe});


  Users.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    password = json['password'];
    usertype = json['userType'];
    specialty = json['specialty'];
  }

  Users.fromJson2(Map<String, dynamic> json) {
    uid = json['uid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    password = json['password'];
    usertype = json['userType'];
  }
  Users.fromJson3(Map<String, dynamic> json) {
    uid = json['uid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['password'] = this.password;
    return data;
  }

}
class Connection{

  Connection({
    this.uid,
    this.dashboard,
    this.nonhealth,
    this.health,
    this.medpres,
    this.foodplan,
    this.explan,
    this.vitals,
  });

  String uid;

  /// patient to doctor
  String dashboard;
  String nonhealth;
  String health;

  Connection.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    dashboard = json['dashboard'];
    nonhealth = json['nonhealth'];
    health = json['health'];
  }

  /// doctor to doctor
  String medpres;
  String foodplan;
  String explan;
  String vitals;

  Connection.fromJson2(Map<String, dynamic> json) {
    uid = json['uid'];
    medpres = json['medpres'];
    foodplan = json['foodplan'];
    explan = json['explan'];
    vitals = json['vitals'];
  }
}

class Additional_Info {
  DateTime birthday = new DateTime.now();
  String gender;
  List<String> foodAller;
  List<String> drugAller;
  List<String> otherAller;
  String lifestyle;
  int average_stick;
  String alcohol_freq;
  List<String> disease;
  List<String> other_disease;
  List<String> family_disease;

  Additional_Info({
    this.birthday,
    this.gender,
    this.foodAller,
    this.drugAller,
    this.otherAller,
    this.lifestyle,
    this.average_stick,
    this.alcohol_freq,
    this.disease,
    this.other_disease,
    this.family_disease
  });
  Additional_Info.fromJson(Map<String, dynamic> json) {
    birthday = DateFormat("MM/dd/yyyy").parse(json['birthday']);
    gender = json['gender'];
    foodAller = json['foodAller'].cast<String>();
    drugAller = json['drugAller'].cast<String>();
    otherAller = json['otherAller'].cast<String>();
    lifestyle = json['lifestyle'];
    average_stick = int.parse(json['average_stick']);
    alcohol_freq = json['alcohol_freq'];
    disease = json['disease'].cast<String>();
    other_disease = json['other_disease'].cast<String>();
    family_disease = json['family_disease'].cast<String>();
  }

  Additional_Info.fromJson2(Map<String, dynamic> json) {
    birthday = DateFormat("MM/dd/yyyy").parse(json['birthday']);
    gender = json['gender'];
  }

  Additional_Info.fromJson3(Map<String, dynamic> json) {
    birthday = DateFormat("MM/dd/yyyy").parse(json['birthday']);
    gender = json['gender'];
    disease = json['disease'].cast<String>();
    other_disease = json['other_disease'].cast<String>();
  }
  Additional_Info.fromJson4(Map<String, dynamic> json) {
    gender = json['gender'];
    disease = json['disease'].cast<String>();
  }
  Additional_Info.fromJson5(Map<String, dynamic> json) {
    birthday = DateFormat("MM/dd/yyyy").parse(json['birthday']);
    gender = json['gender'];
    foodAller = json['foodAller'].cast<String>();
    drugAller = json['drugAller'].cast<String>();
    otherAller = json['otherAller'].cast<String>();
    lifestyle = json['lifestyle'];
    average_stick = json['average_stick'];
    alcohol_freq = json['alcohol_freq'];
    disease = json['disease'].cast<String>();
    other_disease = json['other_disease'].cast<String>();
    family_disease = json['family_disease'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    data['foodAller'] = this.foodAller;
    data['drugAller'] = this.drugAller;
    data['otherAller'] = this.otherAller;
    data['lifestyle'] = this.lifestyle;
    data['average_stick'] = this.average_stick;
    data['alcohol_freq'] = this.alcohol_freq;
    data['disease'] = this.disease;
    data['other_disease'] = this.other_disease;
    data['family_disease'] = this.family_disease;
    return data;
  }

}
class Physical_Parameters {
  double height;
  double weight;
  double bmi;
  Physical_Parameters({
    this.height,
    this.weight,
    this.bmi
  });
  Physical_Parameters.fromJson(Map<String, dynamic> json) {
    height = double.parse(json['height']);
    weight = double.parse(json['weight']);
    bmi = double.parse(json['BMI']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['BMI'] = this.bmi;
    return data;
  }


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
  String imgRef;

  Symptom(
      {this.symptomName,
        this.intensityLvl,
        this.symptomFelt,
        this.symptomDate,
        this.symptomTime,
        this.symptomIsActive,
        this.symptomTrigger,
        this.recurring,
        this.imgRef});

  Symptom.fromJson(Map<String, dynamic> json) {
    symptomName = json['symptom_name'];
    intensityLvl = int.parse(json['intensity_lvl']);
    symptomFelt = json['symptom_felt'];
    symptomDate = DateFormat("MM/dd/yyyy").parse(json['symptom_date']);
    symptomTime = DateFormat("hh:mm").parse(json['symptom_time']);
    String a = json['symptom_isActive'];
    if(a == "true"){
      symptomIsActive = true;
    } else symptomIsActive = false;
    symptomTrigger = json['symptom_trigger'];
    if(json['recurring'] != null){
      recurring = json['recurring'].cast<String>();
    }
    imgRef = json['imgRef'];
  }

  Symptom.fromJson2(Map<String, dynamic> json) {
    symptomName = json['symptom_name'];
    intensityLvl = int.parse(json['intensity_lvl']);
    symptomFelt = json['symptom_felt'];
    symptomDate = DateFormat("MM/dd/yyyy").parse(json['symptom_date']);
    symptomTime = DateFormat("hh:mm").parse(json['symptom_time']);
    String a = json['symptom_isActive'];
    if(a == "true"){
      symptomIsActive = true;
    } else symptomIsActive = false;
    symptomTrigger = json['symptom_trigger'];
    imgRef = json['imgRef'];
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
    data['imgRef'] = this.imgRef;
    return data;
  }
}

class Medication {
  String medicine_name;
  double medicine_dosage;
  String medicine_type;
  String medicine_unit;
  DateTime medicine_date;
  DateTime medicine_time;
  bool medicine_isActive;



  Medication({this.medicine_name, this.medicine_type,this.medicine_unit, this.medicine_dosage, this.medicine_date, this.medicine_time});

  Medication.fromJson(Map<String, dynamic> json) {
    medicine_name = json['medicine_name'];
    medicine_type = json['medicine_type'];
    medicine_unit = json['medicine_unit'];
    medicine_dosage = double.parse(json['medicine_dosage']);
    medicine_date = DateFormat("MM/dd/yyyy").parse(json['medicine_date']);
    medicine_time = DateFormat("hh:mm").parse(json['medicine_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medicine_name'] = this.medicine_name;
    data['medicine_type'] = this.medicine_type;
    data['medicine_unit'] = this.medicine_unit;
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
  String prescribedBy;
  DateTime datecreated;

  Medication_Prescription({this.generic_name, this.branded_name,this.dosage, this.startdate, this.enddate, this.intake_time, this.special_instruction, this.prescription_unit, this.prescribedBy, this.datecreated});

  Medication_Prescription.fromJson(Map<String, dynamic> json) {
    generic_name = json['generic_name'];
    branded_name = json['branded_name'];
    dosage = double.parse(json['dosage']);
    startdate = DateFormat("MM/dd/yyyy").parse(json['startDate']);
    enddate = DateFormat("MM/dd/yyyy").parse(json['endDate']);
    intake_time = json['intake_time'];
    special_instruction = json['special_instruction'];
    prescription_unit = json['medical_prescription_unit'];
    prescribedBy = json['prescribedBy'];
    datecreated = format.parse(json['datecreated']);
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
    data['prescribedBy'] = this.prescribedBy;
    data['datecreated'] = this.datecreated;
    return data;
  }

}

class Supplement_Prescription{
  String supplement_name;
  // DateTime startdate;
  // DateTime enddate;
  String intake_time;
  double dosage;
  // String special_instruction;
  String prescription_unit;
  DateTime dateCreated;


  Supplement_Prescription({this.supplement_name, this.intake_time,this.dosage, this.prescription_unit, this.dateCreated});

  Supplement_Prescription.fromJson(Map<String, dynamic> json) {
    supplement_name = json['supplement_name'];
    intake_time = json['intake_time'];
    dosage = double.parse(json['supp_dosage']);
    prescription_unit = json['medical_prescription_unit'];
    dateCreated = DateFormat("MM/dd/yyyy").parse(json['dateCreated']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supplement_name'] = this.supplement_name;
    data['startDate'] = this.intake_time;
    data['supp_dosage'] = this.dosage;
    data['medical_prescription_unit'] = this.prescription_unit;
    data['dateCreated'] = this.dateCreated;
    return data;
  }

}

class Lab_Result {
  String labResult_name;
  String labResult_note;
  DateTime labResult_date;
  DateTime labResult_time;
  String international_normal_ratio=" ";
  String potassium=" ";
  String hemoglobin_hb=" ";
  String Bun_mgDl=" ";
  String creatinine_mgDl=" ";
  String ldl=" ";
  String hdl=" ";
  String imgRef ='';

  Lab_Result({
    this.labResult_name,
    this.labResult_note,
    this.labResult_date,
    this.labResult_time,
    this.international_normal_ratio,
    this.potassium,
    this.hemoglobin_hb,
    this.Bun_mgDl,
    this.creatinine_mgDl,
    this.ldl,
    this.hdl,
    this.imgRef
  });

  Lab_Result.fromJson(Map<String, dynamic> json) {
    labResult_name = json['labResult_name'];
    labResult_note = json['labResult_note'];
    labResult_date = DateFormat("MM/dd/yyyy").parse(json['labResult_date']);
    labResult_time = DateFormat("hh:mm").parse(json['labResult_time']);
    international_normal_ratio = json['international_normal_ratio'];
    potassium = json['potassium'];
    hemoglobin_hb = json['hemoglobin_hb'];
    Bun_mgDl = json['Bun_mgDl'];
    creatinine_mgDl = json['creatinine_mgDl'];
    ldl = json['ldl'];
    hdl = json['hdl'];
    imgRef = json['imgRef'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labResult_name'] = this.labResult_name;
    data['labResult_note'] = this.labResult_note;
    data['labResult_date'] = this.labResult_date;
    data['labResult_time'] = this.labResult_time;
    data['international_normal_ratio'] = this.international_normal_ratio;
    data['potassium'] = this.potassium;
    data['hemoglobin_hb'] = this.hemoglobin_hb;
    data['Bun_mgDl'] = this.Bun_mgDl;
    data['creatinine_mgDl'] = this.creatinine_mgDl;
    data['ldl'] = this.ldl;
    data['hdl'] = this.hdl;
    data['imgRef'] = this.imgRef;
    return data;
  }

}

class Blood_Pressure {
  String systolic_pressure;
  String diastolic_pressure;
  String pressure_level;
  DateTime bp_date;
  DateTime bp_time;
  String bp_status;

  Blood_Pressure ({this.systolic_pressure, this.diastolic_pressure,this.pressure_level, this.bp_date, this.bp_time, this.bp_status});

  Blood_Pressure.fromJson(Map<String, dynamic> json) {
    systolic_pressure = json['systolic_pressure'];
    diastolic_pressure = json['diastolic_pressure'];
    pressure_level = json['pressure_level'];
    bp_date = DateFormat("MM/dd/yyyy").parse(json['bp_date']);
    bp_time = DateFormat("hh:mm").parse(json['bp_time']);
    bp_status = json['bp_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['systolic_pressure'] = this.systolic_pressure;
    data['diastolic_pressure'] = this.diastolic_pressure;
    data['pressure_level'] = this.pressure_level;
    data['bp_date'] = this.bp_date;
    data['bp_time'] = this.bp_time;
    data['bp_status'] = this.bp_status;
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
  String indication;

  Body_Temperature({this.unit, this.temperature,this.bt_date, this.bt_time, this.indication});

  Body_Temperature.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    temperature = double.parse(json['temperature']);
    bt_date = DateFormat("MM/dd/yyyy").parse(json['bt_date']);
    bt_time = DateFormat("hh:mm").parse(json['bt_time']);
    indication = json['indication'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit'] = this.unit;
    data['temperature'] = this.temperature;
    data['bt_date'] = this.bt_date;
    data['bt_time'] = this.bt_time;
    data['indication'] = this.indication;
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
  int lastMeal = 0;
  String bloodGlucose_status = "";
  DateTime bloodGlucose_date;
  DateTime bloodGlucose_time;

  Blood_Glucose({this.glucose, this.lastMeal, this.bloodGlucose_status, this.bloodGlucose_date, this.bloodGlucose_time});

  Blood_Glucose.fromJson(Map<String, dynamic> json) {
    glucose = double.parse(json['glucose']);
    lastMeal = int.parse(json['lastMeal']);
    bloodGlucose_status = json['glucose_status'];
    bloodGlucose_date = DateFormat("MM/dd/yyyy").parse(json['bloodGlucose_date']);
    bloodGlucose_time = DateFormat("hh:mm").parse(json['bloodGlucose_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['glucose'] = this.glucose;
    data['lastMeal'] = this.lastMeal;
    data['glucose_status'] = this.bloodGlucose_status;
    data['bloodGlucose_date'] = this.bloodGlucose_date;
    data['bloodGlucose_time'] = this.bloodGlucose_time;
    return data;
  }

}
class Respiratory_Rate {
  int bpm = 0;
  DateTime bpm_date;
  DateTime bpm_time;

  Respiratory_Rate({this.bpm, this.bpm_date, this.bpm_time});

  Respiratory_Rate.fromJson(Map<String, dynamic> json) {
    bpm = int.parse(json['bpm']);
    bpm_date = DateFormat("MM/dd/yyyy").parse(json['bpm_date']);
    bpm_time = DateFormat("hh:mm").parse(json['bpm_time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bpm'] = this.bpm;
    data['bpm_date'] = this.bpm_date;
    data['bpm_time'] = this.bpm_time;
    return data;
  }
}


class RecomAndNotif {
  String id;
  String message;
  String title;
  String priority;
  String rec_date;
  String rec_time;
  String category;
  String redirect;

  RecomAndNotif({this.id, this.message,this.title,this.priority, this.rec_date, this.rec_time, this.category, this.redirect});

  RecomAndNotif.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    message = json["message"];
    title = json["title"];
    priority = json['priority'];
    rec_date = json['rec_date'];
    rec_time = json['rec_time'];
    category = json["category"];
    redirect = json["redirect"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['title'] = this.title;
    data['priority'] = this.priority;
    data['rec_date'] = this.rec_date;
    data['rec_time'] = this.rec_time;
    data['category'] = this.category;
    data['redirect'] = this.redirect;
    return data;
  }
}

class FoodPlan {
  String purpose;
  String food;
  String important_notes;
  String prescribedBy;
  DateTime dateCreated;

  FoodPlan({this.purpose, this.food,  this.important_notes, this.prescribedBy, this.dateCreated});

  FoodPlan.fromJson(Map<String, dynamic> json) {
    purpose = json["purpose"];
    food = json["food"];
    important_notes = json['important_notes'];
    prescribedBy = json['prescribedBy'];
    dateCreated = DateFormat("MM/dd/yyyy").parse(json['dateCreated']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purpose'] = this.purpose;
    data['food'] = this.food;
    data['important_notes'] = this.important_notes;
    data['prescribedBy'] = this.prescribedBy;
    data['dateCreated'] = this.dateCreated;
    return data;
  }

}
class ExPlan {
  String purpose;
  String type;
  String important_notes;
  String prescribedBy;
  DateTime dateCreated;

  ExPlan({this.purpose, this.type,  this.important_notes, this.prescribedBy, this.dateCreated});

  ExPlan.fromJson(Map<String, dynamic> json) {
    purpose = json["purpose"];
    type = json["type"];

    important_notes = json['important_notes'];
    prescribedBy = json['prescribedBy'];
    dateCreated = DateFormat("MM/dd/yyyy").parse(json['dateCreated']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purpose'] = this.purpose;
    data['type'] = this.type;
    data['important_notes'] = this.important_notes;
    data['prescribedBy'] = this.prescribedBy;
    data['dateCreated'] = this.dateCreated;
    return data;
  }

}
class Vitals {
  String purpose;
  String type;
  int frequency;
  String important_notes;
  String prescribedBy;
  DateTime dateCreated;

  Vitals({this.purpose, this.type, this.frequency, this.important_notes, this.prescribedBy, this.dateCreated});

  Vitals.fromJson(Map<String, dynamic> json) {
    purpose = json["purpose"];
    type = json["type"];
    frequency = json['frequency'];
    important_notes = json['important_notes'];
    prescribedBy = json['prescribedBy'];
    dateCreated = DateFormat("MM/dd/yyyy").parse(json['dateCreated']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purpose'] = this.purpose;
    data['type'] = this.type;
    data['frequency'] = this.frequency;
    data['important_notes'] = this.important_notes;
    data['prescribedBy'] = this.prescribedBy;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}
class Weight_Goal {
  String objective;
  double target_weight;
  double current_weight;
  double weight;
  String weight_unit;
  DateTime dateCreated;

  Weight_Goal({
   this.objective,
    this.target_weight,
    this.current_weight,
    this.weight,
    this.weight_unit,
    this.dateCreated
  });
  Weight_Goal.fromJson(Map<String, dynamic> json) {
    objective = json["objective"];
    target_weight = double.parse(json["target_weight"]);
    current_weight = double.parse(json["current_weight"]);
    weight = double.parse(json["weight"]);
    weight_unit = json['weight_unit'];
    dateCreated = DateFormat("MM/dd/yyyy").parse(json['dateCreated']);
  }
  Weight_Goal.fromJson2(Map<String, dynamic> json) {
    objective = json["objective"];
    target_weight = double.parse(json["target_weight"]);
    current_weight = double.parse(json["current_weight"]);
    weight = double.parse(json["weight"]);
    weight_unit = json['weight_unit'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objective'] = this.objective;
    data['weight_goal'] = this.target_weight;
    data['weight_unit'] = this.weight_unit;
    data['dateCreated'] = this.dateCreated;
    return data;
  }

}
class Weight {
  double weight;
  double bmi;
  DateTime timeCreated;
  DateTime dateCreated;

  Weight({
    this.weight,
    this.bmi,
    this.timeCreated,
    this.dateCreated
  });

  Weight.fromJson(Map<String, dynamic> json) {
    weight = double.parse(json["weight"]);
    bmi = double.parse(json["bmi"]);
    timeCreated = DateFormat("hh:mm").parse(json['timeCreated']);
    dateCreated = DateFormat("MM/dd/yyyy").parse(json['dateCreated']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight'] = this.weight;
    data['bmi'] = this.bmi;
    data['timeCreated'] = this.timeCreated;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}

class Water_Goal {
  double water_goal;
  double current_water;
  String water_unit;
  DateTime dateCreated;

  Water_Goal({
    this.water_goal,
    this.water_unit,
    this.dateCreated
  });
  Water_Goal.fromJson(Map<String, dynamic> json) {
    water_goal = double.parse(json["water_goal"]);
    water_unit = json['water_unit'];
    dateCreated = DateFormat("MM/dd/yyyy").parse(json['dateCreated']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['water_goal'] = this.water_goal;
    data['water_unit'] = this.water_unit;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}

class WaterIntake {
  int water_intake;
  DateTime timeCreated;
  DateTime dateCreated;
  WaterIntake({
  this.water_intake,
  this.timeCreated,
  this.dateCreated,
  });
  WaterIntake.fromJson(Map<String, dynamic> json) {
    water_intake = int.parse(json["water_intake"]);
    timeCreated = DateFormat("hh:mm").parse(json['timeCreated']);
    dateCreated = DateFormat("MM/dd/yyyy").parse(json['dateCreated']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['water_intake'] = this.water_intake;
    data['timeCreated'] = this.timeCreated;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}

class Sleep_Goal {
  DateTime bed_time;
  DateTime wakeup_time;
  int duration;
  DateTime dateCreated;

  Sleep_Goal({
    this.bed_time,
    this.wakeup_time,
    this.duration,
    this.dateCreated
  });

  Sleep_Goal.fromJson(Map<String, dynamic> json) {
    bed_time = json["bed_time"];
    wakeup_time = json['wakeup_time'];
    duration = json['duration'];
    dateCreated = DateFormat("MM/dd/yyyy").parse(json['dateCreated']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bed_time'] = this.bed_time;
    data['wakeup_time'] = this.wakeup_time;
    data['duration'] = this.duration;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}


