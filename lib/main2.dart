import 'package:flutter/material.dart';


class UserProfile {
  final String imageUrl;
  final String name;
  final String role;
  final String description;

  UserProfile({
    required this.imageUrl,
    required this.name,
    required this.role,
    required this.description,
  });
}


void main() {
  runApp(const HeroProfileApp());
}

class HeroProfileApp extends StatelessWidget {
  const HeroProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hero Animation Profiles',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: UserProfileListScreen(),
    );
  }
}

class UserProfileListScreen extends StatelessWidget {
  final List<UserProfile> users = List.generate(
    8,
        (index) => UserProfile(
      imageUrl: 'https://randomuser.me/api/portraits/men/$index.jpg',
      name: 'User $index',
      role: 'Developer $index',
      description: 'This is a detailed description of User $index. They are skilled in multiple domains and have a keen interest in Flutter development.',
    ),
  );

  UserProfileListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profiles'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 800),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      UserProfileDetailScreen(user: user),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Hero(
              tag: user.imageUrl,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(12.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageUrl),
                    radius: 30,
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.role),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UserProfileDetailScreen extends StatefulWidget {
  final UserProfile user;

  const UserProfileDetailScreen({super.key, required this.user});

  @override
  UserProfileDetailScreenState createState() => UserProfileDetailScreenState();
}

class UserProfileDetailScreenState extends State<UserProfileDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Stack(
        children: [
          Hero(
            tag: widget.user.imageUrl,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(widget.user.imageUrl),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.user.role,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.user.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
