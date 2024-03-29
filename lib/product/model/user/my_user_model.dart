import 'package:json_annotation/json_annotation.dart';

import '../../../core/model/base_model/base_model.dart';

part 'my_user_model.g.dart';

@JsonSerializable()
class MyUser implements BaseModel {
  String? email;
  String? name;
  bool? isBackUpActive;
  String? backUpType;
  @JsonKey(ignore: true)
  DateTime? updatedAt;
  int? level;

  MyUser(
      {this.email,
      this.name,
      this.isBackUpActive = false,
      this.backUpType = "never",
      this.updatedAt,
      this.level});

  factory MyUser.fromJson(Map<String, dynamic> json) => _$MyUserFromJson(json);

  @override
  fromJson(Map<String, dynamic> json) => _$MyUserFromJson(json);

  @override
  Map<String, Object?> toJson() => _$MyUserToJson(this);
}
