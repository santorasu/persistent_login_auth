import 'package:flutter/material.dart';
import 'package:task_management/ui/widgets/home_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  static const int _perPage = 10;

  @override
  void initState() {
    super.initState();
    _fetchData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final List<String> newItems = List.generate(_perPage, (index) {
      final itemNumber = (_currentPage - 1) * _perPage + index + 1;
      return "Task Item #$itemNumber";
    });

    if (newItems.isNotEmpty) {
      setState(() {
        _items.addAll(newItems);
        _currentPage++;
      });
    } else {
      setState(() {
        _hasMore = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: _buildTaskList(),
    );
  }

  Widget _buildTaskList() {
    if (_items.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_items.isEmpty && !_hasMore) {
      return const Center(child: Text("No tasks found."));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _items.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final item = _items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text((index + 1).toString()),
            ),
            title: Text(item),
            subtitle: const Text("This is a description for the task."),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
            },
          ),
        );
      },
    );
  }
}


