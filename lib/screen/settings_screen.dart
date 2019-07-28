import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/edit_text_dialog.dart';
import 'package:sp_client/widget/list_item.dart';
import 'package:sp_client/widget/sub_header.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PreferenceBloc prefBloc;

  @override
  Widget build(BuildContext context) {
    prefBloc = BlocProvider.of<PreferenceBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).actionSettings),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Util.isTablet(context) ? 56.0 : 0,
        ),
        child: BlocBuilder<PreferenceBloc, PreferenceState>(
          bloc: prefBloc,
          builder: (context, state) {
            return ListView(
              children: _buildItems(state.preferences),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildItems(Preferences preferences) {
    return <Widget>[
      ..._buildNoteItems(preferences),
      ..._buildSecurityItems(preferences),
      if (!bool.fromEnvironment('dart.vm.product'))
        ..._buildDebugItems(preferences),
      ..._buildInfoItems(preferences),
    ];
  }

  List<Widget> _buildNoteItems(Preferences preferences) {
    var prefNewNoteOnStartup =
        preferences.get(AppPreferences.keyNewNoteOnStartup);
    var prefQuickFolderClassification =
        preferences.get(AppPreferences.keyQuickFolderClassification);

    return <Widget>[
      SubHeader(
        AppLocalizations.of(context).subtitleNote,
      ),
      SwitchListItem(
        title: AppLocalizations.of(context).labelWriteNewNoteOnStartup,
        value: prefNewNoteOnStartup.value,
        onChanged: (bool value) => prefBloc
            .dispatch(UpdatePreference(prefNewNoteOnStartup..value = value)),
      ),
      SwitchListItem(
        title: AppLocalizations.of(context).labelQuickFolderClassification,
        subtitle:
            AppLocalizations.of(context).subtitleQuickFolderClassification,
        value:
            preferences.get(AppPreferences.keyQuickFolderClassification).value,
        onChanged: (bool value) => prefBloc.dispatch(
            UpdatePreference(prefQuickFolderClassification..value = value)),
      ),
    ];
  }

  List<Widget> _buildSecurityItems(Preferences preferences) {
    return <Widget>[
      SubHeader(
        AppLocalizations.of(context).subtitleSecurity,
      ),
      ListItem(
        title: AppLocalizations.of(context).labelChangePinCode,
        onTap: () {},
      ),
      SwitchListItem(
        title: AppLocalizations.of(context).labelUseFingerprint,
        value: false,
        onChanged: (bool value) {},
      ),
    ];
  }

  List<Widget> _buildDebugItems(Preferences preferences) {
    return <Widget>[
      SubHeader(
        AppLocalizations.of(context).subtitleDebug,
      ),
      _EditTextPreference(
        title: AppLocalizations.of(context).labelServiceHost,
        preference: preferences.get(AppPreferences.keyServiceHost),
        validation: (value) => value.isNotEmpty,
        validationMessage: AppLocalizations.of(context).validationServiceHost,
      ),
    ];
  }

  List<Widget> _buildInfoItems(Preferences preferences) {
    return <Widget>[
      SubHeader(
        AppLocalizations.of(context).subtitleInfo,
      ),
      FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          var subtitle;
          if (snapshot.hasData) {
            subtitle = "v${snapshot.data.version}";
          }
          return ListItem(
            title: AppLocalizations.of(context).labelVersion,
            subtitle: subtitle,
          );
        },
      )
    ];
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
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<PreferenceBloc>(context);
    return ListItem(
      title: title,
      subtitle: preference.value,
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
