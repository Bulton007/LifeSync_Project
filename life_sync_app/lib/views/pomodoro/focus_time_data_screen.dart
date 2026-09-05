import 'package:flutter/material.dart';

class FocusTimeDataScreen extends StatelessWidget {
  const FocusTimeDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Back Button and Title
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.black87,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Focus Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Summary Cards Row (Total Pomodoro & Total Focus Time)
              Row(
                children: [
                  // Total Pomodoro Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Pomodoro',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '16',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2979FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Total Focus Time Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Focus Time',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '17',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2979FF),
                                  ),
                                ),
                                TextSpan(
                                  text: 'h ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2979FF),
                                  ),
                                ),
                                TextSpan(
                                  text: '24',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2979FF),
                                  ),
                                ),
                                TextSpan(
                                  text: 'mn',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2979FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Overview Trends Container Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header & Month Dropdown Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Overview Trends',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'Month',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Month Navigation Row (Aug)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                            size: 18,
                            color: Color(0xFF2979FF),
                          ),
                          onPressed: () {},
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Aug',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: Color(0xFF2979FF),
                          ),
                          onPressed: () {},
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Chart Graph Area with Grid lines & Bars
                    SizedBox(
                      height: 180,
                      child: Stack(
                        children: [
                          // Horizontal grid lines & labels
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildGridLine('75 mn'),
                              _buildGridLine('50 mn'),
                              _buildGridLine('25 mn'),
                              const SizedBox(
                                height: 12,
                              ), // space for x-axis labels
                            ],
                          ),
                          // Simulated Bar Chart Columns
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                bottom: 24.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildBar(0.6),
                                  _buildBar(0.65),
                                  _buildBar(0.3),
                                  _buildBar(0.35),
                                  _buildBar(0.55),
                                  _buildBar(0.65),
                                  _buildBar(0.15),
                                  _buildBar(0.2),
                                  _buildBar(0.25),
                                  _buildBar(0.2),
                                  _buildBar(0.3),
                                  _buildBar(0.65),
                                  _buildBar(0.6),
                                  _buildBar(0.7),
                                  _buildBar(0.08),
                                  _buildBar(0.4),
                                  _buildBar(0.5),
                                  _buildBar(0.45),
                                  _buildBar(0.65),
                                  _buildBar(0.5),
                                  _buildBar(0.55),
                                  _buildBar(0.4),
                                  _buildBar(0.42),
                                  _buildBar(0.4),
                                  _buildBar(0.65),
                                  _buildBar(0.15),
                                  _buildBar(0.2),
                                  _buildBar(0.65),
                                  _buildBar(0.6),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),

                    // X-Axis Date Ticks
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '01',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          '05',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          '10',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          '15',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          '20',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          '25',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          '31',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Helper builder for chart grid line
  Widget _buildGridLine(String label) {
    return Row(
      children: [
        SizedBox(
          width: 42,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: Colors.grey.shade200)),
      ],
    );
  }

  // Helper builder for individual vertical bar in the chart
  Widget _buildBar(double heightFactor) {
    return FractionallySizedBox(
      heightFactor: heightFactor,
      child: Container(
        width: 5,
        decoration: BoxDecoration(
          color: const Color(0xFF2979FF),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
