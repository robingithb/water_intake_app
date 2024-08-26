import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const WaterIntakeApp());
}

class WaterIntakeApp extends StatelessWidget {
  const WaterIntakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Water Intake",
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const WaterIntakeAppHomePage(),
    );
  }
}

class WaterIntakeAppHomePage extends StatefulWidget {
  const WaterIntakeAppHomePage({super.key});

  @override
  State<WaterIntakeAppHomePage> createState() => _WaterIntakeAppHomePageState();
}

class _WaterIntakeAppHomePageState extends State<WaterIntakeAppHomePage> {
  int _waterIntake = 0;
  int _dailyGoal = 8;
  final List<int> _dailyGoalOptions = [8, 10, 12];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake = (pref.getInt('waterIntake') ?? 0);
      _dailyGoal = (pref.getInt('dailyGoal') ?? 8);
    });
  }

  Future<void> _incrementWaterIntake() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake++;
      pref.setInt('waterIntake', _waterIntake);
      if (_waterIntake >= _dailyGoal) {
        //show a dialogue box
        _goalReachedDialog();
      }
    });
  }

  Future<void> _resetWaterInatke() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _waterIntake = 0;
      pref.setInt('waterIntake', _waterIntake);
    });
  }

  Future<void> _setDailyGoal(int newGoal) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _dailyGoal = newGoal;
      pref.setInt('dailyGoal', newGoal);
    });
  }

  Future<void> _goalReachedDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Congratulations...!",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    "You hav reached your daily goal of $_dailyGoal glasses of water...!",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  Future<void> _showResetConfirmationDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Comfirmation",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            content: const SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    "Are you sure you want to reset your water intake?",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  onPressed: () {
                    _resetWaterInatke();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Reset",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double progress = _waterIntake / _dailyGoal;
    bool goalReached = _waterIntake >= _dailyGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Water Intake App"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(
                Icons.water_drop,
                size: 120,
                color: Colors.blue,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "You have consumed : ",
                style: TextStyle(fontSize: 18),
              ),
              Text('$_waterIntake glasses of water',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(
                height: 15,
              ),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
                minHeight: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Daily Goal",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButton(
                  value: _dailyGoal,
                  items: _dailyGoalOptions.map((int value) {
                    return DropdownMenuItem(
                        value: value, child: Text("$value Glasses"));
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      _setDailyGoal(newValue);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
