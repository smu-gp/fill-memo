import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_client/localizations.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  factory MainScreen.forDesignTime() {
    return new MainScreen();
  }

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).get('title')),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Hello!'),
            onTap: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add_photo_alternate),
        onPressed: _showBottomSheet,
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context).get('add_image'),
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text(
                      AppLocalizations.of(context).get('image_from_gallery')),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text(
                      AppLocalizations.of(context).get('image_from_camera')),
                  onTap: () {
                    _getImage(ImageSource.camera);
                  },
                )
              ],
            ),
          );
        });
  }

  void _getImage(ImageSource src) async {
    var image = await ImagePicker.pickImage(source: src);
  }
}
