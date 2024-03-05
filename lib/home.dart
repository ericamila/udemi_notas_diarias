import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/model/anotacao.dart';
import 'helper/anotacao_helper.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];

  _exibirTelaCadastro({Anotacao? anotacao}) {

    String textoSalvarAtualizar = '';
    if(anotacao == null){//SALVAR
      _tituloController.text ='';
      _descricaoController.text ='';
      textoSalvarAtualizar = 'Salvar';
    }else{//ATUALIZAR
      _tituloController.text =anotacao.titulo!;
      _descricaoController.text =anotacao.descricao!;
      textoSalvarAtualizar = 'Atualizar';
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Adicionar anotação'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "Título",
                    hintText: "Digite título...",
                  ),
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                    labelText: "Descrição",
                    hintText: "Digite descrição...",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                  Navigator.pop(context);
                },
                child: Text(textoSalvarAtualizar),
              )
            ],
          );
        });
  }

  _salvarAtualizarAnotacao({Anotacao? anotacaoSelecionada}) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    if(anotacaoSelecionada == null) {//SALVAR

      Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
      await _db.salvarAnotacao(anotacao);

    }else{//ATUALIZAR

      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();
      int resultado = await _db.atualizarAnotacao(anotacaoSelecionada);

    }

    _tituloController.clear();
    _descricaoController.clear();

    _recuperarAnotacao();
  }

  _recuperarAnotacao() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacao();

    List<Anotacao> listaTemporaria = [];
    for (var item in anotacoesRecuperadas) {
      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);
    }

    setState(() {
      _anotacoes = listaTemporaria;
    });
    listaTemporaria = [];
  }

  _formatarData(String? data) {
    initializeDateFormatting('pt_BR');
    var formatador = DateFormat("dd/MM/y");
    DateTime dataConvertida = DateTime.parse(data!);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  _removerAnotacao(int id) async{
    await _db.removerAnotacao(id);
    _recuperarAnotacao();
  }

  @override
  void initState() {
    _recuperarAnotacao();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas anotações'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _anotacoes.length,
              itemBuilder: (context, index) {
                final anotacao = _anotacoes[index];
                return Card(
                  child: ListTile(
                    title: Text(anotacao.titulo.toString()),
                    subtitle: Text(
                        '${_formatarData(anotacao.data)} - ${anotacao.descricao}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _exibirTelaCadastro(anotacao: anotacao);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _removerAnotacao(anotacao.id!);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibirTelaCadastro();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
