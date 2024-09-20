import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zero_waste/models/reward.dart';
import 'package:zero_waste/repositories/rewards_repository.dart';

class ManageRewardsScreen extends StatelessWidget {
  const ManageRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //RewardsRepository().recalculateTotalRewards();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Rewards'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('rewards').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var rewards = snapshot.data!.docs
              .map((doc) => Reward.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: rewards.length,
            itemBuilder: (context, index) {
              var reward = rewards[index];
              return ListTile(
                title: Text('${reward.userId}: ${reward.points} points'),
              );
            },
          );
        },
      ),
    );
  }
}
