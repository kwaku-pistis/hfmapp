import 'dart:async';
import 'dart:io';

import 'package:HFM/models/message.dart';
import 'package:HFM/models/user.dart';
import 'package:HFM/resources/firebase_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Repository {
  final _firebaseProvider = FirebaseProvider();

  Future<void> addDataToDb(auth.User user) =>
      _firebaseProvider.addDataToDb(user);

  Future<auth.User> signIn() => _firebaseProvider.signIn();

  Future<bool> authenticateUser(auth.User user) =>
      _firebaseProvider.authenticateUser(user);

  Future<auth.User> getCurrentUser() => _firebaseProvider.getCurrentUser();

  Future<void> signOut() => _firebaseProvider.signOut();

  Future<String> uploadImageToStorage(File imageFile) =>
      _firebaseProvider.uploadImageToStorage(imageFile);

  Future<void> addPostToDb(
          User currentUser, String imgUrl, String caption, String location) =>
      _firebaseProvider.addPostToDb(currentUser, imgUrl, caption, location);

  Future<User> retrieveUserDetails(auth.User user) =>
      _firebaseProvider.retrieveUserDetails(user);

  Future<List<DocumentSnapshot>> retrieveUserPosts(String userId) =>
      _firebaseProvider.retrieveUserPosts(userId);

  Future<List<DocumentSnapshot>> fetchPostComments(
          DocumentReference reference) =>
      _firebaseProvider.fetchPostCommentDetails(reference);

  Future<List<DocumentSnapshot>> fetchPostLikes(DocumentReference reference) =>
      _firebaseProvider.fetchPostLikeDetails(reference);

  Future<bool> checkIfUserLikedOrNot(
          String userId, DocumentReference reference) =>
      _firebaseProvider.checkIfUserLikedOrNot(userId, reference);

  Future<List<DocumentSnapshot>> retrievePosts(auth.User user) =>
      _firebaseProvider.retrievePosts(user);

  Future<List<String>> fetchAllUserNames(auth.User user) =>
      _firebaseProvider.fetchAllUserNames(user);

  Future<String> fetchUidBySearchedName(String name) =>
      _firebaseProvider.fetchUidBySearchedName(name);

  Future<User> fetchUserDetailsById(String uid) =>
      _firebaseProvider.fetchUserDetailsById(uid);

  Future<void> followUser({String? currentUserId, String? followingUserId}) =>
      _firebaseProvider.followUser(
          currentUserId: currentUserId!, followingUserId: followingUserId!);

  Future<void> unFollowUser(
          {required String currentUserId, required String followingUserId}) =>
      _firebaseProvider.unFollowUser(
          currentUserId: currentUserId, followingUserId: followingUserId);

  Future<bool> checkIsFollowing(String name, String currentUserId) =>
      _firebaseProvider.checkIsFollowing(name, currentUserId);

  Future<List<DocumentSnapshot>> fetchStats(
          {required String uid, required String label}) =>
      _firebaseProvider.fetchStats(uid: uid, label: label);

  Future<void> updatePhoto(String photoUrl, String uid) =>
      _firebaseProvider.updatePhoto(photoUrl, uid);

  Future<void> updateDetails(
          String uid, String name, String bio, String email, String username) =>
      _firebaseProvider.updateDetails(uid, name, bio, email, username);

  Future<List<String>> fetchUserNames(auth.User user) =>
      _firebaseProvider.fetchUserNames(user);

  Future<List<User>> fetchAllUsers(auth.User user) =>
      _firebaseProvider.fetchAllUsers(user);

  void uploadImageMsgToDb(String url, String receiverUid, String senderUid) =>
      _firebaseProvider.uploadImageMsgToDb(url, receiverUid, senderUid);

  Future<void> addMessageToDb(Message message, String receiverUid) =>
      _firebaseProvider.addMessageToDb(message, receiverUid);

  Future<List<DocumentSnapshot>> fetchFeed(auth.User user) =>
      _firebaseProvider.fetchFeed(user);

  Future<List<String>> fetchFollowingUids(auth.User user) =>
      _firebaseProvider.fetchFollowingUids(user);

  //Future<List<DocumentSnapshot>> retrievePostByUID(String uid) => _firebaseProvider.retrievePostByUID(uid);

}
