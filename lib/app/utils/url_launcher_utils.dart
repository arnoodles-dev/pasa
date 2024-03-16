import 'package:url_launcher/url_launcher.dart';

class UrlLauncherUtils {
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri phoneNumberUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await _launch(uri: phoneNumberUri);
  }

  static Future<void> openBrowser(
    String url,
  ) async {
    final Uri websiteUri = Uri.parse(url);

    await _launch(uri: websiteUri, mode: LaunchMode.externalApplication);
  }

  static Future<void> _launch({
    required Uri uri,
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: mode);
    }
  }
}
