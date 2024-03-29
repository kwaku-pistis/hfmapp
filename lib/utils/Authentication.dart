// part of chat_pool;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();


/// try to authenticate with google silently or with interaction
/// return a firebase user
Future<UserCredential> signInWithGoogle() async{
  GoogleSignInAccount? currentUser = _googleSignIn.currentUser;
  //try to sign in without user interaction
  currentUser ??= await _googleSignIn.signInSilently();
  //try to sign in with user interaction
  currentUser ??= await _googleSignIn.signIn();

  //get user authentication
  GoogleSignInAuthentication userAuth = await currentUser!.authentication;

  //sign in with firebase
  AuthCredential credential = GoogleAuthProvider.credential(
      idToken: userAuth.idToken,
      accessToken: userAuth.accessToken);


  return await _firebaseAuth.signInWithCredential(credential);
}

///sign out user from firebase and google
Future<void> signOutWithGoogle() async{
  await _googleSignIn.disconnect();
  await _googleSignIn.signOut();
  await _firebaseAuth.signOut();
}