import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socially/model/userModel.dart';
import 'package:socially/service/feed/feed_service.dart';
import 'package:socially/service/users/userservice.dart';
import 'package:socially/widgets/reusable/custombuttom.dart';

class Singleuserscreen extends StatefulWidget {
  final UserModel user;
  const Singleuserscreen({super.key, required this.user});

  @override
  State<Singleuserscreen> createState() => _SingleuserscreenState();
}

class _SingleuserscreenState extends State<Singleuserscreen> {
  late Future<List<String>> _userPosts;
  late Future<bool> _isFollowing;
  late UserService _userservice;
  late String _currentUserId;

  @override
  void initState() {
    super.initState();
    _userservice = UserService();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _userPosts = FeedService().getalluserpostImage(userId: widget.user.userId);
    _isFollowing = _userservice.isFollowing(
        currentuserid: _currentUserId, userTochecked: widget.user.userId);
  }

  //follow and unfollow
  Future<void> _toggleFollow() async {
    try {
      final isFollowing = await _isFollowing;
      if (isFollowing) {
        await _userservice.unflowwer(
          currentuserId: _currentUserId,
          userunflowwedId: widget.user.userId,
        );
        setState(() {
          _isFollowing = Future.value(false);
        });
      } else {
        await _userservice.followeruser(
            currentuserId: _currentUserId, userfolowwedId: widget.user.userId);
        setState(() {
          _isFollowing = Future.value(true);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("singe user page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: widget.user.imageUrl.isNotEmpty
                      ? NetworkImage(widget.user.imageUrl)
                      : const AssetImage('') as ImageProvider,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.user.jobTitle,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (widget.user.userId != _currentUserId)
              FutureBuilder<bool>(
                future: _isFollowing,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return const Text('Error checking follow status');
                  }
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  final isFollowing = snapshot.data!;
                  return Custombuttom(
                    onpressed: _toggleFollow,
                    width: MediaQuery.of(context).size.width,
                    text: isFollowing ? 'Unfollow' : 'Follow',
                  );
                },
              ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<String>>(
                  future: _userPosts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading posts'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No posts available'));
                    }

                    final postImages = snapshot.data!;

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: postImages.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          postImages[index],
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
