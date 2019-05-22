///
//  Generated code. Do not modify.
//  source: connection.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'package:grpc/service_api.dart' as $grpc;

import 'dart:core' as $core show int, String, List;

import 'connection.pb.dart';
export 'connection.pb.dart';

class ConnectionServiceClient extends $grpc.Client {
  static final _$connection =
      $grpc.ClientMethod<ConnectionRequest, ConnectionResponse>(
          '/connection_grpc.ConnectionService/Connection',
          (ConnectionRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              ConnectionResponse.fromBuffer(value));
  static final _$auth = $grpc.ClientMethod<AuthRequest, AuthResponse>(
      '/connection_grpc.ConnectionService/Auth',
      (AuthRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => AuthResponse.fromBuffer(value));
  static final _$waitAuth =
      $grpc.ClientMethod<WaitAuthRequest, WaitAuthResponse>(
          '/connection_grpc.ConnectionService/WaitAuth',
          (WaitAuthRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => WaitAuthResponse.fromBuffer(value));

  ConnectionServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<ConnectionResponse> connection(ConnectionRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$connection, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<AuthResponse> auth(AuthRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$auth, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseStream<WaitAuthResponse> waitAuth(
      $async.Stream<WaitAuthRequest> request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$waitAuth, request, options: options);
    return $grpc.ResponseStream(call);
  }
}

abstract class ConnectionServiceBase extends $grpc.Service {
  $core.String get $name => 'connection_grpc.ConnectionService';

  ConnectionServiceBase() {
    $addMethod($grpc.ServiceMethod<ConnectionRequest, ConnectionResponse>(
        'Connection',
        connection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => ConnectionRequest.fromBuffer(value),
        (ConnectionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<AuthRequest, AuthResponse>(
        'Auth',
        auth_Pre,
        false,
        false,
        ($core.List<$core.int> value) => AuthRequest.fromBuffer(value),
        (AuthResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<WaitAuthRequest, WaitAuthResponse>(
        'WaitAuth',
        waitAuth,
        true,
        true,
        ($core.List<$core.int> value) => WaitAuthRequest.fromBuffer(value),
        (WaitAuthResponse value) => value.writeToBuffer()));
  }

  $async.Future<ConnectionResponse> connection_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return connection(call, await request);
  }

  $async.Future<AuthResponse> auth_Pre(
      $grpc.ServiceCall call, $async.Future request) async {
    return auth(call, await request);
  }

  $async.Future<ConnectionResponse> connection(
      $grpc.ServiceCall call, ConnectionRequest request);
  $async.Future<AuthResponse> auth($grpc.ServiceCall call, AuthRequest request);
  $async.Stream<WaitAuthResponse> waitAuth(
      $grpc.ServiceCall call, $async.Stream<WaitAuthRequest> request);
}
