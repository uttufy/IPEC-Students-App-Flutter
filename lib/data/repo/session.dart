import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:ipecstudents/data/model/Attendance.dart';
import 'package:ipecstudents/data/service/webClientService.dart';

enum AttendanceStatus { Init, Loaded, Loading, Error }

class Session extends ChangeNotifier {
  Attendance _attendance = Attendance();
  String _attendanceBody;
  WebClientService webClientService = WebClientService();
  List graph = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List graphDays = [];
  AttendanceStatus attendanceStatus = AttendanceStatus.Init;

  get attendance => _attendance;

  List parseTable(String tableHtml) {
    List<double> record = List<double>();
    List<String> days = List<String>();
    String element;
    String element2;
    var document = parse(tableHtml);
    String changedHtml =
        document.querySelector("#ContentPlaceHolder1_GridView1").outerHtml;
    if (changedHtml != null) {
      Document table = parse(changedHtml);
      var rows = table.querySelectorAll('tr');
      if (rows != null) {
        var query;
        var query2;
        for (int i = 3; i < rows.length - 3; i++) {
          query =
              "tbody > tr:nth-child(" + i.toString() + ") > td:nth-child(12)";
          query2 =
              "tbody > tr:nth-child(" + i.toString() + ") > td:nth-child(1)";
          element = table.querySelector(query).text.replaceAll('%', '');
          element2 = table.querySelector(query2).text;
          record.add((double.parse(element)));
          days.add(element2);
        }
        graphDays = days;
        return record;
      }
    }
    return [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  }

  void setAttendance(String body) {
    _attendanceBody = body;

    var document = parse(body);
    var percent = document.querySelector('#ContentPlaceHolder1_lblper').text;
    _attendance.percent =
        double.parse(percent.substring(0, percent.length - 1));
    _attendance.totalLectures =
        document.querySelector('#ContentPlaceHolder1_lbltotal').text;
    _attendance.presentLecture =
        document.querySelector('#ContentPlaceHolder1_lblpresent').text;
    graph = parseTable(body);
    notifyListeners();
  }

  String getTable() {
    var document = parse(_attendanceBody);
    String changedHtml =
        document.querySelector("#ContentPlaceHolder1_GridView1").outerHtml;
    changedHtml = changedHtml.replaceAll('LightBlue', '#f44336');
    // changedHtml = changedHtml.replaceAll('White', '#1D2C4B');
    // changedHtml = changedHtml.replaceAll('#333333', 'White');
    changedHtml = changedHtml.replaceAll('White', 'Black');
    changedHtml = changedHtml.replaceAll('#333333', 'White');

    changedHtml = changedHtml.replaceAll('#006699', '#FFFFFF');
    return changedHtml;
  }

  void setStatus(AttendanceStatus status) {
    attendanceStatus = status;
    notifyListeners();
  }
}
