import 'package:grpc/grpc_web.dart';
import 'package:sp_client/service/protobuf/connection.pbgrpc.dart';

ConnectionServiceClient createConnectionClient({String host}) {
  var channel = GrpcWebClientChannel.xhr(Uri.parse('http://$host:8002'));
  return ConnectionServiceClient(channel);
}
