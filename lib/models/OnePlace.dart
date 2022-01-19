class OnePlace {
  Result2 result;

  OnePlace({this.result});

  OnePlace.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new Result2.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result2 {
  List<AddressComponents> addressComponents;
  String adrAddress;
  String businessStatus;
  String formattedAddress;
  String formattedPhoneNumber;
  Geometry geometry;
  String icon;
  String iconBackgroundColor;
  String iconMaskBaseUri;
  String internationalPhoneNumber;
  String name;
  OpeningHours openingHours;
  List<Photos> photos;
  String placeId;
  PlusCode plusCode;
  String rating;
  String reference;
  List<String> types;
  String url;
  int userRatingsTotal;
  int utcOffset;
  String vicinity;
  String website;

  Result2(
      {this.addressComponents,
        this.adrAddress,
        this.businessStatus,
        this.formattedAddress,
        this.formattedPhoneNumber,
        this.geometry,
        this.icon,
        this.iconBackgroundColor,
        this.iconMaskBaseUri,
        this.internationalPhoneNumber,
        this.name,
        this.openingHours,
        this.photos,
        this.placeId,
        this.plusCode,
        this.rating,
        this.reference,
        this.types,
        this.url,
        this.userRatingsTotal,
        this.utcOffset,
        this.vicinity,
        this.website});

  Result2.fromJson(Map<String, dynamic> json) {
    if (json['address_components'] != null) {
      addressComponents = <AddressComponents>[];
      json['address_components'].forEach((v) {
        addressComponents.add(new AddressComponents.fromJson(v));
      });
    }
    adrAddress = json['adr_address'];
    businessStatus = json['business_status'];
    formattedAddress = json['formatted_address'];
    formattedPhoneNumber = json['formatted_phone_number'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    internationalPhoneNumber = json['international_phone_number'];
    name = json['name'];
    openingHours = json['opening_hours'] != null
        ? new OpeningHours.fromJson(json['opening_hours'])
        : null;
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
      });
    }
    placeId = json['place_id'];
    plusCode = json['plus_code'] != null
        ? new PlusCode.fromJson(json['plus_code'])
        : null;
    rating = json['rating'].toString();
    reference = json['reference'];
    types = json['types'].cast<String>();
    url = json['url'];
    userRatingsTotal = json['user_ratings_total'];
    utcOffset = json['utc_offset'];
    vicinity = json['vicinity'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressComponents != null) {
      data['address_components'] =
          this.addressComponents.map((v) => v.toJson()).toList();
    }
    data['adr_address'] = this.adrAddress;
    data['business_status'] = this.businessStatus;
    data['formatted_address'] = this.formattedAddress;
    data['formatted_phone_number'] = this.formattedPhoneNumber;
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['icon'] = this.icon;
    data['icon_background_color'] = this.iconBackgroundColor;
    data['icon_mask_base_uri'] = this.iconMaskBaseUri;
    data['international_phone_number'] = this.internationalPhoneNumber;
    data['name'] = this.name;
    if (this.openingHours != null) {
      data['opening_hours'] = this.openingHours.toJson();
    }
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    data['place_id'] = this.placeId;
    if (this.plusCode != null) {
      data['plus_code'] = this.plusCode.toJson();
    }
    data['rating'] = this.rating;
    data['reference'] = this.reference;

    data['types'] = this.types;
    data['url'] = this.url;
    data['user_ratings_total'] = this.userRatingsTotal;
    data['utc_offset'] = this.utcOffset;
    data['vicinity'] = this.vicinity;
    data['website'] = this.website;
    return data;
  }
}

class AddressComponents {
  String longName;
  String shortName;
  List<String> types;

  AddressComponents({this.longName, this.shortName, this.types});

  AddressComponents.fromJson(Map<String, dynamic> json) {
    longName = json['long_name'];
    shortName = json['short_name'];
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['long_name'] = this.longName;
    data['short_name'] = this.shortName;
    data['types'] = this.types;
    return data;
  }
}

class Geometry {
  Location location;
  Viewport viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    viewport = json['viewport'] != null
        ? new Viewport.fromJson(json['viewport'])
        : null;
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
    if (this.northeast != null) {
      data['northeast'] = this.northeast.toJson();
    }
    if (this.southwest != null) {
      data['southwest'] = this.southwest.toJson();
    }
    return data;
  }
}

class OpeningHours {
  bool openNow;
  List<Periods> periods;
  List<String> weekdayText;

  OpeningHours({this.openNow, this.periods, this.weekdayText});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    openNow = json['open_now'];
    if (json['periods'] != null) {
      periods = <Periods>[];
      json['periods'].forEach((v) {
        periods.add(new Periods.fromJson(v));
      });
    }
    weekdayText = json['weekday_text'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open_now'] = this.openNow;
    if (this.periods != null) {
      data['periods'] = this.periods.map((v) => v.toJson()).toList();
    }
    data['weekday_text'] = this.weekdayText;
    return data;
  }
}

class Periods {
  Close close;
  Close open;

  Periods({this.close, this.open});

  Periods.fromJson(Map<String, dynamic> json) {
    close = json['close'] != null ? new Close.fromJson(json['close']) : null;
    open = json['open'] != null ? new Close.fromJson(json['open']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.close != null) {
      data['close'] = this.close.toJson();
    }
    if (this.open != null) {
      data['open'] = this.open.toJson();
    }
    return data;
  }
}

class Close {
  int day;
  String time;

  Close({this.day, this.time});

  Close.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['time'] = this.time;
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

class PlusCode {
  String compoundCode;
  String globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['compound_code'] = this.compoundCode;
    data['global_code'] = this.globalCode;
    return data;
  }
}