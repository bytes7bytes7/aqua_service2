import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class ClientEditScreen extends StatelessWidget {
  const ClientEditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: BackAppBar(
          title: 'Клиент',
          onPressed: () {},
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: CircleAvatar(
                    backgroundColor: theme.primaryColor,
                    radius: 46,
                    child: CircleAvatar(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      radius: 45,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.3,
                      child: OutlinedButton(
                        child: FittedBox(
                          child: Text(
                            'Изменить',
                            style: theme.textTheme.bodyText1,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: theme.primaryColor,
                          side: BorderSide(
                            color: theme.disabledColor,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              topRight: Radius.zero,
                              bottomRight: Radius.zero,
                            ),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.3,
                      child: OutlinedButton(
                        child: FittedBox(
                          child: Text(
                            'Удалить',
                            style: theme.textTheme.bodyText1,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          primary: theme.primaryColor,
                          side: BorderSide(
                            color: theme.disabledColor,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.zero,
                              topLeft: Radius.zero,
                            ),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 27.0,
                    vertical: 16.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.disabledColor,
                    ),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Послед. дата: 03.09.21',
                        style: theme.textTheme.bodyText1,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'След. дата: 08.10.21',
                        style: theme.textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                const PaddingTextFormField(
                  title: 'Имя',
                ),
                PaddingTextFormField(
                  title: 'Телефон',
                  onPressed: () {},
                ),
                const PaddingTextFormField(
                  title: 'Город',
                ),
                const PaddingTextFormField(
                  title: 'Адрес',
                ),
                const PaddingTextFormField(
                  title: 'Объем аквариума',
                ),
                const SizedBox(
                  height: 300,
                  child: PaddingTextFormField(
                    title: 'Комментарий',
                    expands: true,
                  ),
                ),
                Container(
                  height: 200,
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(4, (index) {
                        return Container(
                          margin: EdgeInsets.only(
                            left: index == 0 ? 20.0 : 0,
                            right: 20.0,
                          ),
                          width: size.width * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: theme.disabledColor,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                WideButton(
                  isPositive: false,
                  title: 'Удалить',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
