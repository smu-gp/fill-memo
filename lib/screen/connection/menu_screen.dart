import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/repository/repositories.dart';
import 'package:fill_memo/util/localization.dart';
import 'package:fill_memo/util/preference.dart';
import 'package:fill_memo/util/routes.dart';
import 'package:fill_memo/widget/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectionMenuScreen extends StatefulWidget {
  @override
  _ConnectionMenuScreenState createState() => _ConnectionMenuScreenState();
}

class _ConnectionMenuScreenState extends State<ConnectionMenuScreen> {
  AuthBloc _authBloc;
  PreferenceRepository _preferenceRepository;

  String get userId =>
      _preferenceRepository.getString(AppPreferences.keyUserId);

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _preferenceRepository =
        RepositoryProvider.of<PreferenceRepository>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).actionConnection),
        elevation: 0.0,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
          bloc: _authBloc,
          builder: (context, authState) {
            var isHostLogged = false;
            if (authState is Authenticated) {
              isHostLogged = userId == authState.uid;
            }

            var children = <Widget>[
              ListItem(
                title: AppLocalizations.of(context).labelUpdateProfile,
                onTap: () =>
                    Navigator.push(context, Routes().connectionProfile),
                enabled: isHostLogged,
              ),
              ListItem(
                title: AppLocalizations.of(context).titleHostConnection,
                subtitle: AppLocalizations.of(context).hintGenerateCode,
                onTap: () =>
                    Navigator.push(context, Routes().connectionGenerateCode),
                enabled: isHostLogged,
              ),
              ListItem(
                title: AppLocalizations.of(context).titleGuestConnection,
                subtitle: AppLocalizations.of(context).hintConnectAnotherDevice,
                onTap: () =>
                    Navigator.push(context, Routes().connectionConnectDevice),
                enabled: isHostLogged,
              ),
              ListItem(
                title: AppLocalizations.of(context).labelDisconnectAnother,
                onTap: () {
                  _authBloc.dispatch(ChangedUser(userId));
                },
                enabled: !isHostLogged,
              )
            ];

            return ListView.separated(
              itemBuilder: (context, index) => children[index],
              itemCount: children.length,
              separatorBuilder: (context, index) => Divider(height: 1),
            );
          }),
    );
  }
}
