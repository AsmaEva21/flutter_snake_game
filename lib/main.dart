import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
  debugShowCheckedModeBanner: false,
  home: GameScreen(),
  );
  }
  }

  class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
  }

  class _GameScreenState extends State<GameScreen> {
  static const int gridSize = 20;
  List<int> snake = [45, 65, 85];
  int food = 105;
  String direction = 'down';
  bool gameOver = false;
  Timer? gameLoop;

  @override
  void initState() {
  super.initState();
  spawnFood();
  startGame();
  }

  void startGame() {
  gameLoop = Timer.periodic(Duration(milliseconds: 300), (timer) {
  if (!gameOver) {
  moveSnake();
  }
  });
  }

  void spawnFood() {
  Random random = Random();
  do {
  food = random.nextInt(gridSize * gridSize);
  } while (snake.contains(food));
  }

  void moveSnake() {
  setState(() {
  int head = snake.last;

  switch (direction) {
  case 'up':
  head -= gridSize;
  break;
  case 'down':
  head += gridSize;
  break;
  case 'left':
  head -= 1;
  break;
  case 'right':
  head += 1;
  break;
  }

  if (head < 0 ||
  head >= gridSize * gridSize ||
  snake.contains(head) ||
  (direction == 'left' && head % gridSize == gridSize - 1) ||
  (direction == 'right' && head % gridSize == 0)) {
  gameOver = true;
  gameLoop?.cancel();
  showGameOverDialog();
  } else {
  snake.add(head);

  if (head == food) {
  spawnFood();
  } else {
  snake.removeAt(0);
  }
  }
  });
  }

  void showGameOverDialog() {
  showDialog(
  context: context,
  builder: (_) => AlertDialog(
  title: Text('Game Over'),
  content: Text('Your score: ${snake.length - 3}'),
  actions: [
  TextButton(
  onPressed: () {
  Navigator.of(context).pop();
  resetGame();
  },
  child: Text('Restart'),
  ),
  ],
  ),
  );
  }

  void resetGame() {
  setState(() {
  snake = [45, 65, 85];
  direction = 'down';
  gameOver = false;
  spawnFood();
  startGame();
  });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  backgroundColor: Colors.black,
  body: GestureDetector(
  onVerticalDragUpdate: (details) {
  if (details.delta.dy < 0 && direction != 'down') {
  direction = 'up';
  } else if (details.delta.dy > 0 && direction != 'up') {
  direction = 'down';
  }
  },
  onHorizontalDragUpdate: (details) {
  if (details.delta.dx < 0 && direction != 'right') {
  direction = 'left';
  } else if (details.delta.dx > 0 && direction != 'left') {
  direction = 'right';
  }
  },
  child: Center(
  child: AspectRatio(
  aspectRatio: 1,
  child: GridView.builder(
  physics: NeverScrollableScrollPhysics(),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: gridSize,
  ),
  itemCount: gridSize * gridSize,
  itemBuilder: (context, index) {
  if (snake.contains(index)) {
  return Container(
  margin: EdgeInsets.all(1),
  color: Colors.green,
  );
  } else if (index == food) {
  return Container(
  margin: EdgeInsets.all(1),
  color: Colors.red,
  );
  } else {
  return Container(
  margin: EdgeInsets.all(1),
  color: Colors.grey[800],
  );
  }
  },
  ),
  ),
  ),
  ),
  );
  }

  @override
  void dispose() {
  gameLoop?.cancel();
  super.dispose();
  }
  }