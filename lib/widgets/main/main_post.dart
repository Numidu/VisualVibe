import 'package:flutter/material.dart';
import 'package:socially/model/post_model.dart';
import 'package:socially/service/feed/feed_service.dart';
import 'package:socially/views/responsive/utilits/constant/colors.dart';
import 'package:intl/intl.dart';
import 'package:socially/views/responsive/utilits/mode.dart';

class MainPost extends StatefulWidget {
  final Post post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String currentUserId;

  const MainPost(
      {super.key,
      required this.post,
      required this.onEdit,
      required this.onDelete,
      required this.currentUserId});

  @override
  State<MainPost> createState() => _MainPostState();
}

class _MainPostState extends State<MainPost> {
  bool dislike = false;

  //start wenawelawe
  @override
  void initState() {
    super.initState();
    checkuserliked();
  }

  Future<void> checkuserliked() async {
    final hasliked = await FeedService()
        .haslike(postid: widget.post.postId, userid: widget.currentUserId);
    setState(() {
      dislike = hasliked;
      print(dislike);
    });
  }

  //like or dislike
  void likeordislike() async {
    try {
      if (dislike) {
        print("press dislike");
        await FeedService().dislikepost(
            postId: widget.post.postId, userId: widget.currentUserId);
        setState(() {
          dislike = false;
        });
      } else {
        print("press dislike2");
        await FeedService()
            .likepost(postId: widget.post.postId, userId: widget.currentUserId);
        setState(() {
          dislike = true;
        });
      }
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    final formatter =
        DateFormat("dd/MM/yyyy HH:mm").format(widget.post.datePublished);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
          color: webBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ]),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.post.profImage.isEmpty ? '' : widget.post.profImage,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25,
                        color: mainWhiteColor,
                      ),
                    ),
                    // Display the formatted date
                    Text(
                      formatter,
                      style: TextStyle(
                        color: mainWhiteColor.withOpacity(0.4),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              decoration: BoxDecoration(
                color: mainPurpleColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                  "Feeling ${widget.post.mood.name} ${widget.post.mood.emoji}"),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              widget.post.postcaption,
              style: TextStyle(color: mainWhiteColor.withOpacity(0.6)),
            ),
            const SizedBox(
              height: 12,
            ),
            if (widget.post.posturl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.post.posturl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: likeordislike,
                      icon: Icon(
                          dislike ? Icons.favorite : Icons.favorite_border),
                      color: dislike ? Colors.orange : Colors.white,
                    ),
                    Text("${widget.post.likes} likes")
                  ],
                ),
                if (widget.currentUserId == widget.post.pid)
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ListView(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: [
                                  builddialogbox(
                                    context: context,
                                    icon: Icons.edit,
                                    text: "Edit",
                                    onTap: () {},
                                  ),
                                  builddialogbox(
                                    context: context,
                                    icon: Icons.delete,
                                    text: "Delete",
                                    onTap: () {
                                      widget.onDelete();
                                      //close
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.more_vert))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget builddialogbox({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 12,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
