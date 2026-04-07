import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      home: const MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  int volume = 50;
  int currentIndex = 0;
  List<String> playlist = [];
  
  List<Map<String, String>> songs = [
    {"title": "Blinding Lights", "artist": "The Weeknd"},
    {"title": "Shape of You", "artist": "Ed Sheeran"},
    {"title": "Believer", "artist": "Imagine Dragons"},
    {"title": "Dance Monkey", "artist": "Tones and I"},
    {"title": "Someone Like You", "artist": "Adele"},
  ];

  void nextSong() {
    setState(() {
      currentIndex = (currentIndex + 1) % songs.length;
    });
    showMsg("Next: ${songs[currentIndex]["title"]}");
  }

  void prevSong() {
    setState(() {
      currentIndex = (currentIndex - 1 + songs.length) % songs.length;
    });
    showMsg("Previous: ${songs[currentIndex]["title"]}");
  }

  void volUp() {
    setState(() {
      volume = (volume + 10).clamp(0, 100);
    });
    showMsg("Volume: $volume%");
  }

  void volDown() {
    setState(() {
      volume = (volume - 10).clamp(0, 100);
    });
    showMsg("Volume: $volume%");
  }

  void addToPlaylist() {
    String song = songs[currentIndex]["title"]!;
    if (!playlist.contains(song)) {
      setState(() {
        playlist.add(song);
      });
      showMsg("Added: $song");
    } else {
      showMsg("Already in playlist");
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(milliseconds: 500)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gesture Music Player"),
        backgroundColor: Colors.deepPurple,
      ),
      body: GestureDetector(
        onDoubleTap: addToPlaylist,
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) volUp();
          else volDown();
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) nextSong();
          else prevSong();
        },
        child: Column(
          children: [
            // Volume Control
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.volume_down),
                  Expanded(
                    child: Slider(
                      value: volume.toDouble(),
                      min: 0,
                      max: 100,
                      onChanged: (v) => setState(() => volume = v.toInt()),
                    ),
                  ),
                  const Icon(Icons.volume_up),
                  Text("$volume%"),
                ],
              ),
            ),
            
            // Now Playing Card
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: SizedBox(
                height: 250,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.music_note, size: 60, color: Colors.white),
                      const SizedBox(height: 20),
                      Text(
                        songs[currentIndex]["title"]!,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        songs[currentIndex]["artist"]!,
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: prevSong, icon: const Icon(Icons.skip_previous, color: Colors.white, size: 35)),
                          const Icon(Icons.play_circle_filled, color: Colors.white, size: 50),
                          IconButton(onPressed: nextSong, icon: const Icon(Icons.skip_next, color: Colors.white, size: 35)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Gesture Info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("⬆️ Vol+"),
                  Text("⬇️ Vol-"),
                  Text("⬅️ Prev"),
                  Text("➡️ Next"),
                  Text("👆👆 Add"),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Playlist Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.playlist_play, color: Colors.deepPurple),
                  const SizedBox(width: 8),
                  const Text("PLAYLIST", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text("${playlist.length} songs"),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Playlist Content
            Expanded(
              child: playlist.isEmpty
                  ? const Center(child: Text("Double tap song to add to playlist"))
                  : ListView.builder(
                      itemCount: playlist.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.music_note),
                          title: Text(playlist[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                playlist.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
