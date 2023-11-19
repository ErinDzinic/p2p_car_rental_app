import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p2p_renting_car_app/common/add_card_widget.dart';
import 'package:p2p_renting_car_app/common/car_card.dart';
import 'package:p2p_renting_car_app/common/constants.dart';
import 'package:p2p_renting_car_app/helpers/async_value_widget.dart';
import 'package:p2p_renting_car_app/controllers/cars_controller.dart';
import 'package:p2p_renting_car_app/screens/home/search_field_widget.dart';
import 'package:p2p_renting_car_app/services/firebase_messaging_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? mtoken = '';
  final searchController = TextEditingController();
  final service = FirebaseMessagingService();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void getToken() async =>
      await FirebaseMessaging.instance.getToken().then((token) {
        setState(() => mtoken = token);
        service.saveToken(token!);
      });

  @override
  void initState() {
    super.initState();
    service.requestPermission();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: FloatingActionButton(
          onPressed: () => showBottomSheetDialog(context),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          backgroundColor: Colors.teal,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 45.0),
          child: RefreshIndicator(
            color: Colors.teal,
            onRefresh: () =>
                ref.read(carsControllerProvider.notifier).onRefresh(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        Sizes.p16, 0, Sizes.p16, 0),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            Sizes.p16, Sizes.p8, Sizes.p16, Sizes.p8),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              size: Sizes.p24,
                            ),
                            gapW20,
                            SearchFieldWidget(
                                searchController: searchController, ref: ref),
                            IconButton(
                              onPressed: searchController.text.isNotEmpty
                                  ? () {
                                      searchController.clear();
                                      ref
                                          .read(carsControllerProvider.notifier)
                                          .onRefresh();
                                    }
                                  : null,
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  gapH12,
                  Text('Available Cars',
                      style: Theme.of(context).textTheme.labelLarge),
                  const Divider(),
                  CarsListWidget(ref: ref),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CarsListWidget extends StatelessWidget {
  const CarsListWidget({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return AsyncValueWidget<CarsData>(
      showLoading: false,
      value: ref.watch(carsControllerProvider),
      data: (data) {
        final cars = data.cars;
        return cars.isNotEmpty
            ? Column(
                children: [
                  ListView.builder(
                      padding: const EdgeInsets.all(10),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cars.length,
                      itemBuilder: ((context, index) =>
                          CarCard(car: cars[index]))),
                ],
              )
            : Container();
      },
    );
  }
}
