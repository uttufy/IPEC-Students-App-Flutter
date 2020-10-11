import 'package:flutter/material.dart';
import 'package:ipecstudents/data/model/Attendance.dart';
import 'package:ipecstudents/data/service/webClientService.dart';

class Session extends ChangeNotifier {
  Attendance _attendance = Attendance();

  WebClientService webClientService = WebClientService();
}
