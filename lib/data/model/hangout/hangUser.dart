import 'dart:convert';

import 'package:flutter/material.dart';

class Huser {
  String id;
  String name;
  String email;
  String gender;
  String phone;
  String depart;
  String yr;
  String section;
  bool isBanned;
  List<String> likes = [];
  Huser(
      {@required this.id,
      @required this.name,
      @required this.email,
      @required this.gender,
      @required this.phone,
      @required this.depart,
      @required this.yr,
      @required this.section,
      @required this.likes,
      this.isBanned = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'phone': phone,
      'depart': depart,
      'yr': yr,
      'section': section,
      'isBanned': isBanned,
      'likes': likes
    };
  }

  factory Huser.fromMap(Map<dynamic, dynamic> map) {
    return Huser(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      gender: map['gender'],
      phone: map['phone'],
      depart: map['depart'],
      yr: map['yr'],
      section: map['section'],
      isBanned: map['isBanned'],
      likes: map['likes'] != null ? List<String>.from(map['likes']) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Huser.fromJson(String source) => Huser.fromMap(json.decode(source));
}
