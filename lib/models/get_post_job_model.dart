class PostJob {
  final Job job;
  final String contract;
  final List rate;
  final Host host;
  final dynamic employee;
  final List<Contracts> contracts;
  final List<WorkersPostJob> workers;

  PostJob({
    required this.job,
    required this.contract,
    required this.contracts,
    required this.employee,
    required this.host,
    required this.rate,
    required this.workers,
  });
}

class Job {
  final String name;
  final String id;
  final String price;
  final String discount;
  final String movingFee;
  final String amount;

  final String hostId;
  final String phone;
  final String address;
  final int workDate;
  final String workHour;
  final String duration;
  final String discription;
  final String status;
  final List<Service> services;
  final String voucher;
  final String createdAt;
  final String jobId;
  final String updatedAt;
  final String v;
  final List<dynamic> photos;
  final String workerFee;
  final String agentBonus;
  final String sumPrice;
  final String agentVoucher;
  final String agentVoucherBonus;
  final String description;
  final String workerId;
  final Prices prices;
  Job({
    required this.prices,
    required this.sumPrice,
    required this.name,
    required this.id,
    required this.price,
    required this.address,
    required this.agentBonus,
    required this.amount,
    required this.createdAt,
    required this.discount,
    required this.discription,
    required this.duration,
    required this.hostId,
    required this.jobId,
    required this.movingFee,
    required this.phone,
    required this.photos,
    required this.services,
    required this.status,
    required this.updatedAt,
    required this.v,
    required this.voucher,
    required this.workDate,
    required this.workHour,
    required this.workerFee,
    required this.agentVoucher,
    required this.agentVoucherBonus,
    required this.description,
    required this.workerId,
  });
}

class Service {
  final String description;
  final String code;
  final int qt;
  final String sum;
  final String unitPrice;
  final String name;
  Service({
    required this.name,
    required this.description,
    required this.code,
    required this.qt,
    required this.sum,
    required this.unitPrice,
  });
}

class Host {
  final String id;

  final String name;

  final String phone;

  final String email;
  final String address;
  final String lat;

  final String lng;
  final String profileImage;

  Host({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.lat,
    required this.lng,
    required this.profileImage,
  });
}

class Contracts {
  final String id;
  final String jobId;
  final String jobName;
  final String hostId;
  final String hostName;
  final String employeeId;
  final String employeeName;
  final String description;
  final String createdAt;
  final String status;

  final String contractId;
  final String updatedAt;
  final String v;
  Contracts({
    required this.id,
    required this.contractId,
    required this.createdAt,
    required this.description,
    required this.employeeId,
    required this.employeeName,
    required this.hostId,
    required this.hostName,
    required this.jobId,
    required this.jobName,
    required this.status,
    required this.updatedAt,
    required this.v,
  });
}

class WorkersPostJob {
  final String id;
  final String profileImg;
  final String address;
  final String email;
  final String phone;
  final String name;
  final String lat;
  final String lng;
  final String ds;
  final String wf;

  WorkersPostJob({
    required this.id,
    required this.ds,
    required this.wf,
    required this.address,
    required this.email,
    required this.lat,
    required this.lng,
    required this.name,
    required this.phone,
    required this.profileImg,
  });
}

class Prices {
  final String id;
  final String priceId;

  Prices({
    required this.id,
    required this.priceId,
  });
}
