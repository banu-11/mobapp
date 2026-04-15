import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoviePage(),
    );
  }
}

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  int currentIndex = 0;
  int userRating = 0;

  // Movie data
  List<Map<String, dynamic>> movies = [
    {
      "name": "Avengers",
      "genre": "Action",
      "rating": 4.0,
      "totalRatings": 100, // Total sum of all ratings
      "peopleCount": 25, // Number of people who rated
      "image": "assets/images/avengers.jpg"
    },
    {
      "name": "Titanic",
      "genre": "Romance",
      "rating": 4.5,
      "totalRatings": 135,
      "peopleCount": 30,
      "image": "assets/images/titanic.jpg"
    },
    {
      "name": "Joker",
      "genre": "Drama",
      "rating": 4.2,
      "totalRatings": 126,
      "peopleCount": 30,
      "image": "assets/images/joker.jpg"
    }
  ];

  // 🎨 Background color based on rating
  Color getBgColor() {
    switch (userRating) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.pink;
      case 5:
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  // ⭐ Update average rating dynamically
  void updateRating(int newRating) {
    setState(() {
      userRating = newRating;
      
      // Get current movie data
      int currentTotalRatings = movies[currentIndex]["totalRatings"];
      int currentPeopleCount = movies[currentIndex]["peopleCount"];
      
      // Add new rating
      int newTotalRatings = currentTotalRatings + newRating;
      int newPeopleCount = currentPeopleCount + 1;
      
      // Calculate new average
      double newAvg = newTotalRatings / newPeopleCount;
      
      // Update movie data
      movies[currentIndex]["totalRatings"] = newTotalRatings;
      movies[currentIndex]["peopleCount"] = newPeopleCount;
      movies[currentIndex]["rating"] = newAvg;
    });
  }

  // 👉 Next movie
  void nextMovie() {
    setState(() {
      currentIndex = (currentIndex + 1) % movies.length;
      userRating = 0; // Reset user rating for new movie
    });
  }

  @override
  Widget build(BuildContext context) {
    var movie = movies[currentIndex];

    return Scaffold(
      backgroundColor: getBgColor(),
      appBar: AppBar(
        title: const Text("Movie Rating App"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          nextMovie();
        },
        child: SingleChildScrollView(  // ✅ Wrap with SingleChildScrollView to prevent overflow
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Movie Image (using placeholder since assets may not exist)
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: Icon(
                    Icons.movie,
                    size: 100,
                    color: Colors.grey.shade600,
                  ),
                ),
                
                // Alternative: If you have actual images, use this:
                // Image.asset(movie["image"], height: 200, fit: BoxFit.cover),

                const SizedBox(height: 20),

                Text(
                  movie["name"],
                  style: const TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Genre: ${movie["genre"]}",
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 10),

                // Show average rating with stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(width: 5),
                    Text(
                      "Average Rating: ${movie["rating"].toStringAsFixed(1)}/5",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 5),
                
                Text(
                  "Based on ${movie["peopleCount"]} ratings",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Your Rating",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                // ⭐ Stars for user rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        size: 40,
                        color: index < userRating
                            ? Colors.amber
                            : Colors.grey,
                      ),
                      onPressed: () {
                        updateRating(index + 1);
                      },
                    );
                  }),
                ),
                
                if (userRating > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "You rated: $userRating stars",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),

                const SizedBox(height: 30),

                const Text(
                  "👉 Swipe left to see next movie",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                
                const SizedBox(height: 20), // Add extra bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}
