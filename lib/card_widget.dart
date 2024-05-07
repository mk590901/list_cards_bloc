import 'package:flutter/material.dart';
import 'graph_widget.dart';

class CustomCardWidget extends StatelessWidget {
  late String title;
  late String subtitle;
  late IconData iconData;
  final VoidCallback onDeleteWidgetAction;

  final GraphWidget graphWidget;

  CustomCardWidget({
    super.key,
    required this.graphWidget,
    required this.onDeleteWidgetAction,
  }) {
    //graphWidget.setDestroyButton(onDeleteWidgetAction);
    title = "ECG Diagram [${graphWidget.uuid.substring(0, 8)}]";
    subtitle = "Sample rate is ${graphWidget.samplesNumber} points/s";
    iconData = Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(iconData, color: Colors.lightBlue,),
            title: Text(title),
            subtitle: Text(subtitle, style: const TextStyle(
                fontStyle: FontStyle.italic)),
          ),
          graphWidget,
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              // Action to be performed when the button is pressed
              graphWidget.stop();
              onDeleteWidgetAction();
            },
          ),
        ],
      ),
    );
  }
}
