import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p2p_renting_car_app/controllers/cars_controller.dart';

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({
    super.key,
    required this.searchController,
    required this.ref,
  });

  final TextEditingController searchController;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
        child: TextFormField(
          controller: searchController,
          onChanged: (value) => ref
              .read(carsControllerProvider.notifier)
              .filterCars(value.toLowerCase()),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(top: 10, bottom: 10),
            labelText: 'Search for cars',
            labelStyle: TextStyle(color: Colors.teal),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
