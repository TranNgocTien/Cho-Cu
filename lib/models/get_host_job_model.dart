import 'package:chotot/models/job_item.dart';

class HostJob {
  final String id;
  final String jobId;
  final String name;
  final String type;
  final String price;
  final String address;
  final String workDate;
  final String workHour;
  final String description;
  final JobItems service;
  final List<dynamic> photos;
  final String status;
  final PriceHostJob priceHostJob;
  final String jobServiceId;
  HostJob({
    required this.id,
    required this.jobId,
    required this.name,
    required this.type,
    required this.price,
    required this.address,
    required this.workDate,
    required this.description,
    required this.service,
    required this.photos,
    required this.status,
    required this.workHour,
    required this.priceHostJob,
    required this.jobServiceId,
  });
}

class PriceHostJob {
  final String id;

  final String priceId;
  final String createAt;
  final String discount;

  final String distance;

  PriceHostJob({
    required this.id,
    required this.createAt,
    required this.discount,
    required this.distance,
    required this.priceId,
  });
}
