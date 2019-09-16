import 'package:fill_memo/model/user.dart';
import 'package:fill_memo/repository/repository.dart';
import 'package:fill_memo/service/services.dart' as Service;
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserRepository extends UserRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseUserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<User> signIn(String uid) async {
    String token = await Service.getToken(uid: uid);
    var result = await _firebaseAuth.signInWithCustomToken(token: token);
    return _toUser(result.user);
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
