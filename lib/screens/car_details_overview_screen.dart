import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p2p_renting_car_app/common/app_bar_widget.dart';
import 'package:p2p_renting_car_app/common/button_widget.dart';
import 'package:p2p_renting_car_app/common/constants.dart';
import 'package:p2p_renting_car_app/controllers/cars_controller.dart';
import 'package:p2p_renting_car_app/helpers/enum_converter.dart';
import 'package:p2p_renting_car_app/models/car_model.dart';
import 'package:p2p_renting_car_app/services/firebase_messaging_service.dart';

class CarDetailsOverviewScreen extends ConsumerWidget {
  final Car? car;
  final String? notificationSenderId;

  const CarDetailsOverviewScreen({
    super.key,
    this.car,
    this.notificationSenderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: gradientBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Sizes.p16),
                child: Image.network(
                  'https://images.unsplash.com/photo-1547245324-d777c6f05e80?w=1280&h=720',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              gapH24,
              CarDetails(car: car),
              car!.status == formatCarStatus(CarStatus.pendingApproval)
                  ? CarActionButtons(
                      notificationSenderId: notificationSenderId!, car: car!)
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

class CarActionButtons extends ConsumerWidget {
  final String notificationSenderId;
  final Car car;
  const CarActionButtons(
      {super.key, required this.notificationSenderId, required this.car});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void acceptOrDeclineOffer(
        CarStatus status, String body, String title) async {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("UserTokens")
          .doc(notificationSenderId)
          .get();

      ref
          .read(carsControllerProvider.notifier)
          .updateCarStatus(car, status)
          .then((car) => FirebaseMessagingService().sendPushMessage(
              snap['token'],
              body,
              title,
              null,
              FirebaseAuth.instance.currentUser!.uid));

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          gapH32,
          ButtonWidget(
              homeColor: true,
              onPressed: () => acceptOrDeclineOffer(
                  CarStatus.sold,
                  'Status has been changed to: Sold',
                  'Congratulations, you rented a car!'),
              title: 'Approve'),
          gapH32,
          ButtonWidget(
              onPressed: () => acceptOrDeclineOffer(
                  CarStatus.unavailable,
                  'Status has been changed to: Unavailable',
                  'We are very sorry, but your car is unavailable right now'),
              title: 'Decline')
        ],
      ),
    );
  }
}

class CarDetails extends StatelessWidget {
  const CarDetails({
    super.key,
    required this.car,
  });

  final Car? car;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(Sizes.p10))),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Make: ${car?.make}',
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              overflow: TextOverflow.ellipsis,
              'Model: ${car?.model}',
            ),
            Text(
              overflow: TextOverflow.ellipsis,
              'Location: ${car?.location}',
            ),
            Text(
              overflow: TextOverflow.ellipsis,
              'Status: ${car?.status}',
            ),
            Text(
              overflow: TextOverflow.ellipsis,
              'Price: €${car?.price}/day ',
            ),
          ],
        ),
      ),
    );
  }
}
