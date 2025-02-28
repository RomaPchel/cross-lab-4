import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab4',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lab4'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Калькулятор 1'),
              Tab(text: 'Калькулятор 2'),
              Tab(text: 'Калькулятор 3'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CableCalculatorApp(),
            CurrentCalculatorApp(),
            Calculator3App(),
          ],
        ),
      ),
    );
  }
}

class CableCalculatorApp extends StatefulWidget {
  @override
  _CableCalculatorAppState createState() => _CableCalculatorAppState();
}

class _CableCalculatorAppState extends State<CableCalculatorApp> {
  TextEditingController unomController = TextEditingController(text: "10");
  TextEditingController ikController = TextEditingController(text: "2.5");
  TextEditingController tfController = TextEditingController(text: "2.5");
  TextEditingController potuzhnistTPController = TextEditingController(text: "2000");
  TextEditingController smController = TextEditingController(text: "1300");
  TextEditingController tmController = TextEditingController(text: "4000");
  TextEditingController ctController = TextEditingController(text: "92");
  String im = "";
  String impa = "";
  String sek = "";
  String sSmin = "";
  String conductorType = "Тип провідника";
  List<String> conductorTypeOptions = [
    "Неізольовані проводи та шини",
    "Кабелі з паперовою і проводи з гумовою та полівінілхлоридною ізоляцією з жилами",
    "Кабелі з гумовою та пластмасовою ізоляцією з жилами"
  ];
  String conductorMaterial = "Матеріал провідника";
  List<String> conductorMaterialOptions = [
    "мідні",
    "алюмінієві"
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 32),
            TextField(
              controller: unomController,
              decoration: InputDecoration(labelText: "Unom"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: ikController,
              decoration: InputDecoration(labelText: "Ik"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: tfController,
              decoration: InputDecoration(labelText: "Tf"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: potuzhnistTPController,
              decoration: InputDecoration(labelText: "Potuzhnist_TP"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: smController,
              decoration: InputDecoration(labelText: "Sm"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: tmController,
              decoration: InputDecoration(labelText: "Tm"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: conductorType == "Тип провідника" ? null : conductorType,
              hint: Text(conductorType),
              isExpanded: true,
              items: conductorTypeOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  conductorType = newValue!;
                });
              },
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: conductorMaterial == "Матеріал провідника" ? null : conductorMaterial,
              hint: Text(conductorMaterial),
              isExpanded: true,
              items: conductorMaterialOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  conductorMaterial = newValue!;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                double sm = double.tryParse(smController.text) ?? 0.0;
                double unom = double.tryParse(unomController.text) ?? 0.0;
                double tm = double.tryParse(tmController.text) ?? 0.0;
                double ik = double.tryParse(ikController.text) ?? 0.0;
                double _im = (sm / 2.0) / (sqrt(3.0) * unom);
                double _impa = 2 * _im;
                double jek = determineJek(conductorType, conductorMaterial, tm);
                double _sek = _im / jek;
                _im = double.parse(_im.toStringAsFixed(2));
                _impa = double.parse(_impa.toStringAsFixed(2));
                _sek = double.parse(_sek.toStringAsFixed(2));
                setState(() {
                  im = _im.toString();
                  impa = _impa.toString();
                  sek = _sek.toString();
                });
              },
              child: Text("Обчислити"),
            ),
            Text("Розрахунковий струм для нормального режиму: " + im, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Розрахунковий струм для післяаварійного режиму: " + impa, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Економічний переріз (S ек): " + sek, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            TextField(
              controller: ctController,
              decoration: InputDecoration(labelText: "Ct"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                double tf = double.tryParse(tfController.text) ?? 0.0;
                double ik = double.tryParse(ikController.text) ?? 0.0;
                double ct = double.tryParse(ctController.text) ?? 0.0;
                double _sSmin = (ik * 1000 * sqrt(tf)) / ct;
                _sSmin = double.parse(_sSmin.toStringAsFixed(2));
                setState(() {
                  sSmin = _sSmin.toString();
                });
              },
              child: Text("Обчислити переріз за термічною стійкістю до дії струмів КЗ"),
            ),
            SizedBox(height: 8),
            Text("Переріз за термічною стійкістю до дії струмів КЗ: " + sSmin, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class CurrentCalculatorApp extends StatefulWidget {
  @override
  _CurrentCalculatorAppState createState() => _CurrentCalculatorAppState();
}

class _CurrentCalculatorAppState extends State<CurrentCalculatorApp> {
  TextEditingController ucnController = TextEditingController(text: "10.5");
  TextEditingController skController = TextEditingController(text: "200");
  TextEditingController ukPercController = TextEditingController(text: "10.5");
  TextEditingController sNomTController = TextEditingController(text: "6.3");
  String xt = "";
  String xc = "";
  String xe = "";
  String ip0 = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 32),
            TextField(
              controller: ucnController,
              decoration: InputDecoration(labelText: "Ucn"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: skController,
              decoration: InputDecoration(labelText: "Sk"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: ukPercController,
              decoration: InputDecoration(labelText: "Uk_perc"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: sNomTController,
              decoration: InputDecoration(labelText: "S_nom_t"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                double _Ucn = double.tryParse(ucnController.text) ?? 0.0;
                double _Sk = double.tryParse(skController.text) ?? 0.0;
                double _Uk_perc = double.tryParse(ukPercController.text) ?? 0.0;
                double _S_nom_t = double.tryParse(sNomTController.text) ?? 0.0;
                double _Xc = double.parse((_Ucn * _Ucn / _Sk).toStringAsFixed(2));
                double _Xt = double.parse(((_Uk_perc / 100) * (_Ucn * _Ucn / _S_nom_t)).toStringAsFixed(2));
                double _Xe = _Xc + _Xt;
                double _Ip0 = double.parse((_Ucn / (sqrt(3) * _Xe)).toStringAsFixed(2));
                setState(() {
                  xt = _Xc.toString();
                  xc = _Xt.toString();
                  xe = _Xe.toString();
                  ip0 = _Ip0.toString();
                });
              },
              child: Text("Обчислити"),
            ),
            Text("Xc: " + xc, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Xt: " + xt, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Сумарний опір точки К1: " + xe, style: Theme.of(context).textTheme.bodyLarge),
            Text("Початкове діюче значення струму трифазного КЗ: " + ip0, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class Calculator3App extends StatefulWidget {
  @override
  _Calculator3AppState createState() => _Calculator3AppState();
}

class _Calculator3AppState extends State<Calculator3App> {
  TextEditingController sBController = TextEditingController(text: "1000");
  TextEditingController uBController = TextEditingController(text: "6.3");
  TextEditingController sKController = TextEditingController(text: "200");
  TextEditingController uKPercController = TextEditingController(text: "7.5");
  TextEditingController sNomTController = TextEditingController(text: "4");
  TextEditingController x0Controller = TextEditingController(text: "0.08");
  TextEditingController lController = TextEditingController(text: "0.3");
  TextEditingController xDpercController = TextEditingController(text: "23.8");
  TextEditingController sNomDController = TextEditingController(text: "1.94");
  TextEditingController ecController = TextEditingController(text: "1");
  TextEditingController edController = TextEditingController(text: "1.07");
  TextEditingController tController = TextEditingController(text: "0.065");
  TextEditingController ytController = TextEditingController(text: "0.71");
  TextEditingController tacController = TextEditingController(text: "0.03");
  TextEditingController tadController = TextEditingController(text: "0.037");
  TextEditingController tpzController = TextEditingController(text: "0.5");
  TextEditingController tpvController = TextEditingController(text: "0.1");
  String ib = "";
  String xc = "";
  String xt = "";
  String xl = "";
  String xd = "";
  String u_c_n = "";
  String xE_c = "";
  String xE_d = "";
  String ip0c = "";
  String ip0d = "";
  String iptc = "";
  String iptd = "";
  String iac = "";
  String iad = "";
  String iuds = "";
  String iudd = "";
  String tach = "";
  String tpd = "";
  String tvidk = "";
  String vk = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 8),
            TextField(
              controller: sBController,
              decoration: InputDecoration(labelText: "S_b"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: uBController,
              decoration: InputDecoration(labelText: "U_b"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: sKController,
              decoration: InputDecoration(labelText: "S_k"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: uKPercController,
              decoration: InputDecoration(labelText: "U_k_perc"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: sNomTController,
              decoration: InputDecoration(labelText: "S_nom_t"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: x0Controller,
              decoration: InputDecoration(labelText: "X0"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: lController,
              decoration: InputDecoration(labelText: "l"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: xDpercController,
              decoration: InputDecoration(labelText: "X_d_perc"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: sNomDController,
              decoration: InputDecoration(labelText: "S_nom_d"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: ecController,
              decoration: InputDecoration(labelText: "Ec"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: edController,
              decoration: InputDecoration(labelText: "Ed"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: tController,
              decoration: InputDecoration(labelText: "t"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: ytController,
              decoration: InputDecoration(labelText: "Yt"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: tacController,
              decoration: InputDecoration(labelText: "Tac"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: tadController,
              decoration: InputDecoration(labelText: "Tad"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: tpzController,
              decoration: InputDecoration(labelText: "Tpz"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            TextField(
              controller: tpvController,
              decoration: InputDecoration(labelText: "Tpv"),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                double _S_b = double.tryParse(sBController.text) ?? 0.0;
                double _U_b = double.tryParse(uBController.text) ?? 0.0;
                double _S_k = double.tryParse(sKController.text) ?? 0.0;
                double _U_k_perc = double.tryParse(uKPercController.text) ?? 0.0;
                double _S_nom_t = double.tryParse(sNomTController.text) ?? 0.0;
                double _X0 = double.tryParse(x0Controller.text) ?? 0.0;
                double _l = double.tryParse(lController.text) ?? 0.0;
                double _X_d_perc = double.tryParse(xDpercController.text) ?? 0.0;
                double _S_nom_d = double.tryParse(sNomDController.text) ?? 0.0;
                double _Ec = double.tryParse(ecController.text) ?? 0.0;
                double _Ed = double.tryParse(edController.text) ?? 0.0;
                double _t = double.tryParse(tController.text) ?? 0.0;
                double _Yt = double.tryParse(ytController.text) ?? 0.0;
                double _Tac = double.tryParse(tacController.text) ?? 0.0;
                double _Tad = double.tryParse(tadController.text) ?? 0.0;
                double _Tpz = double.tryParse(tpzController.text) ?? 0.0;
                double _Tpv = double.tryParse(tpvController.text) ?? 0.0;
                double _Ib = _S_b / (sqrt(3.0) * _U_b);
                double _Xc = _S_b / _S_k;
                double _Xt = _U_k_perc / 100 * _S_b / _S_nom_t;
                double _U_c_n = _U_b * _U_b;
                double _Xl = _X0 * _l * _S_b / _U_c_n;
                double _Xd = _X_d_perc / 100 * _S_b / _S_nom_d;
                double _X_E_c = _Xc + _Xt;
                double _X_E_d = _Xd + _Xl;
                double _Ip0c = _Ec / _X_E_c * _Ib;
                double _Ip0d = _Ed / _X_E_d * _Ib;
                double _Iptc = _Ip0c;
                double _Iptd = _Ip0d * _Yt;
                double _Iac = sqrt(2.0) * _Ip0c * exp(-_t / _Tac);
                double _Iad = sqrt(2.0) * _Ip0d * exp(-_t / _Tad);
                double _Iuds = sqrt(2.0) * _Ip0c * (1 + exp(-0.01 / _Tac));
                double _Iudd = sqrt(2.0) * _Ip0d * (1 + exp(-0.01 / _Tad));
                double _Tach = (_Tac * _Ip0c + _Tad * _Ip0d) / (_Ip0c + _Ip0d);
                double _Tpd = -_t / (log(_t));
                double _Tvidk = _Tpz + _Tpv;
                double _Vk = (_Ip0c * _Ip0c * (_Tvidk + _Tach)) + (_Ip0d * _Ip0d * (0.5 * _Tpd + _Tach)) + (2 * _Ip0c * _Ip0d * (_Tpd + _Tach));
                print("_Ib = $_Ib");
                print("_Xc = $_Xc");
                print("_Xt = $_Xt");
                print("_U_c_n = $_U_c_n");
                print("_Xl = $_Xl");
                print("_Xd = $_Xd");
                print("_X_E_c = $_X_E_c");
                print("_X_E_d = $_X_E_d");
                print("_Ip0c = $_Ip0c");
                print("_Ip0d = $_Ip0d");
                print("_Iptc = $_Iptc");
                print("_Iptd = $_Iptd");
                print("_Iac = $_Iac");
                print("_Iad = $_Iad");
                print("_Iuds = $_Iuds");
                print("_Iudd = $_Iudd");
                print("_Tach = $_Tach");
                print("_Tpd = $_Tpd");
                print("_Tvidk = $_Tvidk");
                print("_Vk = $_Vk");
                setState(() {
                  ib = roundToTwoDecimalString(_Ib);
                  xc = roundToTwoDecimalString(_Xc);
                  xt = roundToTwoDecimalString(_Xt);
                  u_c_n = roundToTwoDecimalString(_U_c_n);
                  xl = roundToTwoDecimalString(_Xl);
                  xd = roundToTwoDecimalString(_Xd);
                  xE_c = roundToTwoDecimalString(_X_E_c);
                  xE_d = roundToTwoDecimalString(_X_E_d);
                  ip0c = roundToTwoDecimalString(_Ip0c);
                  ip0d = roundToTwoDecimalString(_Ip0d);
                  iptc = roundToTwoDecimalString(_Iptc);
                  iptd = roundToTwoDecimalString(_Iptd);
                  iac = roundToTwoDecimalString(_Iac);
                  iad = roundToTwoDecimalString(_Iad);
                  iuds = roundToTwoDecimalString(_Iuds);
                  iudd = roundToTwoDecimalString(_Iudd);
                  tach = roundToTwoDecimalString(_Tach);
                  tpd = roundToTwoDecimalString(_Tpd);
                  tvidk = roundToTwoDecimalString(_Tvidk);
                  vk = roundToTwoDecimalString(_Vk);
                });
              },
              child: Text("Обчислити"),
            ),
            Text("Ib: " + ib, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Xc: " + xc, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Xt: " + xt, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("U_c_n: " + u_c_n, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Xl: " + xl, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Xd: " + xd, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("X_E_c: " + xE_c, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("X_E_d: " + xE_d, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Ip0c: " + ip0c, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Ip0d: " + ip0d, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Iptc: " + iptc, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Iptd: " + iptd, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Iac: " + iac, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Iad: " + iad, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Iuds: " + iuds, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Iudd: " + iudd, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Tach: " + tach, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Tpd: " + tpd, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Tvidk: " + tvidk, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("Vk: " + vk, style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
  String roundToTwoDecimalString(double value) {
    return ((value * 100).round() / 100.0).toStringAsFixed(2);
  }
}

double determineJek(String conductorType, String conductorMaterial, double tm) {
  Map<String, Map<String, List<RangeJek>>> jekValues = {
    "Неізольовані проводи та шини": {
      "мідні": [
        RangeJek(1000.0, 3000.0, 2.5),
        RangeJek(3000.0, 5000.0, 2.1),
        RangeJek(5000.0, double.infinity, 1.8)
      ],
      "алюмінієві": [
        RangeJek(1000.0, 3000.0, 1.3),
        RangeJek(3000.0, 5000.0, 1.1),
        RangeJek(5000.0, double.infinity, 1.0)
      ]
    },
    "Кабелі з паперовою і проводи з гумовою та полівінілхлоридною ізоляцією з жилами": {
      "мідні": [
        RangeJek(1000.0, 3000.0, 3.0),
        RangeJek(3000.0, 5000.0, 2.5),
        RangeJek(5000.0, double.infinity, 2.0)
      ],
      "алюмінієві": [
        RangeJek(1000.0, 3000.0, 1.6),
        RangeJek(3000.0, 5000.0, 1.4),
        RangeJek(5000.0, double.infinity, 1.2)
      ]
    },
    "Кабелі з гумовою та пластмасовою ізоляцією з жилами": {
      "мідні": [
        RangeJek(1000.0, 3000.0, 3.5),
        RangeJek(3000.0, 5000.0, 3.1),
        RangeJek(5000.0, double.infinity, 2.7)
      ],
      "алюмінієві": [
        RangeJek(1000.0, 3000.0, 1.9),
        RangeJek(3000.0, 5000.0, 1.7),
        RangeJek(5000.0, double.infinity, 1.6)
      ]
    }
  };
  List<RangeJek>? list = jekValues[conductorType]?[conductorMaterial];
  if (list != null) {
    for (var item in list) {
      if (tm >= item.min && tm < item.max) {
        return item.jek;
      }
    }
  }
  return 0.0;
}

class RangeJek {
  final double min;
  final double max;
  final double jek;
  RangeJek(this.min, this.max, this.jek);
}