import 'package:flutter/material.dart';

class Route {
  final String name;
  final Widget body;
  Route(this.name, this.body);
}

enum Place { east, west, north, sowth, lebanon }

class User {
  final String username;
  final String password;
  final String phoneNumber;
  final String imageBase64;
  final Place place;
  User(this.username, this.password, this.phoneNumber, this.place,
      this.imageBase64);
}
