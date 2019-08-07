///
//  Generated code. Do not modify.
//  source: connection.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core show int, String, List;

import 'package:grpc/service_api.dart' as $grpc;
import 'connection.pb.dart' as $0;
export 'connection.pb.dart';

class ConnectionServiceClient extends $grpc.Client {
  static final _$connection =
      $grpc.ClientMethod<$0.ConnectionRequest, $0.ConnectionResponse>(
          '/connection_grpc.ConnectionService/Connection',
          ($0.ConnectionRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ConnectionResponse.fromBuffer(value));
  static final _$auth = $grpc.ClientMethod<$0.AuthRequest, $0.AuthResponse>(
      '/connection_grpc.ConnectionService/Auth',
      ($0.AuthRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.AuthResponse.fromBuffer(value));
  static final _$waitAuth =
      $grpc.ClientMethod<$0.WaitAuthRequest, $0.WaitAuthResponse>(
          '/connection_grpc.ConnectionService/WaitAuth',
          ($0.WaitAuthRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.WaitAuthResponse.fromBuffer(value));

  ConnectionServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.ConnectionResponse> connection(
      $0.ConnectionRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$connection, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.AuthResponse> auth($0.AuthRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$auth, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseStream<$0.WaitAuthResponse> waitAuth(
      $async.Stream<$0.WaitAuthRequest> request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$waitAuth, request, options: options);
    return $grpc.ResponseStream(call);
  }
}

abstract class ConnectionServiceBase extends $grpc.Service {
  $core.String get $name => 'connection_grpc.ConnectionService';

  ConnectionServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ConnectionRequest, $0.ConnectionResponse>(
        'Connection',
        connection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ConnectionRequest.fromBuffer(value),
        ($0.ConnectionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AuthRequest, $0.AuthResponse>(
        'Auth',
        auth_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AuthRequest.fromBuffer(value),
        ($0.AuthResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WaitAuthRequest, $0.WaitAuthResponse>(
        'WaitAuth',
        waitAuth,
        true,
        true,
        ($core.List<$core.int> value) => $0.WaitAuthRequest.fromBuffer(value),
        ($0.WaitAuthResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ConnectionResponse> connection_Pre($grpc.ServiceCall call,
      $async.Future<$0.ConnectionRequest> request) async {
    return connection(call, await request);
  }

  $async.Future<$0.AuthResponse> auth_Pre(
      $grpc.ServiceCall call, $async.Future<$0.AuthRequest> request) async {
    return auth(call, await request);
  }

  $async.Future<$0.ConnectionResponse> connection(
      $grpc.ServiceCall call, $0.ConnectionRequest request);
  $async.Future<$0.AuthResponse> auth(
      $grpc.ServiceCall call, $0.AuthRequest request);
  $async.Stream<$0.WaitAuthResponse> waitAuth(
      $grpc.ServiceCall call, $async.Stream<$0.WaitAuthRequest> request);
}
