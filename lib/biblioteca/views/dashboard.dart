import 'package:flutter/material.dart';
import 'package:livraria/biblioteca/widgets/livro_card.dart';
import 'package:livraria/model/classes/livro_api.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController pesquisaControler = TextEditingController();

  //Lista de Livros
  List<LivroApi> _listaLivrosApi = [];

  @override
  void dispose() {
    pesquisaControler.dispose();
    super.dispose();
  }

  Future<void> pesquisar() async {
    final pesquisa = pesquisaControler.text.trim();

    if (pesquisa.isNotEmpty) {
      List<LivroApi> listaLivros = await LivroApi.pesquisaLivros(pesquisa);

      setState(() {
        _listaLivrosApi = listaLivros;
      });

      pesquisaControler.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(212, 242, 246, 1),
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false, //Remove o "voltar"
        title: SizedBox(
          width: 300,
          height: 40,
          child: TextField(
            decoration: const InputDecoration(
              //Backgroud do campo de pesquisa
              filled: true,
              fillColor: Color.fromRGBO(255, 255, 255, 1),

              //Texto dentro do campo
              hintText: '       Pesquisar',
              contentPadding: EdgeInsets.all(1.0),

              //Borda antes de clicar
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),

              //Borda depois de clicar
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),

              //Ícone antes do texto
              suffixIcon: Icon(
                Icons.search_outlined,
                color: Colors.black,
              ),
            ),
            onTap: () => pesquisar(),
            controller: pesquisaControler,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        //Grid com os livros
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //Quantidade de itens lado a lado
            crossAxisSpacing: 4, //Espaçamento lateral Entre Cards
            mainAxisSpacing: 4, //Espaçamento vertical Entre Cards
          ),

          //A quantidade de livros na lista é o tamanho do "for"
          itemCount: _listaLivrosApi.length,

          //chama a lista toda, um por vez (como num for) e coloca em algo (Card)
          itemBuilder: (context, index) => LivroCard(
            livro: _listaLivrosApi[index],
          ),
        ),
      ),
    );
  }
}
