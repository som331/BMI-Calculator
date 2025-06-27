import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';


class BMIRecord {
  final String name;
  final int age;
  final String gender;
  final double bmi;
  final String category;
  final DateTime date;

  BMIRecord({
    required this.name,
    required this.age,
    required this.gender,
    required this.bmi,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'gender': gender,
    'bmi': bmi,
    'category': category,
    'date': date.toIso8601String(),
  };

  static BMIRecord fromJson(Map<String, dynamic> json) => BMIRecord(
    name: json['name'],
    age: json['age'],
    gender: json['gender'],
    bmi: json['bmi'],
    category: json['category'],
    date: DateTime.parse(json['date']),
  );
}

void main() {
  runApp(BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
        home: HomeScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int age = 0;
  String gender = 'Male';
  double height = 0;
  double weight = 0;
  bool isMetric = true;

  double? bmiResult;

  String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  void calculateBMI() {
    double h = isMetric ? height / 100 : height * 0.0254;
    double w = isMetric ? weight : weight * 0.4536;
    double bmi = w / (h * h);

    setState(() {
      bmiResult = double.parse(bmi.toStringAsFixed(1));
    });

    saveBMIRecord();
  }
  void saveBMIRecord() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingRecords =
        prefs.getStringList('bmi_history') ?? [];

    final record = BMIRecord(
      name: name,
      age: age,
      gender: gender,
      bmi: bmiResult!,
      category: getBMICategory(bmiResult!),
      date: DateTime.now(),
    );

    existingRecords.add(jsonEncode(record.toJson()));
    await prefs.setStringList('bmi_history', existingRecords);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BMI Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (val) => name = val!,
                  validator: (val) =>
                  val!.isEmpty ? 'Please enter your name' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  onSaved: (val) => age = int.parse(val!),
                  validator: (val) =>
                  val == null || int.tryParse(val) == null || int.parse(val) <= 0
                      ? 'Enter valid age'
                      : null,
                ),
                DropdownButtonFormField<String>(
                  value: gender,
                  items: ['Male', 'Female', 'Other']
                      .map((g) => DropdownMenuItem(child: Text(g), value: g))
                      .toList(),
                  onChanged: (val) => setState(() => gender = val!),
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                SwitchListTile(
                  title: Text('Use Metric Units (cm, kg)'),
                  value: isMetric,
                  onChanged: (val) => setState(() => isMetric = val),
                ),
                TextFormField(
                  decoration:
                  InputDecoration(labelText: 'Height (${isMetric ? "cm" : "inches"})'),
                  keyboardType: TextInputType.number,
                  onSaved: (val) => height = double.parse(val!),
                  validator: (val) =>
                  val == null || double.tryParse(val) == null || double.parse(val) <= 0
                      ? 'Enter valid height'
                      : null,
                ),
                TextFormField(
                  decoration:
                  InputDecoration(labelText: 'Weight (${isMetric ? "kg" : "lbs"})'),
                  keyboardType: TextInputType.number,
                  onSaved: (val) => weight = double.parse(val!),
                  validator: (val) =>
                  val == null || double.tryParse(val) == null || double.parse(val) <= 0
                      ? 'Enter valid weight'
                      : null,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Calculate BMI'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      calculateBMI();
                    }
                  },
                ),



                if (bmiResult != null) ...[
                  SizedBox(height: 24),
                  Text('Your BMI is: $bmiResult',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(
                    'Category: ${getBMICategory(bmiResult!)}',
                    style: TextStyle(
                        fontSize: 18,
                        color: {
                          'Underweight': Colors.blue,
                          'Normal': Colors.green,
                          'Overweight': Colors.orange,
                          'Obese': Colors.red
                        }[getBMICategory(bmiResult!)]
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class BMIHistoryScreen extends StatefulWidget {
  @override
  _BMIHistoryScreenState createState() => _BMIHistoryScreenState();
}

class _BMIHistoryScreenState extends State<BMIHistoryScreen> {
  List<BMIRecord> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList('bmi_history') ?? [];

    setState(() {
      history = data
          .map((item) => BMIRecord.fromJson(jsonDecode(item)))
          .toList()
          .reversed
          .toList(); // Most recent first
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI History"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Clear History"),
                  content: Text("Are you sure you want to delete all records?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("Cancel")),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("Delete")),
                  ],
                ),
              );

              if (confirm == true) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('bmi_history');
                setState(() {
                  history.clear();
                });
              }
            },
          ),
        ],
      ),
      body: history.isEmpty
          ? Center(child: Text("No BMI records found."))
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final record = history[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text('${record.name} - BMI: ${record.bmi.toStringAsFixed(1)}'),
              subtitle: Text(
                '${record.category} • ${record.date.toLocal().toString().split('.')[0]}',
              ),
              leading: Icon(Icons.person),
              trailing: Icon(
                Icons.circle,
                color: {
                  'Underweight': Colors.blue,
                  'Normal': Colors.green,
                  'Overweight': Colors.orange,
                  'Obese': Colors.red
                }[record.category],
              ),
            ),
          );
        },
      ),
    );
  }
}
class BMISummaryScreen extends StatefulWidget {
  @override
  _BMISummaryScreenState createState() => _BMISummaryScreenState();
}

class _BMISummaryScreenState extends State<BMISummaryScreen> {
  List<BMIRecord> history = [];
  double avgBMI = 0;
  Map<String, int> categoryCounts = {
    'Underweight': 0,
    'Normal': 0,
    'Overweight': 0,
    'Obese': 0,
  };

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data = prefs.getStringList('bmi_history') ?? [];
    final records = data
        .map((e) => BMIRecord.fromJson(jsonDecode(e)))
        .toList()
        .reversed
        .toList();

    double totalBMI = 0;
    Map<String, int> counts = {
      'Underweight': 0,
      'Normal': 0,
      'Overweight': 0,
      'Obese': 0,
    };

    for (var record in records) {
      totalBMI += record.bmi;
      counts[record.category] = counts[record.category]! + 1;
    }

    setState(() {
      history = records;
      avgBMI = records.isNotEmpty ? totalBMI / records.length : 0;
      categoryCounts = counts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Summary Analytics")),
      body: history.isEmpty
          ? Center(child: Text("No BMI data to show"))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Average BMI: ${avgBMI.toStringAsFixed(1)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text("Category Counts:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ...categoryCounts.entries.map((e) => Text("${e.key}: ${e.value}")),
            SizedBox(height: 24),
            Expanded(
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < history.length) {
                            return Text(history[index].date.day.toString(),
                                style: TextStyle(fontSize: 10));
                          }
                          return Text('');
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: history
                          .asMap()
                          .entries
                          .map((e) =>
                          FlSpot(e.key.toDouble(), e.value.bmi))
                          .toList(),
                      isCurved: true,
                      color: Colors.teal,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    InputScreen(),
    BMIHistoryScreen(),
    BMISummaryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Input'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
        ],
      ),
    );
  }
}

