import 'package:flutter/material.dart';

void main() => runApp(ImcApp());

class ImcApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImcScreen(),
    );
  }
}

class ImcScreen extends StatefulWidget {
  @override
  _ImcScreenState createState() => _ImcScreenState();
}

class _ImcScreenState extends State<ImcScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();
  String _sexo = 'Masculino';
  String _resultado = '';
  String _mensagem = '';
  double? _imc;
  Color _mensagemColor = Colors.black;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  void _calcularImc() {
    if (_formKey.currentState!.validate()) {
      final peso = double.parse(_pesoController.text);
      final altura = double.parse(_alturaController.text);
      _imc = peso / (altura * altura);

      setState(() {
        if (_imc! < 18.5) {
          _resultado = 'Abaixo do peso';
          _mensagem = _sexo == 'Masculino'
              ? 'Você está abaixo do peso ideal. Considere melhorar sua alimentação.'
              : 'Você está abaixo do peso. Consulte um nutricionista!';
          _mensagemColor = Colors.orange;
        } else if (_imc! < 25) {
          _resultado = 'Peso normal';
          _mensagem = _sexo == 'Masculino'
              ? 'Parabéns! Você está com o peso ideal.'
              : 'Parabéns! Continue mantendo um estilo de vida saudável!';
          _mensagemColor = Colors.green;
        } else if (_imc! < 30) {
          _resultado = 'Sobrepeso';
          _mensagem = _sexo == 'Masculino'
              ? 'Cuidado! Tente praticar mais exercícios.'
              : 'Cuidado! Tente melhorar sua alimentação e rotina.';
          _mensagemColor = Colors.orange;
        } else {
          _resultado = 'Obesidade';
          _mensagem = _sexo == 'Masculino'
              ? 'Alerta! Consulte um médico para cuidar de sua saúde.'
              : 'Atenção! Procure ajuda profissional para melhorar sua saúde.';
          _mensagemColor = Colors.red;
        }
      });

      _animationController.forward(from: 0);
    }
  }

  // Função para exibir o diálogo com as informações do IMC
  void _mostrarTabelaImc() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tabela de IMC'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('IMC < 18.5: Abaixo do peso', style: TextStyle(fontSize: 16)),
                Text('IMC 18.5 - 24.9: Peso normal', style: TextStyle(fontSize: 16)),
                Text('IMC 25 - 29.9: Sobrepeso', style: TextStyle(fontSize: 16)),
                Text('IMC ≥ 30: Obesidade', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Text('Esses valores podem variar com base no sexo e outros fatores.', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _alturaController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _mostrarTabelaImc, // Ao clicar, mostra a tabela de IMC
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _sexo,
                items: [
                  DropdownMenuItem(child: Text('Masculino'), value: 'Masculino'),
                  DropdownMenuItem(child: Text('Feminino'), value: 'Feminino'),
                ],
                onChanged: (value) {
                  setState(() {
                    _sexo = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Sexo'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _pesoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Peso (kg)'),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Por favor, insira um peso válido';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              TextFormField(
                controller: _alturaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Altura (m)'),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Por favor, insira uma altura válida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calcularImc,
                child: Text('Calcular'),
              ),
              SizedBox(height: 16),
              FadeTransition(
                opacity: _opacityAnimation,
                child: Column(
                  children: [
                    if (_imc != null)
                      Text(
                        'Seu IMC é: ${_imc!.toStringAsFixed(1)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    SizedBox(height: 8),
                    Text(
                      _resultado,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _mensagem,
                      style: TextStyle(fontSize: 18, color: _mensagemColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
