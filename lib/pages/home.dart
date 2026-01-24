import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
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
  
//   
void _showLogoutDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      bool isLoading = false;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: const Color(0xFF121212),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AmFlix',
                        style: GoogleFonts.anton(
                          fontSize: 22,
                          color: const Color(0xffBF092F),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Yakin ingin keluar dari akun ini?',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text(
                              'Batal',
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffBF092F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: isLoading
                              ? null
                              : () async {
                                  setDialogState(() => isLoading = true);

                                  await AuthService.logout(context);
                                },
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}

      

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
          leadingWidth: 34,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: PopupMenuButton<String>(
              offset: const Offset(0, 48),
              color: const Color(0xFF1E1E1E), // 👈 background popup
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
             ),
              onSelected: (value) {
                if (value == 'logout') {
                  _showLogoutDialog();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, 
                      size: 12,
                      color: Color(0xffBF092F),
                      ),
                      SizedBox(width: 4),
                      Text('Logout',
                      style: TextStyle(
                        color: Color(0xffBF092F),
                        fontSize: 14,
                      ),)
                    ],
                  ),
                ),
              ],
              child: CircleAvatar(
                backgroundColor: Colors.blue[400],
                radius: 12,
                backgroundImage:
                    FirebaseAuth.instance.currentUser?.photoURL != null
                        ? NetworkImage(
                            FirebaseAuth.instance.currentUser!.photoURL!,
                          )
                        : null,
                child: FirebaseAuth.instance.currentUser?.photoURL == null
                    ? const Icon(Icons.person)
                    : null,
              ),
            ),
          ),
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
            style: GoogleFonts.anton(
              fontSize: 22,
              letterSpacing: 0.5,
              // fontWeight: FontWeight.bold,
              color: const Color(0xffBF092F),
              
            ),
          ),
        
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                isSearchActive ? Icons.close : Icons.search,
                color:  Colors.white70,
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
                              errorBuilder: (_, _, _) =>
                                  const Icon(Icons.broken_image),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black87,
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
        ),
        if (isLoading)
          Container(
            color: Colors.black87,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
    
  }
}

