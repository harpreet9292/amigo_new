import 'package:url_launcher/url_launcher.dart';

class ExternalMapProvider
{
  static const BaseUrl = "https://www.google.com/maps/search";

  Future<bool> canOpenMap() async
  {
    return await canLaunch(BaseUrl);
  }

  Future<bool> openMapWithPosition(double lat, double lng)
  {
    final query = "$lat,$lng";
    return _openMapWithQuery(query);
  }

  Future<bool> openMapWithAddress(String addr)
  {
    final query = Uri.encodeFull(addr);
    return _openMapWithQuery(query);
  }

  Future<bool> _openMapWithQuery(String query) async
  {
    final url = "$BaseUrl/?api=1&query=$query";

    if (await canLaunch(url))
    {
      return await launch(url);
    }
    else
    {
      print('Could not launch $url');
    }

    return false;
  }
}