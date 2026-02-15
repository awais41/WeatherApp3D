import 'package:flutter/material.dart';

import 'location_page_state.dart';

class LocationPage extends StatefulWidget {
  final VoidCallback onCitySelectedNavigateHome;

  const LocationPage({super.key, required this.onCitySelectedNavigateHome});

  @override
  State<LocationPage> createState() => LocationPageState();
}
