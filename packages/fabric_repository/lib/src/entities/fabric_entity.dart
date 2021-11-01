import 'package:equatable/equatable.dart';

class FabricEntity extends Equatable {
  const FabricEntity({
    required this.id,
    required this.title,
    this.retailPrice,
    this.purchasePrice,
  });

  final int? id;
  final String title;
  final double? retailPrice;
  final double? purchasePrice;

  FabricEntity.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        title = map['title'] as String,
        retailPrice = map['retailPrice'] as double?,
        purchasePrice = map['purchasePrice'] as double?;

  @override
  List<Object?> get props => [id, title, retailPrice, purchasePrice];

  @override
  String toString() {
    return 'FabricEntity {'
        'id: $id, '
        'title: $title, '
        'retailPrice: $retailPrice, '
        'purchasePrice: $purchasePrice'
        '}';
  }

  Map<String, Object?> toMap() {
    return {
      // do not need id
      'title': title,
      'retailPrice': retailPrice,
      'purchasePrice': purchasePrice,
    };
  }
}
