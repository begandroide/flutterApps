# Template flutter

Estructura escalable de una aplicación para Flutter.

## Requisitos

- [ ] Login/registro de usuarios. Conectar con cuenta de Google o Facebook.
- [ ] Home

## Estructura del proyecto

```
flutter-app/
|- android
|- build
|- ios
|- lib
  |- main.dart
  |- routes.dart
  |- screens/ 
  |- util/
  |- widgets/
  |- data/
  |- services/
|- test
```
## Importante para conectar con Firebase

Dentro de un proyecto registro la aplicación: debo tener el package name 
y luego importar el google-services.json que da firebase.

Además para IOS y Android hay que agregar librerias, para android se debe incluir firebase
en ambos gradles del proyecto a nivel "app".
