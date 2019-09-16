import 'package:fill_memo/model/user.dart';
import 'package:fill_memo/repository/repository.dart';
import 'package:fill_memo/service/services.dart' as Service;
import 'package:firebase/firebase.dart' as fb;

class FirebaseUserRepository extends UserRepository {
  final fb.Auth _firebaseAuth;

  FirebaseUserRepository({fb.Auth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? fb.auth();

  @override
  Future<User> signIn(String uid) async {
    String token = await Service.getToken(uid: uid);
    var result = await _firebaseAuth.signInWithCustomToken(token);
    return _toUser(result.user);
  }

  @override
  Future signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<bool> isSignedIn() async {
    return (_firebaseAuth.currentUser) != null;
  }

  @override
  Future<User> getUser() async {
    var user = _firebaseAuth.currentUser;
    return _toUser(user);
  }

  @override
  Future<User> updateProfile({String displayName, String email}) async {
    var user = _firebaseAuth.currentUser;
    if (displayName != null) {
      await user.updateProfile(fb.UserProfile()..displayName = displayName);
    }
    if (email != null) {
      await user.updateEmail(email);
    }
    return getUser();
  }

  User _toUser(fb.User user) {
    return User(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
    );
  }
}
