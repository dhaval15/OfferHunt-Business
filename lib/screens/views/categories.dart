import 'package:offerhuntbusiness/colors.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      shadowColor: Colors.black87,
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: GridView.builder(
            itemCount: 8,
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5,mainAxisSpacing: 0),
            itemBuilder: (context, index) => CategoryItem('Home', Icons.home),
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const CategoryItem(this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(4),
            width: 36,
            height: 36,
            child: Icon(
              icon,
              size: 24,
              color: brandColorDarker,
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [brandColor2, Colors.white],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: brandColorDarker),
          ),
        ],
      ),
    );
  }
}
