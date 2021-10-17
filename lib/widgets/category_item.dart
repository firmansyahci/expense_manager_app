import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String? name;
  final Function? onDelete;

  CategoryItem({
    this.name,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name!),
          IconButton(
            onPressed: () {
              onDelete!();
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
