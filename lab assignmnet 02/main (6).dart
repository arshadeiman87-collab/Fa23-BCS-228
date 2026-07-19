import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

// --------------------- MAIN APP ---------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Guessing Game',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const HomeScreen(),
    );
  }
}

// --------------------- HOME SCREEN ---------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  int randomNumber = Random().nextInt(100) + 1;

  static const String gameImageUrl =
      "https://cdn-icons-png.flaticon.com/512/3081/3081054.png";

  void _checkGuess() {
    // Ensure context is valid here (inside State)
    if (_controller.text.isEmpty) {
     // ScaffoldMessenger.of(context).showSnackBar(
        //  const SnackBar(content: Text("Please enter a number")));
      return;
    }

    int? guess = int.tryParse(_controller.text);
    if (guess == null || guess < 1 || guess > 100) {
      //ScaffoldMessenger.of(context).showSnackBar(
     //     const SnackBar(content: Text("Enter a number between 1 and 100")));
      return;
    }

    String result;
    if (guess == randomNumber) {
      result = "Correct!";
    } else if (guess > randomNumber) {
      result = "Too High!";
    } else {
      result = "Too Low!";
    }

    // Use Navigator with context from State
    //Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          guess: guess,
          result: result,
          onReset: _resetGame,
          imageUrl: gameImageUrl,
        ),
     // ),
    );
  }

  void _resetGame() {
    setState(() {
      randomNumber = Random().nextInt(100) + 1;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(gameImageUrl, height: 150),
              const SizedBox(height: 20),
              const Text(
                "Guess a number between 1 and 100",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  labelText: "Enter your guess",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkGuess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child:
                    const Text("Submit Guess", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HistoryScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("View History",
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------- RESULT SCREEN ---------------------
class ResultScreen extends StatelessWidget {
  final int guess;
  final String result;
  final VoidCallback onReset;
  final String imageUrl;

  const ResultScreen(
      {super.key,
      required this.guess,
      required this.result,
      required this.onReset,
      required this.imageUrl});

  void _saveResult(BuildContext context) async {
    DBHelper db = DBHelper();
    await db.insertResult(GameResult(
      guess: guess,
      status: result,
      timestamp: DateTime.now().toString(),
    ));

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Result saved")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(imageUrl, height: 120),
                const SizedBox(height: 20),
                Text("Your guess: $guess",
                    style:
                        const TextStyle(fontSize: 24, color: Colors.white)),
                const SizedBox(height: 20),
                Text(result,
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _saveResult(context);
                    onReset();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Play Again",
                      style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _saveResult(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const HistoryScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("View History",
                      style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------- HISTORY SCREEN ---------------------
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DBHelper db = DBHelper();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<List<GameResult>>(
            future: db.getResults(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

              if (snapshot.data!.isEmpty) {
                return const Center(
                    child: Text("No history yet",
                        style: TextStyle(fontSize: 20, color: Colors.white)));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  GameResult result = snapshot.data![index];
                  return Card(
                    color: Colors.white70,
                    child: ListTile(
                      title: Text("Guess: ${result.guess} - ${result.status}"),
                      subtitle: Text(result.timestamp),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// --------------------- DATABASE HELPER ---------------------
class DBHelper {
  static Database? _database;
  static const String DB_NAME = "game_results.db";
  static const String TABLE = "results";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), DB_NAME);
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $TABLE(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          guess INTEGER,
          status TEXT,
          timestamp TEXT
        )
      ''');
    });
  }

  Future<int> insertResult(GameResult result) async {
    final db = await database;
    return await db.insert(TABLE, result.toMap());
  }

  Future<List<GameResult>> getResults() async {
    final db = await database;
    var results = await db.query(TABLE, orderBy: "id DESC");
    return results.isNotEmpty
        ? results.map((e) => GameResult.fromMap(e)).toList()
        : [];
  }
}

// --------------------- GAME RESULT MODEL ---------------------
class GameResult {
  int? id;
  int guess;
  String status;
  String timestamp;

  GameResult(
      {this.id, required this.guess, required this.status, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guess': guess,
      'status': status,
      'timestamp': timestamp,
    };
  }

  factory GameResult.fromMap(Map<String, dynamic> map) {
    return GameResult(
      id: map['id'],
      guess: map['guess'],
      status: map['status'],
      timestamp: map['timestamp'],
    );
  }
}
