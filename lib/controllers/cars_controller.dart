import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p2p_renting_car_app/extensions/api_ref_extension.dart';
import 'package:p2p_renting_car_app/helpers/enum_converter.dart';
import 'package:p2p_renting_car_app/models/car_model.dart';
import 'package:p2p_renting_car_app/services/firebase_messaging_service.dart';

class CarsData {
  final List<Car> cars;

  CarsData({
    this.cars = const [],
  });

  CarsData copyWith({List<Car>? cars}) {
    return CarsData(
      cars: cars ?? this.cars,
    );
  }
}

class CarsController extends StateNotifier<AsyncValue<CarsData>> {
  List<Car> _cars = [];
  final Ref ref;

  CarsController(this.ref) : super(AsyncData(CarsData())) {
    _init();
  }

  Future<void> createCar(Car newCar) async {
    state = const AsyncLoading();
    try {
      final createdCar = await ref.api.createCar(newCar);
      _cars.add(createdCar);
      state = AsyncData(CarsData(cars: _cars));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> updateCarStatus(Car car, CarStatus status) async {
    final String notificationSenderId = FirebaseAuth.instance.currentUser!.uid;

    try {
      state = const AsyncLoading();

      var updatedCar =
          await ref.api.updateCar(car.id!, {'status': formatCarStatus(status)});

      int updatedCarIndex = _cars.indexWhere((c) => c.id == car.id);

      if (updatedCarIndex != -1) {
        _cars[updatedCarIndex] = car.copyWith(status: formatCarStatus(status));
      }

      state = AsyncData(CarsData(cars: _cars));

      if (status == CarStatus.pendingApproval) {
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection("UserTokens")
            .doc(car.createdBy)
            .get();

        String token = snap['token'];

        FirebaseMessagingService().sendPushMessage(
          token,
          'Status has been changed to: PENDING APPROVAL',
          'Someone is interested in your car!',
          jsonEncode(updatedCar.toMap()),
          notificationSenderId,
        );
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      rethrow;
    }
  }

  Future<void> filterCars(String? search) async {
    state = const AsyncLoading();
    var searchTerms = search!.toLowerCase().split(' ');

    state = await AsyncValue.guard(() async {
      if (search.isNotEmpty) {
        var filteredCars = _cars
            .where((car) => searchTerms.any((term) =>
                car.make.toLowerCase().contains(term) ||
                searchTerms
                    .any((term) => car.model.toLowerCase().contains(term))))
            .toList();

        return CarsData(cars: filteredCars);
      } else {
        return CarsData(cars: _cars);
      }
    });
  }

  Future<void> deleteCar(String id) async {
    try {
      state = const AsyncLoading();

      await ref.api.deleteCar(id);

      _cars.removeWhere((car) => car.id == id);

      state = AsyncData(CarsData(cars: _cars));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> onRefresh() async {
    try {
      state = const AsyncLoading();
      _cars = await ref.api.getCars();
      state = AsyncData(CarsData(cars: _cars));
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> _init() async {
    state = const AsyncLoading();

    _cars = await ref.api.getCars();

    state = AsyncData(CarsData(
      cars: _cars,
    ));
  }
}

final carsControllerProvider =
    StateNotifierProvider<CarsController, AsyncValue<CarsData>>(
        (ref) => CarsController(ref));
