import 'package:fill_memo/service/protobuf/connection.pbgrpc.dart';
import 'package:grpc/grpc.dart';

ConnectionServiceClient createConnectionClient({String host}) {
  var channel = ClientChannel(
    host,
    port: 8001,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
  return ConnectionServiceClient(channel);
}
