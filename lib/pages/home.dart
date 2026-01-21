import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';
import '../config/api_config.dart';
import 'package:amflix/routes/app_routes.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  bool isSearchActive = false;
  bool isSearching = false;
  Timer? _debounce;

  //Search Movie
  Future<void> searchMovie(String query) async {
  if (_scrollController.hasClients) {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  if (query.isEmpty) {
    setState(() {
      movies.clear();
      currentPage = 1;
      hasMore = true;
      isSearching = false;
    });
    fetchMovies(); 
    return;
  }
  setState(() {
    isSearching = true;
    isLoading = true;
  });
  final results = await MovieService.searchMovies(query);

  setState(() {
    movies = results;
    isLoading = false;
    hasMore = false;
  });
}

  @override
  void initState() {
    super.initState();
    fetchMovies();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        fetchMovies();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    _scrollController.dispose(); 
    super.dispose();
  }

  // =============================
  // PAGINATION (POPULAR MOVIES)
  // =============================
  Future<void> fetchMovies() async {
    if (isLoading || !hasMore || isSearching) return;

    setState(() => isLoading = true);

    final newMovies =
        await MovieService.getPopularMovies(page: currentPage);

    setState(() {
      currentPage++;
      isLoading = false;

      if (newMovies.isEmpty) {
        hasMore = false;
      } else {
        movies.addAll(newMovies);
      }
    });
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchMovie(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
      leading: Image.asset("assets/images/logo_splash.png",
      fit: BoxFit.contain,),
      title: isSearchActive
    ? TextField(
        controller: searchController,
        onChanged: onSearchChanged, 
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Cari film...',
          hintStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
      )
    : Text(
        'Popular Movies',
        style: GoogleFonts.montserrat(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            isSearchActive ? Icons.close : Icons.search,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            setState(() {
              if (isSearchActive) {               
                isSearchActive = false;
                searchController.clear();
                searchMovie("");
              } else {
                // buka search
                isSearchActive = true;
              }
            });
          },
        ),
      ],
      backgroundColor: Colors.black87,
      ),
      body: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final imageUrl =
              '${ApiConfig.imageBaseUrl}${movie.posterPath}';

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.movieDetail,
                arguments: movie,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                movie.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

