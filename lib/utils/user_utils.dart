import 'package:flutter_gank/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUtils {
  static Future saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('login', user.login);
    await prefs.setInt('id', user.id);
    await prefs.setString('avatar_url', user.avatarUrl);
    await prefs.setString('url', user.url);
    await prefs.setString('email', user.email);
    await prefs.setString('bio', user.bio);
    await prefs.setString('location', user.location);
    await prefs.setString('blog', user.blog);
    await prefs.setString('name', user.name);
    await prefs.setString('token', user.token);
  }

  static Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = User(
        prefs.getString("login"),
        prefs.getInt("id"),
        prefs.getString("avatar_url"),
        prefs.getString("url"),
        prefs.getString("email"),
        prefs.getString("bio"),
        prefs.getString("location"),
        prefs.getString("blog"),
        prefs.getString("name"),
        prefs.getString("token"));
    if (user.login == null || user.login.isEmpty) {
      return null;
    }
    return user;
  }

  static Future<bool> removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
