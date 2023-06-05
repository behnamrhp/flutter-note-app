# My Notes

# Table of Contents

- [My Notes Project](#my-notes)
- [Overview](#overview)
- [Technologies](#technologies)
- [Folder Structuring](#folder-structuring)
- [Architecture](#architecture)
- [Git Working](#git-working-flow)
## Overview

`My Notes` is a project for practicing all of the basic features of a flutter app for ios and android phones.<br/>
in this project I've tried to make an app that it cover all of basic features that is needed in a flutter app such as:
- handling routing, UI logics and basic features of the flutter such as widget, dialogs, error handlings, overlay loading etc.
- handling state management through `bloc` and practice tools of bloc in different situation such as: BlocProvider,BlocConsumer, BlocBuilder, BlocListener
- `separating business logics` and library boundaries
- handling data and Streams in localy with `sqflite` and `firestore`
- authentication of a user (login, register, logout and forgot password) through `firebase`
- `CRUD` process of a feature for handling notes
- localization of the project for three languages: `en`, `sv`, `fa`
- sharing feature
- loading process handling

## Technologies

- flutter
- firebase
- sqflite
- bloc
- intl
- equatable
- flutter_launcher_icons


## Folder Structuring
```
.
└── lib/
    ├── constants
    ├── extensions
    ├── l10n
    ├── pages
    ├── services/
    │   ├── auth
    │   ├── cloud
    │   └── crud
    ├── utils/
    │   ├── dialogs
    │   └── helpers
    └── main.dart
```

## Architecture
as this project is a simple feature project and is for practicing basic features, I've tried to keep it simple and just separating our business logics in `services` folder from UI and UI logics.<br/>
in this project for separating the libraries codes from the main codes such as firebase codes we handled a boundary for this library with `strategy pattern` throug a abstract provider class that we handled this pattern in a service class that you can see it in [this file](./lib/services/auth/auth_service.dart)

## Git working flow
our git flow in this project is:
- `develop` branch for the staging, 
- `main` branch for main prod verison,
- `[task type]/[message]` branch for impelementing the tasks branch
  Example: <br/>
    ```feature/l10n```