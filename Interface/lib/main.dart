import 'package:flutter/material.dart';
import 'package:modelface/question_screen.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(TrackSelectionApp());
}

class TrackSelectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrackSelectionScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.deepPurpleAccent,
          background: Colors.grey[100],
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}

class TrackSelectionScreen extends StatelessWidget {
  final List<Track> tracks = [
    Track(
      name: "Bioinformatics",
      description:
      "Merges biology, computer science, and data analysis to interpret complex biological data like genomic sequences. Explore diverse career opportunities in genomics, personalized medicine, and drug discovery.",
      detailedDescription:
      "Bioinformatics combines biology, computer science, and data analysis to interpret complex biological data such as genomic sequences and protein structures. As biological data grows rapidly, this field is essential for uncovering new insights into biological processes. Career opportunities include research, healthcare, and biotechnology.",
      icon: Icons.science_outlined,
      color: Colors.blue[300],
    ),
    Track(
      name: "Cybersecurity",
      description:
      "Dedicated to protecting systems, networks, and data from digital threats. Develop strategies to ensure the security of sensitive information across industries.",
      detailedDescription:
      "Cybersecurity focuses on protecting systems, networks, and data from digital threats. This field involves developing strategies to prevent, detect, and respond to cyberattacks, ensuring the security of sensitive information across various industries. With the increasing sophistication of cyber threats, there is a growing demand for skilled cybersecurity professionals.",
      icon: Icons.security_outlined,
      color: Colors.red[300],
    ),
    Track(
      name: "Artificial Intelligence",
      description:
      "Focuses on developing systems that mimic human intelligence, covering areas like machine learning, robotics, and natural language processing.",
      detailedDescription:
      "Artificial Intelligence (AI) involves creating systems that mimic human intelligence, including learning, reasoning, and decision-making. AI covers areas such as machine learning, neural networks, robotics, and natural language processing, revolutionizing industries like healthcare and transportation. The demand for AI expertise is rapidly growing, offering exciting career opportunities.",
      icon: Icons.memory_outlined,
      color: Colors.green[300],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose Your Future Track',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 240,
            color: Colors.deepPurple[800],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Navigation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SidebarItem(icon: Icons.info, label: 'Track Overview'),
                SidebarItem(icon: Icons.quiz, label: 'Take the Test'),
                SidebarItem(
                    icon: Icons.contact_support, label: 'Help & Support'),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Explore Each Track',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                        MediaQuery.of(context).size.width > 1200 ? 2 : 1,
                        childAspectRatio: 2.8,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                      ),
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        return TrackCard(track: tracks[index]);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QuestionScreen()), // Navigate to the QuestionScreen
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 60.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: Colors.deepPurpleAccent.withOpacity(0.5),
                      ),
                      child: Text(
                        "Start Your Track Test",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Track {
  final String name;
  final String description;
  final String detailedDescription;
  final IconData icon;
  final Color? color;

  Track({
    required this.name,
    required this.description,
    required this.detailedDescription,
    required this.icon,
    this.color,
  });
}

class TrackCard extends StatefulWidget {
  final Track track;

  const TrackCard({required this.track});

  @override
  _TrackCardState createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => TrackDetailsDialog(track: widget.track),
          );
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Card(
            color: widget.track.color,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    widget.track.icon,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.track.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.track.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TrackDetailsDialog extends StatelessWidget {
  final Track track;

  const TrackDetailsDialog({required this.track});

  // Function to open URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple[200]!, Colors.deepPurple[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              track.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              track.detailedDescription,
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Open Wikipedia page
                    String url;
                    switch (track.name) {
                      case 'Bioinformatics':
                        url = 'https://en.wikipedia.org/wiki/Bioinformatics';
                        break;
                      case 'Cybersecurity':
                        url = 'https://en.wikipedia.org/wiki/Computer_security';
                        break;
                      case 'Artificial Intelligence':
                        url =
                        'https://en.wikipedia.org/wiki/Artificial_intelligence';
                        break;
                      default:
                        url = 'https://en.wikipedia.org/';
                        break;
                    }
                    _launchURL(url);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                  ),
                  child: Text(
                    'See More',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const SidebarItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      onTap: () {
        // Navigate to appropriate screen based on the label
        if (label == 'Take the Test') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuestionScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SoonScreen()),
          );
        }
      },
    );
  }
}

class SoonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coming Soon'),
      ),
      body: Center(
        child: Text(
          'Future work soon',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
