import 'package:flutter/material.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Not Found",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
