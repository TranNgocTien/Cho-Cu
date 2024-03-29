class JobTypeModel {
  JobTypeModel({
    required this.shortName,
    required this.id,
    required this.item,
    required this.jobtypeId,
    required this.fee,
    required this.name,
  });
  final String shortName;
  final String id;
  final List item;
  final String jobtypeId;
  final String fee;
  final String name;
}
