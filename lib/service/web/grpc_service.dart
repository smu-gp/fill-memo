import 'package:fill_memo/service/protobuf/connection.pbgrpc.dart';
import 'package:grpc/grpc_web.dart';

ConnectionServiceClient createConnectionClient({String host}) {
  var channel = GrpcWebClientChannel.xhr(Uri.parse('http://$host:8002'));
  return ConnectionServiceClient(channel);
}
