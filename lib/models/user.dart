
class User {

   String uid;
   String email;
   String profileImage;
   String name;
   String followers;
   String following;
   String posts;
   String bio;
   String username;

   User({this.uid, this.email, this.profileImage, this.name, this.followers, this.following, this.bio, this.posts, this.username});

    Map toMap(User user) {
    var data = Map<String, dynamic>();
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
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.profileImage = mapData['profileImage'];
    this.name = mapData['name'];
    this.followers = mapData['followers'];
    this.following = mapData['following'];
    this.bio = mapData['bio'];
    this.posts = mapData['posts'];
    this.username = mapData['username']; 
  }
}

