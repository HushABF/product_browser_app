import 'package:equatable/equatable.dart';

class Meta extends Equatable {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String barcode;
  final String qrCode;

  const Meta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    barcode: json['barcode'] as String,
    qrCode: json['qrCode'] as String,
  );

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'barcode': barcode,
    'qrCode': qrCode,
  };

  @override
  List<Object> get props => [createdAt, updatedAt, barcode, qrCode];
}
