import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/app_user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String uid,
    required String username,
    required String email,
    required String displayName,
    String? photoUrl,
    required DateTime createdAt,
    String? fcmToken,
    @Default('user') String role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({
      'uid': doc.id,
      ...data,
      'createdAt':
          (data['createdAt'] as Timestamp).toDate().toIso8601String(),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('uid');
    json['createdAt'] = Timestamp.fromDate(createdAt);
    return json;
  }

  AppUser toEntity() => AppUser(
        uid: uid,
        username: username,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        createdAt: createdAt,
        fcmToken: fcmToken,
        role: role,
      );

  factory UserModel.fromEntity(AppUser user) => UserModel(
        uid: user.uid,
        username: user.username,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        createdAt: user.createdAt,
        fcmToken: user.fcmToken,
        role: user.role,
      );
}
