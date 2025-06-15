import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class CalculoInvestimentoScreen extends StatefulWidget {
  const CalculoInvestimentoScreen({Key? key}) : super(key: key);

  @override
  _CalculoInvestimentoScreenState createState() => _CalculoInvestimentoScreenState();
}

class _CalculoInvestimentoScreenState extends State<CalculoInvestimentoScreen> {
  final TextEditingController _aporteMensalController = TextEditingController();
  final TextEditingController _periodoMesesController = TextEditingController();
  final TextEditingController _percentualJurosController = TextEditingController();

  double _totalSemRentabilidade = 0.0;
  double _totalComRentabilidade = 0.0;

  void _executarSimulacao() {
    double aporte = double.tryParse(_aporteMensalController.text) ?? 0.0;
    int meses = int.tryParse(_periodoMesesController.text) ?? 0;
    double juros = double.tryParse(_percentualJurosController.text) ?? 0.0;

    if (aporte > 0 && meses > 0) {
      double valorBruto = aporte * meses;
      double taxa = juros / 100.0;
      double valorComJuros = 0.0;

      if (taxa > 0) {
        valorComJuros = aporte * ((pow(1 + taxa, meses) - 1) / taxa);
      }

      setState(() {
        _totalSemRentabilidade = valorBruto;
        _totalComRentabilidade = valorComJuros;
      });
    } else {
      setState(() {
        _totalSemRentabilidade = 0.0;
        _totalComRentabilidade = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _aporteMensalController.dispose();
    _periodoMesesController.dispose();
    _percentualJurosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulador de Investimentos'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Aporte mensal:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _aporteMensalController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              decoration: InputDecoration(
                hintText: 'Informe o valor mensal',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Período (em meses):',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _periodoMesesController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Quantidade de meses',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Taxa de juros mensal:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _percentualJurosController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              decoration: InputDecoration(
                hintText: 'Ex: 1.5',
                suffixText: '%',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: _executarSimulacao,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Simular'),
            ),
            const SizedBox(height: 30.0),
            Text(
              'Total sem juros: R\$ ${_totalSemRentabilidade.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Total com juros compostos: R\$ ${_totalComRentabilidade.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
