class Attendance {
  double? presentPercent;
  String? totalLectures;
  String? presentLecture;
  String? sipPresentClasses;
  String? sipTotalClasses;
  String? sessionalPresent;
  String? sessionalTotal;
  String? extra;
  String? cummulativeTotalLectures;

  double? percent;
  Attendance(
      {this.percent,
      this.presentPercent,
      this.presentLecture,
      this.totalLectures,
      this.sipPresentClasses,
      this.sipTotalClasses,
      this.sessionalPresent,
      this.sessionalTotal,
      this.cummulativeTotalLectures,
      this.extra});

  double? getPresentPercent() => presentPercent;
  double getAbsentPercent() => (100 - percent!);
  String? getTotalLectures() {
    return totalLectures;
  }

  String getPresentLectures() {
    if (presentLecture!.toLowerCase().contains('extra'))
      return presentLecture!.split('=')[1].split(':')[1].replaceAll(")", "");
    else
      return presentLecture!.split(":")[1].replaceAll(")", "");
  }

  void setCummulativeAttendance() {
    int ex = (int.tryParse(extra!) ?? 0);
    int pl = (int.tryParse(presentLecture!) ?? 0);
    cummulativeTotalLectures = (ex + pl).toString();
  }

  String getAttendanceMessage() {
    double attendance = percent!;
    if (attendance > 100) {
      return "This feels like illegal :)";
    }
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

  @override
  String toString() {
    return 'Attendance(presentPercent: $presentPercent, totalLectures: $totalLectures, presentLecture: $presentLecture, sipPresentClasses: $sipPresentClasses, sipTotalClasses: $sipTotalClasses, sessionalPresent: $sessionalPresent, sessionalTotal: $sessionalTotal, extra: $extra, cummulativeTotalLectures: $cummulativeTotalLectures, percent: $percent)';
  }
}
