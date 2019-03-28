import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preference_helper/preference_helper.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/edit_text_dialog.dart';
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
          body: ListView(
            children: _buildPreferenceItem(state),
          ),
        );
      },
    );
  }

  List<Widget> _buildPreferenceItem(PreferenceState state) {
    var items = <Widget>[];
    var prefUseLocalDummy = state.preferences[AppPreferences.keyUseLocalDummy];
    var prefServiceUrl = state.preferences[AppPreferences.keyServiceUrl];
    var prefOverlayHandleRange =
        state.preferences[AppPreferences.keyOverlayHandleRange];
    items
      ..add(SubHeader(
        'Debug options',
        color: Theme.of(context).accentColor,
        bold: true,
      ))
      ..add(
        _SwitchPreference(
          title: 'Use local dummy data',
          preference: prefUseLocalDummy,
        ),
      )
      ..add(
        _EditTextPreference(
          title: 'Service url',
          preference: prefServiceUrl,
          validation: (value) => value.isNotEmpty,
          validationMessage: 'Error: serviceUrl is not empty',
          enabled: !prefUseLocalDummy.value,
        ),
      )
      ..add(
        _SwitchPreference(
          title: 'Show overlay handle range',
          preference: prefOverlayHandleRange,
        ),
      );
    return items;
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
          bloc.setPreference(preference..value = value);
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
        bloc.setPreference(preference..value = value);
      },
    );
  }
}
