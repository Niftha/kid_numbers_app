# kids_numbers_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Learn numbers 1-10
A fun, interactive Flutter app designed to help children learn numbers from 1 to 10 through visual and auditory experiences.


## Features

## Interactive Number Cards: Colorful, engaging cards for numbers 1-10

## Number Detail Screen:
Large number display
Number word representation
Visual quantity representation (stars/icons)
Pronunciation audio playback


## Kid-Friendly UI:
Large, colorful buttons
Rounded shapes and smooth animations
Intuitive navigation

## Audio Pronunciations: Clear audio for each number

## Smooth Animations:
Screen transitions
Interactive button feedback
Number appearance animations

## Prerequisites
Flutter SDK 
VS Code with Flutter extensions
Android emulator or iOS/Android device

## Built With
Flutter - UI Toolkit
Dart - Programming Language
Audioplayers - Audio playback
Lottie - Animations

Learning Outcomes
This project demonstrates:

## Flutter UI development with responsive layouts
State management for interactive elements
Audio integration with Flutter
Animation implementation
Git branching strategy and version control
Kid-friendly design principles

## Development Process:

# Create new feature branch
git checkout -b feature/new-feature

# Work on feature → test → commit
git add .
git commit -m "Add new feature"

# Push and merge to dev
git push origin feature/new-feature
git checkout dev
git merge feature/new-feature
git push origin dev

# Final merge to main
git checkout main
git merge dev
git push origin main


lib/
├── models/
│   └── number_model.dart      
├── screens/
│   ├── home_screen.dart       
│   └── number_detail_screen.dart 
├── widgets/
│   └── number_card.dart       
└── main.dart               
assets/
├── audio/                     
└── images/        