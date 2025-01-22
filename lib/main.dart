import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_intrvw/blog_home.dart';

void main() => runApp(HiveBlogApp());

class HiveBlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Blog Posts',
      home: HiveBlogHome(),
    );
  }
}