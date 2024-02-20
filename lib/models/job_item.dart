class JobItems {
  final String id;
  final String jobItemId;
  final String version;
  final String v;
  final String description;
  final String fee;
  final String jobserviceId;
  final String name;
  final String price;

  final String unit;
  final String workerId;
  int qt;
  JobItems({
    required this.id,
    required this.jobItemId,
    required this.version,
    required this.v,
    required this.description,
    required this.fee,
    required this.jobserviceId,
    required this.name,
    required this.price,
    required this.unit,
    required this.workerId,
    required this.qt,
  });

  Map<String, dynamic> toJson() => {
        "_id": id,
        "jobitem_id": jobItemId,
        "version": "publish",
        "__v": 0,
        "description": description,
        "fee": fee,
        "jobservice_id": jobserviceId,
        "name": name,
        "price": price,
        "specs": [],
        "unit": unit,
        "worker_id": "THOTHONGMINH",
        "qt": qt
      };
}
