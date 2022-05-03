import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

const url = 'https://bit.ly/3x7J5Qt';

enum Action {
  rotateLeft,
  rotateRight,
  moreVisible,
  lessVisible,
}

class State {
  final double rotatingDeg;
  final double alpha;

  const State({
    required this.rotatingDeg,
    required this.alpha,
  });

  const State.zero()
      : rotatingDeg = 0.0,
        alpha = 1.0;

  State rotationRight() => State(
        alpha: alpha,
        rotatingDeg: rotatingDeg + 10,
      );
  State rotationLeft() => State(
        alpha: alpha,
        rotatingDeg: rotatingDeg - 10,
      );
  State increaseAlpha() => State(
        alpha: min(alpha + 0.1, 1.0),
        rotatingDeg: rotatingDeg,
      );
  State decreaseAlpha() => State(
        alpha: max(alpha - 0.1, 0.0),
        rotatingDeg: rotatingDeg,
      );
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotateLeft:
      return oldState.rotationLeft();
    case Action.rotateRight:
      return oldState.rotationRight();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case null:
      return oldState;
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(
      reducer,
      initialState: const State.zero(),
      initialAction: null,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RotateLeftButton(store: store),
              RotateRightButton(store: store),
              IncreaseOpacity(store: store),
              DecreaseOpacity(store: store),
            ],
          ),
          const SizedBox(height: 100),
          const SizedBox(),
          Opacity(
            opacity: store.state.alpha,
            child: RotationTransition(
                turns: AlwaysStoppedAnimation(store.state.rotatingDeg / 360.0),
                child: Image.network(url)),
          ),
        ],
      ),
    );
  }
}

class DecreaseOpacity extends StatelessWidget {
  const DecreaseOpacity({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.lessVisible);
      },
      child: const Text('- Opacity'),
    );
  }
}

class IncreaseOpacity extends StatelessWidget {
  const IncreaseOpacity({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.moreVisible);
      },
      child: const Text('+ Opacity'),
    );
  }
}

class RotateRightButton extends StatelessWidget {
  const RotateRightButton({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.rotateRight);
      },
      child: const Text('Rotate Right'),
    );
  }
}

class RotateLeftButton extends StatelessWidget {
  const RotateLeftButton({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<State, Action?> store;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        store.dispatch(Action.rotateLeft);
      },
      child: const Text('Rotate Left'),
    );
  }
}
