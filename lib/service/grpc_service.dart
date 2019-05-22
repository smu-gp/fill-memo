import 'package:grpc/grpc.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/service/protobuf/connection.pbgrpc.dart';

class GrpcService {
  final String host;
  final Duration timeout;
  ClientChannel _channel;

  ConnectionServiceClient connectionServiceClient;

  GrpcService({
    @required this.host,
    this.timeout = const Duration(seconds: 10),
  }) {
    _channel = ClientChannel(
      host,
      port: 8001,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );

    connectionServiceClient = ConnectionServiceClient(
      _channel,
      options: CallOptions(
        timeout: timeout,
      ),
    );
  }
}
