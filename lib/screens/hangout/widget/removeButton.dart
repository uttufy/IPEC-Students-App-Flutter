import 'package:flutter/material.dart';

IconButton removeWidget(Function onTap) {
  return IconButton(
    color: Colors.red,
    icon: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        Icons.remove_circle,
        size: 30,
      ),
    ),
    onPressed: () {
      onTap();
    },
  );
}
