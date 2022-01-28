class SleepMe {
  List<Oxygen> sleep;

  SleepMe({this.sleep});

  SleepMe.fromJson(Map<String, dynamic> json) {
    if (json['sleep'] != null) {
      sleep = <Oxygen>[];
      json['sleep'].forEach((v) {
        sleep.add(new Oxygen.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sleep != null) {
      data['sleep'] = this.sleep.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Oxygen {
  String dateOfSleep;
  int duration;
  int efficiency;
  String endTime;
  int infoCode;
  bool isMainSleep;
  Levels levels;
  int logId;
  int minutesAfterWakeup;
  int minutesAsleep;
  int minutesAwake;
  int minutesToFallAsleep;
  String startTime;
  int timeInBed;
  String type;

  Oxygen(
      {this.dateOfSleep,
        this.duration,
        this.efficiency,
        this.endTime,
        this.infoCode,
        this.isMainSleep,
        this.levels,
        this.logId,
        this.minutesAfterWakeup,
        this.minutesAsleep,
        this.minutesAwake,
        this.minutesToFallAsleep,
        this.startTime,
        this.timeInBed,
        this.type});

  Oxygen.fromJson(Map<String, dynamic> json) {
    dateOfSleep = json['dateOfSleep'];
    duration = json['duration'];
    efficiency = json['efficiency'];
    endTime = json['endTime'];
    infoCode = json['infoCode'];
    isMainSleep = json['isMainSleep'];
    levels =
    json['levels'] != null ? new Levels.fromJson(json['levels']) : null;
    logId = json['logId'];
    minutesAfterWakeup = json['minutesAfterWakeup'];
    minutesAsleep = json['minutesAsleep'];
    minutesAwake = json['minutesAwake'];
    minutesToFallAsleep = json['minutesToFallAsleep'];
    startTime = json['startTime'];
    timeInBed = json['timeInBed'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateOfSleep'] = this.dateOfSleep;
    data['duration'] = this.duration;
    data['efficiency'] = this.efficiency;
    data['endTime'] = this.endTime;
    data['infoCode'] = this.infoCode;
    data['isMainSleep'] = this.isMainSleep;
    if (this.levels != null) {
      data['levels'] = this.levels.toJson();
    }
    data['logId'] = this.logId;
    data['minutesAfterWakeup'] = this.minutesAfterWakeup;
    data['minutesAsleep'] = this.minutesAsleep;
    data['minutesAwake'] = this.minutesAwake;
    data['minutesToFallAsleep'] = this.minutesToFallAsleep;
    data['startTime'] = this.startTime;
    data['timeInBed'] = this.timeInBed;
    data['type'] = this.type;
    return data;
  }
}

class Levels {
  List<Data> data;
  List<Data> shortData;
  Summary summary;

  Levels({this.data, this.shortData, this.summary});

  Levels.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    if (json['shortData'] != null) {
      shortData = <Data>[];
      json['shortData'].forEach((v) {
        shortData.add(new Data.fromJson(v));
      });
    }
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.shortData != null) {
      data['shortData'] = this.shortData.map((v) => v.toJson()).toList();
    }
    if (this.summary != null) {
      data['summary'] = this.summary.toJson();
    }
    return data;
  }
}

class Data {
  String dateTime;
  String level;
  int seconds;

  Data({this.dateTime, this.level, this.seconds});

  Data.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    level = json['level'];
    seconds = json['seconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateTime'] = this.dateTime;
    data['level'] = this.level;
    data['seconds'] = this.seconds;
    return data;
  }
}

class Summary {
  Deep deep;
  Deep light;
  Deep rem;
  Deep wake;

  Summary({this.deep, this.light, this.rem, this.wake});

  Summary.fromJson(Map<String, dynamic> json) {
    deep = json['deep'] != null ? new Deep.fromJson(json['deep']) : null;
    light = json['light'] != null ? new Deep.fromJson(json['light']) : null;
    rem = json['rem'] != null ? new Deep.fromJson(json['rem']) : null;
    wake = json['wake'] != null ? new Deep.fromJson(json['wake']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.deep != null) {
      data['deep'] = this.deep.toJson();
    }
    if (this.light != null) {
      data['light'] = this.light.toJson();
    }
    if (this.rem != null) {
      data['rem'] = this.rem.toJson();
    }
    if (this.wake != null) {
      data['wake'] = this.wake.toJson();
    }
    return data;
  }
}

class Deep {
  int count;
  int minutes;
  int thirtyDayAvgMinutes;

  Deep({this.count, this.minutes, this.thirtyDayAvgMinutes});

  Deep.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    minutes = json['minutes'];
    thirtyDayAvgMinutes = json['thirtyDayAvgMinutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['minutes'] = this.minutes;
    data['thirtyDayAvgMinutes'] = this.thirtyDayAvgMinutes;
    return data;
  }
}