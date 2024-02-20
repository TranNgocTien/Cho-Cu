class AcceptWorkerModel {
  final String id;
  final String jobId;
  final String hostId;
  final String hostName;
  final String employeeId;
  final String employeeName;
  final String description;
  final String createdAt;
  final String status;
  final String contractId;

  AcceptWorkerModel({
    required this.contractId,
    required this.createdAt,
    required this.description,
    required this.employeeId,
    required this.employeeName,
    required this.hostId,
    required this.hostName,
    required this.id,
    required this.jobId,
    required this.status,
  });
}
