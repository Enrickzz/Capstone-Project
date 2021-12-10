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