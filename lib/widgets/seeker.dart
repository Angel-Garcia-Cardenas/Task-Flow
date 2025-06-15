import 'package:flutter/material.dart';

class TaskSeeker extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;

  const TaskSeeker({Key? key, required this.onSearchChanged}) : super(key: key);

  @override
  _TaskSeekerState createState() => _TaskSeekerState();
}

class _TaskSeekerState extends State<TaskSeeker> {
  final TextEditingController _controller = TextEditingController();

  void _onChanged() {
    widget.onSearchChanged(_controller.text);
  }

  void _clear() {
    _controller.clear();
    widget.onSearchChanged('');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Buscar tareas...',
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: _clear,
              )
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: const TextStyle(color: Colors.black),
      cursorColor: Colors.blue,
    );
  }
}
