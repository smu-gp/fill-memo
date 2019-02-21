import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).titleHistory,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: AppLocalizations.of(context).get('sort'),
            onPressed: () => showDialog(
                  context: context,
                  builder: (context) => SortDialog(),
                ),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: HistoryList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        tooltip: AppLocalizations.of(context).get('add_image'),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => _buildAddImageSheet(),
          );
        },
        icon: Icon(Icons.add),
        label: Text(AppLocalizations.of(context).get('add_image')),
      ),
    );
  }

  _buildAddImageSheet() {
    return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.image),
            title: Text(AppLocalizations.of(context).get('image_from_gallery')),
            onTap: () {
              _pickImage(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text(AppLocalizations.of(context).get('image_from_camera')),
            onTap: () {
              _pickImage(ImageSource.camera);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  _pickImage(ImageSource src) async {
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
