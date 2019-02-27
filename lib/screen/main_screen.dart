import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sp_client/screen/area_select_screen.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/widget/history_list.dart';
import 'package:sp_client/widget/sort_dialog.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).titleHistory,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: _buildActions(),
      ),
      body: HistoryList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context).actionAddImage,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: _buildAddImageSheet,
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.sort),
        tooltip: AppLocalizations.of(context).actionSort,
        onPressed: () => showDialog(
              context: context,
              builder: (context) => SortDialog(),
            ),
      ),
      IconButton(
        icon: Icon(OMIcons.settings),
        onPressed: () {},
      ),
    ];
  }

  Widget _buildAddImageSheet(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(
              OMIcons.image,
              color: Theme.of(context).accentColor,
            ),
            title: Text(AppLocalizations.of(context).imageFromGallery),
            onTap: () {
              _pickImage(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.photoCamera,
              color: Theme.of(context).accentColor,
            ),
            title: Text(AppLocalizations.of(context).imageFromCamera),
            onTap: () {
              _pickImage(ImageSource.camera);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void _pickImage(ImageSource src) async {
    var image = await ImagePicker.pickImage(source: src);
    if (image != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AreaSelectScreen(
                  selectImage: image,
                ),
          ));
    }
  }
}
