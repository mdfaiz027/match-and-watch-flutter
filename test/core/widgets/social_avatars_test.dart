import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:match_and_watch/core/widgets/social_avatars.dart';
import 'package:match_and_watch/core/widgets/user_avatar.dart';
import 'package:match_and_watch/core/database/app_database.dart';

void main() {
  testWidgets('SocialAvatars shows 1 avatar for 1 user and no badge', (WidgetTester tester) async {
    final users = [
      const User(id: 1, firstName: 'User', lastName: 'One', movieTaste: 'Action', pendingSync: false),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SocialAvatars(users: users),
        ),
      ),
    );

    expect(find.byType(UserAvatar), findsOneWidget);
    expect(find.textContaining('+'), findsNothing);
  });

  testWidgets('SocialAvatars shows 2 avatars and +3 badge for 5 users', (WidgetTester tester) async {
    final users = List.generate(
      5,
      (i) => User(
        id: i,
        firstName: 'User',
        lastName: '$i',
        movieTaste: 'Action',
        pendingSync: false,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SocialAvatars(users: users),
        ),
      ),
    );

    expect(find.byType(UserAvatar), findsNWidgets(2));
    expect(find.text('+3'), findsOneWidget);
  });
}
