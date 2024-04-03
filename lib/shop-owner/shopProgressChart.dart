import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/AllWigtes/Dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const Color primary = contentColorCyan;
  // static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  // static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color.fromARGB(255, 0, 0, 0);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class ShopPregress extends StatefulWidget {
  ShopPregress({super.key});

  List<Color> get availableColors => const <Color>[
        AppColors.contentColorPurple,
        AppColors.contentColorYellow,
        AppColors.contentColorBlue,
        AppColors.contentColorOrange,
        AppColors.contentColorPink,
        AppColors.contentColorRed,
      ];

  final Color barBackgroundColor = AppColors.contentColorWhite.withOpacity(0.3);
  final Color barColor = AppColors.contentColorWhite;
  final Color touchedBarColor = AppColors.contentColorGreen;

  @override
  State<StatefulWidget> createState() => ShopPregressState();
}

User? user = FirebaseAuth.instance.currentUser;

class ShopPregressState extends State<ShopPregress> {
  final _format = NumberFormat('##,###,###.##');

  final Stream<QuerySnapshot> _chatsStream = FirebaseFirestore.instance
      .collection('sales')
      .where("postedBy", isEqualTo: user!.uid)
      .snapshots();

  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;
  List<double> salesData = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black,
      decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xFFe26f39), blurRadius: 1, spreadRadius: 0.1)
          ],
          // color: Color(0xFF232323),
          color: Colors.black,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          )),

      child: Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: _chatsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // Initialize a list to hold your dynamic bar groups
            List<BarChartGroupData> barGroups = [];

            // Function to generate a single group data
// Function to generate a single group data
            BarChartGroupData makeGroupData(
              int x,
              double y, {
              bool isTouched = false,
              Color? barColor,
              double width = 22,
              List<int> showTooltips = const [],
            }) {
              barColor ??= widget.barColor;
              return BarChartGroupData(
                x: x,
                barRods: [
                  BarChartRodData(
                    toY: isTouched ? y + 4 : y,
                    color: isTouched
                        ? const Color.fromARGB(255, 74, 93, 103)
                        : widget.barColor,
                    width: width,
                    borderSide: isTouched
                        ? BorderSide(color: widget.touchedBarColor)
                        : const BorderSide(color: Colors.white, width: 0),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 20,
                      color: widget.barBackgroundColor,
                    ),
                  ),
                ],
                showingTooltipIndicators: showTooltips,
              );
            }

            // Extract sales data and aggregate it
            List<double> salesData = [];
            List<String> productDate = [];

            Map<String, double> sumByDate = {};

            snapshot.data!.docs.forEach((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              double price = double.parse(data["price"].toString());

              // Extract the date part from the Firestore timestamp
              // DateTime postedAt = (data['PostedAt'] as Timestamp).toDate();

              DateTime postedAt;
              if (data['PostedAt'] != null) {
                postedAt = (data['PostedAt'] as Timestamp).toDate();
              } else {
                Timestamp defaultTimestamp =
                    Timestamp.fromDate(DateTime(1998, 1, 2));
                postedAt = defaultTimestamp.toDate();
              }

              String postedDate =
                  "${postedAt.year}-${postedAt.month}-${postedAt.day}";

              // Add the price to the sum for the corresponding date
              if (sumByDate.containsKey(postedDate)) {
                sumByDate[postedDate] = sumByDate[postedDate]! + price;
              } else {
                sumByDate[postedDate] = price;
              }
            });

// Now, sumByDate contains the sum of prices for each posted date

// Push the sums and dates to productDate
            sumByDate.forEach((date, sum) {
              print(sum);
              print(date);
              // DateFormat dateFormat = DateFormat('dd, MMMM');
              var format = DateFormat('d, MMM');
              // DateTime dateTime = DateTime.parse(date);

              List<String> dateParts = date.split('-');

// Extract year, month, and day from the split parts
              int year = int.parse(dateParts[0]);
              int month = int.parse(dateParts[1]);
              int day = int.parse(dateParts[2]);

// Create a DateTime object with the extracted components
              DateTime dateTime = DateTime(year, month, day);
              salesData.add(sum);
              productDate.add(format.format(dateTime));

              // productDate.add({'date': date, 'sum': sum});
            });

            // Generate bar groups dynamically based on sales data
            for (int i = 0; i < salesData.length; i++) {
              double price = salesData[i];
              barGroups
                  .add(makeGroupData(i, price, isTouched: i == touchedIndex));
            }

            // Create the BarChart with dynamic bar groups
            return Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 2,
                ),
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: Colors.blueGrey,
                              tooltipHorizontalAlignment:
                                  FLHorizontalAlignment.right,
                              tooltipMargin: -10,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                String productName = "";

                                // Assuming you have a list of product names named productDate
                                if (groupIndex >= 0 &&
                                    groupIndex < productDate.length) {
                                  productName = productDate[groupIndex];
                                }

                                double price = rod.toY;

                                return BarTooltipItem(
                                  'Date $productName\nPrice: ${_format.format(price)}', // Adjust as per your data
                                  const TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    // backgroundColor: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                );
                              },
                            ),
                            touchCallback:
                                (FlTouchEvent event, barTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    barTouchResponse == null ||
                                    barTouchResponse.spot == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex =
                                    barTouchResponse.spot!.touchedBarGroupIndex;
                              });
                            }),

                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                );

                                Widget text;
                                if (value.toInt() >= 0 &&
                                    value.toInt() < productDate.length) {
                                  print(
                                      productDate[value.toInt()].substring(2));
                                  text = Text(productDate[value.toInt()],
                                      style: style);
                                } else {
                                  text = const Text('', style: style);
                                }

                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 16,
                                  child: text,
                                );
                              },
                              reservedSize: 38,
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                        ),

                        // Other chart configurations...
                        barGroups: barGroups,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
