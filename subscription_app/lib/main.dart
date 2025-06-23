import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const SubscriptionApp());
}

class Subscription {
  String service;
  String email;
  double price;
  int billingDay;
  String card;

  Subscription({
    required this.service,
    required this.email,
    required this.price,
    required this.billingDay,
    required this.card,
  });
}

class SubscriptionApp extends StatefulWidget {
  const SubscriptionApp({Key? key}) : super(key: key);

  @override
  State<SubscriptionApp> createState() => _SubscriptionAppState();
}

class _SubscriptionAppState extends State<SubscriptionApp> {
  final List<Subscription> _subscriptions = [];

  final _formKey = GlobalKey<FormState>();
  final _serviceController = TextEditingController();
  final _emailController = TextEditingController();
  final _priceController = TextEditingController();
  final _dayController = TextEditingController();
  final _cardController = TextEditingController();

  @override
  void dispose() {
    _serviceController.dispose();
    _emailController.dispose();
    _priceController.dispose();
    _dayController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  double get _monthlyTotal {
    return _subscriptions.fold(0.0, (prev, s) => prev + s.price);
  }

  void _addSubscription() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _subscriptions.add(Subscription(
          service: _serviceController.text,
          email: _emailController.text,
          price: double.parse(_priceController.text),
          billingDay: int.parse(_dayController.text),
          card: _cardController.text,
        ));
        _serviceController.clear();
        _emailController.clear();
        _priceController.clear();
        _dayController.clear();
        _cardController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de Suscripciones',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Gestor de Suscripciones'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _serviceController,
                      decoration: const InputDecoration(labelText: 'Servicio'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ingrese el nombre del servicio'
                          : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Correo'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ingrese el correo utilizado'
                          : null,
                    ),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Precio'),
                      validator: (value) => value == null || double.tryParse(value) == null
                          ? 'Ingrese un precio válido'
                          : null,
                    ),
                    TextFormField(
                      controller: _dayController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Día de cobro'),
                      validator: (value) {
                        final day = int.tryParse(value ?? '');
                        if (day == null || day < 1 || day > 31) {
                          return 'Ingrese un día válido (1-31)';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _cardController,
                      decoration: const InputDecoration(labelText: 'Tarjeta'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ingrese la tarjeta utilizada'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addSubscription,
                      child: const Text('Agregar'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Gasto mensual total: ' +
                  NumberFormat.simpleCurrency(locale: 'es').format(_monthlyTotal)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _subscriptions.length,
                  itemBuilder: (context, index) {
                    final sub = _subscriptions[index];
                    return ListTile(
                      title: Text(sub.service),
                      subtitle: Text(
                          '${sub.email} - ${NumberFormat.simpleCurrency(locale: 'es').format(sub.price)} - Día ${sub.billingDay}\nTarjeta: ${sub.card}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
