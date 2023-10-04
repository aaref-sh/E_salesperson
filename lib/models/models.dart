import 'dart:typed_data';

import 'package:flutter/material.dart';

class Route {
  final String name;
  final Widget body;
  final IconData icon;
  Route(this.name, this.body, this.icon);
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
          ? (Uint8List.fromList(data['imageBytes'].cast<int>().toList()))
          : Uint8List(0),
    );
  }
}

class Commission {
  final String id;
  final int esats;
  final int wests;
  final int norths;
  final int sowths;
  final int lebanons;
  final int commissions;
  final String date;
  final String userId;

  Commission(this.id, this.esats, this.wests, this.norths, this.sowths,
      this.lebanons, this.commissions, this.date, this.userId);

  Map<String, dynamic> toJson() => {
        'id': id,
        'esats': esats,
        'wests': wests,
        'norths': norths,
        'sowths': sowths,
        'lebanons': lebanons,
        'commissions': commissions,
        'date': date,
        'userId': userId,
      };

  Map<String, dynamic> toUpdateJson() => {
        'esats': esats,
        'wests': wests,
        'norths': norths,
        'sowths': sowths,
        'lebanons': lebanons,
        'commissions': commissions,
      };

  static Commission fromMap(Map<String, dynamic> data) {
    return Commission(
        data['id'],
        data['easts'],
        data['wests'],
        data['norths'],
        data['sowths'],
        data['lebanons'],
        data['commissions'],
        data['date'],
        data['userId']);
  }
}
