class WorkerJob {
  final String id;
  final String name;
  final String type;
  final String typeId;
  final String unitPrice;
  final String priceId;
  final String price;
  final String movingFee;
  final String sumPrice;
  final String amount;
  final String hostId;
  final String workerId;
  final String phone;
  final String address;
  final String workDate;
  final String description;
  final String status;
  final List<Services> services;
  final List<dynamic> photos;
  final PriceWorkerJob priceWorkerJob;
  final String jobId;
  WorkerJob({
    required this.id,
    required this.name,
    required this.type,
    required this.typeId,
    required this.unitPrice,
    required this.priceId,
    required this.price,
    required this.movingFee,
    required this.sumPrice,
    required this.amount,
    required this.hostId,
    required this.workerId,
    required this.phone,
    required this.address,
    required this.workDate,
    required this.description,
    required this.status,
    required this.services,
    required this.photos,
    required this.priceWorkerJob,
    required this.jobId,
  });
}

class Services {
  final String id;
  final String jobitemId;
  final String description;
  final String fee;
  final String jobserviceId;
  final String name;
  final String price;
  final String qt;
  final String sum;
  final String unitPrice;

  Services(
      {required this.id,
      required this.jobitemId,
      required this.description,
      required this.fee,
      required this.jobserviceId,
      required this.name,
      required this.price,
      required this.qt,
      required this.sum,
      required this.unitPrice});
}

class PriceWorkerJob {
  final String id;

  final String priceId;
  final String createAt;
  final String discount;

  final String distance;

  PriceWorkerJob({
    required this.id,
    required this.createAt,
    required this.discount,
    required this.distance,
    required this.priceId,
  });
}
