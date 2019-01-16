import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_client/bloc/history_bloc.dart';
import 'package:sp_client/dependency_injection.dart';
import 'package:sp_client/localization.dart';
import 'package:sp_client/models.dart';
import 'package:sp_client/screen/area_select_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  HistoryBloc _bloc;

  @override
  Widget build(BuildContext context) {
    var db = Injector.of(context).database;
    _bloc = HistoryBloc(db);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              AppLocalizations.of(context).get('title_history'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            pinned: true,
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.bug_report),
                onPressed: () {
                  var history = History();
                  history.createdAt = DateTime.now().millisecondsSinceEpoch;
                  history.sourceImage = "Test";
                  _bloc.create(history);
                  _bloc.readAll();
                },
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              left: 4.0,
              right: 4.0,
              top: 4.0,
              bottom: 80.0,
            ),
            sliver: _buildHistories(),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        tooltip: AppLocalizations.of(context).get('add_image'),
        onPressed: _addImage,
        icon: Icon(Icons.add),
        label: Text(AppLocalizations.of(context).get('add_image')),
      ),
    );
  }

  Widget _buildHistories() {
    _bloc.readAll();
    return StreamBuilder(
        stream: _bloc.allData,
        builder: (context, AsyncSnapshot<List<History>> snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            var items = snapshot.data;
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                crossAxisCount: 2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => GridTile(
                      child: Container(
                        color: Colors.grey,
                      ),
                      footer: GridTileBar(
                        title: Text(items[index].createdAt.toString()),
                        backgroundColor: Colors.black45,
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _bloc.delete(items[index].id);
                            _bloc.readAll();
                          },
                        ),
                      ),
                    ),
                childCount: items.length,
              ),
            );
          } else {
            return SliverList(
              delegate: SliverChildListDelegate([
                Text('Empty data'),
              ]),
            );
          }
        });
  }

  _addImage() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
            child: Wrap(
              children: <Widget>[
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
                  leading: Icon(Icons.photo_camera),
                  title: Text(
                      AppLocalizations.of(context).get('image_from_camera')),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
    );
  }

  _getImage(ImageSource src) async {
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
