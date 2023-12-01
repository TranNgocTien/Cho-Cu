class Noti {
  Noti({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.time,
    required this.action,
    required this.actionType,
    required this.isRead,
  });
  final String id;
  final String userId;
  final String title;
  final String message;
  final String time;
  final String action;
  final String actionType;
  final String isRead;
}
