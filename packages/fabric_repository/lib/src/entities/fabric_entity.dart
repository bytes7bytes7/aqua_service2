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
  final int? retailPrice;
  final int? purchasePrice;

  FabricEntity.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        title = map['title'] as String,
        retailPrice = map['retailPrice'] as int?,
        purchasePrice = map['purchasePrice'] as int?;

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
