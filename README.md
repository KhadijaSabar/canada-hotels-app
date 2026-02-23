# CanadaHotels - Application Mobile Flutter

Application mobile de réservation d'hôtels de luxe pour la chaîne CanadaHotels, présente dans les principales villes canadiennes.

## Aperçu

CanadaHotels est une application Flutter complète permettant aux utilisateurs de parcourir, rechercher et réserver des chambres dans 5 hôtels de luxe à travers le Canada. L'application communique avec un backend Node.js via une API REST sécurisée par JWT.

## Hôtels disponibles

| Hôtel | Ville | Étoiles | Prix à partir de |
|-------|-------|---------|-----------------|
| CanadaHotels Montreal Signature | Montréal, QC | 5 | $220/nuit |
| CanadaHotels Vancouver Harbour | Vancouver, BC | 5 | $280/nuit |
| CanadaHotels Toronto Financial District | Toronto, ON | 4 | $310/nuit |
| CanadaHotels Quebec City Chateau | Québec, QC | 5 | $390/nuit |
| CanadaHotels Calgary Alpine | Calgary, AB | 4 | $240/nuit |

## Fonctionnalités

- Authentification complète (inscription, connexion, JWT)
- Liste des hôtels avec images, étoiles, localisation et prix
- Recherche en temps réel avec debounce
- Filtres par étoiles et prix maximum
- Détail hôtel avec galerie, description, commodités et chambres
- Réservation complète avec sélection de dates et nombre de voyageurs
- Vérification de disponibilité avant confirmation
- Calcul automatique du prix total
- Historique des réservations (à venir, passées, annulées)
- Annulation de réservation
- Profil utilisateur avec modification

## Stack technique

- **Framework:** Flutter 3.x (Dart)
- **State Management:** Provider
- **Navigation:** go_router
- **HTTP Client:** Dio
- **Stockage sécurisé:** flutter_secure_storage (token JWT)
- **Images:** cached_network_image
- **Loading:** shimmer
- **Dates:** intl, table_calendar

## Structure du projet

```
lib/
├── config/
│   ├── constants.dart      # Constantes et endpoints API
│   ├── router.dart         # Routes go_router
│   └── theme.dart          # Thème Material Design (rouge CanadaHotels)
├── models/
│   ├── user_model.dart     # Modèle utilisateur
│   ├── hotel_model.dart    # Modèles Hotel et Room
│   └── booking_model.dart  # Modèles Booking, BookingRoom, BookingHotel
├── services/
│   ├── api_service.dart    # Client Dio avec intercepteurs JWT
│   ├── auth_service.dart   # Authentification (login/register/profile)
│   ├── hotel_service.dart  # Hôtels (list/search/detail/destinations)
│   ├── booking_service.dart # Réservations (create/list/cancel/availability)
│   └── storage_service.dart # Stockage sécurisé token et user
├── providers/
│   ├── auth_provider.dart   # État authentification
│   ├── hotel_provider.dart  # État hôtels + filtres + recherche
│   └── booking_provider.dart # État réservations + formulaire
├── screens/
│   ├── auth/
│   │   ├── splash_screen.dart    # Écran de démarrage avec animation
│   │   ├── login_screen.dart     # Connexion
│   │   └── register_screen.dart  # Inscription
│   ├── home/
│   │   └── home_screen.dart      # Liste hôtels + recherche + filtres
│   ├── hotel/
│   │   └── hotel_detail_screen.dart  # Détail hôtel + chambres
│   ├── booking/
│   │   ├── booking_screen.dart          # Formulaire réservation
│   │   ├── booking_confirmation_screen.dart  # Confirmation
│   │   └── my_bookings_screen.dart      # Mes réservations
│   └── profile/
│       ├── profile_screen.dart    # Profil utilisateur
│       └── edit_profile_screen.dart  # Modifier profil
└── widgets/
    ├── primary_button.dart       # Bouton principal réutilisable
    ├── custom_text_field.dart    # Champ texte avec validation
    ├── hotel_card.dart           # Carte hôtel pour liste
    ├── room_card.dart            # Carte chambre avec bouton réservation
    ├── shimmer_card.dart         # Placeholder de chargement
    ├── star_rating.dart          # Affichage étoiles
    ├── date_range_selector.dart  # Sélection dates check-in/out
    ├── guest_counter.dart        # Compteur + - voyageurs
    └── filter_bottom_sheet.dart  # Bottom sheet filtres
```

## Palette de couleurs

| Variable | Valeur | Usage |
|----------|--------|-------|
| primaryRed | #D52B1E | Couleur principale (Canada) |
| deepRed | #AB1F14 | Hover et pressed |
| white | #FFFFFF | Fonds et texte sur rouge |
| offWhite | #F8F5F5 | Fond de l'application |
| darkGrey | #1A1A1A | Textes principaux |
| warmGrey | #8C8C8C | Textes secondaires |
| success | #2D8A4E | Statuts et confirmations |
| warning | #E08C00 | Alertes et pending |
| error | #D52B1E | Erreurs |


```
## Auteur

Khadija Sabar
- GitHub: [@KhadijaSabar](https://github.com/KhadijaSabar)
- Email: ksabar179@gmail.com
- LinkedIn: [khadija-sabar](https://linkedin.com/in/khadija-sabar)
