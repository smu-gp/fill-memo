import 'package:firebase_auth/firebase_auth.dart';
import 'package:sp_client/model/user.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:sp_client/service/services.dart' as Service;

class FirebaseUserRepository extends UserRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseUserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<User> signIn(String uid) async {
    String token = await Service.getToken(uid: uid);
    var user = await _firebaseAuth.signInWithCustomToken(token: token);
    return _toUser(user);
  }

  @override
  Future signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<bool> isSignedIn() async {
    return (await _firebaseAuth.currentUser()) != null;
  }

  @override
  Future<User> getUser() async {
    var user = await _firebaseAuth.currentUser();
    return _toUser(user);
  }

  @override
  Future<User> updateProfile({String displayName, String email}) async {
    var user = await _firebaseAuth.currentUser();
    if (displayName != null) {
      await user.updateProfile(UserUpdateInfo()..displayName = displayName);
    }
    if (email != null) {
      await user.updateEmail(email);
    }
    return getUser();
  }

  User _toUser(FirebaseUser user) {
    return User(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
    );
  }
}
