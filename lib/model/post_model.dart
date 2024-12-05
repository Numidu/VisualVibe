import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socially/views/responsive/utilits/mode.dart';

class Post {
  final String postId;
  final String postcaption;
  final Mood mood;
  final String userId;
  final String userName;
  final String profImage;
  final int likes;
  final DateTime datePublished;
  final String posturl;
  String pid;

  Post(
      {required this.postId,
      required this.postcaption,
      required this.mood,
      required this.userId,
      required this.userName,
      required this.profImage,
      required this.likes,
      required this.datePublished,
      required this.posturl,
      required this.pid});
  //convert a post instance to json

  Map<String, dynamic> toJson() {
    return {
      "postId": postId,
      "postCaption": postcaption,
      "mood": mood.name,
      "userId": userId,
      "userName": userName,
      "profImage": profImage,
      "likes": likes,
      "datePublished": Timestamp.fromDate(datePublished),
      "postImage": posturl,
    };
  }

  //retriving from fire store
  factory Post.fromJson(Map<String, dynamic> data) {
    return Post(
      postId: data["PostId"] ?? "",
      postcaption: data["postCaption"] ?? "",
      mood: MoodExtention.formString(data["mood"] ?? ""),
      userId: data["userId"] ?? "",
      userName: data["userName"] ?? "",
      profImage: data["profImage"] ?? "",
      likes: data["likes"] ?? 0,
      datePublished: (data["datePublished"] as Timestamp).toDate(),
      posturl: data["postImage"] ?? "",
      pid: data["postId"] ?? "",
    );
  }
}
