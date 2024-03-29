

class nutritionixApi {
  List<Common> common;

  nutritionixApi({this.common});

  nutritionixApi.fromJson(Map<String, dynamic> json) {
    if (json['common'] != null) {
      common = new List<Common>();
      json['common'].forEach((v) {
        common.add(new Common.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.common != null) {
      data['common'] = this.common.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Common {
  String foodName;
  String servingUnit;
  String tagName;
  String servingQty;
  String tagId;
  Photo photo;
  String servingWeightGrams;
  List<FullNutrients> fullNutrients;
  String locale;


  Common(
      {this.foodName,
        this.servingUnit,
        this.tagName,
        this.servingQty,
        this.tagId,
        this.photo,
        this.servingWeightGrams,
        this.fullNutrients,
        this.locale});

  String getGrams(){
    return this.servingWeightGrams;
  }
  double getCalories(){
    bool gotNutrients = false;
    for(int j = 0; j < this.fullNutrients.length; j++){
      if(fullNutrients[j].attrId == 208){ // getting calories
        gotNutrients = true;
        return fullNutrients[j].value;
      }
    }
    if(!gotNutrients){
      return 0;
    }
  }
  double getSugar(){
    bool gotNutrients = false;
    for(int j = 0; j < this.fullNutrients.length; j++){
      if(fullNutrients[j].attrId == 269){ // getting sugar
        gotNutrients = true;
        return fullNutrients[j].value;
      }
    }
    if(!gotNutrients){
      return 0;
    }
  }

  double getCholesterol(){
    bool gotNutrients = false;
    for(int j = 0; j < this.fullNutrients.length; j++){
      if(fullNutrients[j].attrId == 601){ // getting sugar
        gotNutrients = true;
        return fullNutrients[j].value;
      }
    }
    if(!gotNutrients){
      return 0;
    }
  }
  double getTotalFat(){
    bool gotNutrients = false;
    for(int j = 0; j < this.fullNutrients.length; j++){
      if(fullNutrients[j].attrId == 204){ // getting sugar
        gotNutrients = true;
        return fullNutrients[j].value;
      }
    }
    if(!gotNutrients){
      return 0;
    }
  }
  double getProtein(){
    bool gotNutrients = false;
    for(int j = 0; j < this.fullNutrients.length; j++){
      if(fullNutrients[j].attrId == 203){ // getting sugar
        gotNutrients = true;
        return fullNutrients[j].value;
      }
    }
    if(!gotNutrients){
      return 0;
    }
  }
  double getPotassium(){
    bool gotNutrients = false;
    for(int j = 0; j < this.fullNutrients.length; j++){
      if(fullNutrients[j].attrId == 306){ // getting sugar
        gotNutrients = true;
        return fullNutrients[j].value;
      }
    }
    if(!gotNutrients){
      return 0;
    }
  }
  double getSodium(){
    bool gotNutrients = false;
    for(int j = 0; j < this.fullNutrients.length; j++){
      if(fullNutrients[j].attrId == 307){ // getting sugar
        gotNutrients = true;
        return fullNutrients[j].value;
      }
    }
    if(!gotNutrients){
      return 0;
    }
  }
  // String photoToString(){
  //   // this.photo;
  //   return "assets/images/bloodpressure.jpg";
  // }
  Common.fromJson(Map<String, dynamic> json) {
    foodName = json['food_name'];
    servingUnit = json['serving_unit'];
    tagName = json['tag_name'];
    servingQty = json['serving_qty'].toString();
    tagId = json['tag_id'];
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    servingWeightGrams = json['serving_weight_grams'].toString();
    if (json['full_nutrients'] != null) {
      fullNutrients = new List<FullNutrients>();
      json['full_nutrients'].forEach((v) {
        fullNutrients.add(new FullNutrients.fromJson(v));
      });
    }
    locale = json['locale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_name'] = this.foodName;
    data['serving_unit'] = this.servingUnit;
    data['tag_name'] = this.tagName;
    data['serving_qty'] = this.servingQty;
    data['tag_id'] = this.tagId;
    if (this.photo != null) {
      data['photo'] = this.photo.toJson();
    }
    data['serving_weight_grams'] = this.servingWeightGrams;
    if (this.fullNutrients != null) {
      data['full_nutrients'] =
          this.fullNutrients.map((v) => v.toJson()).toList();
    }
    data['locale'] = this.locale;
    return data;
  }
}

class Photo {
  String thumb;

  Photo({this.thumb});

  Photo.fromJson(Map<String, dynamic> json) {
    thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thumb'] = this.thumb;
    return data;
  }
}

class FullNutrients {
  double value;
  int attrId;

  FullNutrients({this.value, this.attrId});

  FullNutrients.fromJson(Map<String, dynamic> json) {
    value = double.parse(json['value'].toString());
    attrId = json['attr_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['attr_id'] = this.attrId;
    return data;
  }
}

class FoodIntake {
  String img;
  String foodName;
  double weight;
  int calories;
  double cholesterol;
  double total_fat;
  double sugar;
  double protein;
  double potassium;
  double sodium;
  double serving_size;
  String food_unit;
  String mealtype;
  String intakeDate;

  FoodIntake({this.img, this.foodName, this.weight, this.calories, this.cholesterol, this.total_fat, this.sugar, this.protein, this.potassium, this.sodium, this.serving_size, this.food_unit, this.mealtype, this.intakeDate});

  FoodIntake.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    foodName = json['foodName'];
    weight = double.parse(json['weight'].toString());
    calories = int.parse(json['calories'].toString());
    cholesterol = double.parse(json['cholesterol'].toString());
    total_fat = double.parse(json['total_fat'].toString());
    sugar = double.parse(json['sugar'].toString());
    protein = double.parse(json['protein'].toString());
    potassium = double.parse(json['potassium'].toString());
    sodium = double.parse(json['sodium'].toString());
    serving_size = double.parse(json['serving_size'].toString());
    food_unit = json['food_unit'];
    mealtype = json['mealtype'];
    intakeDate = json['intakeDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    data['foodName'] = this.foodName;
    data['weight'] = this.weight;
    data['calories'] = this.calories;
    data['cholesterol'] = this.cholesterol;
    data['total_fat'] = this.total_fat;
    data['sugar'] = this.sugar;
    data['protein'] = this.protein;
    data['potassium'] = this.potassium;
    data['sodium'] = this.sodium;
    data['serving_size'] = this.serving_size;
    data['food_unit'] = this.food_unit;
    data['mealtype'] = this.mealtype;
    data['intakeDate'] = this.intakeDate;
    return data;
  }
}