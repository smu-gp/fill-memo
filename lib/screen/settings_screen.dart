import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preference_helper/preference_helper.dart';
import 'package:sp_client/screen/host_connection_screen.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/edit_text_dialog.dart';
import 'package:sp_client/widget/guest_connection_dialog.dart';
import 'package:sp_client/widget/sub_header.dart';

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
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Util.isTablet(context) ? 56.0 : 0,
            ),
            child: ListView(
              children: _buildPreferenceItem(state),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildPreferenceItem(PreferenceState state) {
    var prefLightTheme = state.preferences.get(AppPreferences.keyLightTheme);
    var prefUserId = state.preferences.get(AppPreferences.keyUserId);
    var prefUseLocalDummy =
        state.preferences.get(AppPreferences.keyUseLocalDummy);
    var prefServiceHost = state.preferences.get(AppPreferences.keyServiceHost);
    var prefOverlayHandleRange =
        state.preferences.get(AppPreferences.keyOverlayHandleRange);

    return <Widget>[
      _buildHostConnectionPreference(),
      if (Util.isTablet(context)) _buildGuestConnectionPreference(),
      _SwitchPreference(
        title: AppLocalizations.of(context).labelLightTheme,
        preference: prefLightTheme,
      ),
      SubHeader(
        'Debug options',
        color: Theme.of(context).accentColor,
        bold: true,
      ),
      ListTile(
        title: Text('Current User ID'),
        subtitle: Text(prefUserId.value ?? 'null'),
      ),
      _SwitchPreference(
        title: 'Use local dummy data',
        preference: prefUseLocalDummy,
      ),
      _EditTextPreference(
        title: 'Service host',
        preference: prefServiceHost,
        validation: (value) => value.isNotEmpty,
        validationMessage: 'Error: service host is not empty',
        enabled: !prefUseLocalDummy.value,
      ),
      _SwitchPreference(
        title: 'Show overlay handle range',
        preference: prefOverlayHandleRange,
      ),
    ];
  }

  _Preference _buildHostConnectionPreference() {
    return _Preference(
      title: AppLocalizations.of(context).titleHostConnection,
      onTap: () {
        if (Util.isTablet(context)) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context).titleHostConnection),
                  contentPadding: EdgeInsets.all(0),
                  content: Container(
                    width: 480.0,
                    height: 240.0,
                    child: HostConnectionScreen(),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        MaterialLocalizations.of(context).cancelButtonLabel,
                      ),
                    )
                  ],
                ),
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HostConnectionScreen(),
              ));
        }
      },
    );
  }

  _Preference _buildGuestConnectionPreference() {
    return _Preference(
      title: AppLocalizations.of(context).titleGuestConnection,
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => GuestConnectionDialog(),
        );
      },
    );
  }
}

class _Preference extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool enabled;

  const _Preference({
    Key key,
    this.title,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      enabled: enabled,
      onTap: onTap,
    );
  }
}

class _EditTextPreference extends StatelessWidget {
  final String title;
  final Preference preference;
  final ValidationCallback validation;
  final String validationMessage;
  final bool enabled;

  const _EditTextPreference({
    Key key,
    @required this.title,
    @required this.preference,
    this.validation,
    this.validationMessage,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<PreferenceBloc>(context);
    return ListTile(
      title: Text(title),
      subtitle: Text(preference.value),
      enabled: enabled,
      onTap: () async {
        var value = await showDialog(
          context: context,
          builder: (context) => EditTextDialog(
                title: title,
                value: preference.value,
                validation: validation,
                validationMessage: validationMessage,
              ),
        );
        if (value != null) {
          bloc.dispatch(UpdatePreference(preference..value = value));
        }
      },
    );
  }
}

class _SwitchPreference extends StatelessWidget {
  final String title;
  final Preference preference;

  const _SwitchPreference({
    Key key,
    @required this.title,
    @required this.preference,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<PreferenceBloc>(context);
    return SwitchListTile(
      title: Text(title),
      value: preference.value,
      onChanged: (value) {
        bloc.dispatch(UpdatePreference(preference..value = value));
      },
    );
  }
}
