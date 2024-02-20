import 'package:chotot/models/job_item.dart';

class GetAJobModel {
  GetAJobModel(
      {required this.name,
      required this.sumPrice,
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
      required this.service});

  final String name;
  final String sumPrice;
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
  final List<JobItems> service;
}
