import 'package:equatable/equatable.dart';

class FabricEntity extends Equatable {
  const FabricEntity({
    this.id,
    required this.title,
    this.retailPrice,
    this.purchasePrice,
    this.actualTime,
  });

  final int? id;
  final String title;
  final int? retailPrice;
  final int? purchasePrice;
  final String? actualTime;

  @override
  List<Object?> get props => [
        id,
        title,
        retailPrice,
        purchasePrice,
        actualTime,
      ];

  FabricEntity.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        title = map['title'] as String,
        retailPrice = map['retailPrice'] as int?,
        purchasePrice = map['purchasePrice'] as int?,
        actualTime = map['actualTime'] as String?;

  @override
  String toString() {
    return 'FabricEntity {'
        'id: $id, '
        'title: $title, '
        'retailPrice: $retailPrice, '
        'purchasePrice: $purchasePrice, '
        'actualTime: $actualTime'
        '}';
  }

  Map<String, Object?> toMap({bool archived = false}) {
    return {
      'id': id,
      'title': title,
      'retailPrice': retailPrice,
      'purchasePrice': purchasePrice,
      if (archived) 'actualTime': actualTime,
    };
  }
}
