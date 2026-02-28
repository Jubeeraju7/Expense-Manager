class AppConfig {

  static const String baseUrl = 'https://appskilltest.zybotech.in';
 
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Map<String, String> headersMultipart = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
  };
  
}
