//Application State class representing a failed network request

class NetworkFailure {
  const NetworkFailure(
    this.message, {
    required this.code,
  });

  final String message;
  final int? code;

  @override
  String toString() {
    return message;
  }
}
