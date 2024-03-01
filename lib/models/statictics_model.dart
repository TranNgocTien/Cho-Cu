class StatisticsModels {
  final String jobs;
  final String workers;
  final List<WorkersByType> workerTypeList;
  StatisticsModels({
    required this.jobs,
    required this.workerTypeList,
    required this.workers,
  });
}

class WorkersByType {
  final String name;
  final String amount;
  WorkersByType({
    required this.amount,
    required this.name,
  });
}
