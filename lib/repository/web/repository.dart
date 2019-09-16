import 'package:firebase/firebase.dart' as fb;

export 'firebase/folder_repository.dart';
export 'firebase/memo_repository.dart';
export 'firebase/user_repository.dart';
export 'local/preference_repository.dart';

void initFirebase() {
  if (fb.apps.isEmpty) {
    fb.initializeApp(
      apiKey: 'AIzaSyAgVki9oTGUgsScsVa5cWZWiVn6Ss6NPho',
      authDomain: 'smu-gp.firebaseapp.com',
      databaseURL: "https://smu-gp.firebaseio.com",
      storageBucket: "smu-gp.appspot.com",
      projectId: 'smu-gp',
    );
  }
}
