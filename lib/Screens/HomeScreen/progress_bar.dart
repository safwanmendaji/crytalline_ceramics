import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatefulWidget {
  final double progress;
  final String label;
  final String trend;
  final double percentageChange;
  final String status;
  final String targetAmount;
  final String remainingAmount;

  const AnimatedProgressBar({
    Key? key,
    required this.progress,
    required this.label,
    required this.trend,
    required this.percentageChange,
    required this.status,
    required this.targetAmount,
    required this.remainingAmount,
  }) : super(key: key);

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "ongoing":
        return Colors.green;
      case "completed":
        return Colors.blue;
      case "pending":
        return Colors.orange;
      case "failed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label and Percentage Change
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.task_alt_rounded,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${widget.percentageChange.toStringAsFixed(1)}%",
                          style: TextStyle(
                            color: widget.trend == "up"
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          widget.trend == "up"
                              ? CupertinoIcons.arrow_up
                              : CupertinoIcons.arrow_down,
                          color:
                              widget.trend == "up" ? Colors.green : Colors.red,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Progress Bar
              Container(
                width: double.infinity,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Container(
                          width: constraints.maxWidth *
                              widget.progress *
                              _controller.value,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.purpleAccent.shade100,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Center(
                          child: Text(
                            "${(widget.progress * 100).toStringAsFixed(1)}% completed",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              // Additional Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Target: ₹${widget.targetAmount}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Remaining: ₹${widget.remainingAmount}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 6),
              // Status
              Row(
                children: [
                  Text(
                    "Status: ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.status,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(widget.status),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
