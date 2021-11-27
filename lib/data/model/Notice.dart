import 'dart:convert';

class Notice {
  String title;
  String date;
  String link;
  String credit;
  bool tp;
  Notice({
    this.title,
    this.date,
    this.link,
    this.credit,
    this.tp,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'link': link,
      'credit': credit,
      'tp': tp,
    };
  }

  factory Notice.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Notice(
      title: map['title'],
      date: map['date'],
      link: map['link'],
      credit: map['credit'],
      tp: map['tp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Notice.fromJson(String source) => Notice.fromMap(json.decode(source));
}
