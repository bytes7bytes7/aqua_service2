import 'package:equatable/equatable.dart';

class ClientEntity extends Equatable {
  const ClientEntity({
    this.id,
    this.avatarPath,
    required this.name,
    required this.city,
    this.address,
    this.phone,
    this.volume,
    this.previousDate,
    this.nextDate,
    this.images,
    this.comment,
    this.actualTime,
  });

  final int? id;
  final String? avatarPath;
  final String name;
  final String city;
  final String? address;
  final String? phone;
  final String? volume;
  final String? previousDate;
  final String? nextDate;
  final String? images;
  final String? comment;
  final String? actualTime;

  @override
  List<Object?> get props => [
        id,
        avatarPath,
        name,
        city,
        address,
        phone,
        volume,
        previousDate,
        nextDate,
        images,
        comment,
        actualTime,
      ];

  ClientEntity.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        avatarPath = map['avatarPath'] as String?,
        name = map['name'] as String,
        city = map['city'] as String,
        address = map['address'] as String?,
        phone = map['phone'] as String?,
        volume = map['volume'] as String?,
        previousDate = map['previousDate'] as String?,
        nextDate = map['nextDate'] as String?,
        images = map['images'] as String?,
        comment = map['comment'] as String?,
        actualTime = map['actualTime'] as String?;

  @override
  String toString() {
    return 'ClientEntity {'
        'id: $id, '
        'avatarPath: $avatarPath, '
        'name: $name, '
        'city: $city, '
        'address: $address, '
        'phone: $phone, '
        'volume: $volume, '
        'previousDate: $previousDate, '
        'nextDate: $nextDate, '
        'images: $images, '
        'comment: $comment,'
        'actualTime: $actualTime'
        '}';
  }

  Map<String, Object?> toMap({bool archived = false}) {
    return {
      'id': id,
      'avatarPath': avatarPath,
      'name': name,
      'city': city,
      'address': address,
      'phone': phone,
      'volume': volume,
      'previousDate': previousDate,
      'nextDate': nextDate,
      'images': images,
      'comment': comment,
      if (archived) 'actualTime': actualTime,
    };
  }
}
