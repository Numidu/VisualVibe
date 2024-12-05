import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socially/model/post_model.dart';
import 'package:socially/service/feed/feed_service.dart';
import 'package:socially/widgets/main/main_post.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});
  Future<void> deleteposts(
      {required String postId, required String posturl}) async {
    FeedService().deletepost(postId: postId, posturl: posturl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FeedService().getPostStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            Text("Fail");
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No posts available"),
            );
          }
          final List<Post> posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final Post = posts[index];
              return Column(
                children: [
                  MainPost(
                      post: Post,
                      onEdit: () {},
                      onDelete: () async {
                        print("delete.press");
                        deleteposts(postId: Post.postId, posturl: Post.posturl);
                      },
                      currentUserId: FirebaseAuth.instance.currentUser!.uid),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
