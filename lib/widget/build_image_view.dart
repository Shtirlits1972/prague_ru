import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

Widget buildNetworkImage(BuildContext context, Map<String, dynamic> json) {
  // Проверяем наличие URL
  if (json.containsKey('image') && json['image'].containsKey('url')) {
    String imageUrl = json['image']['url'];

    return ImageNetwork(
      image: imageUrl,
      height: 350.0,
      width: MediaQuery.of(context).size.width - 50,
      duration: 1500,
      curve: Curves.easeIn,
      onPointer: true,
      debugPrint: false,
      backgroundColor: Colors.blue,
      fitAndroidIos: BoxFit.cover,
      fitWeb: BoxFitWeb.cover,
      borderRadius: BorderRadius.circular(20),
      onLoading: const CircularProgressIndicator(
        color: Colors.indigoAccent,
      ),
      onError: const Icon(
        Icons.error,
        color: Colors.red,
      ),
      onTap: () {
        debugPrint("tap on image network");
      },
    );
  } else {
    return const Center(
      child: Text(
        'Ошибка загрузки изображения',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
