import 'dart:convert';
String exerciseIdtemp;
String exerciseNametemp;
String uRLtemp;
String apparatusNametemp;
String apparatusAbbreviationtemp;
String instructionsPreparationtemp;
String instructionsExecutiontemp;
String videoSrctemp;
String exerciseNameCompleteTemp;
String exerciseNameCompleteAbbreviationtemp;
String imagephoto;
class ExRxTest {
  List<ExercisesTest> exercises;
  ApiTest api;

  ExRxTest({this.exercises, this.api});

  ExRxTest.fromJson(Map<String, dynamic> json) {
    if (json['exercises'] != null) {
      exercises = new List<ExercisesTest>();
      String temp1 = json['exercises'].toString();
      print(temp1);
      if(temp1[0] == "["){
        json['exercises'].forEach((v) {
          exercises.add(new ExercisesTest.fromJson2(v));
        });
      }else{
        List<String> tempArr1 = temp1.split("{");
        String tempNew= "{ exercises: [ ";
        for(var i = 0 ; i < tempArr1.length;i++){
          if(i>1){
            String a = tempArr1[i];
            tempNew = tempNew + "{"+ tempArr1[i].replaceFirst((i).toString()+":", "", a.length-3);
          }
        }
        tempArr1.removeAt(0);
        tempArr1.removeAt(1);
        for(var i = 1 ; i < tempArr1.length;i++){
          String splitthis = tempArr1[i].replaceAll("}", "").replaceAll("]", "");
          String cleanthis = splitthis.substring(0, splitthis.length-3);

          List<String> splitarr= cleanthis.split(",");
          instructionsPreparationtemp = getThisLabel(cleanthis,"Instructions_Preparation:", "Instructions_Execution:" );
          instructionsExecutiontemp= getThisLabel(cleanthis, "Instructions_Execution:", "Small_Img_1");
          imagephoto = getThisLabel(cleanthis, "Larg_Img_1:", "Larg_Img_2");
          exerciseIdtemp = getThisLabel(cleanthis, "Exercise_Id:", "Exercise_Name:");
          exerciseNametemp = getThisLabel(cleanthis, "Exercise_Name:", "URL:");
          uRLtemp = getThisLabel(cleanthis, "URL:", "Apparatus_Name:");
          apparatusNametemp = getThisLabel(cleanthis, "Apparatus_Name:", "Apparatus_Abbreviation:");
          apparatusAbbreviationtemp = getThisLabel(cleanthis, "Apparatus_Abbreviation:", "IV:");
          videoSrctemp = getThisLabel(cleanthis, "video_src:", "Exercise_Name_Complete:");

          exercises.add(new ExercisesTest(exerciseId: int.parse(exerciseIdtemp), exerciseName: exerciseNametemp,
              apparatusAbbreviation: apparatusAbbreviationtemp, apparatusName: apparatusNametemp, largImg1: imagephoto,
              instructionsExecution: instructionsExecutiontemp, instructionsPreparation: instructionsPreparationtemp,
              uRL: uRLtemp, videoSrc: videoSrctemp));
      }
      }
    }
    api = json['api'] != null ? new ApiTest.fromJson(json['api']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.exercises != null) {
      data['exercises'] = this.exercises.map((v) => v.toJson()).toList();
    }
    if (this.api != null) {
      data['api'] = this.api.toJson();
    }
    return data;
  }
  String getThisLabel (String source,String label, String next){
    String str2 = source.substring(source.indexOf("$label"));
    str2 = str2.substring(0,str2.indexOf("$next"));
    str2 = str2.replaceFirst(",", "", str2.length-2);
    str2 = str2.substring(str2.indexOf(":")+1);
    str2 = str2.trim();
    return str2;
  }
}

class ExercisesTest {
  int exerciseId;
  String exerciseName;
  String uRL;
  String apparatusName;
  String apparatusAbbreviation;
  // int iV;
  // int intensityWeight;
  // int intensityRM1;
  // int intensityMeasurement;
  // int intensityCardio;
  // int durationReps;
  // int durationDistance;
  // int durationTime;
  // int durationInterval;
  // int cardioHR;
  // int cardioLevel;
  // int cardioMETs;
  // int cardioHRMax;
  // int cardioHRReserve;
  // int cardioMETMax;
  // int cardioVO2Max;
  // int cardioVO2Reserve;
  // int cardioRPE110;
  // int cardioRPE620;
  // int cardioSpeed;
  // int cardioWatts;
  // String apparatusGroupsName;
  // int isConcatenate;
  // String utilityName;
  // Null secondaryMuscleGroup;
  // String movementName;
  // int bilateralLoading;
  // int bodyWeightPercent;
  String instructionsPreparation;
  String instructionsExecution;
  // String smallImg1;
  // String smallImg2;
  String largImg1;
  // String largImg2;
  // String gIFImg;
  // int recommendImage;
  String videoSrc;
  // String exerciseNameComplete;
  // String exerciseNameCompleteAbbreviation;
  // String utilityIcon;
  // String targetMuscleGroup;

  ExercisesTest(
      {this.exerciseId,
        this.exerciseName,
        this.uRL,
        this.apparatusName,
        this.apparatusAbbreviation,
        // this.iV,
        // this.intensityWeight,
        // this.intensityRM1,
        // this.intensityMeasurement,
        // this.intensityCardio,
        // this.durationReps,
        // this.durationDistance,
        // this.durationTime,
        // this.durationInterval,
        // this.cardioHR,
        // this.cardioLevel,
        // this.cardioMETs,
        // this.cardioHRMax,
        // this.cardioHRReserve,
        // this.cardioMETMax,
        // this.cardioVO2Max,
        // this.cardioVO2Reserve,
        // this.cardioRPE110,
        // this.cardioRPE620,
        // this.cardioSpeed,
        // this.cardioWatts,
        // this.apparatusGroupsName,
        // this.isConcatenate,
        // this.utilityName,
        // this.secondaryMuscleGroup,
        // this.movementName,
        // this.bilateralLoading,
        // this.bodyWeightPercent,
        this.instructionsPreparation,
        this.instructionsExecution,
        // this.smallImg1,
        // this.smallImg2,
        this.largImg1,
        // this.largImg2,
        // this.gIFImg,
        // this.recommendImage,
        this.videoSrc,
        // this.exerciseNameComplete,
        // this.exerciseNameCompleteAbbreviation,
        // this.utilityIcon,
        // this.targetMuscleGroup
      });

  ExercisesTest.fromJson(Map<String, dynamic> json) {
    // exerciseId = json['Exercise_Id'];
    // exerciseName = json['Exercise_Name'];
    // uRL = json['URL'];
    // apparatusName = json['Apparatus_Name'];
    // apparatusAbbreviation = json['Apparatus_Abbreviation'];
    // // iV = json['IV'];
    // // intensityWeight = json['Intensity_Weight'];
    // // intensityRM1 = json['Intensity_RM1'];
    // // intensityMeasurement = json['Intensity_Measurement'];
    // // intensityCardio = json['Intensity_Cardio'];
    // // durationReps = json['Duration_Reps'];
    // // durationDistance = json['Duration_Distance'];
    // // durationTime = json['Duration_Time'];
    // // durationInterval = json['Duration_Interval'];
    // // cardioHR = json['Cardio_HR'];
    // // cardioLevel = json['Cardio_Level'];
    // // cardioMETs = json['Cardio_METs'];
    // // cardioHRMax = json['Cardio_HRMax'];
    // // cardioHRReserve = json['Cardio_HRReserve'];
    // // cardioMETMax = json['Cardio_METMax'];
    // // cardioVO2Max = json['Cardio_VO2Max'];
    // // cardioVO2Reserve = json['Cardio_VO2Reserve'];
    // // cardioRPE110 = json['Cardio_RPE1_10'];
    // // cardioRPE620 = json['Cardio_RPE6_20'];
    // // cardioSpeed = json['Cardio_Speed'];
    // // cardioWatts = json['Cardio_Watts'];
    // // apparatusGroupsName = json['Apparatus_Groups_Name'];
    // // isConcatenate = json['is_concatenate'];
    // // utilityName = json['Utility_Name'];
    // // secondaryMuscleGroup = json['Secondary_Muscle_Group'];
    // // movementName = json['Movement_Name'];
    // // bilateralLoading = json['Bilateral_Loading'];
    // // bodyWeightPercent = json['Body_Weight_Percent'];
    // instructionsPreparation = json['Instructions_Preparation'];
    // instructionsExecution = json['Instructions_Execution'];
    // // smallImg1 = json['Small_Img_1'];
    // // smallImg2 = json['Small_Img_2'];
    // largImg1 = json['Larg_Img_1'];
    // // largImg2 = json['Larg_Img_2'];
    // // gIFImg = json['GIF_Img'];
    // // recommendImage = json['Recommend_Image'];
    // videoSrc = json['video_src'];
    // exerciseNameComplete = json['Exercise_Name_Complete'];
    // exerciseNameCompleteAbbreviation =
    // json['Exercise_Name_Complete_Abbreviation'];
    // utilityIcon = json['Utility_Icon'];
    // targetMuscleGroup = json['Target_Muscle_Group'];
    String thisstring= json.toString();
    exerciseId = int.parse(getThisLabel(thisstring, "exerciseId:", "instructionsExecution:"));
    exerciseName = getThisLabel(thisstring, "exerciseName:", "exerciseId:");
    uRL = getThisLabel(thisstring, "uRL:", "}");
    apparatusName= getThisLabel(thisstring, "apparatusName:", "instructionsPreparation:");
    apparatusAbbreviation= getThisLabel(thisstring, "{apparatusAbbreviation:", "apparatusName:");
    instructionsPreparation= getThisLabel(thisstring, "instructionsPreparation:", "exerciseName:");
    instructionsExecution= getThisLabel(thisstring, "instructionsExecution:", "videoSrc:");
    largImg1= getThisLabel(thisstring, "largImg1:", "uRL:");
    videoSrc= getThisLabel(thisstring, "videoSrc:", "largImg1:");
  }
  ExercisesTest.fromJson2(Map<String, dynamic> json) {
    exerciseId = json['Exercise_Id'];
    exerciseName = json['Exercise_Name'];
    uRL = json['URL'];
    apparatusName = json['Apparatus_Name'];
    apparatusAbbreviation = json['Apparatus_Abbreviation'];
    // // iV = json['IV'];
    // // intensityWeight = json['Intensity_Weight'];
    // // intensityRM1 = json['Intensity_RM1'];
    // // intensityMeasurement = json['Intensity_Measurement'];
    // // intensityCardio = json['Intensity_Cardio'];
    // // durationReps = json['Duration_Reps'];
    // // durationDistance = json['Duration_Distance'];
    // // durationTime = json['Duration_Time'];
    // // durationInterval = json['Duration_Interval'];
    // // cardioHR = json['Cardio_HR'];
    // // cardioLevel = json['Cardio_Level'];
    // // cardioMETs = json['Cardio_METs'];
    // // cardioHRMax = json['Cardio_HRMax'];
    // // cardioHRReserve = json['Cardio_HRReserve'];
    // // cardioMETMax = json['Cardio_METMax'];
    // // cardioVO2Max = json['Cardio_VO2Max'];
    // // cardioVO2Reserve = json['Cardio_VO2Reserve'];
    // // cardioRPE110 = json['Cardio_RPE1_10'];
    // // cardioRPE620 = json['Cardio_RPE6_20'];
    // // cardioSpeed = json['Cardio_Speed'];
    // // cardioWatts = json['Cardio_Watts'];
    // // apparatusGroupsName = json['Apparatus_Groups_Name'];
    // // isConcatenate = json['is_concatenate'];
    // // utilityName = json['Utility_Name'];
    // // secondaryMuscleGroup = json['Secondary_Muscle_Group'];
    // // movementName = json['Movement_Name'];
    // // bilateralLoading = json['Bilateral_Loading'];
    // // bodyWeightPercent = json['Body_Weight_Percent'];
    instructionsPreparation = json['Instructions_Preparation'];
    instructionsExecution = json['Instructions_Execution'];
    // // smallImg1 = json['Small_Img_1'];
    // // smallImg2 = json['Small_Img_2'];
    largImg1 = json['Larg_Img_1'];
    // // largImg2 = json['Larg_Img_2'];
    // // gIFImg = json['GIF_Img'];
    // // recommendImage = json['Recommend_Image'];
    videoSrc = json['video_src'];
    // exerciseNameComplete = json['Exercise_Name_Complete'];
    // exerciseNameCompleteAbbreviation =
    // json['Exercise_Name_Complete_Abbreviation'];
    // utilityIcon = json['Utility_Icon'];
    // targetMuscleGroup = json['Target_Muscle_Group'];
  }
  String getThisLabel (String source,String label, String next){
    String str2 = source.substring(source.indexOf("$label"));
    str2 = str2.substring(0,str2.indexOf("$next"));
    str2 = str2.replaceFirst(",", "", str2.length-2);
    str2 = str2.substring(str2.indexOf(":")+1);
    str2 = str2.trim();
    return str2;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Exercise_Id'] = this.exerciseId;
    data['Exercise_Name'] = this.exerciseName;
    data['URL'] = this.uRL;
    data['Apparatus_Name'] = this.apparatusName;
    data['Apparatus_Abbreviation'] = this.apparatusAbbreviation;
    // data['IV'] = this.iV;
    // data['Intensity_Weight'] = this.intensityWeight;
    // data['Intensity_RM1'] = this.intensityRM1;
    // data['Intensity_Measurement'] = this.intensityMeasurement;
    // data['Intensity_Cardio'] = this.intensityCardio;
    // data['Duration_Reps'] = this.durationReps;
    // data['Duration_Distance'] = this.durationDistance;
    // data['Duration_Time'] = this.durationTime;
    // data['Duration_Interval'] = this.durationInterval;
    // data['Cardio_HR'] = this.cardioHR;
    // data['Cardio_Level'] = this.cardioLevel;
    // data['Cardio_METs'] = this.cardioMETs;
    // data['Cardio_HRMax'] = this.cardioHRMax;
    // data['Cardio_HRReserve'] = this.cardioHRReserve;
    // data['Cardio_METMax'] = this.cardioMETMax;
    // data['Cardio_VO2Max'] = this.cardioVO2Max;
    // data['Cardio_VO2Reserve'] = this.cardioVO2Reserve;
    // data['Cardio_RPE1_10'] = this.cardioRPE110;
    // data['Cardio_RPE6_20'] = this.cardioRPE620;
    // data['Cardio_Speed'] = this.cardioSpeed;
    // data['Cardio_Watts'] = this.cardioWatts;
    // data['Apparatus_Groups_Name'] = this.apparatusGroupsName;
    // data['is_concatenate'] = this.isConcatenate;
    // data['Utility_Name'] = this.utilityName;
    // data['Secondary_Muscle_Group'] = this.secondaryMuscleGroup;
    // data['Movement_Name'] = this.movementName;
    // data['Bilateral_Loading'] = this.bilateralLoading;
    // data['Body_Weight_Percent'] = this.bodyWeightPercent;
    data['Instructions_Preparation'] = this.instructionsPreparation;
    data['Instructions_Execution'] = this.instructionsExecution;
    // data['Small_Img_1'] = this.smallImg1;
    // data['Small_Img_2'] = this.smallImg2;
    data['Larg_Img_1'] = this.largImg1;
    // data['Larg_Img_2'] = this.largImg2;
    // data['GIF_Img'] = this.gIFImg;
    // data['Recommend_Image'] = this.recommendImage;
    data['video_src'] = this.videoSrc;
    // data['Exercise_Name_Complete'] = this.exerciseNameComplete;
    // data['Exercise_Name_Complete_Abbreviation'] =
    //     this.exerciseNameCompleteAbbreviation;
    // data['Utility_Icon'] = this.utilityIcon;
    // data['Target_Muscle_Group'] = this.targetMuscleGroup;
    return data;
  }
}

class ApiTest {
  String videoAccess;
  int guidTier;
  int callCountWithinMinute;
  int callCountLimitMinute;
  int callCountWithinHour;
  int callCountLimitHour;

  ApiTest(
      {this.videoAccess,
        this.guidTier,
        this.callCountWithinMinute,
        this.callCountLimitMinute,
        this.callCountWithinHour,
        this.callCountLimitHour});

  ApiTest.fromJson(Map<String, dynamic> json) {
    videoAccess = json['videoAccess'];
    guidTier = json['guid-tier'];
    callCountWithinMinute = json['call-count-within-minute'];
    callCountLimitMinute = json['call-count-limit-minute'];
    callCountWithinHour = json['call-count-within-hour'];
    callCountLimitHour = json['call-count-limit-hour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['videoAccess'] = this.videoAccess;
    data['guid-tier'] = this.guidTier;
    data['call-count-within-minute'] = this.callCountWithinMinute;
    data['call-count-limit-minute'] = this.callCountLimitMinute;
    data['call-count-within-hour'] = this.callCountWithinHour;
    data['call-count-limit-hour'] = this.callCountLimitHour;
    return data;
  }

}