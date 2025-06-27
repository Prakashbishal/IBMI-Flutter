import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:ibmi/utils/calculator.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('Basic BMI Calculation Tests', () {
    test(
      'Given height and weight When calculateBMI invoked Then correct BMI returned',
      () {
        const int height = 160, weight = 80;
        double bmi = calculateBMI(height, weight);
        expect(bmi, closeTo(31.25, 0.01));
      },
    );

    test('BMI Category Classification Test', () {
      expect(getBMIStatus(17.5), 'Underweight');
      expect(getBMIStatus(22.0), 'Normal');
      expect(getBMIStatus(27.0), 'Overweight');
      expect(getBMIStatus(32.0), 'Obese');
    });

    test('BMI calculation with float precision', () {
      double bmi = calculateBMI(188, 85);
      expect(bmi, closeTo(24.06, 0.02)); // increased tolerance
    });

    test('BMI calculation with zero height should return NaN', () {
      double bmi = calculateBMI(0, 70);
      expect(bmi.isNaN, true);
    });

    test('BMI calculation with extreme high values', () {
      double bmi = calculateBMI(200, 300); // Very high weight
      expect(bmi > 70, true);
    });

    test('BMI calculation with extremely low weight and normal height', () {
      double bmi = calculateBMI(180, 20); // Underweight
      expect(bmi < 7, true);
    });

    test('BMI calculation with negative height or weight returns NaN', () {
      expect(calculateBMI(-180, 70).isNaN, true);
      expect(calculateBMI(180, -70).isNaN, true);
    });
  });

  group('BMI Async + Mocktail Test', () {
    test('Mocked Dio call returns expected BMI from fake JSON data', () async {
      final mockDio = MockDio();
      final fakeData = jsonEncode([188, 85]);

      final response = Response(
        requestOptions: RequestOptions(path: 'https://jsonkeeper.com/b/YAGK'),
        data: fakeData,
        statusCode: 200,
      );

      when(() => mockDio.get(any())).thenAnswer((_) async => response);

      final bmi = await calculateBMIAsync(mockDio);
      expect(bmi, closeTo(24.06, 0.02));
    });
  });
}
