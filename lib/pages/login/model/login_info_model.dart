class LoginInfoModel {
  String _accessToken;
  String _tokenType;
  String _refreshToken;
  int _expiresIn;
  String _scope;

  LoginInfoModel(
      {String accessToken,
        String tokenType,
        String refreshToken,
        int expiresIn,
        String scope}) {
    this._accessToken = accessToken;
    this._tokenType = tokenType;
    this._refreshToken = refreshToken;
    this._expiresIn = expiresIn;
    this._scope = scope;
  }

  String get accessToken => _accessToken;
  set accessToken(String accessToken) => _accessToken = accessToken;
  String get tokenType => _tokenType;
  set tokenType(String tokenType) => _tokenType = tokenType;
  String get refreshToken => _refreshToken;
  set refreshToken(String refreshToken) => _refreshToken = refreshToken;
  int get expiresIn => _expiresIn;
  set expiresIn(int expiresIn) => _expiresIn = expiresIn;
  String get scope => _scope;
  set scope(String scope) => _scope = scope;

  LoginInfoModel.fromJson(Map<String, dynamic> json) {
    _accessToken = json['access_token'];
    _tokenType = json['token_type'];
    _refreshToken = json['refresh_token'];
    _expiresIn = json['expires_in'];
    _scope = json['scope'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this._accessToken;
    data['token_type'] = this._tokenType;
    data['refresh_token'] = this._refreshToken;
    data['expires_in'] = this._expiresIn;
    data['scope'] = this._scope;
    return data;
  }
}
class Autogenerated {
  String _accessToken;
  String _tokenType;
  String _refreshToken;
  int _expiresIn;
  String _scope;

  Autogenerated(
      {String accessToken,
        String tokenType,
        String refreshToken,
        int expiresIn,
        String scope}) {
    this._accessToken = accessToken;
    this._tokenType = tokenType;
    this._refreshToken = refreshToken;
    this._expiresIn = expiresIn;
    this._scope = scope;
  }

  String get accessToken => _accessToken;
  set accessToken(String accessToken) => _accessToken = accessToken;
  String get tokenType => _tokenType;
  set tokenType(String tokenType) => _tokenType = tokenType;
  String get refreshToken => _refreshToken;
  set refreshToken(String refreshToken) => _refreshToken = refreshToken;
  int get expiresIn => _expiresIn;
  set expiresIn(int expiresIn) => _expiresIn = expiresIn;
  String get scope => _scope;
  set scope(String scope) => _scope = scope;

  Autogenerated.fromJson(Map<String, dynamic> json) {
    _accessToken = json['access_token'];
    _tokenType = json['token_type'];
    _refreshToken = json['refresh_token'];
    _expiresIn = json['expires_in'];
    _scope = json['scope'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this._accessToken;
    data['token_type'] = this._tokenType;
    data['refresh_token'] = this._refreshToken;
    data['expires_in'] = this._expiresIn;
    data['scope'] = this._scope;
    return data;
  }
}

