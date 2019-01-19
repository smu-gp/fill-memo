import 'dart:io';

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
  SortOrder _sortOrder = SortOrder.createdAtDes;

  @override
  Widget build(BuildContext context) {
    var db = Injector.of(context).database;
    _bloc = HistoryBloc(db);
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
                            onPressed: () {
                              _showSortDialog();
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
    _bloc.readAll(
      orderBy:
          '${History.columnCreatedAt} ${_sortOrder == SortOrder.createdAtAsc ? 'ASC' : 'DESC'}',
    );
    return StreamBuilder(
        stream: _bloc.allData,
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
                      child: Image.file(
                        File(items[index].sourceImage),
                        fit: BoxFit.cover,
                      ),
                      footer: GridTileBar(
                        title: Text(DateTime.fromMillisecondsSinceEpoch(
                                items[index].createdAt)
                            .toString()),
                        backgroundColor: Colors.black45,
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _bloc.delete(items[index].id);
                            Scaffold.of(context).showSnackBar(
                                _buildDeleteHistorySnackBar(items[index]));
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

  _showSortDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context).get('sort')),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 0.0,
            ),
            content: Wrap(
              children: <Widget>[
                RadioListTile<SortOrder>(
                    title: Text(
                        AppLocalizations.of(context).get('order_created_des')),
                    value: SortOrder.createdAtDes,
                    groupValue: _sortOrder,
                    onChanged: (value) {
                      setState(() {
                        _sortOrder = value;
                        Navigator.pop(context);
                      });
                    }),
                RadioListTile<SortOrder>(
                    title: Text(
                        AppLocalizations.of(context).get('order_created_asc')),
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
            _bloc.create(history);
            setState(() {});
          }),
    );
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
