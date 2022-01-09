class GooglePlaces {
  List<Results> results;

  GooglePlaces({this.results});

  GooglePlaces.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results = null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String businessStatus;
  String formattedAddress;
  Geometry geometry;
  String icon;
  String iconBackgroundColor;
  String iconMaskBaseUri;
  String name;
  String placeId;
  String rating;
  String reference;
  List<String> types;
  String userRatingsTotal;
  Photos photos;
  OpeningHours openingHours;

  Results(
      {this.businessStatus,
        this.formattedAddress,
        this.geometry,
        this.icon,
        this.iconBackgroundColor,
        this.iconMaskBaseUri,
        this.name,
        this.placeId,
        this.rating,
        this.reference,
        this.types,
        this.userRatingsTotal,
        this.photos,
        this.openingHours});

  Results.fromJson(Map<String, dynamic> json) {
    businessStatus = json['business_status'];
    formattedAddress = json['formatted_address'];
    geometry = json['geometry'] = new Geometry.fromJson(json['geometry']);
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    placeId = json['place_id'];
    rating = json['rating'].toString();
    reference = json['reference'];
    types = json['types'].cast<String>();
    userRatingsTotal = json['user_ratings_total'].toString();
    if (json['photos'] != null) {
      photos = new Photos();
      String read1 = json['photos'].toString();
      print(read1);
      String read2 = read1.replaceAll("[", "").replaceAll("]", "");
      print(read2);
      String height = getThisLabel(read2, "height:", "html_attributions:");
      String photoref = getThisLabel(read2, "photo_reference:", "width:");
      String width = read2.substring(read2.indexOf("width:"));
      width = width.substring(width.indexOf(":")+1);
      width = width.replaceAll("}", "");
      //print(width + "<<<<<<<WIDTH");
      photos = new Photos(height: int.parse(height), photoReference: photoref, width: int.parse(width));
      // json['photos'].forEach((v) {
      //   photos.add(new Photos.fromJson(v));
      // });
    }else{
      photos = new Photos(height: 0, photoReference: "photoref", width: 0);
    }
    openingHours = json['opening_hours'] != null
        ? new OpeningHours.fromJson(json['opening_hours'])
        : null;
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
    data['business_status'] = this.businessStatus;
    data['formatted_address'] = this.formattedAddress;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['icon'] = this.icon;
    data['icon_background_color'] = this.iconBackgroundColor;
    data['icon_mask_base_uri'] = this.iconMaskBaseUri;
    data['name'] = this.name;
    data['place_id'] = this.placeId;
    data['rating'] = this.rating;
    data['reference'] = this.reference;
    data['types'] = this.types;
    data['user_ratings_total'] = this.userRatingsTotal;
    if (this.photos != null) {
      data['photos'] = this.photos.toJson();
    }
    if (this.openingHours != null) {
      data['opening_hours'] = this.openingHours.toJson();
    }
    return data;
  }
}

class Geometry {
  Location location;
  Viewport viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] =
         new Location.fromJson(json['location']);
    viewport = json['viewport'] =
         new Viewport.fromJson(json['viewport']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    if (this.viewport != null) {
      data['viewport'] = this.viewport.toJson();
    }
    return data;
  }
}

class Location {
  double lat;
  double lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Viewport {
  Location northeast;
  Location southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast = json['northeast'] != null
        ? new Location.fromJson(json['northeast'])
        : null;
    southwest = json['southwest'] != null
        ? new Location.fromJson(json['southwest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.northeast = null) {
      data['northeast'] = this.northeast.toJson();
    }
    if (this.southwest = null) {
      data['southwest'] = this.southwest.toJson();
    }
    return data;
  }
}


class Photos {
  int height;
  List<String> htmlAttributions;
  String photoReference;
  int width;

  Photos({this.height, this.htmlAttributions, this.photoReference, this.width});

  Photos.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    htmlAttributions = json['html_attributions'].cast<String>();
    photoReference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['html_attributions'] = this.htmlAttributions;
    data['photo_reference'] = this.photoReference;
    data['width'] = this.width;
    return data;
  }
}

class OpeningHours {
  bool openNow;

  OpeningHours({this.openNow});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    openNow = json['open_now'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open_now'] = this.openNow;
    return data;
  }
}