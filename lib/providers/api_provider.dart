import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p2p_renting_car_app/api/api.dart';
import 'package:p2p_renting_car_app/providers/dio_provider.dart';

final apiProvider = Provider<Api>((ref) {
  final dio = ref.watch(dioProvider);
  return Api(dio: dio);
});
