import 'package:flash_it/bloc/bloc_provider.dart';
import 'package:flash_it/bloc/topic_database_bloc.dart';
import 'package:flash_it/controllers/google_services_api.dart';
import 'package:flash_it/models/entities/topic_model.dart';
import 'package:flash_it/widgets/topic/topic_grid.dart';
import 'package:flash_it/widgets/ui/form_dialog.dart';
import 'package:flash_it/widgets/ui/side_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Widget child;
  TopicDatabaseBloc _topicDatabaseBloc = TopicDatabaseBloc();

  HomePage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<TopicDatabaseBloc>(
        key: Key("_HomePageState BlocProvider"),
        bloc: _topicDatabaseBloc,
        child: Scaffold(
          key: Key("_HomePageState Scaffold"),
          appBar: AppBar(
            key: Key("_HomePageState AppBar"),
            title: const Text("Topics"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.sync),
                tooltip: 'Sync data',
                onPressed: () => GoogleServicesAPI.gService.sync(),
              ),
              IconButton(
                icon: Icon(Icons.add),
                tooltip: 'Add new topic',
                onPressed: () => _handleAdd(context),
              ),
            ],
          ),
          drawer: SideDrawer(0),
          body: StreamBuilder<List<TopicModel>>(
            stream: _topicDatabaseBloc.topics,
            builder: _steamBuilder,
          ),
        ),
      );

  Widget _steamBuilder(
    BuildContext context,
    AsyncSnapshot<List<TopicModel>> snapshot,
  ) =>
      snapshot.hasData
          ? snapshot.data.length > 0
              ? TopicGrid(
                  key: Key('_HomePageState TopicGrid'),
                  topics: snapshot.data,
                )
              : Center(child: Text('There are no topics! Add some!'))
          : Center(
              child: CircularProgressIndicator(
              key: Key('_HomePageState CircularProgressIndicator'),
            ));

  void _handleAdd(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) => FormDialog(
            formData: Map<String, dynamic>.of(topicFormData),
            title: 'Add New Topic',
            field1: 1,
            field2: 2,
            fieldHint1: 'E.g. Calculus',
            fieldHint2: 'E.g. Facts and formulae',
            formKey1: topicAttributes[1][0],
            formKey2: topicAttributes[2][0],
            operation: _topicDatabaseBloc.insert,
            existingValue: null,
            primaryKey: topicPK,
            foreignKey: null,
            parentID: null,
            buttonText: 'Add topic',
          ));
}
