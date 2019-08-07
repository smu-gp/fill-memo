import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/constants.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/util/preference.dart';
import 'package:sp_client/widget/list_item.dart';

enum _MemoType { richText, markdown, handWriting }

class SettingsMemoTypeScreen extends StatefulWidget {
  @override
  _SettingsMemoTypeScreenState createState() => _SettingsMemoTypeScreenState();
}

class _SettingsMemoTypeScreenState extends State<SettingsMemoTypeScreen> {
  PreferenceBloc _preferenceBloc;
  Preference<String> savedType;
  _MemoType _type;

  @override
  void initState() {
    super.initState();
    _preferenceBloc = BlocProvider.of<PreferenceBloc>(context);
    savedType =
        _preferenceBloc.getPreference(AppPreferences.keyDefaultMemoType);
    _type = _toTypeFromString(savedType.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).labelDefaultMemoType),
        elevation: 0.0,
      ),
      body: ListView.separated(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return <Widget>[
            ListItem(
              leading: Radio(
                value: _MemoType.richText,
                groupValue: _type,
                onChanged: (_MemoType value) => _updateType(value),
              ),
              title: AppLocalizations.of(context).labelRichText,
              onTap: () => _updateType(_MemoType.richText),
            ),
            ListItem(
              leading: Radio(
                value: _MemoType.markdown,
                groupValue: _type,
                onChanged: (_MemoType value) => _updateType(value),
              ),
              title: AppLocalizations.of(context).labelMarkdown,
              onTap: () => _updateType(_MemoType.markdown),
            ),
            ListItem(
              leading: Radio(
                value: _MemoType.handWriting,
                groupValue: _type,
                onChanged: (_MemoType value) => _updateType(value),
              ),
              title: AppLocalizations.of(context).labelHandWriting,
              onTap: () => _updateType(_MemoType.handWriting),
            ),
          ].elementAt(index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(height: 2.0);
        },
      ),
    );
  }

  void _updateType(_MemoType type) {
    setState(() {
      _type = type;
    });
  }

  String _toStringFromType(_MemoType type) {
    switch (type) {
      case _MemoType.richText:
        return typeRichText;
      case _MemoType.markdown:
        return typeMarkdown;
      case _MemoType.handWriting:
        return typeHandWriting;
    }
    return null;
  }

  _MemoType _toTypeFromString(String string) {
    switch (string) {
      case typeRichText:
        return _MemoType.richText;
      case typeMarkdown:
        return _MemoType.markdown;
      case typeHandWriting:
        return _MemoType.handWriting;
    }
    return null;
  }

  @override
  void dispose() {
    _preferenceBloc.dispatch(
        UpdatePreference(savedType..value = _toStringFromType(_type)));
    super.dispose();
  }
}
