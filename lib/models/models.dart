import 'dart:typed_data';

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
  final String id;
  final String username;
  final String password;
  final String phoneNumber;
  final Uint8List imageBytes;
  final Place place;
  User(this.id, this.username, this.password, this.phoneNumber, this.place,
      this.imageBytes);

  Map<String, dynamic> toJson() => {
        'ID': id,
        'Username': username,
        'Password': password,
        'PhoneNumber': phoneNumber,
        'imageBytes': imageBytes,
        'Place': place.index
      };

  static User fromMap(Map<String, dynamic> data) {
    return User(
      data['ID'],
      data['Username'],
      data['Password'],
      data.containsKey('Place') ? data['PhoneNumber'] : '',
      data.containsKey('Place')
          ? Place.values[data['Place'] as int]
          : Place.east,
      data.containsKey('Place')
          ? (data['imageBytes'] as Uint8List)
          : Uint8List(0),
    );
  }
}
