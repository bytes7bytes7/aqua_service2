class Client {
  Client({
    this.id,
    this.avatarPath,
    this.name = '',
    this.city = '',
    this.address = '',
    this.phone = '',
    this.volume = '',
    this.previousDate = '',
    this.nextDate = '',
    this.images,
    this.comment = '',
  });

  int? id;
  String? avatarPath;
  String name;
  String city;
  String address;
  String phone;
  String volume;
  String previousDate;
  String nextDate;
  List<String>? images;
  String comment;
}
