import 'package:client_repository/src/entities/client_entity.dart';

class Client {
  Client({
    this.id,
    String? avatarPath,
    String? name,
    String? city,
    String? address,
    String? phone,
    String? volume,
    String? previousDate,
    String? nextDate,
    List<String>? images,
    String? comment,
  })  : avatarPath = avatarPath ?? '',
        name = name ?? '',
        city = city ?? '',
        address = address ?? '',
        phone = phone ?? '',
        volume = volume ?? '',
        previousDate = previousDate ?? '',
        nextDate = nextDate ?? '',
        images = images ?? [],
        comment = comment ?? '';

  int? id;
  String avatarPath;
  String name;
  String city;
  String address;
  String phone;
  String volume;
  String previousDate;
  String nextDate;
  List<String> images;
  String comment;

  @override
  int get hashCode {
    return id.hashCode ^
        avatarPath.hashCode ^
        name.hashCode ^
        city.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        volume.hashCode ^
        previousDate.hashCode ^
        nextDate.hashCode ^
        images.hashCode ^
        comment.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Client &&
            id == other.id &&
            avatarPath == other.avatarPath &&
            name == other.name &&
            city == other.city &&
            address == other.address &&
            phone == other.phone &&
            volume == other.volume &&
            previousDate == other.previousDate &&
            nextDate == other.nextDate &&
            images == other.images &&
            comment == other.comment;
  }

  @override
  String toString() {
    return 'Client {id : $id, avatarPath : $avatarPath, name : $name, city : $city, address : $address, phone : $phone, volume : $volume, previousDate : $previousDate, nextDate : $nextDate, images : $images, comment : $comment}';
  }

  ClientEntity? toEntity() {
    return ClientEntity(
      id: id,
      avatarPath: avatarPath,
      name: name,
      city: city,
      address: address,
      phone: phone,
      volume: volume,
      previousDate: previousDate,
      nextDate: nextDate,
      images: images,
      comment: comment,
    );
  }

  static Client fromEntity(ClientEntity entity) {
    return Client(
      id: entity.id,
      avatarPath: entity.avatarPath,
      name: entity.name,
      city: entity.city,
      address: entity.address,
      phone: entity.phone,
      volume: entity.volume,
      previousDate: entity.previousDate,
      nextDate: entity.nextDate,
      images: entity.images,
      comment: entity.comment,
    );
  }
}
