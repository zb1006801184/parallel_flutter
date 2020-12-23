class DateUnitls {
  static String secondChangeDate(double time) {
    if (time == null) {
      return '0:00';
    }
    if (time >= 60.0) {
      return '1:00';
    }
    if (time >=10.0) {
      return '0:${time.toInt()}';
    }
    return '0:0${time.toInt()}';
  }
}
