import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preference_helper/preference_helper.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/edit_text_dialog.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PreferenceBloc _preferenceBloc;

  @override
  void initState() {
    super.initState();
    _preferenceBloc = BlocProvider.of<PreferenceBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferenceEvent, PreferenceState>(
      bloc: _preferenceBloc,
      builder: (BuildContext context, PreferenceState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).actionSettings),
            elevation: 0.0,
          ),
          body: ListView(
            children: _buildPreferenceItem(state),
          ),
        );
      },
    );
  }

  List<Widget> _buildPreferenceItem(PreferenceState state) {
    var items = <Widget>[];
    var prefDebugMode = state.preferences[AppPreferences.keyDebugMode];
    items.add(
      SwitchListTile(
        title: Text('Debug mode'),
        value: prefDebugMode.value,
        onChanged: (value) {
          _preferenceBloc.setPreference(prefDebugMode..value = value);
        },
      ),
    );
    if (prefDebugMode.value) {
      var prefUseLocalDummy =
          state.preferences[AppPreferences.keyUseLocalDummy];
      var prefServiceUrl = state.preferences[AppPreferences.keyServiceUrl];
      items
        ..add(
          SwitchListTile(
            title: Text('Use local dummy data'),
            value: prefUseLocalDummy.value,
            onChanged: (value) {
              _preferenceBloc.setPreference(prefUseLocalDummy..value = value);
            },
          ),
        )
        ..add(
          ListTile(
            title: Text('Service url'),
            subtitle: Text(prefServiceUrl.value),
            enabled: !prefUseLocalDummy.value,
            onTap: () async {
              var value = await showDialog(
                  context: context,
                  builder: (context) => EditTextDialog(
                        title: 'Service url',
                        value: prefServiceUrl.value,
                      ));
              _preferenceBloc.setPreference(prefServiceUrl..value = value);
            },
          ),
        );
    }
    return items;
  }
}
