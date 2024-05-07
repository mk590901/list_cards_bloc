import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'utils.dart';
import 'card_widget.dart';
import 'graph_mode.dart';
import 'graph_widget.dart';

void main() {
  runApp(const ListApp());
}

class ListApp extends StatelessWidget {
  const ListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter List BLoC Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => ItemBloc(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Cards<BLoC> List',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontStyle: FontStyle.italic)),
            leading: IconButton(
              icon: const Icon(Icons.crop_rounded, color: Colors.white), // Icon widget
              onPressed: () {
                // Add onPressed logic here if need
              },
            ),
            backgroundColor: Colors.lightBlue,
          ),
          body: const ItemList(),
          floatingActionButton: const AddItemButton(),
        ),
      ),
    );
  }
}

class ItemBloc extends Bloc<ItemEvent, List<CustomCardWidget>> {
  ItemBloc() : super([]) {
    on<ItemEvent>((event, Emitter<List<CustomCardWidget>> emit) {
      if (event is AddItemEvent) {
        // Handle AddItem event
        List<CustomCardWidget> currentItems = List.from(state);
        currentItems.add(event.item);
        emit(currentItems);
      } else if (event is RemoveItemEvent) {
        // Handle RemoveItem event
        List<CustomCardWidget> currentItems = List.from(state);
        currentItems.remove(event.item);
        emit(currentItems);
      }
    });
  }

  Stream<List<CustomCardWidget>> mapEventToState(ItemEvent event) async* {
    if (event is AddItemEvent) {
      // Logic to handle AddItem event
      List<CustomCardWidget> currentItems = List.from(state);
      currentItems.add(event.item);
      yield currentItems;
    } else if (event is RemoveItemEvent) {
      List<CustomCardWidget> currentItems = List.from(state);
      currentItems.remove(event.item);
      yield currentItems;
    }
  }
}

abstract class ItemEvent {}

class AddItemEvent extends ItemEvent {
  final CustomCardWidget item;

  AddItemEvent(this.item);
}

class RemoveItemEvent extends ItemEvent {
  final CustomCardWidget item;

  RemoveItemEvent(this.item);
}

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemBloc, List<CustomCardWidget>>(
      builder: (context, items) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items
                .map((item) => CustomCardWidget(
                      graphWidget: item.graphWidget,
                      onDeleteWidgetAction: () {
                        final bloc = BlocProvider.of<ItemBloc>(context);
                        if (bloc.state.isNotEmpty) {
                          bloc.add(RemoveItemEvent(item));
                        } else {
                          const snackBar = SnackBar(
                            content: Text('Failed to remove card: no more'),
                            duration: Duration(seconds: 1),
                            backgroundColor: Colors.deepPurpleAccent,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

class AddItemButton extends StatelessWidget {
  const AddItemButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        final bloc = BlocProvider.of<ItemBloc>(context);
        int number = bloc.state.length + 1;
        final item = CustomCardWidget(
          graphWidget: GraphWidget(
              samplesNumber: getRandomValue(100, 220),
              width: 340,
              height: 100,
              mode: (number % 2 == 0) ? GraphMode.overlay : GraphMode.flowing),
          onDeleteWidgetAction: () {},
        );
        bloc.add(AddItemEvent(item)); // Dispatch AddItem event to the bloc
      },
      backgroundColor: Colors.lightBlue,
      foregroundColor: Colors.white,
      child: const Icon(Icons.add),
    );
  }
}
