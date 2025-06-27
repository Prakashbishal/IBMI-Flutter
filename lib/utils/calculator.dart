import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';

double calculateBMI(int height, int weight) {
  if (height <= 0 || weight <= 0) return double.nan;
  double heightInMeters = height / 100;
  return weight / pow(heightInMeters, 2);
}

/// Returns the BMI classification based on WHO standards
String getBMIStatus(double bmi) {
  if (bmi < 18.5) return "Underweight";
  if (bmi < 25) return "Normal";
  if (bmi < 30) return "Overweight";
  return "Obese";
}

Future<double> calculateBMIAsync(Dio dio) async {
  var response = await dio.get('https://jsonkeeper.com/b/YAGK');
  var data = jsonDecode(response.data) as List<dynamic>; // ✅ Fix

  return calculateBMI(data[0], data[1]);
}
