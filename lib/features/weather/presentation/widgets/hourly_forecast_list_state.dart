import 'package:flutter/material.dart';

import 'hourly_forecast_item.dart';
import 'hourly_forecast_list.dart';

class HourlyForecastListState extends State<HourlyForecastList> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  @override
  void didUpdateWidget(covariant HourlyForecastList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.isEmpty) {
      _selectedIndex = 0;
      return;
    }
    if (_selectedIndex >= widget.items.length) {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 148,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final isActive = index == _selectedIndex;
          return HourlyForecastItem(
            item: item,
            isActive: isActive,
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onSelected?.call(index);
            },
          );
        },
      ),
    );
  }
}
