import 'package:flutter/material.dart';

import '../core/constants/asset_constants.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF070B2C), Color(0xFF060A24), Color(0xFF04071B)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.14),
              Container(
                width: size.width * 0.82,
                height: size.width * 0.82,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const RadialGradient(
                    center: Alignment(0, -0.05),
                    radius: 0.85,
                    colors: [
                      Color(0xCC113B8A),
                      Color(0x6613376F),
                      Color(0x00133A70),
                    ],
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    '${AssetConstants.iconPath}/ic_sun_cloud_zap.png',
                    width: size.width * 0.46,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Text(
                'Discover the Weather\nin Your City',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 46,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Get to know your weather maps and\nradar precipitation forecast',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  fontSize: 28,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
