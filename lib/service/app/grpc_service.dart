import 'package:grpc/grpc.dart';
import 'package:sp_client/service/protobuf/connection.pbgrpc.dart';

ConnectionServiceClient createConnectionClient({String host}) {
  var channel = ClientChannel(
    host,
    port: 8001,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
  return ConnectionServiceClient(channel);
}
