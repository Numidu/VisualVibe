import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/model/userModel.dart';
import 'package:socially/service/users/userservice.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<UserModel> _users = [];
  List<UserModel> filterusers = [];

  Future<void> fetchAllUsers() async {
    try {
      final List<UserModel> users = await UserService().getallusers();
      setState(() {
        _users = users;
        filterusers = users;
      });
    } catch (e) {
      print(e);
    }
  }

//serch

  void _searchUsers(String query) {
    setState(() {
      filterusers = _users
          .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final inputboderstyle = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: Divider.createBorderSide(context));
    return Scaffold(
      appBar: AppBar(
        title: Text("users"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                border: inputboderstyle,
                focusedBorder: inputboderstyle,
                enabledBorder: inputboderstyle,
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
              ),
              onChanged: _searchUsers,
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: filterusers.length,
                itemBuilder: (context, index) {
                  final UserModel user = filterusers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.imageUrl.isNotEmpty
                          ? NetworkImage(user.imageUrl)
                          : const AssetImage("assets/logo.png")
                              as ImageProvider,
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.jobTitle),
                    onTap: () {
                      GoRouter.of(context).push("/userprofile", extra: user);
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
