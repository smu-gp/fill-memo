import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_client/localizations.dart';
import 'package:sp_client/screen/area_select.dart';
import 'package:sp_client/screen/result.dart';

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
      body: _buildHistoryWidgets(),
      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context).get('add_image'),
        child: Icon(Icons.add_photo_alternate),
        onPressed: _showBottomSheet,
      ),
    );
  }

  Widget _buildHistoryWidgets() {
    var histories = List<String>.generate(
        10, (index) => '${new DateTime.now().toString()}');
    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
              title: Text(histories[index]),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ResultScreen()));
              },
            ),
        itemCount: histories.length);
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
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text(
                      AppLocalizations.of(context).get('image_from_camera')),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  void _getImage(ImageSource src) async {
    var image = await ImagePicker.pickImage(source: src);
    if (image != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AreaSelectScreen(
                    selectImage: image,
                  )));
    }
  }
}
