// To parse this JSON data, do
//
//     final ResponseImageEntity = ResponseImageEntityFromJson(jsonString);

//  String? uuid;

import 'dart:convert';

List<ResponseImageEntity> responseImageEntityFromJson(String str) =>
    List<ResponseImageEntity>.from(
        json.decode(str).map((x) => ResponseImageEntity.fromJson(x)));

List<ResponseImageEntity> responseImageEntityFromJsonVersion2(String str) =>
    List<ResponseImageEntity>.from(
        json.decode(str).map((x) => ResponseImageEntity.fromJsonVersion2(x)));

String responseImageEntityToJson(List<ResponseImageEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResponseImageEntity {
  DateTime? createdAt;
  dynamic error;
  String? id;
  List<String>? output;
  String? status;
  String? uuid;

  ResponseImageEntity({
    this.createdAt,
    this.error,
    this.id,
    this.output,
    this.status,
    this.uuid,
  });

  ResponseImageEntity copyWith({
    DateTime? completedAt,
    DateTime? createdAt,
    dynamic error,
    String? id,
    List<String>? output,
    String? status,
    String? uuid,
  }) =>
      ResponseImageEntity(
        createdAt: createdAt ?? this.createdAt,
        error: error ?? this.error,
        id: id ?? this.id,
        output: output ?? this.output,
        status: status ?? this.status,
        uuid: uuid ?? this.uuid,
      );

  factory ResponseImageEntity.fromJson(Map<String, dynamic> json) =>
      ResponseImageEntity(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        error: json["error"],
        id: json["id"],
        output: json["output"] == null
            ? []
            : List<String>.from(json["output"]!.map((x) => x)),
        status: json["status"],
        uuid: json["uuid"],
      );

  factory ResponseImageEntity.fromJsonVersion2(Map<String, dynamic> json) =>
      ResponseImageEntity(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        error: json["error"],
        id: json["id"],
        output: json["output"] == null
            ? []
            : jsonDecode(json["output"]).cast<String>(),
        status: json["status"],
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "error": error,
        "id": id,
        "output":
            output == null ? [] : List<dynamic>.from(output!.map((x) => x)),
        "status": status,
        "uuid": uuid,
      };
}
