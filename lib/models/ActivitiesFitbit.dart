class ActivitiesFitbit {
  List<Activities> activities;

  ActivitiesFitbit({this.activities});

  ActivitiesFitbit.fromJson(Map<String, dynamic> json) {
    if (json['activities'] != null) {
      activities = <Activities>[];
      json['activities'].forEach((v) {
        activities.add(new Activities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.activities != null) {
      data['activities'] = this.activities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Activities {
  int activeDuration;
  List<ActivityLevel> activityLevel;
  String activityName;
  int activityTypeId;
  int calories;
  String caloriesLink;
  int distance;
  String distanceUnit;
  int duration;
  bool hasActiveZoneMinutes;
  String lastModified;
  int logId;
  String logType;
  ManualValuesSpecified manualValuesSpecified;
  int originalDuration;
  String originalStartTime;
  double pace;
  double speed;
  String startTime;
  int steps;
  ActiveZoneMinutes activeZoneMinutes;
  int averageHeartRate;
  String heartRateLink;
  List<HeartRateZones> heartRateZones;
  String tcxLink;

  Activities(
      {this.activeDuration,
        this.activityLevel,
        this.activityName,
        this.activityTypeId,
        this.calories,
        this.caloriesLink,
        this.distance,
        this.distanceUnit,
        this.duration,
        this.hasActiveZoneMinutes,
        this.lastModified,
        this.logId,
        this.logType,
        this.manualValuesSpecified,
        this.originalDuration,
        this.originalStartTime,
        this.pace,
        this.speed,
        this.startTime,
        this.steps,
        this.activeZoneMinutes,
        this.averageHeartRate,
        this.heartRateLink,
        this.heartRateZones,
        this.tcxLink});

  Activities.fromJson(Map<String, dynamic> json) {
    activeDuration = json['activeDuration'];
    if (json['activityLevel'] != null) {
      activityLevel = <ActivityLevel>[];
      json['activityLevel'].forEach((v) {
        activityLevel.add(new ActivityLevel.fromJson(v));
      });
    }
    activityName = json['activityName'];
    activityTypeId = json['activityTypeId'];
    calories = json['calories'];
    caloriesLink = json['caloriesLink'];
    distance = json['distance'];
    distanceUnit = json['distanceUnit'];
    duration = json['duration'];
    hasActiveZoneMinutes = json['hasActiveZoneMinutes'];
    lastModified = json['lastModified'];
    logId = json['logId'];
    logType = json['logType'];
    manualValuesSpecified = json['manualValuesSpecified'] != null
        ? new ManualValuesSpecified.fromJson(json['manualValuesSpecified'])
        : null;
    originalDuration = json['originalDuration'];
    originalStartTime = json['originalStartTime'];
    pace = json['pace'];
    speed = double.parse(json['speed'].toString());
    startTime = json['startTime'];
    steps = json['steps'];
    activeZoneMinutes = json['activeZoneMinutes'] != null
        ? new ActiveZoneMinutes.fromJson(json['activeZoneMinutes'])
        : null;
    averageHeartRate = json['averageHeartRate'];
    heartRateLink = json['heartRateLink'];
    if (json['heartRateZones'] != null) {
      heartRateZones = <HeartRateZones>[];
      json['heartRateZones'].forEach((v) {
        heartRateZones.add(new HeartRateZones.fromJson(v));
      });
    }
    tcxLink = json['tcxLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activeDuration'] = this.activeDuration;
    if (this.activityLevel != null) {
      data['activityLevel'] =
          this.activityLevel.map((v) => v.toJson()).toList();
    }
    data['activityName'] = this.activityName;
    data['activityTypeId'] = this.activityTypeId;
    data['calories'] = this.calories;
    data['caloriesLink'] = this.caloriesLink;
    data['distance'] = this.distance;
    data['distanceUnit'] = this.distanceUnit;
    data['duration'] = this.duration;
    data['hasActiveZoneMinutes'] = this.hasActiveZoneMinutes;
    data['lastModified'] = this.lastModified;
    data['logId'] = this.logId;
    data['logType'] = this.logType;
    if (this.manualValuesSpecified != null) {
      data['manualValuesSpecified'] = this.manualValuesSpecified.toJson();
    }
    data['originalDuration'] = this.originalDuration;
    data['originalStartTime'] = this.originalStartTime;
    data['pace'] = this.pace;
    data['speed'] = this.speed;
    data['startTime'] = this.startTime;
    data['steps'] = this.steps;
    if (this.activeZoneMinutes != null) {
      data['activeZoneMinutes'] = this.activeZoneMinutes.toJson();
    }
    data['averageHeartRate'] = this.averageHeartRate;
    data['heartRateLink'] = this.heartRateLink;
    if (this.heartRateZones != null) {
      data['heartRateZones'] =
          this.heartRateZones.map((v) => v.toJson()).toList();
    }
    data['tcxLink'] = this.tcxLink;
    return data;
  }
}

class ActivityLevel {
  int minutes;
  String name;

  ActivityLevel({this.minutes, this.name});

  ActivityLevel.fromJson(Map<String, dynamic> json) {
    minutes = json['minutes'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minutes'] = this.minutes;
    data['name'] = this.name;
    return data;
  }
}

class ManualValuesSpecified {
  bool calories;
  bool distance;
  bool steps;

  ManualValuesSpecified({this.calories, this.distance, this.steps});

  ManualValuesSpecified.fromJson(Map<String, dynamic> json) {
    calories = json['calories'];
    distance = json['distance'];
    steps = json['steps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calories'] = this.calories;
    data['distance'] = this.distance;
    data['steps'] = this.steps;
    return data;
  }
}

class ActiveZoneMinutes {
  List<MinutesInHeartRateZones> minutesInHeartRateZones;
  int totalMinutes;

  ActiveZoneMinutes({this.minutesInHeartRateZones, this.totalMinutes});

  ActiveZoneMinutes.fromJson(Map<String, dynamic> json) {
    if (json['minutesInHeartRateZones'] != null) {
      minutesInHeartRateZones = <MinutesInHeartRateZones>[];
      json['minutesInHeartRateZones'].forEach((v) {
        minutesInHeartRateZones.add(new MinutesInHeartRateZones.fromJson(v));
      });
    }
    totalMinutes = json['totalMinutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.minutesInHeartRateZones != null) {
      data['minutesInHeartRateZones'] =
          this.minutesInHeartRateZones.map((v) => v.toJson()).toList();
    }
    data['totalMinutes'] = this.totalMinutes;
    return data;
  }
}

class MinutesInHeartRateZones {
  int minuteMultiplier;
  int minutes;
  int order;
  String type;
  String zoneName;

  MinutesInHeartRateZones(
      {this.minuteMultiplier,
        this.minutes,
        this.order,
        this.type,
        this.zoneName});

  MinutesInHeartRateZones.fromJson(Map<String, dynamic> json) {
    minuteMultiplier = json['minuteMultiplier'];
    minutes = json['minutes'];
    order = json['order'];
    type = json['type'];
    zoneName = json['zoneName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minuteMultiplier'] = this.minuteMultiplier;
    data['minutes'] = this.minutes;
    data['order'] = this.order;
    data['type'] = this.type;
    data['zoneName'] = this.zoneName;
    return data;
  }
}

class HeartRateZones {
  double caloriesOut;
  int max;
  int min;
  int minutes;
  String name;

  HeartRateZones(
      {this.caloriesOut, this.max, this.min, this.minutes, this.name});

  HeartRateZones.fromJson(Map<String, dynamic> json) {
    caloriesOut = json['caloriesOut'];
    max = json['max'];
    min = json['min'];
    minutes = json['minutes'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['caloriesOut'] = this.caloriesOut;
    data['max'] = this.max;
    data['min'] = this.min;
    data['minutes'] = this.minutes;
    data['name'] = this.name;
    return data;
  }
}


class ActivitiesFitbitDetailed {
  List<ActivitiesCalories> activitiesCalories;

  ActivitiesFitbitDetailed({this.activitiesCalories});

  ActivitiesFitbitDetailed.fromJson(Map<String, dynamic> json) {
    if (json['activities-calories'] != null) {
      activitiesCalories = <ActivitiesCalories>[];
      json['activities-calories'].forEach((v) {
        activitiesCalories.add(new ActivitiesCalories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.activitiesCalories != null) {
      data['activities-calories'] =
          this.activitiesCalories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActivitiesCalories {
  String dateTime;
  String value;

  ActivitiesCalories({this.dateTime, this.value});

  ActivitiesCalories.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateTime'] = this.dateTime;
    data['value'] = this.value;
    return data;
  }
}