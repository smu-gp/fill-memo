import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/edit_text_dialog.dart';
import 'package:sp_client/widget/list_item.dart';

class ConnectionProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ConnectionProfileScreen> {
  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).labelUpdateProfile),
        elevation: 0.0,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          var displayName = AppLocalizations.of(context).labelUnnamed;
          if (state is Authenticated) {
            var savedName = state.displayName;
            if (savedName != null && savedName.isNotEmpty) {
              displayName = savedName;
            }
          }

          return ListView(
            children: <Widget>[
              ListItem(
                title: AppLocalizations.of(context).labelName,
                subtitle: displayName,
                onTap: _updateName,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(AppLocalizations.of(context).hintName),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _updateName() async {
    var currentName = (_authBloc.currentState as Authenticated).displayName;
    var newName = await showDialog(
      context: context,
      builder: (context) => EditTextDialog(
        title: AppLocalizations.of(context).labelName,
        value: currentName,
        validation: (value) => value.isNotEmpty,
        validationMessage: AppLocalizations.of(context).errorEmptyName,
      ),
    );
    if (newName != null) {
      _authBloc.dispatch(ProfileUpdated(name: newName));
    }
  }
}
