import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import '../services/image_service.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({
    Key? key,
    required this.images,
    required this.index,
    required this.onAdd,
    required this.onDelete,
  }) : super(key: key);

  final List<String> images;
  final int index;
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late final PageController controller;
  late final ValueNotifier<int> indexNotifier;

  @override
  void initState() {
    controller = PageController(initialPage: widget.index);
    indexNotifier = ValueNotifier(widget.index);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    indexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const BackAppBar(
        title: 'Фото',
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (int index) {
                indexNotifier.value = index;
              },
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                // TODO: create bloc for images
                return FutureBuilder(
                  future: ImageService.loadImage(widget.images[index]),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && snapshot.data.isNotEmpty) {
                      return Image.memory(snapshot.data);
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: indexNotifier,
            builder: (context, int value, _) {
              return Container(
                height: 50,
                color: theme.primaryColor.withOpacity(0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.images.length,
                    // TODO: create bloc for images
                    (index) => FutureBuilder(
                      future: ImageService.loadImage(widget.images[index]),
                      builder: (context, AsyncSnapshot snapshot) {
                        return GestureDetector(
                          onTap: () {
                            if (controller.page != index) {
                              controller.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 35.0,
                            height: 35.0,
                            decoration: BoxDecoration(
                              border: (index == value)
                                  ? Border.all(
                                      color: theme.primaryColor,
                                      width: 3,
                                    )
                                  : null,
                              color: theme.scaffoldBackgroundColor,
                              image:
                                  (snapshot.hasData && snapshot.data.isNotEmpty)
                                      ? DecorationImage(
                                          image: MemoryImage(snapshot.data),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            height: 40.0,
            color: theme.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ['Добавить', widget.onAdd],
                ['Удалить', widget.onDelete]
              ].map(
                (pair) {
                  return GestureDetector(
                    onTap: pair[1] as VoidCallback,
                    child: Text(
                      pair[0] as String,
                      style: theme.textTheme.subtitle1!
                          .copyWith(color: theme.scaffoldBackgroundColor),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
