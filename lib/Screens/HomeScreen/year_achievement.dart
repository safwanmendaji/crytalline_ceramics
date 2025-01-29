import 'package:flutter/material.dart';

class YearAchievement extends StatelessWidget {
  final int totalPurchaseAmount; // Total purchase amount
  final int highestTargetAmount; // Highest target amount from last index

  const YearAchievement({
    required this.totalPurchaseAmount,
    required this.highestTargetAmount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate progress with a cap at 1.0 for 100%
    double progress =
        (totalPurchaseAmount / highestTargetAmount).clamp(0.0, 1.0);

    // Calculate percentage to display
    int percentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // Softer rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Subtle shadow
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Colors.blueGrey.shade100,
            Colors.blueGrey.shade200,
          ], // Professional gradient with blue-grey tones
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with a professional icon
          Row(
            children: [
              Icon(
                Icons.stars, // Professional star icon
                color: Colors.blue.shade700,
                size: 30,
              ),
              const SizedBox(width: 12),
              Text(
                "Yearly Achievement",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey.shade800,
                  fontFamily: 'Roboto', // Professional and clean font
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Total Purchase Amount with clean typography
          Text(
            "Total Purchase Amount: ₹${totalPurchaseAmount.toString()}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey.shade800,
            ),
          ),
          const SizedBox(height: 16),

          // Progress bar with percentage label below it
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar
              Stack(
                children: [
                  // Background bar
                  Container(
                    height: 24,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade300,
                    ),
                  ),
                  // Filled progress bar
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            Colors.green.shade600, // Professional green color
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withOpacity(0.6),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Percentage label on the right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(), // Spacer to align text to the right
                  Text(
                    "$percentage%", // Display percentage
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: progress == 1.0
                          ? Colors.green.shade800
                          : Colors.blueGrey.shade800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Highest Target Amount with clean layout
          Row(
            children: [
              Icon(
                Icons.arrow_upward, // Arrow for positive trend
                color: Colors.orange.shade600,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Highest Target: ₹${highestTargetAmount}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
