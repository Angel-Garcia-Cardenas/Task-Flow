// screens/home_screen.dart - Completely redesigned UI
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/task_list.dart';
import 'package:todo_app/screens/profile_screen.dart'; 
import '../models/task.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_dialog.dart' as add_task_dialog;
import '../widgets/stats_card.dart' as stats_card;
import '../widgets/seeker.dart'; // Asegúrate de importar tu seeker

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      builder: (context) => const add_task_dialog.AddTaskDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtén el usuario actual de Firebase Auth
    final user = FirebaseAuth.instance.currentUser;
    // Usa el displayName si existe, si no, un fallback genérico
    final displayName = user?.displayName ?? user?.email?.split('@').first ?? 'Usuario';
    final taskList = Provider.of<TaskList>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FB),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar.large(
            title: const Text(
              'Mis Tareas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            pinned: true,
            expandedHeight: 90,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 65, left: 20, right: 16),
                      child: Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const ProfilePage()),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Mis Tareas',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              Text('Hola, $displayName',
                                  style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                            },
                            child: const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Statistics Cards
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Buscador usando TaskSeeker
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TaskSeeker(
                      onSearchChanged: (text) {
                        setState(() {
                          _searchText = text;
                        });
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: stats_card.StatsCard(
                          title: 'Total',
                          count: taskList.tasks.length,
                          color: theme.colorScheme.primary,
                          icon: Icons.list,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: stats_card.StatsCard(
                          title: 'Pendientes',
                          count: taskList.pendingCount,
                          color: Colors.orange,
                          icon: Icons.pending_actions,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: stats_card.StatsCard(
                          title: 'Completadas',
                          count: taskList.completedCount,
                          color: Colors.green,
                          icon: Icons.check_circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Filter Tabs
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(style: BorderStyle.none),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      onTap: (index) {
                        setState(() {
                          switch (index) {
                            case 0:
                              _selectedFilter = 'all';
                              break;
                            case 1:
                              _selectedFilter = 'pending';
                              break;
                            case 2:
                              _selectedFilter = 'completed';
                              break;
                            case 3:
                              _selectedFilter = 'overdue';
                              break;
                          }
                        });
                      },
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey,
                      ),
                      labelColor: Colors.white,
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        overflow: TextOverflow.visible,
                      ),
                      unselectedLabelColor: theme.colorScheme.onSurface,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(
                            child:
                            Text('Todas', overflow: TextOverflow.ellipsis)),
                        Tab(
                            child: Text('Pendientes',
                                overflow: TextOverflow.ellipsis)),
                        Tab(
                            child: Text('Completas',
                                overflow: TextOverflow.ellipsis)),
                        Tab(
                            child: Text('Vencidas',
                                overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tasks List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: Consumer<TaskList>(
              builder: (context, taskList, child) {
                // Aplica filtro de búsqueda además del filtro de pestaña
                final filteredTasks = taskList
                    .getFilteredTasks(_selectedFilter)
                    .where((task) => task.title
                    .toLowerCase()
                    .contains(_searchText.toLowerCase()))
                    .toList();

                if (filteredTasks.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 64,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            emptyTitle[_selectedFilter] ?? '',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            emptyMessages[_selectedFilter] ?? '',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Agrupar tareas por categoría y ordenar por fecha más próxima
                final Map<String, List<Task>> categorizedTasks = <String, List<Task>>{};
                for (var task in filteredTasks) {
                  final String category = task.category.name[0].toUpperCase() +
                      task.category.name.substring(1).toLowerCase();
                  categorizedTasks
                      .putIfAbsent(category, () => <Task>[])
                      .add(task);
                }
                // Ordenar cada lista de tareas por fecha más próxima (ascendente)
                categorizedTasks.forEach((key, tasks) {
                  tasks.sort((a, b) {
                    if (a.dueDate == null && b.dueDate == null) return 0;
                    if (a.dueDate == null) return 1;
                    if (b.dueDate == null) return -1;
                    return a.dueDate!.compareTo(b.dueDate!);
                  });
                });

                // Mostrar categorías como acordeón
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final category = categorizedTasks.keys.toList()[index];
                      final tasksInCategory = categorizedTasks[category]!;

                      return Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          title: Text(
                            category,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          initiallyExpanded: true,
                          iconColor: Colors.grey,
                          collapsedIconColor: Colors.grey,
                          children: tasksInCategory.map((task) {
                            final taskIndex = taskList.tasks.indexOf(task);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8, left: 0, right: 0),
                              child: TaskTile(
                                task: task,
                                index: taskIndex,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                    childCount: categorizedTasks.keys.length,
                  ),
                );
              },
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}

final Map<String, String> emptyTitle = {
  'all': '¡Excelente!',
  'pending': '¡Excelente!',
  'completed': '¡Oh no!',
  'overdue': '¡Excelente!',
};

final Map<String, String> emptyMessages = {
  'all': 'No tienes tareas por realizar. ¿Deseas agregar alguna?',
  'pending': 'No tienes tareas pendientes.',
  'completed': 'Aún no completas ninguna tarea.',
  'overdue': 'No tienes tareas vencidas. ¡Bien hecho!',
};
