import 'dart:convert';

class Huser {
  String? id;
  String? name;
  String? email;
  String? gender;
  String? phone;
  String? depart;
  String? yr;
  String? section;
  String? profile;
  bool? isBanned;
  AddtionalUserInfo? addtionalUserInfo;
  List<String> likes = [];
  Huser(
      {required this.id,
      required this.name,
      required this.email,
      required this.gender,
      required this.phone,
      required this.depart,
      required this.yr,
      required this.section,
      required this.likes,
      this.addtionalUserInfo,
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
      'likes': likes,
      'additionalUserInfo': addtionalUserInfo?.toMap() ?? {},
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
        addtionalUserInfo: map['additionalUserInfo'] != null
            ? AddtionalUserInfo.fromMap(map['additionalUserInfo'])
            : null);
  }

  String toJson() => json.encode(toMap());

  factory Huser.fromJson(String source) => Huser.fromMap(json.decode(source));
}

class AddtionalUserInfo {
  String? profileImg;
  String? bio;
  String? insta;
  String? snapchat;
  AddtionalUserInfo({
    this.profileImg,
    this.bio,
    this.insta,
    this.snapchat,
  });

  Map<String, dynamic> toMap() {
    return {
      'profileImg': profileImg,
      'bio': bio,
      'insta': insta,
      'snapchat': snapchat,
    };
  }

  factory AddtionalUserInfo.fromMap(Map<String, dynamic> map) {
    return AddtionalUserInfo(
      profileImg: map['profileImg'],
      bio: map['bio'],
      insta: map['insta'],
      snapchat: map['snapchat'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddtionalUserInfo.fromJson(String source) =>
      AddtionalUserInfo.fromMap(json.decode(source));
}
