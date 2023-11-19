import 'package:dio/dio.dart';
import 'package:p2p_renting_car_app/models/car_model.dart';

class Api {
  final Dio dio;

  Api({required this.dio});

  static const baseUrl =
      'https://6556157084b36e3a431efb6e.mockapi.io/api/v1/cars';

  Future<List<Car>> getCars() async {
    try {
      final response = await dio.get(baseUrl);
      final List<dynamic> data = response.data;
      return data.map((json) => Car.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch cars: $e');
    }
  }

  Future<Car> createCar(Car car) async {
    try {
      final response = await dio.post(baseUrl, data: car.toJson());
      return Car.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create car: $e');
    }
  }

  Future<Car> updateCar(String id, Map<String, dynamic> updatedFields) async {
    try {
      final response = await dio.patch('$baseUrl/$id', data: updatedFields);
      return Car.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update car: $e');
    }
  }

  Future<bool> deleteCar(String carId) async {
    try {
      final response = await dio.delete('$baseUrl/$carId');

      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      throw Exception('Failed to delete car: $e');
    }
  }
}
