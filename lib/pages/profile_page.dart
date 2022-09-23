import 'package:flutter/material.dart';
import 'package:resto_app/theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 36.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              child: const CircleAvatar(
                                minRadius: 70.0,
                                backgroundImage: AssetImage(
                                  'assets/profile.jpg',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            Text(
                              'Krista W. Pickens',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.black),
                            )
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Coming Soon!'),
                                    content: const Text(
                                        'This feature will be released in the next update.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Can\'t wait'))
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 64.0,
                              height: 36.0,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white),
                              child: AnimatedAlign(
                                  duration: const Duration(milliseconds: 500),
                                  alignment: Alignment.centerRight,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    child: const Icon(
                                      Icons.light_mode,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                  )),
                            ))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 32.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(
                            'My Profile',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: semiBold),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        ListTile(
                          leading: const Icon(Icons.payment),
                          title: Text(
                            'My Saved Cards',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: semiBold),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        ListTile(
                          leading: const Icon(Icons.policy),
                          title: Text(
                            'Privacy Policy',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: semiBold),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        ListTile(
                          leading: const Icon(Icons.support_agent),
                          title: Text(
                            'Customer Care',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: semiBold),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        ListTile(
                          leading: const Icon(Icons.help),
                          title: Text(
                            'FAQ',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: semiBold),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: Text(
                            'Logout',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: semiBold),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
