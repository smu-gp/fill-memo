import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/repository/repositories.dart';
import 'package:fill_memo/util/constants.dart';
import 'package:fill_memo/util/dimensions.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:fill_memo/widget/edit_text_dialog.dart';
import 'package:fill_memo/widget/list_item.dart';
import 'package:fill_memo/widget/sub_header.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PreferenceBloc _preferenceBloc;

  @override
  void initState() {
    super.initState();
    var preferenceRepository =
        RepositoryProvider.of<PreferenceRepository>(context);
    _preferenceBloc = PreferenceBloc(
      repository: preferenceRepository,
      usagePreferences: AppPreferences.preferences,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).actionSettings),
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.preferenceHorizontalMargin(context),
        ),
        child: BlocProvider<PreferenceBloc>.value(
          value: _preferenceBloc,
          child: BlocBuilder<PreferenceBloc, PreferenceState>(
            bloc: _preferenceBloc,
            builder: (context, state) {
              return ListView(
                children: _buildItems(state.preferences),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _preferenceBloc.dispose();
    super.dispose();
  }

  List<Widget> _buildItems(Preferences preferences) {
    return <Widget>[
      ..._buildNoteItems(preferences),
      ..._buildSecurityItems(preferences),
      ..._buildInfoItems(preferences),
    ];
  }

  List<Widget> _buildNoteItems(Preferences preferences) {
    var prefDefaultMemoType =
        preferences.get(AppPreferences.keyDefaultMemoType);
    var prefNewNoteOnStartup =
        preferences.get(AppPreferences.keyNewNoteOnStartup);
    var prefQuickFolderClassification =
        preferences.get(AppPreferences.keyQuickFolderClassification);
    var prefQuickMemoWriting =
        preferences.get(AppPreferences.keyQuickMemoWriting);
    var prefResultAppendType =
        preferences.get(AppPreferences.keyResultAppendType);

    return <Widget>[
      SubHeader(
        AppLocalizations.of(context).subtitleNote,
      ),
      if (!kIsWeb)
        SwitchListItem(
          title: AppLocalizations.of(context).labelWriteNewNoteOnStartup,
          value: prefNewNoteOnStartup.value,
          onChanged: (bool value) {
            _preferenceBloc.dispatch(
              UpdatePreference(prefNewNoteOnStartup..value = value),
            );
          },
        ),
      SwitchListItem(
        title: AppLocalizations.of(context).labelQuickFolderClassification,
        subtitle:
            AppLocalizations.of(context).subtitleQuickFolderClassification,
        value: prefQuickFolderClassification.value,
        onChanged: (bool value) {
          _preferenceBloc.dispatch(
            UpdatePreference(prefQuickFolderClassification..value = value),
          );
        },
      ),
      SwitchListItem(
        title: AppLocalizations.of(context).labelQuickMemoWriting,
        subtitle: AppLocalizations.of(context).subtitleQuickMemoWriting,
        value: prefQuickMemoWriting.value,
        onChanged: (bool value) {
          _preferenceBloc.dispatch(
            UpdatePreference(prefQuickMemoWriting..value = value),
          );
        },
      ),
      ListItem(
        title: AppLocalizations.of(context).labelDefaultMemoType,
        subtitle: _toLocalizationsFromType(prefDefaultMemoType.value),
        enabled: prefQuickMemoWriting.value,
        onTap: () {
          Navigator.push(context, Routes().settingsMemoType(_preferenceBloc));
        },
      ),
      _DropdownPreference<String>(
        title: AppLocalizations.of(context).labelResultAppendType,
        subtitle: AppLocalizations.of(context).subtitleResultAppendType,
        labels: appendTypes
            .map((type) => _toLocalizationsFromAppendType(type))
            .toList(),
        values: appendTypes,
        initValue: prefResultAppendType.value ?? typeSpace,
        onChanged: (dynamic newValue) {
          _preferenceBloc.dispatch(
            UpdatePreference(prefResultAppendType..value = newValue),
          );
        },
      ),
      Divider(height: 1),
    ];
  }

  List<Widget> _buildSecurityItems(Preferences preferences) {
    if (kIsWeb) return [];

    var prefUseFingerprint = preferences.get(AppPreferences.keyUseFingerprint);
    var config = Provider.of<AppConfig>(context);

    return <Widget>[
      SubHeader(
        AppLocalizations.of(context).subtitleSecurity,
      ),
      SwitchListItem(
        title: AppLocalizations.of(context).labelUseFingerprint,
        value: prefUseFingerprint.value,
        enabled: config.useFingerprint,
        onChanged: (bool value) {
          _preferenceBloc.dispatch(
            UpdatePreference(prefUseFingerprint..value = value),
          );
        },
      ),
      Divider(height: 1),
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
          var subtitle = "v1.0";
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

  String _toLocalizationsFromType(String typeString) {
    switch (typeString) {
      case typeRichText:
        return AppLocalizations.of(context).labelRichText;
      case typeMarkdown:
        return AppLocalizations.of(context).labelMarkdown;
      case typeHandWriting:
        return AppLocalizations.of(context).labelHandWriting;
    }
    return null;
  }

  String _toLocalizationsFromAppendType(String appendType) {
    switch (appendType) {
      case typeNone:
        return AppLocalizations.of(context).labelAppendTypeNone;
      case typeSpace:
        return AppLocalizations.of(context).labelAppendTypeSpace;
      case typeNewline:
        return AppLocalizations.of(context).labelAppendTypeNewLine;
    }
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

class _DropdownPreference<T> extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String> labels;
  final List<T> values;
  final T initValue;
  final ValueChanged<T> onChanged;

  _DropdownPreference({
    Key key,
    @required this.title,
    this.subtitle,
    @required this.labels,
    @required this.values,
    @required this.initValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _DropdownPreferenceState<T> createState() => _DropdownPreferenceState<T>();
}

class _DropdownPreferenceState<T> extends State<_DropdownPreference> {
  T _dropdownValue;

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: widget.title,
      subtitle: widget.subtitle,
      threeLine: true,
      trailing: DropdownButton<T>(
        value: _dropdownValue,
        onChanged: widget.onChanged != null
            ? (T newValue) {
                setState(() {
                  _dropdownValue = newValue;
                });
                widget.onChanged(newValue);
              }
            : null,
        items: widget.values.asMap().entries.map((entry) {
          return DropdownMenuItem<T>(
            value: entry.value,
            child: Text(widget.labels[entry.key]),
          );
        }).toList(),
      ),
    );
  }
}
