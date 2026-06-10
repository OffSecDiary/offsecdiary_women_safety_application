import 'package:url_launcher/url_launcher.dart';

class CallService {
  Future<void> makeCall() async {
    final Uri call = Uri(scheme: 'tel', path: '112'); // emergency number
    await launchUrl(call);
  }
}