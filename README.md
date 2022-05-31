# Smareci
**Smareci** este o aplicație care face mai ușoară reciclarea pentru cetățeni si ajută municipalitatea să 
fie la curent cu gradul de ocupare al punctelor de colectare.

## Librării utilizate
Pentru construirea aplicației, am folosit librăriile:
> - [google_maps_flutter](https://pub.dev/packages/google_maps_flutter "google_maps_flutter")
> - [percent_indicator](https://pub.dev/packages/percent_indicator "percent_indicator")
> - [url_launcher](https://pub.dev/packages/url_launcher "url_launcher")
> - [appwrite](https://pub.dev/packages/appwrite "appwrite")

Appwrite este un pachet Docker care ajută la implementarea unei baze de date în aplicații scrise în Dart.

**Atentie!**
Pentru construirea aplicatiei, este nevoie de o cheie API pentru Google Maps care se poate obtine pe [Google Cloud](https://cloud.google.com). Cheia trebuie salvata intr-un fisier numit `android/local.properties` cu denumirea `GMAPS_KEY`. Cheia API este astfel protejata de a fi divulgata in repository-ul public, deoarece fisierul `local.properties` este adaugat in `android/.gitignore`.
