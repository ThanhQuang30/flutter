import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split/splitwise/root.dart';
import 'package:split/splitwise/splitwise_screen.dart';
import 'package:split/src/fire_base/fire_base.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(fontSize: 25)),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 200,
                    top: 0,
                    child: Center(
                      child: Text(
                        'Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/avatar.png'), // Thay thế bằng đường dẫn ảnh avatar của bạn
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Profile', style: TextStyle(fontSize: 20)),
              onTap: () {
                //
              },
            ),
            ListTile(
              title: const Text('Setting', style: TextStyle(fontSize: 20)),
              onTap: () {
                //
              },
            ),
            ListTile(
              title: ElevatedButton(
                child: const Text("Sign Out", style: TextStyle(fontSize: 20)),
                onPressed: () async {
                  CurrentUser _currentUser =
                  Provider.of<CurrentUser>(context, listen: false);
                  String _returnString = await _currentUser.signOut();
                  if (_returnString == "success") {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OurRoot(),
                      ),
                          (route) => false,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút My Wallet
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_balance_wallet, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'My Wallet',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Sử dụng Navigator.pushReplacement thay vì Navigator.push
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SplitwiseScreen()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.attach_money, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'Splitwise',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Xử lý khi nhấn nút Our Fund
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monetization_on, size: 40),
                    SizedBox(height: 8),
                    Text(
                      'Our Fund',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
