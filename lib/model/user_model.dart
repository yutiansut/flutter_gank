class User {
  String login;
  int id;
  String avatarUrl;
  String url;
  String email;
  String bio;
  String location;
  String blog;
  String name;
  String token;

  User(this.login, this.id, this.avatarUrl, this.url, this.email, this.bio,
      this.location, this.blog, this.name, this.token);

  String get userDesc => bio ?? blog ?? email;

  String get userName => name ?? login;

  Map toMap() {
    Map<String, dynamic> map = new Map();
    map['login'] = login;
    map['id'] = id;
    map['avatar_url'] = avatarUrl;
    map['url'] = url;
    map['email'] = email;
    map['bio'] = bio;
    map['location'] = location;
    map['blog'] = blog;
    map['name'] = name;
    map['token'] = token;
    return map;
  }
}
