import 'dart:ui';

import 'package:flutter/material.dart';

class TestimonialOnImage extends StatelessWidget {
  const TestimonialOnImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Clip it cleanly.
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.grey.withOpacity(0.1),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"It has never been easier to track my time! I truely love the fact that you live can see how much you earn on your hour"',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jeppe',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              ),
              Text(
                'Founder of marketing agency',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
