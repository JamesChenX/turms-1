import 'package:flutter/material.dart';

import '../../../components/components.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) => _buildProfile();

  Widget _buildProfile() => const IntrinsicHeight(
        child: Row(
          children: [
            TAvatar(
              useLargeSize: true,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'my name是一个很长的名字',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    Text('User ID: 123456789'),
                  ],
                ),
              ),
            )
          ],
        ),
      );
}