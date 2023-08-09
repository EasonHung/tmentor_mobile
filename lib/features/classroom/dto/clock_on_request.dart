class ClockOnRequest {
  String classId;
  int clockTime;

  ClockOnRequest(this.classId, this.clockTime);

  Map<String, dynamic> toJson() {
    return {
      "classId": classId,
      "age": clockTime
    };
  }
}