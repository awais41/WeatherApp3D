import '../../../../core/constants/asset_constants.dart';
import '../../../../core/utils/app_logger.dart';

class WeatherIconMapper {
  const WeatherIconMapper();

  String mapAssetPath({required int weatherId, String? iconCode}) {
    final fileName = _mapFileName(weatherId: weatherId, iconCode: iconCode);
    final assetPath = '${AssetConstants.iconPath}/$fileName';

    AppLogger.log(
      '[ICON MAP] weatherId=$weatherId, iconCode=$iconCode, iconName=$fileName, asset=$assetPath',
    );

    return assetPath;
  }

  String _mapFileName({required int weatherId, String? iconCode}) {
    final normalizedIconCode = iconCode?.trim().toLowerCase();

    final byIconCode = _mapByIconCode(normalizedIconCode);
    if (byIconCode != null) {
      return _substituteMissingAsset(byIconCode);
    }

    final byWeatherId = _mapByWeatherId(weatherId, normalizedIconCode);
    return _substituteMissingAsset(byWeatherId);
  }

  String? _mapByIconCode(String? iconCode) {
    switch (iconCode) {
      case '01d':
        return 'ic_clear_sky_day.png';
      case '01n':
        return 'ic_clear_sky_night.png';
      case '02d':
        return 'ic_few_clouds_day.png';
      case '02n':
        return 'ic_few_clouds_night.png';
      case '03d':
      case '03n':
        return 'ic_scattered_clouds.png';
      case '04d':
      case '04n':
        return 'ic_broken_clouds.png';
      case '09d':
      case '09n':
        return 'ic_shower_rain.png';
      case '10d':
        return 'ic_rain_day.png';
      case '10n':
        return 'ic_rain_night.png';
      case '11d':
      case '11n':
        return 'ic_thunderstorm.png';
      case '13d':
      case '13n':
        return 'ic_snow.png';
      case '50d':
      case '50n':
        return 'ic_mist.png';
      default:
        return null;
    }
  }

  String _mapByWeatherId(int weatherId, String? iconCode) {
    if (weatherId >= 200 && weatherId < 300) return 'ic_thunderstorm.png';
    if (weatherId >= 300 && weatherId < 400) return 'ic_drizzle.png';
    if (weatherId >= 500 && weatherId < 600) return 'ic_rain.png';
    if (weatherId >= 600 && weatherId < 700) return 'ic_snow.png';
    if (weatherId >= 700 && weatherId < 800) return 'ic_mist.png';
    if (weatherId == 800) {
      final isNight = iconCode != null && iconCode.endsWith('n');
      return isNight ? 'ic_clear_sky_night.png' : 'ic_clear_sky_day.png';
    }
    if (weatherId >= 801 && weatherId <= 804) {
      final isNight = iconCode != null && iconCode.endsWith('n');
      return isNight ? 'ic_clouds_night.png' : 'ic_clouds_day.png';
    }
    return 'ic_unknown.png';
  }

  String _substituteMissingAsset(String fileName) {
    switch (fileName) {
      case 'ic_broken_clouds.png':
        return 'ic_overcast_clouds.png';
      case 'ic_rain_night.png':
        return 'ic_cloud_big_rain.png';
      case 'ic_drizzle.png':
        return 'ic_light_intensity_drizzle_rain_n.png';
      case 'ic_rain.png':
        return 'ic_rain_drops.png';
      case 'ic_clouds_day.png':
        return 'ic_scattered_clouds.png';
      case 'ic_clouds_night.png':
        return 'ic_few_clouds_night.png';
      case 'ic_unknown.png':
        return 'ic_cloud_wind.png';
      default:
        return fileName;
    }
  }
}
