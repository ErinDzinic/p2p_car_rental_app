import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final bool showLoading;
  final Widget? errorWidget;
  final Widget? shimmer;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.showLoading = true,
    this.errorWidget,
    this.shimmer,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: false,
      data: data,
      error: (e, st) =>
          errorWidget ??
          Center(
              child:
                  Text(e is SocketException ? 'No Connection' : e.toString())),
      loading: () => showLoading
          ? shimmer != null
              ? shimmer!
              : const Center(
                  child: CircularProgressIndicator(
                  color: Colors.teal,
                ))
          : const SizedBox(),
    );
  }
}
