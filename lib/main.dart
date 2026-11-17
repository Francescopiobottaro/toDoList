import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'ToDo List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Attivita> mieAttivita = [];

  int totale=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              child: Text('Attività svolte: $totale/${mieAttivita.length}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight(600),
                ),


              )
            ),
            if (mieAttivita.isEmpty)
              const Expanded(
              child: Center(
                child: Text(
                  "Nessuna attività presente.\nClicca 'Aggiungi attività' per iniziare!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),


            Expanded(

              child: ListView.builder(
                  itemCount: mieAttivita.length,
                  itemBuilder: (context, indice) {
                    Attivita attivitaCorrente = mieAttivita[indice];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if(attivitaCorrente.importante) Icon(Icons.warning_amber_sharp, color: Colors.red),
                            const SizedBox(width: 15),

                            ElevatedButton(
                                onPressed: () {

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: const Text('Elimina attività'),
                                        content: const Text('Sei sicuro di voler eliminare questa attività?'),
                                        actions: [


                                          TextButton(
                                            onPressed: () {
                                              // chiude solo il pop-up
                                              Navigator.pop(dialogContext);
                                            },
                                            child: const Text('Annulla'),
                                          ),


                                          TextButton(
                                            onPressed: () {

                                              setState(() {
                                                if (attivitaCorrente.completata) {
                                                  totale--;
                                                }
                                                mieAttivita.remove(attivitaCorrente);
                                              });


                                              Navigator.pop(dialogContext);
                                            },
                                            child: Text('Elimina'),
                                          ),

                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(Icons.delete)
                            )
                          ],



                        ),
                        leading: Checkbox(
                          value: attivitaCorrente.completata,
                          onChanged: (valore) {
                            setState(() {
                              attivitaCorrente.completata = valore ?? false;
                              attivitaCorrente.completata ? totale++ : totale--;
                            });
                          },
                        ),
                        title: Text(
                          attivitaCorrente.titolo,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight(400),
                            decoration: attivitaCorrente.completata ? TextDecoration.lineThrough : null,
                            color: attivitaCorrente.completata ? Colors.grey : Colors.black,
                          ),
                        ),

                      ),
                    );
                  }),
            ),

            // 2. DOPO mettiamo il bottone, così finisce in basso
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 8.0), // Spazio per non attaccarlo al bordo
              child: ElevatedButton(
                onPressed: () async {
                  final nuovaAttivita = await Navigator.push<Attivita>(
                    context,
                    MaterialPageRoute(builder: (_) => const newPage()),
                  );

                  if (nuovaAttivita != null) {
                    setState(() {
                      mieAttivita.add(nuovaAttivita);
                    });
                  }
                },
                child: const Text('Aggiungi attività'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class Attivita {
  String titolo;
  bool importante;
  bool completata;

  Attivita({
    required this.titolo,
    this.importante = false,
    this.completata = false,
  });
}


class newPage extends StatefulWidget {
  const newPage({super.key});

  @override
  State<newPage> createState() => _newPageState();
}

class _newPageState extends State<newPage> {
  String titolo = '';
  bool importante = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Crea attività')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            onChanged: (testoDigitato) {
              setState(() {
                titolo = testoDigitato;
              });
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Attività importante: ', style: TextStyle(fontSize: 18)),
              Switch(
                value: importante,
                onChanged: (valore) {
                  setState(() {
                    importante = valore;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(

            onPressed: () {
              if (titolo.trim().isEmpty) {
                // Mostriamo l'errore
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Errore: inserisci un nome per l\'attività!')),
                );

                // Il return blocca tutto: non salva e non torna indietro
                return;
              }

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Salvato!')));

              // Creiamo l'attività ma non tocchiamo più la lista
              Attivita nuovaAttivita = Attivita(
                titolo: titolo,
                importante: importante,
              );

              // Rimandiamo l'attività alla pagina precedente usando pop!
              Navigator.pop(context, nuovaAttivita);


            },
            child: const Text('Crea attività'),



          ),
        ],
      ),
    ),
  );
}