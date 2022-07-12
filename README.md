# Smareci

<p float="left">
  <img src="https://user-images.githubusercontent.com/37705192/178480252-e82f3e67-b7ab-4ce7-8d7b-d45f3ee5dc2d.png" width="200" />
  <img src="https://user-images.githubusercontent.com/37705192/178480659-ad0b3fca-ecb4-44e9-ae2c-1085e449b4be.png" width="200" /> 
  <img src="https://user-images.githubusercontent.com/37705192/178483601-03ac1596-ee9a-48a2-94b0-4bf582749536.png" width="200" />
  <img src="https://user-images.githubusercontent.com/37705192/178483714-ac590613-f52e-458b-9ddb-6a0fde031e44.png"
  width=200/>
</p>

------------

## Descrierea aplicației

**Smareci** este o aplicație care face mai ușoară reciclarea pentru locuitori si ajută municipalitatea să fie la curent cu gradul de ocupare al punctelor de colectare. Astfel, utilizatorii au acces la o hartă cu toate punctele de reciclare disponibile în oraș (momentan în aplicație sunt puncte doar în București). 

Aceștia pot selecta un marker de pe hartă pentru a vedea gradul de ocupare al punctului de reciclare. În cazul în care un utilizator dorește să recicleze, continuă procesul prin apăsarea butonului "**Vreau să reciclez!**".  Obiectele sunt adăugate spre reciclare fie manual, prin selectarea materialului si volumului corespunzător, fie pe baza scanării codului de bare de pe obiect, detaliile menționate fiind obținute dintr-o interogare a bazei de date. La apăsarea butonului "**Reciclează acum!**",  este actualizat în baza de date gradul de ocupare al punctului, iar utilizatorul este redirecționat în Google Maps/Apple Maps pentru a putea ajunge la punctul la care dorește să recicleze obiectele selectate.

Aplicația este utilă si municipalității, deoarece face mai ușoară gestionarea punctelor de colectare (adăugare pe hartă a unui loc de reciclare, verificarea ocupării punctelor de reciclare pentru a putea colecta deșeurile).

## Instrucțiuni pentru compilarea codului
1.  Instalați [Flutter](https://flutter.dev/setup "Flutter")
2. Clonați repository-ul Smareci
3. În folderul local Smareci, rulați comenzile:

	`flutter pub get`

	`flutter build apk`

	APK-ul aplicației se va afla în `build/app/outputs/flutter-apk/app-release.apk`.

	**Atenție!**
	Pentru construirea aplicației, este nevoie de o cheie API pentru Google Maps care se poate obține pe [Google Cloud](https://cloud.google.com). Cheia trebuie salvată într-un fișier numit `android/local.properties` cu denumirea `GMAPS_KEY`. Cheia API este astfel protejată de a fi divulgată în repository-ul public, deoarece fișierul `local.properties` este adăugat în `android/.gitignore`.

## Librării utilizate
Pentru construirea aplicației, am folosit librăriile:
> - [google_maps_flutter](https://pub.dev/packages/google_maps_flutter "google_maps_flutter")
> - [percent_indicator](https://pub.dev/packages/percent_indicator "percent_indicator")
> - [url_launcher](https://pub.dev/packages/url_launcher "url_launcher")
> - [appwrite](https://pub.dev/packages/appwrite "appwrite")
>- [flutter_barcode_scanner](https://pub.dev/packages/flutter_barcode_scanner)

[Appwrite](https://appwrite.io "Appwrite") este un container Docker care ajută la implementarea unei baze de date optimizate în aplicații scrise în [Dart](https://dart.dev "Dart").

