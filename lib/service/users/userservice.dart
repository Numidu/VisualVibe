import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/model/userModel.dart';
import 'package:socially/service/auth/auth_srvice.dart';

class UserService {
  // Collection names
  static const String usersCollectionName = 'users';
  static const String feedCollectionName = 'feed';

  // Collection references
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(usersCollectionName);
  final CollectionReference _feedCollection =
      FirebaseFirestore.instance.collection(feedCollectionName);

  // Save the user in the Firestore database
  Future<bool> saveUser(UserModel user) async {
    try {
      // Create a new user with email and password
      final userCredential = await AuthService().createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      // Retrieve the user ID from the created user
      final userId = userCredential.user?.uid;

      if (userId != null) {
        // Create a new user document in Firestore with the user ID as the document ID
        final userRef = _usersCollection.doc(userId);

        // Serialize the user data to JSON
        final userMap = user.toJson();
        userMap['userId'] = userId;

        // Set the user data in Firestore
        await userRef.set(userMap);

        print('User saved successfully with ID: $userId');
        return true;
      } else {
        print('Error: User ID is null');
        return false;
      }
    } catch (error) {
      print('Error saving user: $error');
      return false;
    }
  }

  Future<UserModel?> getUserByUserId({required String userId}) async {
    try {
      final DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  //get user
  Future<List<UserModel>> getallusers() async {
    try {
      final snapshot = await _usersCollection.get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (error) {
      print(error);
      return [];
    }
  }

  Future<void> followeruser(
      {required String currentuserId, required String userfolowwedId}) async {
    try {
      await _usersCollection
          .doc(userfolowwedId)
          .collection("followers")
          .doc(currentuserId)
          .set({"FollowedAt": Timestamp.now()});

      //update follower count;
      final follwedUserRef = _usersCollection.doc(userfolowwedId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final followeduserDoc = await transaction.get(follwedUserRef);

        if (followeduserDoc.exists) {
          final data = followeduserDoc.data() as Map<String, dynamic>;
          final currentFollowerscount = data["followersCount"] ?? 0;
          transaction.update(
              follwedUserRef, {"followersCount": currentFollowerscount + 1});
        }
      });

      //updatefollowing count

      final currentUserRef = _usersCollection.doc(currentuserId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final currentUserDoc = await transaction.get(currentUserRef);

        if (currentUserDoc.exists) {
          final data = currentUserDoc.data() as Map<String, dynamic>;
          final currentFollowingcount = data["followingCount"] ?? 0;
          transaction.update(
              currentUserRef, {"followingCount": currentFollowingcount + 1});
        }
      });
    } catch (e) {
      print(e);
    }
    ;
  }

  Future<void> unflowwer(
      {required String currentuserId, required String userunflowwedId}) async {
    await _usersCollection
        .doc(userunflowwedId)
        .collection("followers")
        .doc(currentuserId)
        .delete();

    //update folowwer

    final unfolloweduserRef = _usersCollection.doc(userunflowwedId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final unflloweduserdoc = await transaction.get(unfolloweduserRef);
      if (unflloweduserdoc.exists) {
        final data = unflloweduserdoc.data() as Map<String, dynamic>;
        final currentcount = data["followersCount"] ?? 0;
        transaction
            .update(unfolloweduserRef, {"followersCount": currentcount - 1});
      }
    });

    final currentuserRef = _usersCollection.doc(currentuserId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final currentuserdoc = await transaction.get(currentuserRef);
      if (currentuserdoc.exists) {
        final data = currentuserdoc.data() as Map<String, dynamic>;
        final currentcount = data["followersCount"] ?? 0;
        transaction
            .update(currentuserRef, {"followersCount": currentcount - 1});
      }
    });
  }

  //methodd to check follow
  Future<bool> isFollowing(
      {required String currentuserid, required userTochecked}) async {
    try {
      final docSnapshot = await _usersCollection
          .doc(userTochecked)
          .collection("followers")
          .doc(currentuserid)
          .get();
      return docSnapshot.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int> getUserFollowersCount(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['followersCount'] ?? 0;
      }
      return 0; // Return 0 if the document doesn't exist
    } catch (error) {
      print('Error getting user followers count: $error');
      return 0;
    }
  }

  Future<int> getUserFollowingCount(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['followingCount'] ?? 0;
      }
      return 0; // Return 0 if the document doesn't exist
    } catch (error) {
      print('Error getting user following count: $error');
      return 0;
    }
  }
}
