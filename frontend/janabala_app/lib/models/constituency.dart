class Constituency {
  Constituency({
    required this.id,
    required this.name,
    required this.code,
    this.district,
    this.state,
  });

  final String id;
  final String name;
  final String code;
  final String? district;
  final String? state;

  factory Constituency.fromApi(Map<String, dynamic> json) {
    return Constituency(
      id: json["id"] as String,
      name: json["name"] as String,
      code: json["code"] as String,
      district: json["district"] as String?,
      state: json["state"] as String?,
    );
  }

  Map<String, dynamic> toDb() => {
        "id": id,
        "name": name,
        "code": code,
        "district": district,
        "state": state,
      };

  factory Constituency.fromDb(Map<String, dynamic> row) => Constituency(
        id: row["id"] as String,
        name: row["name"] as String,
        code: row["code"] as String,
        district: row["district"] as String?,
        state: row["state"] as String?,
      );
}
