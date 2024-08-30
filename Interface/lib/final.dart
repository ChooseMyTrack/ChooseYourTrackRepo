import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class FinalScreen extends StatefulWidget {
  final String track;

  FinalScreen({required this.track});

  @override
  _FinalScreenState createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  String title = "";
  String imagePath = "";
  String pdfPath = "";
  List<String> tips = [];
  String? pdfFilePath;

  @override
  void initState() {
    super.initState();
    _setupContent();
  }

  void _setupContent() {
    switch (widget.track) {
      case "Bioinformatics":
        title = "Bioinformatics";
        imagePath = 'assets/images/bioinformatics.jpg';
        pdfPath = 'assets/bioinformatics.pdf';
        tips = [
          "Build a Strong Foundation: Focus on key areas like molecular biology, genetics, and data analysis techniques to understand biological data deeply.",
          "Utilize Tools and Software: Learn to use bioinformatics tools and software, such as BLAST, Bioconductor, and Galaxy, to analyze and interpret data.",
          "Collaborate on Research: Get involved in research projects or internships to gain practical experience and apply your skills in real-world scenarios.",
          "Stay Current: Keep up with advancements in genomics, proteomics, and computational biology by reading relevant journals and attending conferences.",
          "Network with Experts: Join bioinformatics communities, attend workshops, and connect with researchers to expand your knowledge and career opportunities."
        ];
        break;
      case "Cybersecurity":
        title = "Cybersecurity";
        imagePath = 'assets/images/cybersecurity.jpg';
        pdfPath = 'assets/cybersecurity.pdf';
        tips = [
          "Master the Basics: Start with fundamental concepts in computer science and networking before diving into advanced security topics.",
          "Hands-On Experience: Set up your own labs or virtual environments to practice penetration testing, malware analysis, and incident response.",
          "Certifications: Consider earning certifications such as CompTIA Security+, CEH (Certified Ethical Hacker), or CISSP to validate your skills and enhance your resume.",
          "Stay Informed: Follow cybersecurity news, blogs, and forums to stay updated on the latest threats, tools, and best practices.",
          "Join Communities: Engage with cybersecurity communities, attend conferences, and participate in hackathons to network and learn from professionals in the field."
        ];
        break;
      case "AI/Data Science":
        title = "AI and Data Science";
        imagePath = 'assets/images/ai.jpg';
        pdfPath = 'assets/ai-data-scientist.pdf';
        tips = [
          "Grasp the Fundamentals: Build a solid understanding of algorithms, data structures, and basic machine learning concepts before exploring advanced topics.",
          "Work on Projects: Implement and experiment with AI models using datasets from platforms like Kaggle to apply what you’ve learned in practical scenarios.",
          "Learn from Online Courses: Utilize online resources and courses from platforms like Coursera, edX, or Udacity to deepen your knowledge in specialized areas such as deep learning or natural language processing.",
          "Collaborate and Contribute: Engage in collaborative projects, contribute to open-source AI projects, and participate in hackathons to gain experience and network with other professionals.",
          "Stay Updated: Follow the latest research, trends, and technologies in AI by reading academic papers, blogs, and attending conferences or webinars."
        ];
        break;
      default:
        title = "Unknown Track";
        imagePath = 'assets/default.jpg';
        tips = ["No tips available."];
        break;
    }

    if (pdfPath.isNotEmpty) {
      _loadPdf(pdfPath);
    }
  }

  Future<void> _loadPdf(String path) async {
    ByteData bytes = await rootBundle.load(path);
    final buffer = bytes.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = await File('$tempPath/temp.pdf').writeAsBytes(
        buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

    setState(() {
      pdfFilePath = file.path;
    });
  }

  Widget _buildTip(String tip) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          tip,
          style: TextStyle(fontSize: 18, color: Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$title Roadmap",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Your Track is: $title",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              if (imagePath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),
              Text(
                'Tips for Succeeding in $title:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              ...tips.map((tip) => _buildTip(tip)),
              SizedBox(height: 20),
              if (pdfFilePath != null)
                Container(
                  height: 400,
                  child: PDFView(
                    filePath: pdfFilePath,
                    enableSwipe: true,
                    swipeHorizontal: true,
                    autoSpacing: false,
                    pageFling: true,
                    onRender: (_pages) {
                      setState(() {
                        // Handle pages ready state
                      });
                    },
                    onError: (error) {
                      print(error.toString());
                    },
                    onPageError: (page, error) {
                      print('$page: ${error.toString()}');
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      // You can control the PDF view with this controller
                    },
                    onPageChanged: (int? page, int? total) {
                      print('page change: $page/$total');
                    },
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Implement sharing logic
                },
                icon: Icon(Icons.share),
                label: Text("Share PDF"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              if (pdfFilePath != null)
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement download logic
                  },
                  icon: Icon(Icons.download),
                  label: Text("Download PDF"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
              SizedBox(height: 30),
              Divider(),
              SizedBox(height: 20),
              Text(
                "More Resources:",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Implement navigation to external resource
                },
                child: Text(
                  "• Resource 1",
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  // Implement navigation to external resource
                },
                child: Text(
                  "• Resource 2",
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  // Implement navigation to external resource
                },
                child: Text(
                  "• Resource 3",
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ),
              SizedBox(height: 30),
              Divider(),
              SizedBox(height: 20),
              Text(
                "We value your feedback:",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Leave your feedback here...',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement feedback submission logic
                },
                child: Text("Submit Feedback"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
