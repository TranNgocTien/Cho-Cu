class WorkerByLocation {
  final String description;
  final String experience;
  final String id;
  final String userId;
  final String ds;
  final String wf;
  final String address;
  final String ccid;
  final CcidImg ccidImg;
  final List<Certificate> certificate;
  final String lat;
  final String lng;
  final String name;

  WorkerByLocation({
    required this.description,
    required this.experience,
    required this.id,
    required this.userId,
    required this.ds,
    required this.wf,
    required this.address,
    required this.ccid,
    required this.ccidImg,
    required this.certificate,
    required this.lat,
    required this.lng,
    required this.name,
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
  final String image;
  Certificate({
    required this.image,
  });
}
