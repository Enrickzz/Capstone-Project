import 'dart:convert';
class nutritionixApi {

  List<Food> food;

  nutritionixApi({
    this.food,
});


  factory nutritionixApi.fromJson(Map<String, dynamic> json) => nutritionixApi(
    food: List<Food>.from(json["common"].map((x) => Food.fromJson(x))),
    // food_name: json['food_name'] as String,
    // serving_unit: json['serving_unit'] as String,
    // tag_name: json['tag_name'] as String,
    // tag_id: json['tag_id'] as int,
    // serving_qty: json['serving_qty'] as double,
  );

  // Map<String, dynamic> toJson() => {
  //   "food_name": food_name,
  //   "serving_unit": serving_unit,
  //   "tag_name": tag_name,
  //   "tag_id": tag_id,
  //   "serving_qty": serving_qty,
  // };

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

class Food {
  String food_name;
  String serving_unit;
  String tag_name;
  int serving_qty;
  String tag_id;

  Food({this.food_name, this.serving_unit, this.tag_name, this.serving_qty, this.tag_id});

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    food_name:  json["food_name"] as String,
    serving_unit: json["serving_unit"] as String,
    tag_name: json["tag_name"] as String,
    serving_qty: json["serving_qty"] as int,
    tag_id: json["tag_id"] as String,
  );
  Map<String, dynamic> toJson() => {
    "food_name": food_name,
    "serving_unit": serving_unit,
    "tag_name": tag_name,
    "tag_id": tag_id,
    "serving_qty": serving_qty,
  };
  String get getFName {
    return food_name;
  }
  String get getUnit {
    return serving_unit;
  }
  String get getTName {
    return tag_name;
  }
  int get getQty {
    return serving_qty;
  }
  String get getID {
    return tag_id;
  }



}