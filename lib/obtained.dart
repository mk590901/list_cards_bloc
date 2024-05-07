import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawing_bloc.dart';
import 'events/draw_events.dart';
import 'events/event.dart';
import 'pair_data_object.dart';

class Obtained {

  final Duration _period;
  late int _cycles;
  late BuildContext _context;

  late Timer? _timer;

  int _counter = 1; //  Ok

  Obtained (this._period, this._cycles, this._context);

  Obtained.part (this._period);

  void set(int cycles, BuildContext context) {
    _cycles = cycles;
    _context = context;
  }

  void start(final String uuid) {
    print ('------- Obtainer.start [$uuid] -------');

    _counter = 0;
    _timer = Timer.periodic(_period, (Timer t) {
       _callbackFunction(uuid);
    });

  }

  void redraw(BuildContext context, String uuid, int counter) {
    Event? event = Drawing();
    event.setData(Pair(uuid,counter));
    context.read<DrawingBloc>().add(event);
  }

  void _callbackFunction(String uuid) {
    redraw(_context, uuid, _counter++);
    if (_counter >= _cycles) {
      _counter = 1;
    }
  }

  void stop(final String uuid) {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    _timer = null;
    print ('------- Obtainer.stop [$uuid] -------');

  }

  bool isActive() {
    return _timer != null && _timer!.isActive;
  }

}
