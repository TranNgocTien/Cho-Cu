class Rate {
  final String id;
  final String contractId;
  final String type;

  final String content;
  final String d1;
  final String d2;
  final String d3;
  final String d4;
  final String d5;
  final String ds;
  final String hostId;
  final String jobId;
  final String time;
  final String workerId;

  Rate({
    required this.id,
    required this.contractId,
    required this.type,
    required this.content,
    required this.d1,
    required this.d2,
    required this.d3,
    required this.d4,
    required this.d5,
    required this.ds,
    required this.hostId,
    required this.jobId,
    required this.time,
    required this.workerId,
  });
}

class Contract {
  final String jobId;
  final String jobName;
  final String hostId;
  final String hostName;
  final String employeeId;
  final String employeeName;
  final String contractId;
  final String createdAt;
  Contract({
    required this.jobId,
    required this.jobName,
    required this.hostId,
    required this.hostName,
    required this.employeeId,
    required this.employeeName,
    required this.contractId,
    required this.createdAt,
  });
}
