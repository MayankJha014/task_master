import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String uniqueId;
  final String displayName;
  final String email;
  final int mobile;
  final String? profilePicture;
  final String? token;
  final String? deviceToken;
  final List<String> followers;
  final List<String> following;
  final String createdAt;
  User({
    required this.id,
    required this.uniqueId,
    required this.displayName,
    required this.email,
    required this.mobile,
    required this.profilePicture,
    this.token,
    this.deviceToken,
    required this.followers,
    required this.following,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'uniqueId': uniqueId,
      'displayName': displayName,
      'email': email,
      'mobile': mobile,
      'profilePicture': profilePicture,
      'token': token,
      'deviceToken': deviceToken,
      'followers': followers,
      'following': following,
      'createdAt': createdAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      uniqueId: map['uniqueId'] as String,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      mobile: map['mobile'] ?? 0,
      profilePicture: map['profilePicture'] != null
          ? map['profilePicture'] as String
          : null,
      token: map['token'] != null ? map['token'] as String : null,
      deviceToken:
          map['deviceToken'] != null ? map['deviceToken'] as String : null,
      followers: List<String>.from((map['followers'] ?? [''])),
      following: List<String>.from((map['following'] ?? [''])),
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? id,
    String? uniqueId,
    String? displayName,
    String? email,
    int? mobile,
    String? profilePicture,
    String? token,
    String? deviceToken,
    List<String>? followers,
    List<String>? following,
    String? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      uniqueId: uniqueId ?? this.uniqueId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      profilePicture: profilePicture ?? this.profilePicture,
      token: token ?? this.token,
      deviceToken: deviceToken ?? this.deviceToken,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
