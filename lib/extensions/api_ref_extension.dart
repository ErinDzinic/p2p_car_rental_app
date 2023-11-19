import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p2p_renting_car_app/api/api.dart';
import 'package:p2p_renting_car_app/providers/api_provider.dart';

extension ApiRef on Ref {
  Api get api => read(apiProvider);
}
