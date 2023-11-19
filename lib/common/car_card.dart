import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p2p_renting_car_app/common/button_widget.dart';
import 'package:p2p_renting_car_app/controllers/cars_controller.dart';
import 'package:p2p_renting_car_app/helpers/enum_converter.dart';
import 'package:p2p_renting_car_app/models/car_model.dart';

class CarCard extends ConsumerWidget {
  final Car car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String notificationSenderId = FirebaseAuth.instance.currentUser!.uid;
    return Card(
        elevation: 2.0,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 44),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 8, 16, 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1547245324-d777c6f05e80?w=1280&h=720',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 0, 16, 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.add_task_sharp,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 4),
                                    SizedBox(
                                      width: 192,
                                      child: Text(
                                        '${car.make} ${car.model}',
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 0, 0),
                                  child: Text(
                                    '€${car.price}/day',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 0, 16, 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        car.location,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 4, 4, 0),
                                  child: Text(
                                    car.status,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 310,
                    child: ButtonWidget(
                      homeColor: true,
                      onPressed:
                          (car.status == formatCarStatus(CarStatus.available) &&
                                  car.createdBy != notificationSenderId)
                              ? () async {
                                  ref
                                      .read(carsControllerProvider.notifier)
                                      .updateCarStatus(
                                          car, CarStatus.pendingApproval);
                                }
                              : null,
                      title: 'Rent a car',
                    ),
                  )
                ],
              ),
            ),
          ]),
        ));
  }
}
