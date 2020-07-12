class HttpExeption implements Exception {
  final String message;

  HttpExeption(this.message);

  @override
  String toString() {
    print('MESSAGE: HttpExeption toString ${message}');
    return message;
  }
}
