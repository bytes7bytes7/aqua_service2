import '../entities/entities.dart';

class Fabric {
  Fabric({
    this.id,
    String? title,
    int? retailPrice,
    int? purchasePrice,
    this.expiredTime,
  })  : title = title ?? '',
        retailPrice = retailPrice ?? 0,
        purchasePrice = purchasePrice ?? 0;

  int? id;
  String title;
  int retailPrice;
  int purchasePrice;
  DateTime? expiredTime;

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        retailPrice.hashCode ^
        purchasePrice.hashCode ^
    expiredTime.hashCode;
  }

  Fabric.from(Fabric other)
      : id = other.id,
        title = other.title,
        retailPrice = other.retailPrice,
        purchasePrice = other.purchasePrice,
        expiredTime = other.expiredTime;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Fabric &&
            id == other.id &&
            title == other.title &&
            retailPrice == other.retailPrice &&
            purchasePrice == other.purchasePrice &&
            expiredTime == other.expiredTime;
  }

  @override
  String toString() {
    return 'Fabric {'
        'id: $id, '
        'title: $title, '
        'retailPrice: $retailPrice, '
        'purchasePrice: $purchasePrice, '
        'expiredTime: $expiredTime'
        '}';
  }

  FabricEntity toEntity() {
    return FabricEntity(
      id: id,
      title: title,
      retailPrice: retailPrice != 0 ? retailPrice : null,
      purchasePrice: purchasePrice != 0 ? purchasePrice : null,
      expiredTime: expiredTime?.toString(),
    );
  }

  static Fabric fromEntity(FabricEntity entity) {
    return Fabric(
      id: entity.id,
      title: entity.title,
      retailPrice: entity.retailPrice,
      purchasePrice: entity.purchasePrice,
      expiredTime:
          entity.expiredTime != null ? DateTime.parse(entity.expiredTime!) : null,
    );
  }
}
