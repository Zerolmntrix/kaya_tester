import 'package:flutter/material.dart';
import 'package:kagayaku_modules/kagayaku_modules.dart';
import 'package:url_launcher/url_launcher_string.dart';

GridView buildGridResult(List<NovelModel> novels, [double width = 1200]) {
  final count = width ~/ 300;

  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: count,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      childAspectRatio: 0.7,
    ),
    itemCount: novels.length,
    itemBuilder: (context, index) {
      final NovelModel novel = novels[index];
      return Novel(novel);
    },
  );
}

class Novel extends StatelessWidget {
  const Novel(this.novel, {super.key});

  final NovelModel novel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        image: DecorationImage(
          image: NetworkImage(novel.cover),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    novel.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  tooltip: "Open novel page",
                  onPressed: () => launchUrlString(novel.url),
                  icon: const Icon(
                    Icons.link,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
