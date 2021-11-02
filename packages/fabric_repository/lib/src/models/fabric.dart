import '../entities/entities.dart';

class Fabric {
  Fabric({
    this.id,
    String? title,
    double? retailPrice,
    double? purchasePrice,
  })  : title = title ?? '',
        retailPrice = retailPrice ?? 0.0,
        purchasePrice = purchasePrice ?? 0.0;

  int? id;
  String title;
  double retailPrice;
  double purchasePrice;

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        retailPrice.hashCode ^
        purchasePrice.hashCode;
  }

  Fabric.from(Fabric other)
      : id = other.id,
        title = other.title,
        retailPrice = other.retailPrice,
        purchasePrice = other.purchasePrice;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Fabric &&
            id == other.id &&
            title == other.title &&
            retailPrice == other.retailPrice &&
            purchasePrice == other.purchasePrice;
  }

  @override
  String toString() {
    return 'Fabric {'
        'id: $id, '
        'title: $title, '
        'retailPrice: $retailPrice, '
        'purchasePrice: $purchasePrice'
        '}';
  }

  FabricEntity toEntity() {
    return FabricEntity(
      id: id,
      title: title,
      retailPrice: retailPrice != 0 ? retailPrice : null,
      purchasePrice: purchasePrice != 0 ? purchasePrice : null,
    );
  }

  static Fabric fromEntity(FabricEntity entity) {
    return Fabric(
      id: entity.id,
      title: entity.title,
      retailPrice: entity.retailPrice,
      purchasePrice: entity.purchasePrice,
    );
  }
}
