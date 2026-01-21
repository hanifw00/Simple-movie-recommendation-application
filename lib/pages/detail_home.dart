import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/movie_model.dart';
import '../config/api_config.dart';


class DetailMovie extends StatelessWidget {
  final Movie movie;

  const DetailMovie({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        '${ApiConfig.imageBaseUrl}${movie.posterPath}';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(movie.title,
        style: GoogleFonts.montserrat(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white
        )
        ),
        centerTitle: true,
        actions: [Image.asset("assets/images/logo_splash.png",
       
        )
        ],
        
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        movie.releaseDate,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    movie.displayOverview,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
