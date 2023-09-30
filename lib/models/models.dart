import 'package:flutter/material.dart';

class Route {
  final String name;
  final Widget body;
  Route(this.name, this.body);
}

enum Place { east, west, north, sowth, lebanon }

var placeLabel = <String>[
  'المنطقة الشرقية',
  'المنطقة الساحلية',
  'المنقطة الجنوبية',
  'المنطقة الشمالية',
  'لبنان'
];

class User {
  final String username;
  final String password;
  final String phoneNumber;
  final String imageBase64;
  final Place place;
  User(this.username, this.password, this.phoneNumber, this.place,
      this.imageBase64);

  Map<String, dynamic> toJson() => {
        'Username': username,
        'Password': password,
        'PhoneNumber': phoneNumber,
        'ImageBase64': imageBase64,
        'Place': place.index
      };

  static User fromMap(Map<String, dynamic> data) {
    return User(
      data['Username'],
      data['Password'],
      data['PhoneNumber'],
      Place.values[data['Place'] as int],
      data['ImageBase64'],
    );
  }
}
