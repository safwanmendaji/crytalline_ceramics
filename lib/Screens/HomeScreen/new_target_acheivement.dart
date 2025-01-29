import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myshop_app/Helper/constants.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewTargetAchievement extends StatefulWidget {
  const NewTargetAchievement({super.key});

  @override
  State<NewTargetAchievement> createState() => _NewTargetAchievementState();
}

class _NewTargetAchievementState extends State<NewTargetAchievement> {
  double _currentAchievement = 0.0; // Initialize current achievement
  double _maxTarget = 0.0; // Initialize maximum target (will be updated)

  List<Map<String, dynamic>> _achievementData = [];
  String _apiMessage = "";
  int? userId; // Store the user ID

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Load user ID on initialization
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdStr = prefs.getString('userid');
    if (userIdStr != null) {
      setState(() {
        userId = int.parse(userIdStr);
        _fetchAchievementData(); // Fetch achievement data after loading user ID
      });
    } else {
      setState(() {
        _apiMessage = "User ID not found.";
      });
    }
  }

  Future<void> _fetchAchievementData() async {
    if (userId == null) return; // Ensure userId is not null

    try {
      final response = await http.get(
        Uri.parse('${ConstantHelper.uri}api/get_achievement/$userId'),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data']['data']; // Access nested 'data' key
        final offerInfo = jsonResponse['data']['offer_info'];

        setState(() {
          _achievementData = List<Map<String, dynamic>>.from(data);

          // Fetch the current achievement value from API response
          double totalPurchaseAmount =
              double.tryParse(offerInfo['total_purchase_amount'].toString()) ??
                  0.0;

          // Set max target based on the highest achievement target_amount
          if (_achievementData.isNotEmpty) {
            _maxTarget = _achievementData
                .map((ach) =>
                    double.tryParse(ach['target_amount'].toString()) ?? 0.0)
                .reduce((a, b) => a > b ? a : b);

            // Show totalPurchaseAmount directly without capping
            _currentAchievement = totalPurchaseAmount;
          } else {
            _currentAchievement = totalPurchaseAmount;
          }
        });
      } else {
        setState(() {
          _apiMessage = "Failed to load data.";
        });
      }
    } catch (e) {
      setState(() {
        _apiMessage = "Error: $e";
      });
    }
  }
  // Widget _buildProgressBar(double progress) {
  //   bool exceededTarget = _currentAchievement >= _maxTarget;
  //   String progressText = exceededTarget
  //       ? "Progress: Rs ${_maxTarget.toStringAsFixed(0)} / Rs ${_maxTarget.toStringAsFixed(0)}"
  //       : "Progress: Rs ${_currentAchievement.toStringAsFixed(0)} / Rs ${_maxTarget.toStringAsFixed(0)}";

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Text(
  //         progressText,
  //         style: TextStyle(
  //           fontSize: 18,
  //           color: Colors.blueGrey[800],
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       Center(
  //         child: ProgressBarCustomLabels(
  //             progress: exceededTarget ? 100 : progress),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildProgressBar(double progress) {
    // Display progress text using total purchase amount and max target
    String progressText =
        "Progress: Rs ${_currentAchievement.toStringAsFixed(0)} / Rs ${_maxTarget.toStringAsFixed(0)}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          progressText,
          style: TextStyle(
            fontSize: 18,
            color: Colors.blueGrey[800],
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: ProgressBarCustomLabels(
            progress: progress,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_currentAchievement / _maxTarget).clamp(0.0, 1.0) * 100;

    return Scaffold(
      appBar: AppBar(title: const Text("New Target Achievement")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildProgressBar(progress),
              const SizedBox(height: 30),
              _buildAchievementList(),
              if (_apiMessage.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(_apiMessage, style: TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Achievements",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "Track your progress and reach new milestones!",
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // Widget _buildProgressBar(double progress) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Text(
  //         "Progress: Rs ${_currentAchievement.toStringAsFixed(0)} / Rs ${_maxTarget.toStringAsFixed(0)}",
  //         style: TextStyle(
  //           fontSize: 18,
  //           color: Colors.blueGrey[800],
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       Center(
  //         child: ProgressBarCustomLabels(progress: progress),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildAchievementList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _achievementData.length,
      itemBuilder: (context, index) {
        final achievement = _achievementData[index];
        return _buildAchievementCard(
          index + 1,
          achievement["offer"],
          double.tryParse(achievement["target_amount"].toString()) ?? 0.0,
          achievement["status"],
          achievement["description"] ?? "No description available",
          double.tryParse(achievement["achieved_percentage"].toString()) ?? 0.0,
          achievement["remaining_amount"].toString(),
        );
      },
    );
  }

  Widget _buildAchievementCard(
      int serialNo,
      String title,
      double targetAmount,
      String status,
      String description,
      double achievedPercentage,
      String remainingAmount) {
    // Determine the color based on achievement status
    Color cardColor;
    switch (status) {
      case 'achieved':
        cardColor = Colors.green[100]!;
        break;
      case 'in progress':
        cardColor = Colors.yellow[100]!;
        break;
      case 'not started':
      default:
        cardColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => _showAchievementDescription(title, description),
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: cardColor,
        child: ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.pinkAccent.withOpacity(0.2),
            child: Text(
              "$serialNo",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[800],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Target Amount: Rs ${targetAmount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey[400],
                ),
              ),
              Text(
                "Achieved: ${achievedPercentage.toStringAsFixed(0)}%",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey[400],
                ),
              ),
              Text(
                "Remaining: Rs $remainingAmount",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey[400],
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ),
      ),
    );
  }

  void _showAchievementDescription(String title, String description) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(description),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

class ProgressBarCustomLabels extends StatelessWidget {
  final double progress;

  const ProgressBarCustomLabels({Key? key, required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
          showLabels: false,
          showTicks: false,
          radiusFactor: 0.8,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.2,
            cornerStyle: CornerStyle.bothCurve,
            color: Color.fromRGBO(211, 211, 211, 1),
            gradient: null,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: progress,
              cornerStyle: CornerStyle.bothCurve,
              width: 0.2,
              color: Colors.blue,
              sizeUnit: GaugeSizeUnit.factor,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.1,
              widget: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${progress.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}
