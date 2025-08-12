
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mohamed Said — Flutter Developer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey homeKey = GlobalKey();
  final GlobalKey skillsKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: ResponsiveAppBar(
        onNavTap: (index) {
          switch (index) {
            case 0:
              _scrollTo(homeKey);
              break;
            case 1:
              _scrollTo(skillsKey);
              break;
            case 2:
              _scrollTo(projectsKey);
              break;
            case 3:
              _scrollTo(contactKey);
              break;
          }
        },
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionContainer(key: homeKey, child: HomeSection(onDownloadCV: _downloadCV)),
            SectionContainer(key: skillsKey, child: SkillsSection()),
            SectionContainer(key: projectsKey, child: ProjectsSection()),
            SectionContainer(key: contactKey, child: ContactSection()),
            const SizedBox(height: 40),
            const Footer(),
          ],
        ),
      ),
    );
  }

  void _downloadCV() async {
    // replace with your real CV link or file hosting
    const url = 'https://example.com/Mohamed_Said_CV.pdf';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(int) onNavTap;
  const ResponsiveAppBar({Key? key, required this.onNavTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 800) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            const CircleAvatar(backgroundColor: Colors.blue, child: Text('MS')),
            const SizedBox(width: 12),
            const Text('Mohamed Said', style: TextStyle(color: Colors.black87)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => onNavTap(0), child: const Text('Home')),
          TextButton(onPressed: () => onNavTap(1), child: const Text('Skills')),
          TextButton(onPressed: () => onNavTap(2), child: const Text('Projects')),
          TextButton(onPressed: () => onNavTap(3), child: const Text('Contact')),
          const SizedBox(width: 12),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('Mohamed Said', style: TextStyle(color: Colors.black87)),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onSelected: onNavTap,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 0, child: Text('Home')),
              PopupMenuItem(value: 1, child: Text('Skills')),
              PopupMenuItem(value: 2, child: Text('Projects')),
              PopupMenuItem(value: 3, child: Text('Contact')),
            ],
          )
        ],
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SectionContainer extends StatelessWidget {
  final Widget child;
  const SectionContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1100), child: child)),
    );
  }
}

class HomeSection extends StatelessWidget {
  final VoidCallback onDownloadCV;
  const HomeSection({Key? key, required this.onDownloadCV}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return isWide
        ? Row(
      children: [
        Expanded(child: _IntroColumn(onDownloadCV: onDownloadCV)),
        const SizedBox(width: 24),
        Expanded(child: _Portrait()),
      ],
    )
        : Column(
      children: [
        _Portrait(),
        const SizedBox(height: 20),
        _IntroColumn(onDownloadCV: onDownloadCV),
      ],
    );
  }
}

class _IntroColumn extends StatelessWidget {
  final VoidCallback onDownloadCV;
  const _IntroColumn({Key? key, required this.onDownloadCV}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mohamed Said Abd Elmonem Ebaid', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Senior Flutter Developer | Mobile & Web Apps', style: TextStyle(fontSize: 18, color: Colors.black54)),
        const SizedBox(height: 16),
        const Text(
          'Flutter Developer with 5+ years experience building production-grade apps in healthcare, education, e-commerce and logistics. Passionate about UI/UX, performance and clean architecture.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            ElevatedButton.icon(onPressed: onDownloadCV, icon: const Icon(Icons.download), label: const Text('Download CV')),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () => launchUrl(Uri.parse('https://github.com/MohamedSaidEbaid')),
              icon: const Icon(Icons.code),
              label: const Text('GitHub'),
            ),
          ],
        )
      ],
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: Icon(Icons.person, size: 120, color: Colors.blue)),
          ),
          const SizedBox(height: 12),
          const Text('Maadi, Cairo, Egypt', style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class SkillsSection extends StatelessWidget {
  SkillsSection({Key? key}) : super(key: key);

  final List<String> skills = const [
    'Flutter',
    'Dart',
    'Firebase',
    'REST APIs',
    'GraphQL',
    'BLoC',
    'GetX',
    'Provider',
    'Clean Architecture',
    'TDD',
    'CI/CD',
    'Crashlytics',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxis = width > 1000 ? 4 : width > 700 ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Skills'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxis,
            childAspectRatio: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: skills.length,
          itemBuilder: (_, i) => SkillTile(skill: skills[i]),
        ),
      ],
    );
  }
}

class SkillTile extends StatelessWidget {
  final String skill;
  const SkillTile({Key? key, required this.skill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.blue),
          const SizedBox(width: 8),
          Flexible(child: Text(skill, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class ProjectsSection extends StatelessWidget {
  ProjectsSection({Key? key}) : super(key: key);

  final List<Project> projects = const [
    Project(
      title: 'Dacktra App',
      subtitle: 'Healthcare booking & schedule management',
      tech: 'Flutter, Firebase, Google Maps, REST',
      demoUrl: 'https://example.com/dacktra',
      codeUrl: 'https://github.com/MohamedSaidEbaid/dacktra',
    ),
    Project(
      title: 'Clean O\'clock',
      subtitle: 'Car care service with real-time tracking',
      tech: 'Flutter, Maps, Firebase Realtime',
      demoUrl: 'https://example.com/cleano',
      codeUrl: 'https://github.com/MohamedSaidEbaid/cleanoclock',
    ),
    Project(
      title: 'GCI App',
      subtitle: 'Product scanner & info portal',
      tech: 'Flutter, Barcode Scanner, REST',
      demoUrl: 'https://example.com/gci',
      codeUrl: 'https://github.com/MohamedSaidEbaid/gci-app',
    ),
    Project(
      title: 'SAO App',
      subtitle: 'Job hiring & posting platform',
      tech: 'Flutter, REST API, Auth',
      demoUrl: 'https://example.com/sao',
      codeUrl: 'https://github.com/MohamedSaidEbaid/sao',
    ),
    Project(
      title: 'Quizara App',
      subtitle: 'Quiz challenges with ads & deep links',
      tech: 'Flutter, Google Ads, Deep Links',
      demoUrl: 'https://example.com/quizara',
      codeUrl: 'https://github.com/MohamedSaidEbaid/quizara',
    ),
    Project(
      title: 'Teach Zone',
      subtitle: 'Educational platform with video streaming',
      tech: 'Flutter, Video Streaming, Firebase',
      demoUrl: 'https://example.com/teachzone',
      codeUrl: 'https://github.com/MohamedSaidEbaid/teachzone',
    ),
    Project(
      title: 'Zi Sushi',
      subtitle: 'Food ordering with live admin tracking',
      tech: 'Flutter, Realtime DB, Order Tracking',
      demoUrl: 'https://example.com/zisushi',
      codeUrl: 'https://github.com/MohamedSaidEbaid/zisushi',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxis = width > 1000 ? 3 : width > 700 ? 2 : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Projects'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxis,
            childAspectRatio: 1.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: projects.length,
          itemBuilder: (_, i) => ProjectCard(project: projects[i]),
        ),
      ],
    );
  }
}

class Project {
  final String title;
  final String subtitle;
  final String tech;
  final String demoUrl;
  final String codeUrl;
  const Project({required this.title, required this.subtitle, required this.tech, required this.demoUrl, required this.codeUrl});
}

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Icon(Icons.phone_android, size: 48, color: Colors.blue)),
            ),
          ),
          const SizedBox(height: 12),
          Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Text(project.subtitle, style: const TextStyle(color: Colors.black54)),
          const Spacer(),
          Text(project.tech, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(onPressed: () => _open(project.codeUrl), child: const Text('View Code')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () => _open(project.demoUrl), child: const Text('Live Demo')),
            ],
          )
        ],
      ),
    );
  }

  void _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionTitle(title: 'Contact'),
      const SizedBox(height: 12),
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ContactRow(label: 'Email', value: 'ebaidmohamed79@gmail.com', url: 'mailto:ebaidmohamed79@gmail.com'),
            const SizedBox(height: 8),
            ContactRow(label: 'LinkedIn', value: 'linkedin.com/in/mohamed-said-23661a137', url: 'https://linkedin.com/in/mohamed-said-23661a137'),
            const SizedBox(height: 8),
            ContactRow(label: 'GitHub', value: 'github.com/MohamedSaidEbaid', url: 'https://github.com/MohamedSaidEbaid'),
            const SizedBox(height: 8),
            ContactRow(label: 'Phone', value: '+20 102 419 3734', url: 'tel:+201024193734'),
          ]),
        ),
      )
    ]);
  }
}

class ContactRow extends StatelessWidget {
  final String label;
  final String value;
  final String url;
  const ContactRow({Key? key, required this.label, required this.value, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(width: 90, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold))),
      Expanded(child: SelectableText(value)),
      IconButton(onPressed: () => launchUrl(Uri.parse(url)), icon: const Icon(Icons.open_in_new)),
    ]);
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold));
  }
}

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(child: Text('© ${2025} Mohamed Said — Flutter Developer', style: const TextStyle(color: Colors.black54))),
    );
  }
}
