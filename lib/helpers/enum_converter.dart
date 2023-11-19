import 'package:p2p_renting_car_app/models/car_model.dart';

String formatCarStatus(CarStatus status) {
  return status
      .toString()
      .split('.')
      .last
      .replaceAllMapped(
        RegExp(r'([A-Z])'),
        (match) => ' ${match.group(0)}',
      )
      .toUpperCase();
}
