import 'package:flutter/material.dart';
import 'sobre_page.dart';
import 'policy_page.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF44AD3A),
            ),
            child: Text(
              "WhatsApp Lista de Contatos",
              style: TextStyle(color: Color(0xFFf5f5f5), fontSize: 24),
            ),
          ),
          ListTile(
            title: const Text("Sobre"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SobrePage()),
              );
            },
          ),
          ListTile(
            title: const Text("Politica de Privacidade"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PolicyPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
