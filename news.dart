import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      home: const NewsApp(),
    );
  }
}

class News {
  String title;
  String description;
  String category;
  bool isBreaking;
  
  News({required this.title, required this.description, required this.category, this.isBreaking = false});
}

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  List<News> allNews = [];
  List<News> filteredNews = [];
  List<String> bookmarkedTitles = [];
  String selectedCategory = "All";
  
  List<String> categories = ["All", "Technology", "Sports", "Business", "Health"];

  @override
  void initState() {
    super.initState();
    loadNews();
    loadBookmarks();
  }

  void loadNews() {
    allNews = [
      News(title: "BREAKING: Earthquake Hits City", description: "A powerful earthquake struck the city today. Rescue operations are underway. People are advised to stay safe.", category: "Breaking", isBreaking: true),
      News(title: "New iPhone Released", description: "Apple launches new iPhone with amazing features. The camera is improved and battery lasts longer.", category: "Technology"),
      News(title: "India Wins Cricket Match", description: "Indian cricket team wins by 50 runs. The crowd goes wild as India defeats Australia.", category: "Sports"),
      News(title: "Stock Market Rises", description: "Sensex goes up by 1000 points today. Investors are happy with the market performance.", category: "Business"),
      News(title: "New Health Guidelines", description: "Doctors recommend eating healthy and exercising daily. New health guidelines issued by government.", category: "Health", isBreaking: true),
      News(title: "Google Launches New AI", description: "Google announces new AI model that can answer questions. This will change how we search.", category: "Technology"),
      News(title: "Football World Cup", description: "World Cup finals this Sunday. All tickets are sold out for the big match.", category: "Sports"),
      News(title: "Startup Gets Funding", description: "Indian startup raises 100 crore rupees. Company plans to expand to new cities.", category: "Business"),
    ];
    filterNews();
  }

  void filterNews() {
    setState(() {
      if (selectedCategory == "All") {
        filteredNews = allNews;
      } else {
        filteredNews = allNews.where((news) => news.category == selectedCategory).toList();
      }
    });
  }

  Future<void> loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarkedTitles = prefs.getStringList('bookmarks') ?? [];
    });
  }

  Future<void> toggleBookmark(News news) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (bookmarkedTitles.contains(news.title)) {
        bookmarkedTitles.remove(news.title);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Removed from bookmarks")));
      } else {
        bookmarkedTitles.add(news.title);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to bookmarks")));
      }
      prefs.setStringList('bookmarks', bookmarkedTitles);
    });
  }

  bool isBookmarked(News news) {
    return bookmarkedTitles.contains(news.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📰 News App"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(icon: const Icon(Icons.bookmark), onPressed: showBookmarks),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(categories[index]),
                    selected: selectedCategory == categories[index],
                    onSelected: (sel) {
                      setState(() {
                        selectedCategory = categories[index];
                        filterNews();
                      });
                    },
                  ),
                );
              },
            ),
          ),
          // News List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredNews.length,
              itemBuilder: (context, index) {
                News news = filteredNews[index];
                return Card(
                  color: news.isBreaking ? Colors.red.shade50 : Colors.white,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailPage(news: news)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Icon instead of image
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: news.isBreaking ? Colors.red : Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              news.isBreaking ? Icons.warning : Icons.article,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (news.isBreaking)
                                  const Text("🔴 BREAKING", style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                                Text(
                                  news.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: news.isBreaking ? Colors.red : Colors.black,
                                  ),
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 4),
                                Text(news.description, maxLines: 2, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                                      child: Text(news.category, style: const TextStyle(fontSize: 10)),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: Icon(isBookmarked(news) ? Icons.bookmark : Icons.bookmark_border, size: 20),
                                      onPressed: () => toggleBookmark(news),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showBookmarks() {
    List<News> bookmarkedNews = allNews.where((n) => bookmarkedTitles.contains(n.title)).toList();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text("📌 Bookmarks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Divider(),
              Expanded(
                child: bookmarkedNews.isEmpty
                    ? const Center(child: Text("No bookmarks"))
                    : ListView.builder(
                        itemCount: bookmarkedNews.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.bookmark),
                            title: Text(bookmarkedNews[index].title),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailPage(news: bookmarkedNews[index])));
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Detail Page
class NewsDetailPage extends StatelessWidget {
  final News news;
  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
        backgroundColor: news.isBreaking ? Colors.red : Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.isBreaking)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.red.shade100,
                child: const Text("🔴 BREAKING NEWS", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: news.isBreaking ? Colors.red : Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                news.isBreaking ? Icons.warning : Icons.article,
                color: Colors.white,
                size: 80,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
              child: Text(news.category),
            ),
            const SizedBox(height: 16),
            Text(news.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(news.description, style: const TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade100,
              child: const Text("📌 Read full article in real app. This is a demo version."),
            ),
          ],
        ),
      ),
    );
  }
}
