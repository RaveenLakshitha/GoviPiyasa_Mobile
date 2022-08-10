class Location {
  Location({
    this.locId,
    this.locX,
    this.locY,
    this.locInfo,
    this.locSpd,
    this.locDate,
  });
  String locId;
  String locX;
  String locY;
  String locInfo;
  String locSpd;
  String locDate;
  factory Location.fromJson(Map<String, dynamic> json) => Location(
    locId: json['loc_id'],
    locX: json['loc_x'],
    locY: json['loc_y'],
    locInfo: json['loc_info'],
    locSpd: json['loc_spd'],
    locDate: json['loc_date'],
  );
  Map<String, dynamic> toJson() => {
    'loc_id': locId,
    'loc_x': locX,
    'loc_y': locY,
    'loc_info': locInfo,
    'loc_spd': locSpd,
    'loc_date': locDate,
  };
}