import 'package:cbt_software_win/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    String username = context.watch<UserProvider>().userStateItems.username;
    return  Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          
          width: double.infinity,
          color: const Color(0xFFFFFFFF),
        
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children:[
              SizedBox(
                width: 40.00,
                height: 40.00,
                child: Placeholder()
              ),
               SizedBox(width: 10.0,),
               Text("AKAD CBT SOFTWARE", style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, fontFamily: "EastSeaDokdo"),),
            ]),

           
              
                Text(username.isNotEmpty ? "Welcome, $username" : "Welcome", style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),)
            ],
          ),
        );
  }
}