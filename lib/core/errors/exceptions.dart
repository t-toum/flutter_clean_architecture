import 'package:equatable/equatable.dart';

abstract class CustomException extends Equatable {
  final String message;
  const CustomException(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerException extends CustomException {
  const ServerException(super.message);
}
class CacheException extends CustomException {
  const CacheException(super.message);
}