class User {
  final String id;
  final String name;
  final String phone;
  final String ccid;
  final String email;
  final String emailAuthen;
  final String address;
  final String lat;
  final String lng;
  final String wf;
  final String profileImage;
  final String type;
  final String joinDate;
  final String phoneAuthen;
  final String workerAuthen;
  final String documentStatus;
  final String salt;
  final String checksum;
  final String createdAt;
  final String password;
  final String wallet;

  const User(
      {required this.id,
      required this.name,
      required this.phone,
      required this.ccid,
      required this.email,
      required this.emailAuthen,
      required this.address,
      required this.lat,
      required this.lng,
      required this.wf,
      required this.profileImage,
      required this.type,
      required this.joinDate,
      required this.phoneAuthen,
      required this.workerAuthen,
      required this.documentStatus,
      required this.salt,
      required this.checksum,
      required this.createdAt,
      required this.password,
      required this.wallet});
}

class WorkerAUser {
  final String id;
  final String userId;
  final dynamic ds;
  final dynamic wf;
  final String address;
  final String agent;
  final String ccid;
  final CcidImg ccidImg;
  final List<Certificate> certificate;

  // final List<Certificates> certificates;
  final String cost;
  final String description;
  final String experience;
  final String name;
  final String workerLevel;
  final List<dynamic> workerType;

  WorkerAUser({
    required this.id,
    required this.userId,
    required this.ds,
    required this.wf,
    required this.address,
    required this.agent,
    required this.ccid,
    required this.ccidImg,
    required this.certificate,
    // required this.certificates,
    required this.cost,
    required this.description,
    required this.experience,
    required this.name,
    required this.workerLevel,
    required this.workerType,
  });
}

class CcidImg {
  final String truoc;
  final String sau;
  CcidImg({
    required this.truoc,
    required this.sau,
  });
}

class Certificate {
  final String img;

  Certificate({
    required this.img,
  });
}

class Certificates {
  final String img;

  Certificates({
    required this.img,
  });
}

class AUser {
  final User user;
  final WorkerAUser worker;
  AUser({
    required this.user,
    required this.worker,
  });
}
