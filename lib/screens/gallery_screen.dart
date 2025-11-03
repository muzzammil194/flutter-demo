import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DynamicGallery extends StatelessWidget {
  final List<Map<String, dynamic>> images;

  const DynamicGallery({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MasonryGridView.count(
            crossAxisCount: 4, // number of grid columns
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount: images.length,
            itemBuilder: (context, index) {
              final img = images[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey[200],
                  child: AspectRatio(
                    aspectRatio: (img['w'] / img['h']),
                    child: Image.network(
                      img['url'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.error),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
