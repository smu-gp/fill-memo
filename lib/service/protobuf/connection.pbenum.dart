///
//  Generated code. Do not modify.
//  source: connection.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class AuthResponse_ResultMessage extends $pb.ProtobufEnum {
  static const AuthResponse_ResultMessage MESSAGE_FAILED = AuthResponse_ResultMessage._(0, 'MESSAGE_FAILED');
  static const AuthResponse_ResultMessage MESSAGE_SUCCESS = AuthResponse_ResultMessage._(1, 'MESSAGE_SUCCESS');

  static const $core.List<AuthResponse_ResultMessage> values = <AuthResponse_ResultMessage> [
    MESSAGE_FAILED,
    MESSAGE_SUCCESS,
  ];

  static final $core.Map<$core.int, AuthResponse_ResultMessage> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AuthResponse_ResultMessage valueOf($core.int value) => _byValue[value];

  const AuthResponse_ResultMessage._($core.int v, $core.String n) : super(v, n);
}

class AuthResponse_FailedReason extends $pb.ProtobufEnum {
  static const AuthResponse_FailedReason NONE = AuthResponse_FailedReason._(0, 'NONE');
  static const AuthResponse_FailedReason AUTH_FAILED = AuthResponse_FailedReason._(1, 'AUTH_FAILED');
  static const AuthResponse_FailedReason INTERNAL_ERR = AuthResponse_FailedReason._(2, 'INTERNAL_ERR');
  static const AuthResponse_FailedReason REJECT_HOST = AuthResponse_FailedReason._(3, 'REJECT_HOST');
  static const AuthResponse_FailedReason NO_HOST_WAITED = AuthResponse_FailedReason._(4, 'NO_HOST_WAITED');
  static const AuthResponse_FailedReason RESPONSE_TIMEOUT = AuthResponse_FailedReason._(5, 'RESPONSE_TIMEOUT');

  static const $core.List<AuthResponse_FailedReason> values = <AuthResponse_FailedReason> [
    NONE,
    AUTH_FAILED,
    INTERNAL_ERR,
    REJECT_HOST,
    NO_HOST_WAITED,
    RESPONSE_TIMEOUT,
  ];

  static final $core.Map<$core.int, AuthResponse_FailedReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AuthResponse_FailedReason valueOf($core.int value) => _byValue[value];

  const AuthResponse_FailedReason._($core.int v, $core.String n) : super(v, n);
}

class AuthDeviceInfo_DeviceType extends $pb.ProtobufEnum {
  static const AuthDeviceInfo_DeviceType DEVICE_TABLET = AuthDeviceInfo_DeviceType._(0, 'DEVICE_TABLET');
  static const AuthDeviceInfo_DeviceType DEVICE_WEB = AuthDeviceInfo_DeviceType._(1, 'DEVICE_WEB');

  static const $core.List<AuthDeviceInfo_DeviceType> values = <AuthDeviceInfo_DeviceType> [
    DEVICE_TABLET,
    DEVICE_WEB,
  ];

  static final $core.Map<$core.int, AuthDeviceInfo_DeviceType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AuthDeviceInfo_DeviceType valueOf($core.int value) => _byValue[value];

  const AuthDeviceInfo_DeviceType._($core.int v, $core.String n) : super(v, n);
}

