import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_client/bloc/history_bloc.dart';
import 'package:sp_client/bloc/result_bloc.dart';
import 'package:sp_client/dependency_injection.dart';
import 'package:sp_client/localization.dart';
import 'package:sp_client/models.dart';
import 'package:sp_client/screen/area_select_screen.dart';
import 'package:sp_client/screen/result_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  HistoryBloc _historyBloc;
  ResultBloc _resultBloc;
  SortOrder _sortOrder = SortOrder.createdAtDes;

  @override
  Widget build(BuildContext context) {
    var db = Injector.of(context).database;
    _historyBloc = HistoryBloc(db);
    _resultBloc = ResultBloc(db);
    return OrientationBuilder(
      builder: (context, orientation) => Scaffold(
            body: Builder(
              builder: (context) => CustomScrollView(
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
                            icon: Icon(Icons.sort),
                            tooltip: AppLocalizations.of(context).get('sort'),
                            onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => _buildSortDialog(),
                                ),
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
                        sliver: _buildHistories(context, orientation),
                      )
                    ],
                  ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              tooltip: AppLocalizations.of(context).get('add_image'),
              onPressed: _addImage,
              icon: Icon(Icons.add),
              label: Text(AppLocalizations.of(context).get('add_image')),
            ),
          ),
    );
  }

  Widget _buildHistories(BuildContext context, Orientation orientation) {
    _historyBloc.readAll(
      orderBy:
          '${History.columnCreatedAt} ${_sortOrder == SortOrder.createdAtAsc ? 'ASC' : 'DESC'}',
    );
    return StreamBuilder(
        stream: _historyBloc.allData,
        builder: (context, AsyncSnapshot<List<History>> snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            var items = snapshot.data;
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => GridTile(
                      child: Ink.image(
                        image: FileImage(File(items[index].sourceImage)),
                        fit: BoxFit.cover,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                        historyId: items[index].id,
                                      ),
                                ));
                          },
                        ),
                      ),
                      footer: GridTileBar(
                        title: Text(DateTime.fromMillisecondsSinceEpoch(
                                items[index].createdAt)
                            .toString()),
                        backgroundColor: Colors.black45,
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _historyBloc.delete(items[index].id);
                            Scaffold.of(context)
                                .showSnackBar(
                                    _buildDeleteHistorySnackBar(items[index]))
                                .closed
                                .then((SnackBarClosedReason reason) {
                              if (reason == SnackBarClosedReason.timeout ||
                                  reason == SnackBarClosedReason.swipe) {
                                _resultBloc.deleteByHistoryId(items[index].id);
                              }
                            });
                            setState(() {});
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

  _buildSortDialog() {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).get('sort')),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 0.0,
      ),
      content: Wrap(
        children: <Widget>[
          RadioListTile<SortOrder>(
              title:
                  Text(AppLocalizations.of(context).get('order_created_des')),
              value: SortOrder.createdAtDes,
              groupValue: _sortOrder,
              onChanged: (value) {
                setState(() {
                  _sortOrder = value;
                  Navigator.pop(context);
                });
              }),
          RadioListTile<SortOrder>(
              title:
                  Text(AppLocalizations.of(context).get('order_created_asc')),
              value: SortOrder.createdAtAsc,
              groupValue: _sortOrder,
              onChanged: (value) {
                setState(() {
                  _sortOrder = value;
                  Navigator.pop(context);
                });
              }),
        ],
      ),
    );
  }

  _buildDeleteHistorySnackBar(History history) {
    return SnackBar(
      content: Text(AppLocalizations.of(context)
          .get('item_deleted')
          .replaceFirst(
              '\$',
              DateTime.fromMillisecondsSinceEpoch(history.createdAt)
                  .toString())),
      action: SnackBarAction(
          label: AppLocalizations.of(context).get('undo'),
          onPressed: () {
            _historyBloc.create(history);
            setState(() {});
          }),
    );
  }

  _buildBottomSheet() {
    return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.image),
            title: Text(AppLocalizations.of(context).get('image_from_gallery')),
            onTap: () {
              _getImage(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text(AppLocalizations.of(context).get('image_from_camera')),
            onTap: () {
              _getImage(ImageSource.camera);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  _addImage() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => _buildBottomSheet(),
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
