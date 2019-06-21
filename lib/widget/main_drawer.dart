import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:package_info/package_info.dart';
import 'package:sp_client/screen/settings_screen.dart';

import '../bloc/blocs.dart';
import '../util/utils.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SessionInfoHeader(),
            MainDrawerMenu(),
            ThemeSwitchItem(),
            _buildPackageInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageInfo() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PackageInfoText(),
        ),
      ),
    );
  }
}

class MainDrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var drawerBloc = BlocProvider.of<MainDrawerBloc>(context);
    var historyListBloc = BlocProvider.of<HistoryListBloc>(context);
    return BlocBuilder<MainDrawerEvent, MainDrawerState>(
      bloc: drawerBloc,
      builder: (context, state) {
        return Column(
          children: <Widget>[
            _DrawerSelectableItem(
              icon: OMIcons.accessTime,
              title: AppLocalizations.of(context).actionDate,
              selected: state.selectedMenu == 0,
              onTap: () {
                drawerBloc.dispatch(SelectMenu(0));
                Navigator.pop(context);
              },
            ),
            _DrawerSelectableItem(
              icon: OMIcons.folder,
              title: AppLocalizations.of(context).actionFolder,
              selected: state.selectedMenu == 1,
              onTap: () {
                drawerBloc.dispatch(SelectMenu(1));
                historyListBloc.dispatch(UnSelectable());
                Navigator.pop(context);
              },
            ),
            _DrawerSelectableItem(
              icon: OMIcons.lock,
              title: AppLocalizations.of(context).actionSecretFolder,
              selected: false,
              onTap: () {},
            ),
            Divider(),
            _DrawerItem(
              icon: OMIcons.phonelink,
              title: Text(AppLocalizations.of(context).actionConnection),
              onTap: () {},
            ),
            _DrawerItem(
              icon: OMIcons.settings,
              title: Text(AppLocalizations.of(context).actionSettings),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class SessionInfoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      currentAccountPicture: CircleAvatar(
        child: Icon(Util.isTablet(context)
            ? Icons.tablet_android
            : Icons.phone_android),
      ),
      accountName: Text("Name"),
      accountEmail: FutureBuilder<String>(
        future: _getDeviceName(),
        builder: (context, snapshot) => Text(snapshot.data ?? "Unknown"),
      ),
    );
  }

  Future<String> _getDeviceName() async {
    if (Platform.isAndroid) {
      var info = await DeviceInfoPlugin().androidInfo;
      return info.model;
    } else if (Platform.isIOS) {
      var info = await DeviceInfoPlugin().iosInfo;
      return info.utsname.machine;
    } else {
      return null;
    }
  }
}

class ThemeSwitchItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferenceEvent, PreferenceState>(
      bloc: BlocProvider.of<PreferenceBloc>(context),
      builder: (BuildContext context, PreferenceState state) {
        var darkModePref = state.preferences.get(AppPreferences.keyDarkMode);
        var themeBloc = BlocProvider.of<ThemeBloc>(context);
        return ListTileTheme(
          style: ListTileStyle.drawer,
          contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SwitchListTile(
            title: Text(AppLocalizations.of(context).actionDarkMode),
            secondary: Icon(
              Icons.brightness_2,
              color: Theme.of(context).accentColor,
            ),
            value: darkModePref.value,
            onChanged: (bool value) {
              BlocProvider.of<PreferenceBloc>(context)
                  .dispatch(UpdatePreference(darkModePref..value = value));
              themeBloc.dispatch(
                value ? AppThemes.darkTheme : AppThemes.lightTheme,
              );
            },
          ),
        );
      },
    );
  }
}

class PackageInfoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            "ver ${snapshot.data.version} (build. ${snapshot.data.buildNumber})",
            style: TextStyle(color: Theme.of(context).disabledColor),
          );
        } else {
          return Text('Unknown package info');
        }
      },
    );
  }
}

class _DrawerSelectableItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool selected;

  const _DrawerSelectableItem({
    @required this.icon,
    @required this.title,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color:
              selected ? Theme.of(context).accentColor.withOpacity(0.2) : null,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: selected ? Theme.of(context).accentColor : null,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: selected ? Theme.of(context).accentColor : null,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          onTap: onTap,
          selected: selected,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final Widget title;
  final VoidCallback onTap;

  const _DrawerItem({
    @required this.icon,
    @required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
      leading: Icon(
        icon,
        color: Theme.of(context).accentColor,
      ),
      title: title,
      onTap: onTap,
    );
  }
}
