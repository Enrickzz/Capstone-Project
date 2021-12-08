import 'dart:convert';
class nutritionixApi {

  String food_name;
  String serving_unit;
  String tag_name;
  int tag_id;
  double serving_qty;

  nutritionixApi({
    this.food_name,
    this.serving_unit,
    this.tag_name,
    this.tag_id,
    this.serving_qty,
});


  factory nutritionixApi.fromJson(Map<String, dynamic> json) => nutritionixApi(
    food_name: json['food_name'] as String,
    serving_unit: json['serving_unit'] as String,
    tag_name: json['tag_name'] as String,
    tag_id: json['tag_id'] as int,
    serving_qty: json['serving_qty'] as double,
  );

  Map<String, dynamic> toJson() => {
    "food_name": food_name,
    "serving_unit": serving_unit,
    "tag_name": tag_name,
    "tag_id": tag_id,
    "serving_qty": serving_qty,
  };

  // final String id;
  // final double calories;
  // Food({required this.id, required this.calories});
  //
  //
  // factory Food.fromJson(Map<String, dynamic> data){
  //   final id = data['id'] as String;
  //   final calories = data['calories'] as double;
  //   return Food(id: id, calories: calories);
  // }
  //
  // Map<String, dynamic> toJson() {
  //   return{
  //     'id' : id,
  //     'calories' : calories,
  //   };
  // }

}