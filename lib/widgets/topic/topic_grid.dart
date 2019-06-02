import 'package:flash_it/models/entities/topic_model.dart';
import 'package:flash_it/widgets/topic/topic_tile.dart';
import 'package:flutter/material.dart';

class TopicGrid extends StatelessWidget {
  final Widget child;
  final List<TopicModel> topics;

  TopicGrid({
    Key key,
    @required this.topics,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scrollbar(
        key: Key('${this.runtimeType} Scrollbar'),
        child: GridView.builder(
          key: Key("${this.runtimeType} GridView.builder"),
          itemCount: topics.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) => TopicTile(
                key: ValueKey(topics[index].id),
                topic: topics[index],
                isOdd: index.isOdd,
              ),
        ),
      );
}
