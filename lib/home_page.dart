import 'package:appwhats/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> contatos = [];
  List<Map<String, dynamic>> contatosFiltrados = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarContatos();
    searchController.addListener(_filtrarContatos);
  }

  Future<void> _carregarContatos() async {
    final data = await DatabaseHelper.getContatos();
    setState(() {
      contatos = data;
      contatosFiltrados = data;
    });
  }

  void _filtrarContatos() {
    final query = searchController.text.toLowerCase();
    setState(() {
      contatosFiltrados = contatos
          .where((contato) =>
              contato['nome'].toLowerCase().contains(query) ||
              contato['telefone'].toLowerCase().contains(query))
          .toList();
    });
  }

  void _adicionarContato() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String nome = '';
        String telefone = '';

        return AlertDialog(
          title: const Text('Adicionar Contato'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nome'),
                onChanged: (value) {
                  nome = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  telefone = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (nome.isNotEmpty && telefone.isNotEmpty) {
                  await DatabaseHelper.createContato(nome, telefone);
                  await _carregarContatos();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, preencha todos os campos!'),
                    ),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _editarContato(int id, String nomeAtual, String telefoneAtual) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String nome = nomeAtual;
        String telefone = telefoneAtual;

        return AlertDialog(
          title: const Text('Editar Contato'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nome'),
                controller: TextEditingController(text: nomeAtual),
                onChanged: (value) {
                  nome = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                controller: TextEditingController(text: telefoneAtual),
                onChanged: (value) {
                  telefone = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (nome.isNotEmpty && telefone.isNotEmpty) {
                  await DatabaseHelper.updateContato(id, nome, telefone);
                  await _carregarContatos();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, preencha todos os campos!'),
                    ),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _deletarContato(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content:
              const Text('Tem certeza de que deseja excluir este contato?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper.deleteContato(id);
                await _carregarContatos();
                Navigator.of(context).pop();
              },
              child: const Text('Excluir'),
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
        title: const Text(
          'Contatos WhatsApp',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
        backgroundColor: const Color(0xFF44AD3A),
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contatosFiltrados.length,
              itemBuilder: (context, index) {
                final contato = contatosFiltrados[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/whats-icon.png'),
                      radius: 20,
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(
                      contato['nome'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(contato['telefone']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.black),
                          onPressed: () {
                            _editarContato(
                              contato['id'],
                              contato['nome'],
                              contato['telefone'],
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deletarContato(contato['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarContato,
        backgroundColor: const Color(0xFF44AD3A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
