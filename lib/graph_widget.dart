import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'drawing_bloc.dart';
import 'obtained.dart';
import 'path_painter.dart';
import 'states/drawing_state.dart';
import 'store_wrapper.dart';
import 'graph_mode.dart';

class GraphWidget extends StatelessWidget {

  static const int FREQ = 24;      // frames-per-seconds
  final int PERIOD = 1000;  // 1s = 1000ms

  final int samplesNumber;
  final double width;
  final double height;
  final GraphMode mode;
  late VoidCallback onDestroyAction;
  final String uuid = const Uuid().v4().toString();

  bool _startStop = false;

  late StoreWrapper storeWrapper;
 
  final Obtained obtain = Obtained.part(const Duration(milliseconds: FREQ));

  GraphWidget({super.key, required this.samplesNumber, required this.width, required this.height, required this.mode}) {
    int pointsToDraw = (samplesNumber.toDouble()/(PERIOD.toDouble()/FREQ.toDouble())).toInt() + 1;
    storeWrapper = StoreWrapper(samplesNumber, 5, pointsToDraw, mode);
  }

  void setDestroyButton(final VoidCallback onPressedAction) {
    onDestroyAction = onPressedAction;
  }

  @override
  Widget build(BuildContext context) {
    return  BlocProvider<DrawingBloc>(
      create: (_) => DrawingBloc(DrawingState(DrawingStates.drawing)),
      child: GestureDetector(
        onTap: () {
          _startStop = !_startStop;
          if (_startStop) {
            obtain.start(uuid);
          }
          else {
            obtain.stop(uuid);
          }
        },
        child:
          BlocBuilder<DrawingBloc, DrawingState>(builder: (context, state) {

          obtain.set(storeWrapper.drawingFrequency(), context);
          storeWrapper.updateBuffer(state.counter());

          return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            SizedBox(
              width: width,
              height: height,
              child: CustomPaint(
                painter: PathPainter.graph(state.counter(), storeWrapper),
              ),
            ),

            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // Action to be performed when the button is pressed
                print('DELETE Icon button pressed');

                 if (_startStop) {
                  obtain.stop(uuid);
                  _startStop = false;
                }
                onDestroyAction();
              },
            ),
          ],
          );
        }),
      ),
    );
  }
}
