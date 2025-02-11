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
        title: const Text("Massager"),),
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
          Divider(color: Colors.grey.withOpacity(0.1),thickness: 10,),
          Expanded(
            flex: 6,
            child: ListView.separated(
                itemCount: 20,
                itemBuilder: (context,index){
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                      ),
                      title: Text('User Name'),
                    ),
                  );
                }, separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: Colors.grey.withOpacity(0.1));
            },),


          ),
          const SizedBox(height: 24)
        ],
      ),
    );
  }
}
