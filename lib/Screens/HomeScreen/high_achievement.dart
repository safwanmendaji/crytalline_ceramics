import 'package:flutter/material.dart';

class AchievementProgressBar extends StatelessWidget {
  final int currentAmount;
  final int targetAmount;
  final int remainingAmount;
  final int achievedPercentage;

  const AchievementProgressBar({
    required this.currentAmount,
    required this.targetAmount,
    required this.remainingAmount,
    required this.achievedPercentage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the achievedPercentage from the API response directly
    int progressPercentage = achievedPercentage;

    // Ensure the progress percentage is between 0 and 100
    progressPercentage = progressPercentage > 100
        ? 100
        : progressPercentage < 0
            ? 0
            : progressPercentage;

    // Set the progress bar color based on the progress percentage
    Color progressColor;
    if (progressPercentage < 30) {
      progressColor = Colors.redAccent;
    } else if (progressPercentage < 70) {
      progressColor = Colors.orangeAccent;
    } else {
      progressColor = Colors.green.shade500;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.indigo.shade200, Colors.teal.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display title
          Text(
            "Achievement Progress",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade900,
            ),
          ),
          const SizedBox(height: 12),

          // Current and Remaining Amounts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Current: ₹${currentAmount}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                "Remaining: ₹${remainingAmount}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          Stack(
            children: [
              Container(
                height: 25,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade300,
                ),
              ),
              // Filled progress bar
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressPercentage / 100,
                child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: progressColor,
                    boxShadow: [
                      BoxShadow(
                        color: progressColor.withOpacity(0.6),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Percentage Label
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${progressPercentage.toStringAsFixed(1)}% Achieved",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Target amount below the progress bar
          Text(
            'Highest Target: ₹${targetAmount}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
