library lib_net;

class HttpErrorEvent {
  final int? code;

  final String message;

  HttpErrorEvent(this.code, this.message);
}
