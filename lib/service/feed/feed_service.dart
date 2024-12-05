import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:socially/model/post_model.dart';
import 'package:socially/service/feed/feed_storage.dart';
import 'package:socially/views/responsive/utilits/mode.dart';

class FeedService {
  final CollectionReference feedcollection =
      FirebaseFirestore.instance.collection("feed");

  //save post
  Future<void> savepost(Map<String, dynamic> postDetails) async {
    try {
      String? postUrl;
      if (postDetails["postImage"] != null &&
          postDetails["postImage"] is File) {
        postUrl = await FeedStorage().uploadImage(
          postImage: postDetails["postImage"] as File,
        );

        final Post newpost = Post(
            postId: FirebaseAuth.instance.currentUser!.uid,
            postcaption: postDetails["postCaption"] as String? ?? "",
            mood: MoodExtention.formString(postDetails["mood"] ?? 'happy'),
            userId: postDetails["userId"] as String? ?? "",
            userName: postDetails["userName"] as String? ?? "",
            profImage: postDetails["profImage"],
            likes: 0,
            datePublished: DateTime.now(),
            posturl: postUrl ?? "",
            pid: "");

        final DocumentReference docRef =
            await feedcollection.add(newpost.toJson());
        await docRef.update({"PostId": docRef.id});
      }
    } catch (error) {
      print(error);
    }
  }

// get data from detabase
  Stream<List<Post>> getPostStream() {
    return feedcollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

//post ekakata like krnn
  Future<void> likepost({
    required String postId,
    required String userId,
  }) async {
    print("entered");

    // Reference to the "likes" sub-collection
    final DocumentReference postlikeref =
        feedcollection.doc(postId).collection("likes").doc(userId);

    // Add a like timestamp
    await postlikeref.set({
      "likeat": Timestamp.now(),
    });

    // Get the current post document
    final DocumentSnapshot postDoc = await feedcollection.doc(postId).get();

    // Check if the document exists and parse it
    if (postDoc.exists) {
      final Post post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      // Increment likes
      final int newlike = post.likes + 1;

      // Update the likes field in the post document
      await feedcollection.doc(postId).update({"likes": newlike});
      print("like added successfully");
    } else {
      print("Post not found");
    }
  }

  Future<void> dislikepost(
      {required String postId, required String userId}) async {
    final DocumentReference postlikeref =
        feedcollection.doc(postId).collection("likes").doc(userId);

    //Add a like time
    await postlikeref.delete();

    final DocumentSnapshot postDoc = await feedcollection.doc(postId).get();
    final Post post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

    final int newlike = post.likes - 1;

    await feedcollection.doc(postId).update({"likes": newlike});
  }

  Future<bool> haslike({required String postid, required String userid}) async {
    try {
      final DocumentReference postlikeref =
          feedcollection.doc(postid).collection("likes").doc(userid);

      // Check if the document exists
      final doc = await postlikeref.get();
      return doc.exists;
    } catch (error, stacktrace) {
      // Log the error and stacktrace for easier debugging
      print("Error checking like for post: $postid, user: $userid");
      print("Error: $error");
      print("Stacktrace: $stacktrace");
      return false;
    }
  }

  //delete firestore

  Future<void> deletepost(
      {required String postId, required String posturl}) async {
    try {
      await feedcollection.doc(postId).delete();
      print("came");
    } catch (error) {
      print(error);
    }
  }

  //get all posts
  Future<List<String>> getalluserpostImage({required String userId}) async {
    try {
      final userpost =
          await feedcollection.where("userId", isEqualTo: userId).get().then(
        (snapshot) {
          return snapshot.docs.map(
            (doc) {
              return Post.fromJson(doc.data() as Map<String, dynamic>);
            },
          ).toList();
        },
      );
      return userpost.map((post) => post.posturl).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<int> getUserPostsCount(String userId) async {
    try {
      final snapshot =
          await feedcollection.where('userId', isEqualTo: userId).get();
      return snapshot.size;
    } catch (error) {
      print('Error getting user posts count: $error');
      return 0;
    }
  }
}
