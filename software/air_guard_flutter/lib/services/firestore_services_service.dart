import 'package:air_guard/app/app.locator.dart';
import 'package:air_guard/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

class FirestoreServices {
  // final log = getLogger('FirestoreApi');
  final _authenticationService = locator<FirebaseAuthenticationService>();

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('user');

  Future<bool> createUser({required AppUser user, required keyword}) async {
    // log.i('user:$user');
    try {
      final userDocument = _usersCollection.doc(user.id);
      await userDocument.set(user.toJson(keyword), SetOptions(merge: true));
      //  log.v('UserCreated at ${userDocument.path}');
      return true;
    } catch (error) {
      // log.e("Error $error");
      return false;
    }
  }

  Future<AppUser?> getUser({required String userId}) async {
    // log.i('userId:$userId');

    if (userId.isNotEmpty) {
      final userDoc = await _usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        //    log.v('We have no user with id $userId in our database');
        return null;
      }

      final userData = userDoc.data();
      //  log.v('User found. Data: $userData');

      return AppUser.fromMap(userData! as Map<String, dynamic>);
    } else {
      //  log.e("Error no user");
      return null;
    }
  }
}
