import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({
    Key? key,
    required this.galleryBloc,
    required this.images,
    required this.index,
  }) : super(key: key);

  final GalleryBloc galleryBloc;
  final List<String> images;
  final int index;

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
            // TODO: find a way how to use one instance of GalleryBloc
            child: BlocBuilder<GalleryBloc, GalleryState>(
              bloc: widget.galleryBloc,
              builder: (BuildContext context, GalleryState state) {
                if (state is GalleryLoadingState) {
                  return const SizedBox.shrink();
                } else if (state is GalleryDataState) {
                  if (state.gallery.isEmpty) {
                    return Center(
                      child: Text(
                        'Пусто',
                        style: theme.textTheme.bodyText1,
                      ),
                    );
                  }
                  return PageView.builder(
                    controller: controller,
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.gallery.length,
                    onPageChanged: (i) {
                      indexNotifier.value = i;
                    },
                    itemBuilder: (context, index) {
                      return InteractiveViewer(
                        child: Image.memory(
                          state.gallery[index],
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  );
                } else {
                  // TODO: try GalleryErrorState
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          color: theme.errorColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ошибка',
                          style: theme.textTheme.bodyText1!
                              .copyWith(color: theme.errorColor),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: indexNotifier,
            builder: (context, int value, _) {
              return Container(
                height: 50,
                color: theme.primaryColor.withOpacity(0.3),
                child: BlocBuilder<GalleryBloc, GalleryState>(
                  bloc: widget.galleryBloc,
                  builder: (BuildContext context, GalleryState state) {
                    if (state is GalleryLoadingState) {
                      return const SizedBox.shrink();
                    } else if (state is GalleryDataState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          state.gallery.length,
                          (index) {
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
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
                                  image: DecorationImage(
                                    image: MemoryImage(state.gallery[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      // TODO: try GalleryErrorState
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_outlined,
                              color: theme.errorColor,
                            ),
                          ],
                        ),
                      );
                    }
                  },
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
                GestureDetector(
                  onTap: () {
                    widget.galleryBloc.add(
                      GalleryAddEvent(widget.images),
                    );
                  },
                  child: Text(
                    'Добавить',
                    style: theme.textTheme.subtitle1!
                        .copyWith(color: theme.scaffoldBackgroundColor),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.galleryBloc.add(
                      GalleryDeleteEvent(
                        widget.images..removeAt(indexNotifier.value),
                      ),
                    );
                    if (indexNotifier.value != 0) {
                      indexNotifier.value--;
                    }
                  },
                  child: Text(
                    'Удалить',
                    style: theme.textTheme.subtitle1!
                        .copyWith(color: theme.scaffoldBackgroundColor),
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
