import '../entities/entities.dart';

class Fabric {
  Fabric({
    this.id,
    String? title,
    int? retailPrice,
    int? purchasePrice,
    this.actualTime,
  })  : title = title ?? '',
        retailPrice = retailPrice ?? 0,
        purchasePrice = purchasePrice ?? 0;

  int? id;
  String title;
  int retailPrice;
  int purchasePrice;
  DateTime? actualTime;

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        retailPrice.hashCode ^
        purchasePrice.hashCode ^
        actualTime.hashCode;
  }

  Fabric.from(Fabric other)
      : id = other.id,
        title = other.title,
        retailPrice = other.retailPrice,
        purchasePrice = other.purchasePrice,
        actualTime = other.actualTime;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Fabric &&
            id == other.id &&
            title == other.title &&
            retailPrice == other.retailPrice &&
            purchasePrice == other.purchasePrice &&
            actualTime == other.actualTime;
  }

  @override
  String toString() {
    return 'Fabric {'
        'id: $id, '
        'title: $title, '
        'retailPrice: $retailPrice, '
        'purchasePrice: $purchasePrice, '
        'actualTime: $actualTime'
        '}';
  }

  FabricEntity toEntity() {
    return FabricEntity(
      id: id,
      title: title,
      retailPrice: retailPrice != 0 ? retailPrice : null,
      purchasePrice: purchasePrice != 0 ? purchasePrice : null,
      actualTime: actualTime?.toString(),
    );
  }

  static Fabric fromEntity(FabricEntity entity) {
    return Fabric(
      id: entity.id,
      title: entity.title,
      retailPrice: entity.retailPrice,
      purchasePrice: entity.purchasePrice,
      actualTime:
          entity.actualTime != null ? DateTime.parse(entity.actualTime!) : null,
    );
  }
}
