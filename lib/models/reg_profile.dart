class RegProfile {
  final String id;
  final String userId;
  final String address;
  final String ccid;
  final List<CcidImage> ccidList;
  final List<Cert> certList;
  final String description;
  final String experience;
  final String lat;
  final String lng;
  final String name;
  final String regId;
  final String status;
  final String time;
  final String type;
  final String workerType;
  final String avatar;
  const RegProfile({
    required this.avatar,
    required this.id,
    required this.userId,
    required this.address,
    required this.ccid,
    required this.ccidList,
    required this.description,
    required this.experience,
    required this.lat,
    required this.lng,
    required this.name,
    required this.regId,
    required this.status,
    required this.time,
    required this.type,
    required this.certList,
    required this.workerType,
  });
}

class CcidImage {
  final String name;
  String img;
  CcidImage({required this.name, required this.img});
}

class Cert {
  final String name;
  String img;
  Cert({required this.name, required this.img});
}
