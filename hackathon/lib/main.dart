import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // For formatting timestamps

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consultation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,  // Light theme
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,  // Dark theme
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.system,  // Automatically switch based on system preference
      home: SignInOrSignUpChoicePage(),  // Set the initial page to sign-in/sign-up choice page
    );
  }
}

// Page where users choose to sign in or sign up
class SignInOrSignUpChoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In or Sign Up"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome! Please choose:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserTypeChoicePage(signingUp: false),
                  ),
                );
              },
              child: Text("Sign In"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserTypeChoicePage(signingUp: true),
                  ),
                );
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}

// Page where users choose between Regular User and Certified Physician
class UserTypeChoicePage extends StatelessWidget {
  final bool signingUp;

  UserTypeChoicePage({required this.signingUp});

  @override
  Widget build(BuildContext context) {
    String action = signingUp ? "Sign Up" : "Sign In";
    return Scaffold(
      appBar: AppBar(
        title: Text("$action as User or Physician"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Are you a regular user or a certified physician?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(
                      userType: "Regular User",
                      signingUp: signingUp,
                    ),
                  ),
                );
              },
              child: Text("Regular User $action"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(
                      userType: "Certified Physician",
                      signingUp: signingUp,
                    ),
                  ),
                );
              },
              child: Text("Certified Physician $action"),
            ),
          ],
        ),
      ),
    );
  }
}

// This page will handle both the sign-up and sign-in process
class SignUpPage extends StatefulWidget {
  final String userType;
  final bool signingUp;

  SignUpPage({required this.userType, required this.signingUp});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();  // For medical license
  final TextEditingController _universityController = TextEditingController();  // For university

  @override
  Widget build(BuildContext context) {
    String action = widget.signingUp ? "Sign Up" : "Sign In";
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.userType} $action"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please $action as a ${widget.userType}.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            // Show medical license and university fields only for Certified Physicians
            if (widget.userType == "Certified Physician") ...[
              SizedBox(height: 20),
              TextField(
                controller: _licenseController,
                decoration: InputDecoration(labelText: "Medical License"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _universityController,
                decoration: InputDecoration(labelText: "Graduating University"),
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle submission (you can add validation here)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => widget.userType == "Certified Physician"
                        ? DoctorMainScreen()  // Go to doctor screen
                        : MainScreen(),  // Go to user screen
                  ),
                );
              },
              child: Text(action),
            ),
          ],
        ),
      ),
    );
  }
}

// Main application screen with bottom navigation for users
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    ConsultationPage(),
    CommunityPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Consultation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Doctor's Main Screen with bottom navigation
class DoctorMainScreen extends StatefulWidget {
  @override
  _DoctorMainScreenState createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<DoctorMainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    DoctorConsultationPage(),
    DoctorCommunityPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Consultation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Doctor's Consultation Page
class DoctorConsultationPage extends StatelessWidget {
  final List<Map<String, dynamic>> previousConsultations = [
    {
      "patient": "John Doe",
      "date": "01/01/2024",
      "summary": "Discussed general health checkup.",
      "conversation": [
        {"sender": "doctor", "message": "How are you feeling today?"},
        {"sender": "patient", "message": "I am feeling a bit tired."},
        {"sender": "doctor", "message": "That's common. How's your sleep been?"},
        {"sender": "patient", "message": "I haven't been sleeping well."},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Consultation History"),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Previous Consultations",
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: previousConsultations.length,
                itemBuilder: (context, index) {
                  final consultation = previousConsultations[index];
                  return Card(
                    color: isDarkMode ? Colors.white : Colors.blue[50],
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    child: ListTile(
                      title: Text(
                        consultation["patient"]!,
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date: ${consultation["date"]}",
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            "Summary: ${consultation["summary"]}",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        child: Text(
                          consultation["patient"]![0],
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: isDarkMode ? Colors.grey[400] : Colors.blue[100],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DoctorChatDetailPage(chat: consultation),
                          ),
                        );
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

// Doctor's Community Page (Discussions in their field)
class DoctorCommunityPage extends StatefulWidget {
  @override
  _DoctorCommunityPageState createState() => _DoctorCommunityPageState();
}

class _DoctorCommunityPageState extends State<DoctorCommunityPage> {
  List<Map<String, dynamic>> messages = [
    {
      "text": "Hi everyone! Let's discuss some recent developments in neurology.",
      "isUser": false,
      "user": "Dr. Anonymous",
      "time": DateTime.now(),
      "avatar": "D"
    },
    {
      "text": "Has anyone tried the new approach for treating migraines?",
      "isUser": false,
      "user": "Dr. Neuro",
      "time": DateTime.now(),
      "avatar": "N"
    },
  ];

  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          "text": messageController.text,
          "isUser": true,
          "user": "You",
          "time": DateTime.now(),
          "avatar": "Y",
        });
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Community Chat (Neurology)"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isUser = message["isUser"];
                String formattedTime =
                DateFormat('hh:mm a').format(message["time"]);

                return Row(
                  mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isUser)
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.03),
                        child: CircleAvatar(
                          child: Text(
                            message["avatar"],
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor:
                          isDarkMode ? Colors.grey[400] : Colors.blue[200],
                        ),
                      ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                            horizontal: screenWidth * 0.03),
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.white
                              : (isUser
                              ? Colors.blue[300]
                              : Colors.blue[100]),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(isUser ? 15 : 0),
                            bottomRight: Radius.circular(isUser ? 0 : 15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${message['user']}: ${message['text']}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                          ],
                        ),
                      ),
                    ),
                    if (isUser)
                      Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.03),
                        child: CircleAvatar(
                          child: Text(
                            message["avatar"],
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor:
                          isDarkMode ? Colors.grey[400] : Colors.blue[200],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Enter your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Doctor's Chat Detail Page
class DoctorChatDetailPage extends StatefulWidget {
  final Map<String, dynamic> chat;

  DoctorChatDetailPage({required this.chat});

  @override
  _DoctorChatDetailPageState createState() => _DoctorChatDetailPageState();
}

class _DoctorChatDetailPageState extends State<DoctorChatDetailPage> {
  List<bool> _isTimestampVisible = [];

  @override
  void initState() {
    super.initState();
    _isTimestampVisible =
    List<bool>.filled(widget.chat["conversation"].length, false);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.chat["patient"]}"),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Patient: ${widget.chat["patient"]}",
              style: TextStyle(
                  fontSize: screenWidth * 0.03, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Date: ${widget.chat["date"]}",
              style: TextStyle(fontSize: screenWidth * 0.03),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Conversation:",
              style: TextStyle(
                  fontSize: screenWidth * 0.03, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.chat["conversation"].length,
                itemBuilder: (context, index) {
                  final message = widget.chat["conversation"][index];
                  final timestamp =
                  DateFormat('hh:mm a').format(DateTime.now());

                  return GestureDetector(
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        _isTimestampVisible[index] =
                        !_isTimestampVisible[index];
                      });
                    },
                    child: Align(
                      alignment: message["sender"] == "doctor"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: message["sender"] == "doctor"
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01),
                            padding:
                            EdgeInsets.all(screenWidth * 0.03),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.white
                                  : (message["sender"] == "doctor"
                                  ? Colors.blue[300]
                                  : Colors.blue[100]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message["message"],
                              style: TextStyle(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (_isTimestampVisible[index])
                            Text(
                              timestamp,
                              style: TextStyle(
                                  fontSize: screenWidth * 0.025,
                                  color: Colors.grey),
                            ),
                        ],
                      ),
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

// Consultation Page with Floating Action Button to Start New Chat for users
class ConsultationPage extends StatefulWidget {
  @override
  _ConsultationPageState createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  final List<Map<String, dynamic>> previousChats = [
    {
      "doctor": "Dr. John Doe",
      "date": "01/01/2024",
      "summary": "Discussed general health checkup.",
      "conversation": [
        {"sender": "patient", "message": "I am feeling a bit tired."},
        {"sender": "doctor", "message": "That’s common. How’s your sleep been?"},
        {"sender": "patient", "message": "I haven’t been sleeping well recently."},
        {"sender": "doctor", "message": "Let’s work on improving your sleep routine."},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Consultation History"),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Previous Consultations",
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: previousChats.length,
                itemBuilder: (context, index) {
                  final chat = previousChats[index];
                  return Card(
                    color: isDarkMode ? Colors.white : Colors.blue[50],
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    child: ListTile(
                      title: Text(
                        chat["doctor"]!,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date: ${chat["date"]}",
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            "Summary: ${chat["summary"]}",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        child: Text(
                          chat["doctor"]![3],
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        backgroundColor: isDarkMode ? Colors.grey[400] : Colors.blue[100],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailPage(chat: chat),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the new chat screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewChatPage()),
          );
        },
        child: Icon(Icons.add, color: isDarkMode ? Colors.black : Colors.white),
        backgroundColor: isDarkMode ? Colors.white : Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// New Chat Page for Starting a New Conversation
class NewChatPage extends StatefulWidget {
  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  List<Map<String, dynamic>> conversation = [
    {"sender": "doctor", "message": "Hi, how you doing?", "timestamp": DateTime.now()}
  ]; // Start with preset message
  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        conversation.add({
          "sender": "patient",
          "message": messageController.text,
          "timestamp": DateTime.now(),
        });
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("New Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: conversation.length,
              itemBuilder: (context, index) {
                final message = conversation[index];
                return Align(
                  alignment: message["sender"] == "patient"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: message["sender"] == "patient"
                          ? isDarkMode ? Colors.white : Colors.blue[300]  // User's message
                          : isDarkMode ? Colors.white : Colors.blue[100],  // Doctor's message
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: message["sender"] == "patient"
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message["message"],
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat('hh:mm a').format(message["timestamp"]),
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 50), // Move up from bottom by 100px
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(hintText: "Type your message"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Chat Detail Page for viewing the selected consultation
class ChatDetailPage extends StatefulWidget {
  final Map<String, dynamic> chat;

  ChatDetailPage({required this.chat});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<bool> _isTimestampVisible = [];

  @override
  void initState() {
    super.initState();
    _isTimestampVisible = List<bool>.filled(widget.chat["conversation"].length, false);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat["doctor"]!),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Doctor: ${widget.chat["doctor"]}",
              style: TextStyle(fontSize: screenWidth * 0.03, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Date: ${widget.chat["date"]}",
              style: TextStyle(fontSize: screenWidth * 0.03),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              "Conversation:",
              style: TextStyle(fontSize: screenWidth * 0.03, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.chat["conversation"].length,
                itemBuilder: (context, index) {
                  final message = widget.chat["conversation"][index];
                  final timestamp = DateFormat('hh:mm a').format(DateTime.now());

                  return GestureDetector(
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        _isTimestampVisible[index] = !_isTimestampVisible[index];
                      });
                    },
                    child: Align(
                      alignment: message["sender"] == "doctor"
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: message["sender"] == "doctor"
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                            padding: EdgeInsets.all(screenWidth * 0.03),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.white
                                  : (message["sender"] == "doctor" ? Colors.blue[100] : Colors.blue[300]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message["message"],
                              style: TextStyle(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (_isTimestampVisible[index])
                            Text(
                              timestamp,
                              style: TextStyle(fontSize: screenWidth * 0.025, color: Colors.grey),
                            ),
                        ],
                      ),
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

// Community Page with Avatars and Timestamps
class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Map<String, dynamic>> messages = [
    {"text": "Hi everyone!", "isUser": false, "user": "Anonymous 1", "time": DateTime.now(), "avatar": "A"},
    {"text": "Does anyone know a good recipe for vegan pancakes?", "isUser": false, "user": "Anonymous 2", "time": DateTime.now(), "avatar": "B"},
    {"text": "I tried a keto diet, but it's hard to stick to.", "isUser": false, "user": "Anonymous 3", "time": DateTime.now(), "avatar": "C"},
  ];

  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          "text": messageController.text,
          "isUser": true,
          "user": "You",
          "time": DateTime.now(),
          "avatar": "Y",
        });
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Community Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isUser = message["isUser"];
                String formattedTime = DateFormat('hh:mm a').format(message["time"]);

                return Row(
                  mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (!isUser)
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.03),
                        child: CircleAvatar(
                          child: Text(
                            message["avatar"],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          backgroundColor: isDarkMode ? Colors.grey[400] : Colors.blue[200],
                        ),
                      ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01, horizontal: screenWidth * 0.03),
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white : (isUser ? Colors.blue[300] : Colors.blue[100]),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(isUser ? 15 : 0),
                            bottomRight: Radius.circular(isUser ? 0 : 15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${message['user']}: ${message['text']}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.03,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                          ],
                        ),
                      ),
                    ),
                    if (isUser)
                      Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.03),
                        child: CircleAvatar(
                          child: Text(
                            message["avatar"],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          backgroundColor: isDarkMode ? Colors.grey[400] : Colors.blue[200],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Enter your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}