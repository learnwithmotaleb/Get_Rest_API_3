
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Model/UserModel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<UserModel> userList = [];
  Future<List<UserModel>> getUserApi()async{
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200){
      for(Map i in data){
        print(i['name']);
        userList.add(UserModel.fromJson(i));
      }
      return userList;
    }else{
      return userList;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Rest API'),
          centerTitle: true,
        ),
        body: Column(
           children: [
             Expanded(
                 child: FutureBuilder(
                   future: getUserApi(),
                   builder: (context, AsyncSnapshot<List<UserModel>> snapshot){
                     if(!snapshot.hasData){
                       return Center(
                         child: CircularProgressIndicator(
                         ),
                       );
                     }else{
                       return ListView.builder(
                         itemCount: userList.length,
                           itemBuilder: (context, index){
                             return Card(
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Column(
                                   children: [
                                     ReusebleRow(title: 'Name',value: snapshot.data![index].name.toString()),
                                     ReusebleRow(title: 'UserName',value: snapshot.data![index].username.toString()),
                                     ReusebleRow(title: 'E-mail',value: snapshot.data![index].email.toString()),
                                     ReusebleRow(title: 'Address',
                                         value:
                                              snapshot.data![index].address.toString() +'\n'
                                             +snapshot.data![index].address!.city.toString()+'\n'
                                             +snapshot.data![index].address!.geo.toString()+'\n'
                                             +snapshot.data![index].address!.geo!.lat.toString()

                                     ),

                                     ReusebleRow(title: 'Company',value: snapshot.data![index].company.toString()),
                                     ReusebleRow(title: 'Company Name',value: snapshot.data![index].company!.name.toString()),

                                   ],
                                 ),
                               ),
                             );
                           }
                       );
                     }

                   },
                 )
             )
           ],
        )
    );
  }
}
class ReusebleRow extends StatelessWidget {
  String title,value;
  ReusebleRow({super.key,required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value),
        ],
      ),
    );
  }
}

