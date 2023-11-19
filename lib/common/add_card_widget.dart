import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p2p_renting_car_app/common/custom_textfield_widget.dart';
import 'package:p2p_renting_car_app/controllers/cars_controller.dart';
import 'package:p2p_renting_car_app/helpers/enum_converter.dart';
import 'package:p2p_renting_car_app/helpers/validator.dart';
import 'package:p2p_renting_car_app/models/car_model.dart';

Future<void> showBottomSheetDialog(BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    context: context,
    builder: (BuildContext context) => Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: const AddCarWidget(),
    ),
  );
}

class AddCarWidget extends ConsumerStatefulWidget {
  const AddCarWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<AddCarWidget> createState() => _AddCarWidgetState();
}

class _AddCarWidgetState extends ConsumerState<AddCarWidget> {
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  CarStatus? selectedStatus = CarStatus.available;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    makeController.dispose();
    modelController.dispose();
    priceController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFieldWidget(
              controller: makeController,
              title: 'Make',
              validator: validation,
            ),
            CustomTextFieldWidget(
              controller: modelController,
              title: 'Model',
              validator: nonEmptyValidation,
            ),
            DigitTextFieldWidget(
              controller: priceController,
              title: 'Price',
              validator: nonEmptyValidation,
            ),
            CustomTextFieldWidget(
              controller: locationController,
              title: 'Location',
              validator: validation,
            ),
            DropdownButtonFormField<CarStatus>(
              value: selectedStatus,
              items: [CarStatus.available].map((status) {
                return DropdownMenuItem<CarStatus>(
                  value: status,
                  child: Text(formatCarStatus(status)),
                );
              }).toList(),
              onChanged: (CarStatus? value) {
                setState(() {
                  selectedStatus = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Status',
                labelStyle: TextStyle(color: Colors.teal),
                focusColor: Colors.black,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              validator: (value) {
                if (value == null) {
                  return 'Please select a status';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() == true) {
                    User? user = FirebaseAuth.instance.currentUser;
                    var newCar = Car(
                        make: makeController.text,
                        model: modelController.text,
                        price: int.parse(priceController.text),
                        location: locationController.text,
                        status: formatCarStatus(selectedStatus!),
                        createdBy: user!.uid);
                    ref.read(carsControllerProvider.notifier).createCar(newCar);
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Add new car'.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
