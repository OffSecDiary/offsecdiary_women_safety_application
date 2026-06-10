import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static String formatLocation(double lat, double lng) {
    return "Lat: $lat, Lng: $lng";
  }

  static Future<void> openGoogleMaps(double lat, double lng) async {
    final url =
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng";

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}