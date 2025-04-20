import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyBarChart extends StatelessWidget {
  final Map<String, double> dailyTotalsMap;

  const DailyBarChart({super.key, required this.dailyTotalsMap});

  @override
  Widget build(BuildContext context) {
    final sortedKeys = dailyTotalsMap.keys.toList()..sort();
    final values = sortedKeys.map((key) => dailyTotalsMap[key]!).toList();
    String _monthAbbr(int month) {
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return months[month - 1];
    }

    double maxY = values.reduce((a, b) => a > b ? a : b);

    double interval;
    if (maxY > 1000 - 00) {
      interval = 1000000;
    } else if (maxY > 100000) {
      interval = 100000;
    } else if (maxY > 10000) {
      interval = 10000;
    } else if (maxY > 1000) {
      interval = 1000;
    } else if (maxY > 500) {
      interval = 500;
    } else if (maxY > 100) {
      interval = 100;
    } else {
      interval = 10;
    }

    double adjustedMaxY = ((maxY / interval).ceil() * interval).toDouble();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: values.length * 100,
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            maxY: adjustedMaxY,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                // tooltipBgColor: Colors.black87,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    'RM ${rod.toY.toStringAsFixed(2)}',
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 60,
                  interval: interval,
                  getTitlesWidget: (value, meta) {
                    if (value % interval != 0) return Container();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        'RM${value.toInt()}',
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < sortedKeys.length) {
                      try {
                        DateTime date = DateFormat("yyyy-M-d").parse(sortedKeys[index]);
                        String formattedDate = "${date.day} ${_monthAbbr(date.month)}";
                        return Text(formattedDate, style: TextStyle(fontSize: 12));
                      } catch (e) {
                        try {
                          DateTime date = DateFormat("yyyy-MM-d").parse(sortedKeys[index]);
                          String formattedDate = "${date.day} ${_monthAbbr(date.month)}";
                          return Text(formattedDate, style: TextStyle(fontSize: 12));
                        } catch (e) {}
                      }
                    }
                    return Text('');
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(values.length, (index) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: values[index],
                    width: 20,
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade900],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
