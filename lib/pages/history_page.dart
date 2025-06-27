import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibmi/widgets/info_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  double? _deviceHeight, _deviceWidth;
  late Future<SharedPreferences> _prefsFuture;

  @override
  void initState() {
    super.initState();
    _prefsFuture = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("BMI History"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.refresh),
          onPressed: () {
            setState(() {
              _prefsFuture = SharedPreferences.getInstance();
            });
          },
        ),
      ),
      child: _dataCard(),
    );
  }

  Widget _dataCard() {
    return FutureBuilder(
      future: _prefsFuture,
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(color: Colors.green),
          );
        }

        if (_snapshot.hasData) {
          final _prefs = _snapshot.data as SharedPreferences;
          final _date = _prefs.getString('bmi_date');
          final _data = _prefs.getStringList('bmi_data');

          if (_date == null || _data == null) {
            return const Center(child: Text("No BMI data found."));
          }

          return Center(
            child: InfoCard(
              height: _deviceHeight! * 0.25,
              width: _deviceWidth! * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _statusText(_data[1]),
                  _dateText(_date),
                  _bmiText(_data[0]),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text("Error loading data"));
        }
      },
    );
  }

  Widget _statusText(String _status) {
    return Text(
      _status,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
    );
  }

  Widget _dateText(String _date) {
    DateTime _parseDate = DateTime.parse(_date);
    return Text(
      '${_parseDate.day}/${_parseDate.month}/${_parseDate.year}',
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
    );
  }

  Widget _bmiText(String _bmi) {
    return Text(
      double.parse(_bmi).toStringAsFixed(2),
      style: const TextStyle(fontSize: 55, fontWeight: FontWeight.w600),
    );
  }
}
