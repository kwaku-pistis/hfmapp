class User {
  late String? uid;
  late String? email;
  late String? profileImage;
  late String? name;
  late String? followers;
  late String? following;
  late String? posts;
  late String? bio;
  late String? username;

  User(
      {this.uid,
      this.email,
      this.profileImage,
      this.name,
      this.followers,
      this.following,
      this.bio,
      this.posts,
      this.username});

  Map<String, dynamic> toMap(User user) {
    var data = <String, dynamic>{};
    data['uid'] = user.uid;
    data['email'] = user.email;
    data['profileImage'] = user.profileImage;
    data['name'] = user.name;
    data['followers'] = user.followers;
    data['following'] = user.following;
    data['bio'] = user.bio;
    data['posts'] = user.posts;
    data['username'] = user.username;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['uid'];
    email = mapData['email'];
    profileImage = mapData['profileImage'];
    name = mapData['name'];
    followers = mapData['followers'];
    following = mapData['following'];
    bio = mapData['bio'];
    posts = mapData['posts'];
    username = mapData['username'];
  }
}
