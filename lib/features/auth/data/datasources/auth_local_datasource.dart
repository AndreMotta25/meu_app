import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

final class AuthLocalDatasource {
  static const String userKey = 'cached_user';

  const AuthLocalDatasource(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  Future<UserModel> getUser() async {
    final jsonString = _sharedPreferences.getString(userKey);

    if (jsonString == null) {
      throw const CacheException('Nenhum usuário encontrado no cache.');
    }

    return UserModel.fromJson(json.decode(jsonString) as Map<String, dynamic>);
  }

  Future<void> saveUser(UserModel user) async {
    final jsonString = json.encode(user.toJson());
    await _sharedPreferences.setString(userKey, jsonString);
  }

  Future<void> clearUser() async {
    await _sharedPreferences.remove(userKey);
  }
}
