# journal

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Run the App
To run the first create a [Supabase](https://supabase.io) project, and create a table `journal`,
with following columns:
1. title - text
2. description - text
3. images - array<string>

Now run the app with following command

```zsh
flutter run --dart-define=SupabaseURL=<your supabase url> --dart-define=SupabaseURL=<your supabase token>
```