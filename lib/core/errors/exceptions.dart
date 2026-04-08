sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Não autorizado.']);
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Sem conexão com a internet.']);
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Erro no servidor.']);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Erro ao acessar dados locais.']);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Recurso não encontrado.']);
}
