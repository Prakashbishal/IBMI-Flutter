import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibmi/utils/calculator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ibmi/widgets/info_card.dart';

class BMIPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BMIPageState();
}

class _BMIPageState extends State<BMIPage> {
  double? _deviceHeight, _deviceWidth;
  int _age = 25, _weight = 72, _height = 168, _gender = 0;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "🧮 BMI Calculator",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.label,
                  ),
                ),
                const SizedBox(height: 25),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [_ageSelectContainer(), _weightSelectContainer()],
                ),
                const SizedBox(height: 20),
                _heightSelectContainer(),
                const SizedBox(height: 20),
                _genderSelectContainer(),
                const SizedBox(height: 35),
                _calculateBMIButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ageSelectContainer() {
    return _styledInfoCard(
      width: _deviceWidth! * 0.42,
      height: _deviceHeight! * 0.18,
      title: "Age",
      value: _age.toString(),
      onMinus: () => setState(() => _age--),
      onPlus: () => setState(() => _age++),
    );
  }

  Widget _weightSelectContainer() {
    return _styledInfoCard(
      width: _deviceWidth! * 0.42,
      height: _deviceHeight! * 0.18,
      title: "Weight",
      value: _weight.toString(),
      onMinus: () => setState(() => _weight--),
      onPlus: () => setState(() => _weight++),
      minusKey: const Key('decrease-weight'),
      plusKey: const Key('increase-weight'),
    );
  }

  Widget _styledInfoCard({
    required double width,
    required double height,
    required String title,
    required String value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
    Key? minusKey,
    Key? plusKey,
  }) {
    return InfoCard(
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                key: minusKey,
                padding: EdgeInsets.zero,
                onPressed: onMinus,
                child: const Text(
                  '-',
                  style: TextStyle(fontSize: 35, color: Colors.red),
                ),
              ),
              CupertinoButton(
                key: plusKey,
                padding: EdgeInsets.zero,
                onPressed: onPlus,
                child: const Text(
                  '+',
                  style: TextStyle(fontSize: 30, color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heightSelectContainer() {
    return InfoCard(
      width: _deviceWidth! * 0.90,
      height: _deviceHeight! * 0.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "Height (cm)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            _height.toString(),
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: _deviceWidth! * 0.80,
            child: CupertinoSlider(
              value: _height.toDouble(),
              min: 0,
              max: 245,
              divisions: 245,
              onChanged: (val) => setState(() => _height = val.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderSelectContainer() {
    return InfoCard(
      width: _deviceWidth! * 0.90,
      height: _deviceHeight! * 0.12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Gender",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          CupertinoSlidingSegmentedControl(
            groupValue: _gender,
            children: const {
              0: Padding(padding: EdgeInsets.all(5), child: Text("Male")),
              1: Padding(padding: EdgeInsets.all(5), child: Text("Female")),
            },
            onValueChanged: (val) => setState(() => _gender = val as int),
          ),
        ],
      ),
    );
  }

  Widget _calculateBMIButton() {
    return SizedBox(
      width: _deviceWidth! * 0.6,
      height: 50,
      child: CupertinoButton.filled(
        borderRadius: BorderRadius.circular(25),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: const Text(
          "Calculate BMI",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (_height > 0 && _weight > 0 && _age > 0) {
            double _bmi = calculateBMI(_height, _weight);
            _showResultDialog(_bmi);
          }
        },
      ),
    );
  }

  void _showResultDialog(double _bmi) {
    String _status = getBMIStatus(_bmi);

    showCupertinoDialog(
      context: context,
      builder:
          (_) => CupertinoAlertDialog(
            title: Text(_status),
            content: Text(_bmi.toStringAsFixed(2)),
            actions: [
              CupertinoDialogAction(
                child: const Text("OK"),
                onPressed: () {
                  _saveResult(_bmi.toString(), _status);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  void _saveResult(String _bmi, String _status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bmi_date', DateTime.now().toString());
    await prefs.setStringList('bmi_data', <String>[_bmi, _status]);
    print("Result Saved");
  }
}
