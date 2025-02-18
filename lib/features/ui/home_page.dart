import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 2,
        title: const Text("Chats"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
                itemBuilder: (context,index){
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  radius: 32,
                ),
              );
            }),
          ),
          Divider(color: Colors.grey.withOpacity(0.05),thickness: 10,),
          Expanded(
            flex: 6,
            child: ListView.separated(
                itemCount: 20,
                itemBuilder: (context,index){
                  return const ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                    ),
                    title: Text('User Name',style: TextStyle(fontWeight: FontWeight.w600),),
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Divider(color: Colors.grey.withOpacity(0.05)),
                  );
            },),


          ),
          const SizedBox(height: 24)
        ],
      ),
    );
  }
}
