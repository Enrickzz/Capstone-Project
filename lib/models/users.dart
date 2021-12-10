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