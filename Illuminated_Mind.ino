#include <DmxSimple.h>

#include <Servo.h> //Die Servobibliothek wird aufgerufen. Sie wird benötigt, damit die Ansteuerung des Servos vereinfacht wird.
Servo servoblau; //Erstellt für das Programm einen Servo mit dem Namen „servoblau“

#define BTSerial Serial1
#define BAUD 115200

String Eingabe;
String Art, Colour;
int r, g, b, rpos, gpos, bpos;
int Licht, FTon;
int Feedback[5];
int allChannels = 13;
int pos[13];
int blinkt[4] = {0, 0, 0, 0};
int nextone;
int k = 1;
int m = 200;
int o = 200;
int n = 200;
int q = 250;
bool a = true;
int s = 110; //Servo Ausgangspunkt
float p;

//FUNKTIONEN:

int Position(int pos) {
  //Gibt die Kanäle von rgb in Bezug zum betrachteten Scheinwerfer zurück
  switch (pos) {
    case 1:
      rpos = 1;
      break;
    case 2:
      rpos = 4;
      break;
    case 3:
      rpos = 7;
      break;
    case 4:
      rpos = 10;
      break;
  }
  gpos = rpos + 1;
  bpos = rpos + 2;
  return rpos, gpos, bpos;
}

int Umwandlung(String Clr, int pos) {
  //Wandelt Farbnamen in rgb-Helligkeiten um und gibt zusätzlich die zugehörigen Kanäle zurück
  Position(pos);
  if (Clr.equals("rot")) {
    r = 200;
    g = 0;
    b = 0;
  }
  else if (Clr.equals("gruen")) {
    r = 130;
    g = 200;
    b = 0;

  }
  else if (Clr.equals("blau")) {
    r = 0;
    g = 0;
    b = 200;
  }
  else if (Clr.equals("gelb")) {
    r = 180;
    g = 200;
    b = 0;
  }
  else if (Clr.equals("lila")) {
    r = 154;
    g = 84;
    b = 200;
  }
  else if (Clr.equals("pink")) {
    r = 200;
    g = 150;
    b = 150;
  }
  else if (Clr.equals("weiss")) {
    r = 190;
    g = 230;
    b = 190;
  }
  return r, g, b;
}

String setFarbe(int Light, int Farbe) {
  // Ordnet Zahlen 1-6 Farbtönen zu und ruft "Umwandlung" auf,diese Werte werden in "pos" gespeichert, für Werte 7-9 erhält "blinkt" Werte 1-3. 
  if (Farbe == 1) {
    Colour = "rot";
    Umwandlung(Colour, Light);
  }
  if (Farbe == 2) {
    Colour = "gruen";
    Umwandlung(Colour, Light);
  }
  if (Farbe == 3) {
    Colour = "blau";
    Umwandlung(Colour, Light);
  }
  if (Farbe == 4) {
    Colour = "gelb";
    Umwandlung(Colour, Light);
  }
  if (Farbe == 5) {
    Colour = "lila";
    Umwandlung(Colour, Light);
  }
  if (Farbe == 6) {
    Colour = "pink";
    Umwandlung(Colour, Light);
  }
  //Feedback:
  if (Farbe == 7) {         //Farbe genau richtig

    blinkt[Light - 1] = 1;
    Colour = "genau richtig, immer heller";
  }
  if (Farbe == 8) {         //Farbe halb richtig

    blinkt[Light - 1] = 2;
    Colour = "halbrichtig, ich blinke";
  }
  if (Farbe == 9) {         //Farbe falsch

    blinkt[Light - 1] = 3;
    Colour = "falsch, immer dunkler";
  }
  pos[rpos - 1] = r;
  pos[gpos - 1] = g;
  pos[bpos - 1] = b;
  return Colour;
}

void setup() {
  servoblau.attach(8);
  servoblau.write(110);
  DmxSimple.usePin(3);  
  DmxSimple.maxChannel(allChannels);
  Serial.begin(BAUD);
  BTSerial.begin(BAUD);
  Serial.begin(BAUD);
}

void loop() {
  randomSeed(analogRead(0));
  
  for (int i = 1; i <= 4; i++) {
    //kontinuierliche Auswertung von "blinkt"
    if ((blinkt[i - 1] == 1) && (m <= 250)) {
      // "richtig", Licht wird heller
      Position(i);
      float f = m / 200.0;
      r = pos[rpos - 1];
      g = pos[gpos - 1];
      b = pos[bpos - 1];
      DmxSimple.write(rpos, (f * r));
      DmxSimple.write(gpos, (f * g));
      DmxSimple.write(bpos, (f * b));
      delay(30);
    }
    
    if (blinkt[i - 1] == 2) {
      // "Halbrichtig", Licht blinkt
      Position(i);
      if (k % 2 != 0) {
        DmxSimple.write(rpos, pos[rpos - 1]);
        DmxSimple.write(gpos, pos[gpos - 1]);
        DmxSimple.write(bpos, pos[bpos - 1]);
        delay(random(100, 150));
      }
      if (k % 2 == 0) {
        DmxSimple.write(rpos, 0);
        DmxSimple.write(gpos, 0);
        DmxSimple.write(bpos, 0);
        delay(random(30, 70));
      }
      DmxSimple.write(rpos, 0);
      DmxSimple.write(gpos, 0);
      DmxSimple.write(bpos, 0);


    }
    if ((blinkt[i - 1] == 3) && (n >= 0)) {
      // "falsch", Licht geht aus
      Position(i);
      float u = n / 200.0;
      DmxSimple.write(rpos, u * pos[rpos - 1]);
      DmxSimple.write(gpos, u * pos[gpos - 1]);
      DmxSimple.write(bpos, u * pos[bpos - 1]);
      delay(50);
    }
    
    if (blinkt[i - 1] == 4) {
      // "gewonnen"
      Position(i);
      if (o <= 250) {
        // Erhöhung der Helligkeit aller Scheinwerfer, die zuvor noch nicht richtig waren
        p = o / 200.0;
        DmxSimple.write(rpos, p * pos[rpos - 1]);
        DmxSimple.write(gpos, p * pos[gpos - 1]);
        DmxSimple.write(bpos, p * pos[bpos - 1]);
        delay(30);
      }
      if (o > 250) {
        // Alle Scheinwerfer erhalten den Wert 4 in "blinkt" und "pulsieren", der Servo wird gedreht (Kiste öffnet sich)
        for (int l = 0; l <= 3; l++) {
          blinkt[l] = 4;
        }
        p = q / 200.0;
        DmxSimple.write(rpos, p * pos[rpos - 1]);
        DmxSimple.write(gpos, p * pos[gpos - 1]);
        DmxSimple.write(bpos, p * pos[bpos - 1]);
        if (s >= 15) {
          servoblau.write(s);
          s = s - 1;
        }
        delay(50);
      }
    }


  }

  if (BTSerial.available() > 0) {
    // eine Eingabe am BT-Modul wurde detektiert, alle Veränderlichen werden auf Ausgangszustand versetzt
    Eingabe = BTSerial.readString();
    BTSerial.println(Eingabe);
    DmxSimple.write(13, 0);
    m = 200;
    k = 0;
    n = 200;
    o = 200;
    q = 250;
    a = true;

    if ( s < 110) {
      for (int i = s; i <=110; i = i+1) {
        servoblau.write(i);
        delay(50);
      }
    }
    s = 110;
    for (int i = 0; i <= 3; i++) {      
      if (blinkt[i] == 3) {
        Position(i+1);
        DmxSimple.write(rpos, 0);
        DmxSimple.write(gpos, 0);
        DmxSimple.write(bpos, 0);
      }
    }
    for (int i = 0; i <= 3; i++) {
      blinkt[i] = 0;
    }


    if (Eingabe.charAt(0) == 's') {
      // Starteingabe
      if (Eingabe.charAt(1) == '0') {
        // alle Lichter weiß
        for (int i = 1; i <= 10; i = i + 3) {
          Umwandlung("weiss", i);
          DmxSimple.write(i, r);
          DmxSimple.write(i + 1, g);
          DmxSimple.write(i + 2, b);

        }
      }
      if (Eingabe.charAt(1) == '1') {
        // erster Scheinwerfer weiß, Rest aus
        Umwandlung("weiss", 1);
        DmxSimple.write(rpos, r);
        DmxSimple.write(gpos, g);
        DmxSimple.write(bpos, b);

        for (int i = 4; i <= 12; i++) {
          DmxSimple.write(i, 0);
        }
      }
    }
    
    if (Eingabe.charAt(0) == 'e') {
      // Farbeingabe 
      Licht = Eingabe.charAt(1) - '0'; //welcher Scheinwerfer
      FTon = Eingabe.charAt(2) - '0'; //welche Farbe
      nextone = Eingabe.charAt(3) - '0'; //welcher Scheinwerfer folgt als nächstes
      if (Licht != 0) {
        // Vor jeder neuen Runde wird ein String der Form e00x gesendet, mit x aus [1,4]. Dabei erfolgt keine Farbzuordnung sondern nur die Markierung des nächsten aktiven Scheinwerfers
        setFarbe(Licht, FTon);
        DmxSimple.write(rpos, r);
        DmxSimple.write(gpos, g);
        DmxSimple.write(bpos, b);
      }
      if (nextone <= 4) { // wenn >4 dann letzte Farbeingabe in der Runde, daher kein weißer Scheinwerfer als nächstes
        Umwandlung("weiss", nextone);
        DmxSimple.write(rpos, r);
        DmxSimple.write(gpos, g);
        DmxSimple.write(bpos, b);
      }
    }
    
    if (Eingabe.charAt(0) == 'f') {
      // Feedbackeingabe, "blinkt" wird mit Feedbackwerten belegt
      for (int i = 1; i <= 4; i++) {
        Feedback[i] = Eingabe.charAt(i) - '0';
        Art = setFarbe(i, Feedback[i]);
      }
    }
    
    if (Eingabe.charAt(0) == 'x') {
      // Spielende
      if (Eingabe.charAt(1) == 'g') {
        //Gewonnen
        m = 253;
        for (int i = 0; i <= 3; i++) {
          if (blinkt[i] != 1) {
            // alle Scheinwerfer, die vorher nicht richtig waren, bekommen die 4 zugeordnet
            blinkt[i] = 4;
          }
        }
        DmxSimple.write(13, 255);
      }
      if (Eingabe.charAt(1) == 'a') {
        // Abbruch, alles weiß
        for (int i = 1; i <= 10; i = i + 3) {
          Umwandlung("weiss", i);
          DmxSimple.write(i, r);
          DmxSimple.write(i + 1, g);
          DmxSimple.write(i + 2, b);
        }
      }
    }
  }
  if (m <= 250) {
    m = m + 4;
  }
  if (o <= 250) {
    o = o + 4;
  }

  k = k + 1;

  if (n >= 0) {
    n = n - 10;
  }
  if ((q >= 190) && (o > 250) && (a == true)) {
    q = q - 5;
    if (q == 190) {
      a = false;
    }
  }
  if ((q <= 250) && (o > 250) && (a == false)) {
    q = q + 5;
    if (q == 250) {
      a = true;
    }
  }
}
