import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/model/userModel.dart';
import 'package:socially/views/auth_views/loging.dart';
import 'package:socially/views/mainscreen.dart';
import 'package:socially/views/mainscreen/singleuserScreen.dart';
import 'package:socially/views/responsive/mobile_layout.dart';
import 'package:socially/views/responsive/responsive_layout.dart';
import 'package:socially/views/responsive/web_layout.dart';
import 'package:socially/views/auth_views/register.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/register",
    errorPageBuilder: (context, state) {
      return const MaterialPage(
        child: Scaffold(
          body: Center(
            child: Text("This page is not found"),
          ),
        ),
      );
    },
    routes: [
      GoRoute(
        path: "/",
        name: "nav_Layout",
        builder: (context, state) {
          return const ResponsiveLayout(
              mobileLayout: MobileLayout(), webLayout: WebLayout());
        },
      ),
      GoRoute(
        path: "/register",
        name: "register",
        builder: (context, state) {
          return const Register();
        },
      ),
      GoRoute(
        path: "/login",
        name: "login",
        builder: (context, state) {
          return Loging();
        },
      ),
      GoRoute(
        path: "/mainscreen",
        name: "mainscreen",
        builder: (context, state) {
          return const Mainscreen();
        },
      ),
      GoRoute(
        path: "/userprofile",
        name: "userprofile",
        builder: (context, state) {
          UserModel user = state.extra as UserModel;
          return Singleuserscreen(user: user);
        },
      )
    ],
  );
}
