import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BalanceCard extends StatefulWidget {
  final String balance;

  const BalanceCard({super.key, required this.balance});

  @override
  _DashCardState createState() => _DashCardState();
}

class _DashCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;  // Toggle visibility state

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFf2f9fc),
        borderRadius: BorderRadius.circular(16),
      ),
      height: 100,
      child: Column(
        children: [
          const Gap(5),
          Text(
            'Account balance',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 16,
              color: Colors.black.withOpacity(.8),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                // Display balance or hidden text
                _isBalanceVisible ? widget.balance : '******',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
              const Gap(8),
              // Icon to toggle visibility
              IconButton(
                icon: Icon(
                  _isBalanceVisible
                      ? Icons.remove_red_eye_outlined
                      : Icons.visibility_off_outlined,  // Change icon when toggled
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;  // Toggle the visibility
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
