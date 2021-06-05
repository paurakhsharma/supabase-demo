import 'package:flutter/material.dart';
import 'package:journal/services/journal_service.dart';

import 'package:provider/provider.dart';

class ImageRenderer extends StatelessWidget {
  const ImageRenderer({
    Key? key,
    required this.imagePath,
    this.height,
  }) : super(key: key);

  final String imagePath;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final downloadImage = context.select((JournalService e) => e.downloadImage);
    return FutureBuilder(
      future: downloadImage(imagePath),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        print('fsfsdfsdfsd');
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        print(snapshot.data.error);
        return Image.memory(
          snapshot.data.data,
          height: height,
        );
      },
    );
  }
}
