class FitBitToken {
  String accessToken;
  String refreshToken;
  String idToken;
  String tokenEndpoint;
  List<String> scopes;
  int expiration;

  FitBitToken(
      {this.accessToken,
        this.refreshToken,
        this.idToken,
        this.tokenEndpoint,
        this.scopes,
        this.expiration});

  FitBitToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    idToken = json['idToken'].toString();
    tokenEndpoint = json['tokenEndpoint'];
    if(json['scopes'] != null){
      scopes = json['scopes'].cast<String>();
    }else scopes = new List();
    expiration =int.parse( json['expiration'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['idToken'] = this.idToken;
    data['tokenEndpoint'] = this.tokenEndpoint;
    data['scopes'] = this.scopes;
    data['expiration'] = this.expiration;
    if (this.scopes != null) {
      data['scopes'] = this.scopes;
    }
    return data;
  }
}