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
  Huser({
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.gender,
    @required this.phone,
    @required this.depart,
    @required this.yr,
    @required this.section,
  });

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
    };
  }

  factory Huser.fromMap(Map<String, dynamic> map) {
    return Huser(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      gender: map['gender'],
      phone: map['phone'],
      depart: map['depart'],
      yr: map['yr'],
      section: map['section'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Huser.fromJson(String source) => Huser.fromMap(json.decode(source));
}
