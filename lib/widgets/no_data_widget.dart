import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Image.asset('assets/no-data-pana.png',
            width: MediaQuery.of(context).size.width / 1.5),
        const SizedBox(
          height: 24.0,
        ),
        Text(
          'No Data!',
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    ));
  }
}
