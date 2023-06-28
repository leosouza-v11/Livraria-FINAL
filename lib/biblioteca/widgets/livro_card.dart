import 'package:flutter/material.dart';
import 'package:livraria/biblioteca/widgets/livro_widget.dart';
import 'package:livraria/model/classes/livro_api.dart';

class LivroCard extends StatelessWidget {
  const LivroCard({super.key, required this.livro});

  final LivroApi livro;

  @override
  Widget build(BuildContext context) {
    //Eventos de toque no card
    return InkWell(
      child: Card(
        //Limita as informações dentro do card
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: const Color.fromRGBO(240, 248, 255, 1),
        margin: const EdgeInsets.all(4),
        //Borda do Card
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.5, color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SizedBox(
          child: Column(
            // Espaço entre os textos
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                livro.titulo,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  livro.capa ??
                      'https://jbinstrumentos.com.br/wp-content/uploads/2021/04/sem-imagem.jpg',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.18,
                ),
              ),
            ],
          ),
        ),
      ),

      //Quando clicado no card do livro, abre o widget com os dados do livro
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LivroWidget(livro: livro),
          ),
        );
      },
    );
  }
}
