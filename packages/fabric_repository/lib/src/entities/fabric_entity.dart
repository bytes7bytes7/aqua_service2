import 'package:equatable/equatable.dart';

class FabricEntity extends Equatable {
  const FabricEntity({
    this.id,
    required this.title,
    this.retailPrice,
    this.purchasePrice,
    this.expiredTime,
  });

  final int? id;
  final String title;
  final int? retailPrice;
  final int? purchasePrice;
  final String? expiredTime;

  @override
  List<Object?> get props => [
        id,
        title,
        retailPrice,
        purchasePrice,
    expiredTime,
      ];

  FabricEntity.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        title = map['title'] as String,
        retailPrice = map['retailPrice'] as int?,
        purchasePrice = map['purchasePrice'] as int?,
        expiredTime = map['expiredTime'] as String?;

  @override
  String toString() {
    return 'FabricEntity {'
        'id: $id, '
        'title: $title, '
        'retailPrice: $retailPrice, '
        'purchasePrice: $purchasePrice, '
        'expiredTime: $expiredTime'
        '}';
  }

  Map<String, Object?> toMap({bool archived = false}) {
    return {
      'id': id,
      'title': title,
      'retailPrice': retailPrice,
      'purchasePrice': purchasePrice,
      if (archived) 'expiredTime': expiredTime,
    };
  }
}
