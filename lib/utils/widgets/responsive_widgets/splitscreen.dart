import 'package:flutter/material.dart';

class ResponsiveSplitScreen extends StatelessWidget {
  const ResponsiveSplitScreen({
    required this.left,
    Key? key,
  }) : super(key: key);

  final Widget left;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool responsiveBreak = width > 1000;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                child: left,
              ),
            ),
          ),
        ),
        Visibility(
          visible: responsiveBreak,
          child: Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue[50],
                  image: DecorationImage(
                      image: AssetImage('assets/startimage.jpg'),
                      fit: BoxFit.cover)),
            ),
          ),
        )
      ],
    );
  }
}
