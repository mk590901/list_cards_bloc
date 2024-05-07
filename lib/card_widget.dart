import 'package:flutter/material.dart';
import 'graph_widget.dart';

class CustomCardWidget extends StatefulWidget {
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
    title = "ECG Diagram [${graphWidget.uuid.substring(0, 8)}]";
    subtitle = "Sample rate is ${graphWidget.samplesNumber} points/s";
    iconData = Icons.info_outline;
  }

  @override
  State<CustomCardWidget> createState() => _CustomCardWidgetState();
}

class _CustomCardWidgetState extends State<CustomCardWidget> {

  bool disposed_ = false;

  final MaterialStateProperty<Color?> trackColor =
  MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
      // Track color when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return Colors.lightBlue;
      }
      // Otherwise return null to set default track color
       return null;
    },
  );

  final MaterialStateProperty<Icon?> thumbIconRun =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.play_arrow_sharp);
      }
      return const Icon(Icons.pause_sharp);
    },
  );

  final MaterialStateProperty<Icon?> thumbIconMode =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.equalizer_sharp);
      }
      return const Icon(Icons.monitor_heart_outlined);
    },
  );

  @override
  void initState() {
    widget.graphWidget.setRefreshCallback(onRefreshAction);
    disposed_ = false;
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of resources or controllers when the widget is removed from the widget tree
    disposed_ = true;
    super.dispose();
  }

  void onRefreshAction() {
    print ("******* refreshAction *******");
    if (disposed_) {
      print ("******* refreshAction.leave *******");
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(widget.iconData, color: Colors.lightBlue,),
            title: Text(widget.title),
            subtitle: Text(widget.subtitle, style: const TextStyle(
                fontStyle: FontStyle.italic)),
          ),
          widget.graphWidget,
          ButtonBar(
          children: <Widget>[

            Switch(
                trackColor: trackColor,
                thumbIcon: thumbIconMode,
                value: widget.graphWidget.isFlowing(),
                onChanged: (bool newValue) {
                  widget.graphWidget.onChangeMode();
                }
            ),

            Switch(
                trackColor: trackColor,
                thumbIcon: thumbIconRun,
                value: widget.graphWidget.isActive(),
                onChanged: (bool newValue) {
                  widget.graphWidget.onStartStop();
                }
            ),

            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // Action to be performed when the button is pressed
                widget.graphWidget.stop();
                widget.onDeleteWidgetAction();
              },
            ),
          ]),
        ],
      ),
    );
  }
}
