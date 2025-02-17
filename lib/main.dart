import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятори',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Калькулятор 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Калькулятор 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Калькулятор 3',
          ),
        ],
      ),
    );
  }

  Widget _getCurrentScreen() {
    switch (_selectedTabIndex) {
      case 0:
        return CableCalculatorApp();
      case 1:
        return CurrentCalculatorApp();
      case 2:
        return Calculator3App();
      default:
        return Center(child: Text('Невідома сторінка'));
    }
  }
}

class CableCalculatorApp extends StatefulWidget {
  const CableCalculatorApp({super.key});

  @override
  _CableCalculatorAppState createState() => _CableCalculatorAppState();
}

class _CableCalculatorAppState extends State<CableCalculatorApp> {
  final _unomController = TextEditingController(text: '10');
  final _ikController = TextEditingController(text: '2.5');
  final _tfController = TextEditingController(text: '2.5');
  final _potuzhnistTPController = TextEditingController(text: '2000');
  final _smController = TextEditingController(text: '1300');
  final _tmController = TextEditingController(text: '4000');
  final _ctController = TextEditingController(text: '92');

  String _im = '';
  String _impa = '';
  String _sek = '';
  String _sSmin = '';

  String _conductorType = 'Неізольовані проводи та шини';
  final List<String> _conductorTypeOptions = [
    'Неізольовані проводи та шини',
    'Кабелі з паперовою ізоляцією',
    'Кабелі з гумовою ізоляцією',
  ];

  String _conductorMaterial = 'Матеріал провідника';
  final List<String> _conductorMaterialOptions = ['мідні', 'алюмінієві'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ..._buildTextFields(),
          DropdownButton<String>(
            value: _conductorTypeOptions.contains(_conductorType) ? _conductorType : null,
            onChanged: (value) => setState(() => _conductorType = value!),
            items: _conductorTypeOptions.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
          ),
          DropdownButton<String>(
            value: _conductorMaterialOptions.contains(_conductorMaterial) ? _conductorMaterial : null,
            onChanged: (value) => setState(() => _conductorMaterial = value!),
            items: _conductorMaterialOptions.map((mat) => DropdownMenuItem(value: mat, child: Text(mat))).toList(),
          ),
          ElevatedButton(onPressed: _calculate, child: Text('Обчислити')),
          ..._buildResults(),
        ],
      ),
    );
  }

  List<Widget> _buildTextFields() => [
    _textField(_unomController, 'Unom'),
    _textField(_ikController, 'Ik'),
    _textField(_tfController, 'Tf'),
    _textField(_potuzhnistTPController, 'Потужність ТП'),
    _textField(_smController, 'Sm'),
    _textField(_tmController, 'Tm'),
  ];

  Widget _textField(TextEditingController controller, String label) =>
      TextField(controller: controller, decoration: InputDecoration(labelText: label));

  List<Widget> _buildResults() => [
    Text('Розрахунковий струм для нормального режиму: $_im'),
    Text('Розрахунковий струм для післяаварійного режиму: $_impa'),
    Text('Економічний переріз (S ек): $_sek'),
    Text('Переріз за термічною стійкістю: $_sSmin'),
  ];



  void _calculate() {
    final sm = double.tryParse(_smController.text) ?? 0.0;
    final unom = double.tryParse(_unomController.text) ?? 0.0;
    final tm = double.tryParse(_tmController.text) ?? 0.0;
    final ik = double.tryParse(_ikController.text) ?? 0.0;
    final ct = double.tryParse(_ctController.text) ?? 0.0;

    final im = (sm / 2.0) / (sqrt(3.0) * unom);
    final impa = 2 * im;
    final jek = _determineJek(_conductorType, _conductorMaterial, tm);
    final sek = im / jek;
    final sSmin = (ik * 1000 * sqrt(tm)) / ct;

    setState(() {
      _im = im.toStringAsFixed(2);
      _impa = impa.toStringAsFixed(2);
      _sek = sek.toStringAsFixed(2);
      _sSmin = sSmin.toStringAsFixed(2);
    });
  }

  double _determineJek(String conductorType, String conductorMaterial, double tm) {
    final jekValues = {
      'Неізольовані проводи та шини': {
        'мідні': [2.5, 2.1, 1.8],
        'алюмінієві': [1.3, 1.1, 1.0],
      },
      'Кабелі з паперовою і проводи з гумовою та полівінілхлоридною ізоляцією з жилами': {
        'мідні': [3.0, 2.5, 2.0],
        'алюмінієві': [1.6, 1.4, 1.2],
      },
      'Кабелі з гумовою та пластмасовою ізоляцією з жилами': {
        'мідні': [3.5, 3.1, 2.7],
        'алюмінієві': [1.9, 1.7, 1.6],
      },
    };

    final ranges = [
      (1000.0, 3000.0),
      (3000.0, 5000.0),
      (5000.0, double.infinity),
    ];

    final values = jekValues[conductorType]?[conductorMaterial] ?? [];
    for (var i = 0; i < ranges.length; i++) {
      if (tm >= ranges[i].$1 && tm < ranges[i].$2) {
        return values[i];
      }
    }
    return 0.0;
  }
}

class CurrentCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('Current Calculator')),
        body: CurrentCalculatorScreen(),
      ),
    );
  }
}

class Calculator3App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('Calculator 3')),
        body: Calculator3Screen(),
      ),
    );
  }
}

class CurrentCalculatorScreen extends StatefulWidget {
  @override
  _CurrentCalculatorScreenState createState() => _CurrentCalculatorScreenState();
}

class _CurrentCalculatorScreenState extends State<CurrentCalculatorScreen> {
  final _ucnController = TextEditingController(text: '10.5');
  final _skController = TextEditingController(text: '200');
  final _ukPercController = TextEditingController(text: '10.5');
  final _sNomTController = TextEditingController(text: '6.3');

  String _xt = '', _xc = '', _xe = '', _ip0 = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTextField(_ucnController, 'Ucn'),
          _buildTextField(_skController, 'Sk'),
          _buildTextField(_ukPercController, 'Uk_perc'),
          _buildTextField(_sNomTController, 'S_nom_t'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _calculate,
            child: Text('Обчислити'),
          ),
          SizedBox(height: 16),
          Text('Xc: $_xc', style: Theme.of(context).textTheme.bodyLarge),
          Text('Xt: $_xt', style: Theme.of(context).textTheme.bodyLarge),
          Text('Сумарний опір точки К1: $_xe', style: Theme.of(context).textTheme.bodyLarge),
          Text('Початкове діюче значення струму трифазного КЗ: $_ip0', style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  void _calculate() {
    final double ucn = double.tryParse(_ucnController.text) ?? 0.0;
    final double sk = double.tryParse(_skController.text) ?? 0.0;
    final double ukPerc = double.tryParse(_ukPercController.text) ?? 0.0;
    final double sNomT = double.tryParse(_sNomTController.text) ?? 0.0;

    double xc = ((ucn * ucn) / sk);
    double xt = ((ukPerc / 100) * (ucn * ucn / sNomT));
    double xe = xc + xt;
    double ip0 = (ucn / (sqrt(3.0) * xe));

    setState(() {
      _xc = xc.toString();
      _xt = xt.toString();
      _xe = xe.toString();
      _ip0 = ip0.toString();
    });
  }
}

class Calculator3Screen extends StatefulWidget {
  @override
  _Calculator3ScreenState createState() => _Calculator3ScreenState();
}

class _Calculator3ScreenState extends State<Calculator3Screen> {
  final controllers = List.generate(20, (index) => TextEditingController());
  List<String> labels = [
    'S_b', 'U_b', 'S_k', 'U_k_perc', 'S_nom_t', 'X0', 'l', 'X_d_perc', 'S_nom_d', 'Ec',
    'Ed', 't', 'Yt', 'Tac', 'Tad', 'Tpz', 'Tpv'
  ];

  Map<String, String> results = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          for (int i = 0; i < labels.length; i++)
            TextField(controller: controllers[i], decoration: InputDecoration(labelText: labels[i])),
          SizedBox(height: 16),
          ElevatedButton(onPressed: _calculate, child: Text('Обчислити')),
          SizedBox(height: 16),
          ...results.entries.map((e) => Text('${e.key}: ${e.value}', style: Theme.of(context).textTheme.bodyLarge)).toList(),
        ],
      ),
    );
  }

  void _calculate() {
    double getVal(int i) => double.tryParse(controllers[i].text) ?? 0.0;

    double Ib = getVal(0) / (sqrt(3.0) * getVal(1));
    double Xc = getVal(0) / getVal(2);
    double Xt = (getVal(3) / 100) * getVal(0) / getVal(4);
    double U_c_n = getVal(1) * getVal(1);
    double Xl = getVal(5) * getVal(6) * getVal(0) / U_c_n;
    double Xd = (getVal(7) / 100) * getVal(0) / getVal(8);
    double X_E_c = Xc + Xt;
    double X_E_d = Xd + Xl;
    double Ip0c = getVal(9) / X_E_c * Ib;
    double Ip0d = getVal(10) / X_E_d * Ib;
    double Iptc = Ip0c;
    double Iptd = Ip0d * getVal(12);
    double Iac = sqrt(2.0) * Ip0c * exp(-getVal(11) / getVal(13));
    double Iad = sqrt(2.0) * Ip0d * exp(-getVal(11) / getVal(14));
    double Iuds = sqrt(2.0) * Ip0c * (1 + exp(-0.01 / getVal(13)));
    double Iudd = sqrt(2.0) * Ip0d * (1 + exp(-0.01 / getVal(14)));
    double Tach = (getVal(13) * Ip0c + getVal(14) * Ip0d) / (Ip0c + Ip0d);
    double Tpd = -getVal(11) / log(getVal(11));
    double Tvidk = getVal(15) + getVal(16);
    double Vk = (Ip0c * Ip0c * (Tvidk + Tach)) + (Ip0d * Ip0d * (0.5 * Tpd + Tach)) + (2 * Ip0c * Ip0d * (Tpd + Tach));

    setState(() {
      results = {
        'Ib': Ib.toStringAsFixed(2), 'Xc': Xc.toStringAsFixed(2), 'Xt': Xt.toStringAsFixed(2),
        'U_c_n': U_c_n.toStringAsFixed(2), 'Xl': Xl.toStringAsFixed(2), 'Xd': Xd.toStringAsFixed(2),
        'X_E_c': X_E_c.toStringAsFixed(2), 'X_E_d': X_E_d.toStringAsFixed(2), 'Ip0c': Ip0c.toStringAsFixed(2),
        'Ip0d': Ip0d.toStringAsFixed(2), 'Iptc': Iptc.toStringAsFixed(2), 'Iptd': Iptd.toStringAsFixed(2),
        'Iac': Iac.toStringAsFixed(2), 'Iad': Iad.toStringAsFixed(2), 'Iuds': Iuds.toStringAsFixed(2),
        'Iudd': Iudd.toStringAsFixed(2), 'Tach': Tach.toStringAsFixed(2), 'Tpd': Tpd.toStringAsFixed(2),
        'Tvidk': Tvidk.toStringAsFixed(2), 'Vk': Vk.toStringAsFixed(2),
      };
    });
  }
}
