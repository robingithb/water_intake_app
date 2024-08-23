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

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
