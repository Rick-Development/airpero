
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget{

  final String title;
  final String bankInfo;
  final String transactionId;
  final String amount;
  final String status;
  final String date;
  final String time;
  final String iconPath; // Asset path for the icon.

  const TransactionCard({ required this.title, required this.bankInfo, required this.transactionId, required this.amount, required this.status, required this.date, required this.time, required this.iconPath, // Asset path for the icon.
  });

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Card background color.
        borderRadius: BorderRadius.circular(12), // Rounded corners.
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Soft shadow.
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4), // Shadow position.
          ),
        ],
      ),
      padding: EdgeInsets.all(16), // Padding inside the card.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start, // Align items at the top.
        children: [
          // Icon on the left.
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100, // Light blue background for the icon.
                      borderRadius: BorderRadius.circular(8), // Rounded edges for the icon container.
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      iconPath,
                      height: 32,
                      width: 32,
                    ),
                  ))
            ],
          ),
          const SizedBox(width: 12), // Space between the icon and text.
          // Transaction details.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Darker text for the title.
                  ),
                ),
                // Text(
                //   bankInfo,
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: Colors.black54, // Lighter shade for bank info.
                //   ),
                // ),
                SizedBox(height: 4),
                Text(
                  transactionId,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87, // Transaction ID text.
                  ),
                ),
              ],
            ),
          ),
          // Amount and status on the right.
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$$amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status == '1' ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status == '1' ? 'Successful' : 'Pending',
                  style: TextStyle(
                    fontSize: 12,
                    color: status == '1' ? Colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black45, // Lighter text for date and time.
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

