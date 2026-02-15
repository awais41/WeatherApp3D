import 'package:flutter/material.dart';

import '../core/constants/asset_constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF090E2B), Color(0xFF05081A)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const RadialGradient(
                    center: Alignment(0, -0.15),
                    radius: 0.9,
                    colors: [
                      Color(0xA61B4FB8),
                      Color(0x66103373),
                      Color(0x00103373),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    '${AssetConstants.iconPath}/ic_sun_cloud_zap.png',
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Weather App',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
