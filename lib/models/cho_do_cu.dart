class DoCu {
  DoCu(
      {required this.name,
      required this.price,
      required this.description,
      required this.id,
      required this.address,
      required this.province,
      required this.district,
      required this.ward,
      required this.photos,
      required this.phone,
      required this.hostId,
      required this.status,
      required this.createdAt});
  final String createdAt;
  final String name;
  final String price;
  final String description;
  final String id;
  final String address;
  final String province;
  final String district;
  final String ward;
  final List photos;
  final String phone;
  final String hostId;
  final String status;
}
