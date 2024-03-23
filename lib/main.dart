import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MazonApp());
}

class MazonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mazon Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mazon Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mazon',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              child: Text('Jugar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayerRegistrationScreen()),
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Reglas del Juego'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RulesScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reglas del Juego'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reglas del Juego',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Numero de jugadores: El juego es para más de 2 jugadores.\n\n'
              'Componentes del juego: Se requiere un tarro y 2 dados.\n\n'
              'Objetivo: El objetivo del juego es ser el último jugador en pie.\n\n'
              'Desarrollo del juego:\n'
              '1. Los jugadores se sientan en un círculo, y el turno para tirar los dados se pasa en sentido contrario al horario.\n'
              '2. El jugador que tira los dados es el único que puede ver los resultados.\n'
              '3. Después de mirar los resultados, el jugador debe decir en voz alta un número basado en los dados que tiene o no tiene y se lo dice al jugador de su derecha.\n'
              '4. Si el jugador de la derecha confía en lo que dijo el jugador, debe tirar los dados y superar el número mencionado anteriormente o mentir diciendo un número más alto.\n'
              '5. Si el jugador de la derecha desconfía de lo que dijo el jugador, puede levantar el tarro.\n'
              '6. Si el jugador que levanta el tarro tiene el número que se mencionó, el jugador que mintió recibe una falta. Si no tiene el número, el jugador que levantó el tarro recibe una falta.\n'
              '7. Cada falta sumada corresponde a un fallo del jugador. Al acumular 5 faltas, un jugador es eliminado del juego.\n'
              '8. Si un jugador obtiene un "Mazon" (2-1) en su tirada, equivale a 2 faltas, tanto si mintió como si realmente tiene el "Mazon".\n'
              '9. Si un jugador afirma tener un "Mazon" y el otro jugador acepta creerle, el jugador que afirmó tenerlo debe tirar los dados a la vista de todos.\n'
              '10. Si el jugador que afirmó tener un "Mazon" realmente obtiene uno en su tirada, el primer jugador en tener el "Mazon" recibe las faltas acumuladas.\n\n'
              'Valores del "Mazon":\n'
              '- Números del 13 al 65 (excluyendo los pares y mazon).\n'
              '- Todos los pares.\n'
              '- "Mazon" (2-1).',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerRegistrationScreen extends StatefulWidget {
  @override
  _PlayerRegistrationScreenState createState() => _PlayerRegistrationScreenState();
}

class _PlayerRegistrationScreenState extends State<PlayerRegistrationScreen> {
  int playerCount = 2;
  List<String> playerNames = [];

  void registerPlayers() {
    if (playerNames.length == playerCount) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameScreen(playerNames: playerNames)),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Debes ingresar el nombre de cada jugador.'),
            actions: [
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Jugadores'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cantidad de Jugadores:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            DropdownButton<int>(
              value: playerCount,
              onChanged: (value) {
                setState(() {
                  playerCount = value!;
                });
              },
              items: [
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('2'),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text('3'),
                ),
                DropdownMenuItem<int>(
                  value: 4,
                  child: Text('4'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Nombres de los Jugadores:',
              style: TextStyle(fontSize: 18),
            ),
            for (int i = 0; i < playerCount; i++)
              TextField(
                decoration: InputDecoration(labelText: 'Jugador ${i + 1}'),
                onChanged: (value) {
                  setState(() {
                    if (i >= playerNames.length) {
                      playerNames.add(value);
                    } else {
                      playerNames[i] = value;
                    }
                  });
                },
              ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Registrarse'),
              onPressed: registerPlayers,
            ),
          ],
        ),
      ),
    );
  }
}



class GameScreen extends StatefulWidget {
  final List<String> playerNames;

  GameScreen({required this.playerNames});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Player> players = [];
  int currentPlayerIndex = 0;
  bool gameOver = false;
  int dice1 = 1;
  int dice2 = 1;
  int? claimDice1Value;
  int? claimDice2Value;
  bool throwRegistered = false;
  bool rollButtonEnabled = true;
  bool registerButtonEnabled = false;

  TextEditingController claimTextController = TextEditingController();

  bool get trustButtonEnabled =>
      claimDice1Value != null &&
      claimDice2Value != null &&
      throwRegistered &&
      !gameOver;

  bool get doubtButtonEnabled =>
      claimDice1Value != null &&
      claimDice2Value != null &&
      throwRegistered &&
      !gameOver;

  @override
  void initState() {
    super.initState();
    initializePlayers();
  }

  void initializePlayers() {
    for (String playerName in widget.playerNames) {
      players.add(Player(name: playerName));
    }
  }

  void rollDice() {
    setState(() {
      dice1 = Random().nextInt(6) + 1;
      dice2 = Random().nextInt(6) + 1;
      rollButtonEnabled = false;
      registerButtonEnabled = true;
      claimDice1Value = null;
      claimDice2Value = null;
    });
  }

  void registerThrow() {
    setState(() {
      throwRegistered = true;
      rollButtonEnabled = true;
      registerButtonEnabled = false;
      claimDice1Value = int.tryParse(claimTextController.text.substring(0, 1));
      claimDice2Value = int.tryParse(claimTextController.text.substring(1));
    });
  }

  void trustPlayer() {
    setState(() {
      throwRegistered = false;
      rollButtonEnabled = true;
      registerButtonEnabled = false;
      currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
      claimTextController.clear();
    });
  }

  void doubtPlayer() {
    setState(() {
      throwRegistered = false;
      rollButtonEnabled = true;
      registerButtonEnabled = false;
      int nextPlayerIndex = (currentPlayerIndex + 1) % players.length;
      bool claimMatch =
          claimDice1Value == dice1 && claimDice2Value == dice2;
      if (claimMatch) {
        players[nextPlayerIndex].faults++;
      } else {
        players[currentPlayerIndex].faults++;
      }
      currentPlayerIndex = nextPlayerIndex;
      claimTextController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juego'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Turno de ${players[currentPlayerIndex].name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (dice1 != null && dice2 != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dados:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Dado 1: $dice1',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Dado 2: $dice2',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Tirar Dados'),
              onPressed: rollButtonEnabled ? rollDice : null,
            ),
            SizedBox(height: 16),
            if (claimDice1Value == null ||
                claimDice2Value == null ||
                !throwRegistered)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingresar valor de la jugada:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: claimTextController,
                    decoration: InputDecoration(
                      labelText: 'Valor de la jugada',
                      errorText: claimTextController.text.length != 2
                          ? 'Ingrese solo 2 números'
                          : null,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    onChanged: (value) {
                      setState(() {
                        if (value.length == 2) {
                          registerButtonEnabled = true;
                          rollButtonEnabled = false;
                        } else {
                          registerButtonEnabled = false;
                          rollButtonEnabled = true;
                        }
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Registrar Tiro'),
                    onPressed: registerButtonEnabled ? registerThrow : null,
                  ),
                ],
              ),
            if (claimDice1Value != null &&
                claimDice2Value != null &&
                throwRegistered &&
                !gameOver)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Acciones:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    child: Text('Confíar'),
                    onPressed: trustButtonEnabled ? trustPlayer : null,
                  ),
                  ElevatedButton(
                    child: Text('Desconfíar'),
                    onPressed: doubtButtonEnabled ? doubtPlayer : null,
                  ),
                ],
              ),
            SizedBox(height: 16),
            Text(
              'Tabla de Puntuaciones:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            DataTable(
              columns: [
                DataColumn(label: Text('Jugador')),
                DataColumn(label: Text('Faltas')),
              ],
              rows: players.map((player) {
                return DataRow(cells: [
                  DataCell(Text(player.name)),
                  DataCell(Text(player.faults.toString())),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class Player {
  String name;
  int faults;

  Player({required this.name, this.faults = 0});
}