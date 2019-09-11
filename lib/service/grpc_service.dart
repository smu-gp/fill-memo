import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_web.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/service/protobuf/connection.pbgrpc.dart';

class GrpcService {
  final String host;

  ConnectionServiceClient connectionServiceClient;

  GrpcService({@required this.host}) {
    var channel;
    if (kIsWeb) {
      channel = GrpcWebClientChannel.xhr(Uri.parse('http://$host:8002'));
    } else {
      channel = ClientChannel(
        host,
        port: 8001,
        options:
            const ChannelOptions(credentials: ChannelCredentials.insecure()),
      );
    }
    connectionServiceClient = ConnectionServiceClient(channel);
  }
}
