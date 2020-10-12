class Attendance {
  double presentPercent;
  String totalLectures;
  String presentLecture;

  double percent;
  Attendance(
      {this.percent,
      this.presentPercent,
      this.presentLecture,
      this.totalLectures});

  double getPresentPercent() => presentPercent;
  double getAbsentPercent() => (100 - percent);
  String getTotalLectures() => totalLectures;
  String getPresentLectures() => presentLecture;
  String getAttendanceMessage() {
    double attendance = percent;

    if (attendance == 100) {
      return "God Level! 🙏👑👏";
    }
    if (90 <= attendance) {
      return "I know you love attending classes 😌";
    }
    if (80 <= attendance) {
      return "Safezone! Keep on maintaining\nit! 🌠🌈";
    }
    if (75 <= attendance) {
      return "Pheww...You are Safe ! 👏😁";
    }
    if (65 <= attendance) {
      return "Oh!no...Short Attendance! 😱";
    }
    if (50 <= attendance) {
      return "Daredevil Attend more Classes 😈";
    }
    if (attendance < 50 && attendance != 0) {
      return "Classes are calling attend them 🐱🔥";
    }
    if (attendance == 0) {
      return "Zero-zero is a big score! 🌸";
    }
    return "Attendance Loaded :)";
  }
}
