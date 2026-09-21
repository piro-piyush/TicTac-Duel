import 'package:flutter/material.dart';
import 'package:tictac_duel/lib.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HELP',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),

          child: Column(
            spacing: 32,
            children: [
              Column(
                spacing: 28,
                children: [
                  HelpHeaderWidget(),

                  HowToPlayWidget(),

                  OnlineDuelsWidget(),

                  QuickTipsWidget(),
                ],
              ),

              FooterCardWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
