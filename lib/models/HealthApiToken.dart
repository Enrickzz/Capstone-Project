class HealthApiToken {
  String aPIName;
  String accessToken;
  int expires;
  String refreshToken;
  int refreshTokenExpires;
  String uUID;
  String userID;
  String userOpenID;
  String userRegion;
  String clientPara;
  String tokenType;

  HealthApiToken(
      {this.aPIName,
        this.accessToken,
        this.expires,
        this.refreshToken,
        this.refreshTokenExpires,
        this.uUID,
        this.userID,
        this.userOpenID,
        this.userRegion,
        this.clientPara,
        this.tokenType});

  HealthApiToken.fromJson(Map<String, dynamic> json) {
    aPIName = json['APIName'];
    accessToken = json['AccessToken'];
    expires = int.parse(json['Expires'].toString());
    refreshToken = json['RefreshToken'];
    refreshTokenExpires = int.parse(json['RefreshTokenExpires'].toString());
    uUID = json['UUID'];
    userID = json['UserID'];
    userOpenID = json['UserOpenID'];
    userRegion = json['UserRegion'];
    clientPara = json['client_para'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['APIName'] = this.aPIName;
    data['AccessToken'] = this.accessToken;
    data['Expires'] = this.expires;
    data['RefreshToken'] = this.refreshToken;
    data['RefreshTokenExpires'] = this.refreshTokenExpires;
    data['UUID'] = this.uUID;
    data['UserID'] = this.userID;
    data['UserOpenID'] = this.userOpenID;
    data['UserRegion'] = this.userRegion;
    data['client_para'] = this.clientPara;
    data['token_type'] = this.tokenType;
    return data;
  }
}