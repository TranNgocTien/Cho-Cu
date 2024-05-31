import 'package:chotot/models/job_item.dart';

class GetAJobModel {
  GetAJobModel({
    required this.name,
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
    required this.workerId,
    required this.status,
    required this.service,
    required this.workDate,
    required this.contracts,
    required this.employee,
    required this.workers,
    required this.host,
    required this.contract,
    required this.priceId,
    required this.discount,
    required this.movingFee,
    required this.holidayPrice,
    required this.price,
  });
  final String workDate;
  final String workerId;
  final String name;
  final String sumPrice;
  final String movingFee;
  final String price;
  final String discount;
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
  final Employee employee;
  final List<Contracts> contracts;
  final List<WorkerAJob> workers;
  final Contract contract;
  final Host host;
  final String priceId;
  final String holidayPrice;
}

class Employee {
  Employee({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.lat,
    required this.lng,
    required this.profileImage,
  });
  final String id;
  final String name;
  final String phone;
  final String address;
  final String lat;
  final String lng;
  final String profileImage;
}

class Contracts {
  Contracts({
    required this.id,
    required this.jobId,
    required this.contractId,
    required this.jobName,
    required this.hostId,
    required this.hostName,
    required this.employeeId,
    required this.employeeName,
    required this.description,
    required this.createAt,
    required this.status,
  });
  final String id;
  final String jobId;
  final String jobName;
  final String hostId;

  final String hostName;
  final String employeeId;
  final String employeeName;
  final String description;
  final String createAt;
  final String status;
  final String contractId;
}

class WorkerAJob {
  WorkerAJob(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.adress,
      required this.lat,
      required this.lng,
      required this.profileImage,
      required this.ds,
      required this.wf});
  final String id;
  final String name;
  final String phone;
  final String email;
  final String adress;
  final String lat;
  final String lng;
  final String profileImage;
  final String ds;
  final String wf;
}

class Contract {
  Contract({
    required this.id,
    required this.jobId,
    required this.jobName,
    required this.hostId,
    required this.hostName,
    required this.employeeId,
    required this.employeeName,
    required this.contractId,
  });
  final String id;
  final String jobId;
  final String jobName;
  final String hostId;
  final String hostName;
  final String employeeId;
  final String employeeName;
  final String contractId;
}

class Host {
  Host({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.lat,
    required this.lng,
    required this.profileImage,
    required this.phone,
  });
  final String id;
  final String name;
  final String email;
  final String address;
  final String lat;
  final String lng;
  final String phone;
  final String profileImage;
}
