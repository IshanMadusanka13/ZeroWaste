import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/reward_item.dart';
import 'package:zero_waste/repositories/gifs_repository.dart';
import 'package:zero_waste/repositories/reward_item_repository.dart';

class RewardsGiftScreen extends StatefulWidget {
  const RewardsGiftScreen({super.key});

  @override
  _RewardsGiftScreenState createState() => _RewardsGiftScreenState();
}

class _RewardsGiftScreenState extends State<RewardsGiftScreen> {
  late Stream<DocumentSnapshot> _rewardStream;
  final RewardItemRepository _rewardItemRepository = RewardItemRepository();
  final GifsRepository _giftItemRepository = GifsRepository();

  final String userId = '001';

  @override
  void initState() {
    super.initState();
    _rewardStream = FirebaseFirestore.instance
        .collection('rewards')
        .doc(userId)
        .snapshots();
  }

  void _buyItem(BuildContext context, RewardItem item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Confirm Purchase',
            style: TextStyle(color: Colors.green[800]),
          ),
          content: Text(
              'Are you sure you want to buy ${item.name} for ${item.points} points?',
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Buy', style: TextStyle(color: Colors.green[800])),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  bool success =
                      await _giftItemRepository.buyItem(userId, item.points);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? 'Successfully purchased ${item.name}!'
                          : 'Not enough points to buy ${item.name}.'),
                      backgroundColor: success ? Colors.green : Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error occurred while purchasing.'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          'Rewards Gift Shop',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green[800],
        centerTitle: true,
      ),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: _rewardStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('No rewards data available'));
              }

              final rewardData = snapshot.data!.data() as Map<String, dynamic>;
              final userPoints = rewardData['points'] ?? 0;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Your Points: $userPoints',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<List<RewardItem>>(
              stream: _rewardItemRepository.getItems(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final items = snapshot.data ?? [];

                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Image.network(
                                item.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green[800],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${item.points} points',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  item.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[800],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('Buy'),
                                  onPressed: () => _buyItem(context, item),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
