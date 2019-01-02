class User {
  String login;
  int id;
  String avatar_url;
  String url;
  String email;
  String bio;
  String location;
  String blog;
  String name;
  String token;

  User(this.login, this.id, this.avatar_url, this.url, this.email, this.bio,
      this.location, this.blog, this.name, this.token);

  Map toMap() {
    Map<String, dynamic> map = new Map();
    map['login'] = login;
    map['id'] = id;
    map['avatar_url'] = avatar_url;
    map['url'] = url;
    map['email'] = email;
    map['bio'] = bio;
    map['location'] = location;
    map['blog'] = blog;
    map['name'] = name;
    map['token'] = token;
  }
}
