import 'package:flutter/material.dart';

import 'shimmer_state.dart';

class Shimmer extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const Shimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  State<Shimmer> createState() => ShimmerState();
}
