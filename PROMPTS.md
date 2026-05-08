# AI Prompt Log

## Entry #1: Establish the AI Log
**Prompt:**
System Mandate: You are my expert Flutter Developer agent. We are going to build an offline-first movie discovery app called Match&Watch.

Task 0: Establish the AI Log
Before we write a single line of code, configure our project structure, or touch any checklists, I need you to create a file named PROMPTS.md in the root of the project.

Your Ongoing Strict Rule: From this exact moment forward, every time I give you a prompt, you must silently append it to PROMPTS.md before executing the task. You must include the prompt text and a 1-2 sentence explanation of the context/why it was asked.

Immediate Action: Create the PROMPTS.md file now. Add a title # AI Prompt Log. Then, log this exact prompt as Entry #1. Do not install packages, do not create folder structures, and do not write any Flutter code yet. Simply create the file, log this prompt, and confirm when you are finished.

**Context:**
This prompt establishes the ground rules for the project's documentation and logs the initial setup instruction for the AI Log system to ensure all future interactions are documented.

## Entry #2: Core Dependencies, Folder Structure, & Local Theming
**Prompt:**
Task 1: Core Dependencies, Folder Structure, & Local Theming

Log this first: Please log this prompt into PROMPTS.md as Entry #2. Context: "Setting up the project's foundational dependencies, clean architecture folder structure, and Material 3 design system using local fonts."

Action 1: Dependencies
Please update my pubspec.yaml with the following packages required for our architecture:

State Management: flutter_bloc and equatable

Network: dio

Local DB: drift, sqlite3_flutter_libs, path_provider, path (and drift_dev, build_runner under dev_dependencies)

Background Sync: workmanager

Navigation: go_router

UI/Design: cached_network_image, shimmer (for the required loading states)

Action 2: Folder Structure & Asset Declaration

Create a clean, feature-based folder structure inside /lib: /lib/core (for theme, router, network client, database setup), /lib/features/users, /lib/features/movies, and /lib/features/sync.

Update pubspec.yaml to declare my image assets folder: assets/images/

Update pubspec.yaml to declare my local fonts. I have placed Poppins .ttf files in assets/fonts/. Please set up the fonts section in pubspec for the 'Poppins' family, mapping the Regular, Medium, SemiBold, and Bold weights appropriately.

Action 3: The Theme
Create a file at /lib/core/theme/app_theme.dart. Implement a Material 3 dark theme (perfect for a cinematic movie app). Define a primary color (e.g., a vibrant accent color like Teal or Amber against dark backgrounds). Most importantly, set the fontFamily of the entire ThemeData to 'Poppins' so it uses my newly declared local font.

Please execute these steps and confirm when complete.

**Context:**
Setting up the project's foundational dependencies, clean architecture folder structure, and Material 3 design system using local fonts.

## Entry #3: Implement the "Cinematic Gold" Material 3 Theme
**Prompt:**
Task 2: Implement the "Cinematic Gold" Material 3 Theme

Log this first: Please log this prompt into PROMPTS.md as Entry #3. Context: "Implementing the centralized Material 3 'Cinematic Gold' dark theme and applying the local Poppins font family."

Action: > I need you to create a comprehensive theme configuration file at /lib/core/theme/app_theme.dart. We are building a premium, modern movie app, so we need a highly polished Dark Mode theme.

Please implement an AppTheme class with a static darkTheme getter that returns a ThemeData object meeting these exact specifications:

Color Scheme (Material 3):

brightness: Brightness.dark

primary / secondary / tertiary: Use a rich, vibrant "Cinematic Gold" or Amber (e.g., Color(0xFFFFC107) or similar).

background / scaffoldBackgroundColor: A deep, premium charcoal or near-black (e.g., Color(0xFF121212)).

surface: A slightly lighter dark grey for movie cards and bottom sheets (e.g., Color(0xFF1E1E1E)).

onPrimary: Black or very dark grey (for text inside gold buttons).

onBackground / onSurface: White or very light grey (for standard text).

Typography:

Set the global fontFamily to 'Poppins' (which we configured in pubspec.yaml).

Ensure headers are bold and clear, while body text is highly legible for movie descriptions.

Component Themes:

CardTheme: Rounded corners (e.g., radius 12 or 16), slight elevation, using the surface color.

ElevatedButtonTheme: Pill-shaped (StadiumBorder) or rounded rectangles, using the Gold primary color.

AppBarTheme: Transparent or matching the scaffold background, no elevation, center title.

Please generate the complete app_theme.dart file. Once done, let me know so I can apply it to my MaterialApp widget in main.dart.

**Context:**
Implementing the centralized Material 3 'Cinematic Gold' dark theme and applying the local Poppins font family.

## Entry #4: Drift Database Schema & Offline-First Setup
**Prompt:**
Task 3: Drift Database Schema & Offline-First Setup

Log this first: Please log this prompt into PROMPTS.md as Entry #4. Context: "Designing the Drift database schema to support offline-first data, including Users, Movies, and a junction table for Saved Movies."

Action: > I need you to set up our local SQLite database using drift. Please create the necessary files in /lib/core/database/.

We need three tables defined to perfectly match our assignment requirements:

Users Table:

id: Int (Local primary key, auto-increment).

serverId: Int (Nullable. This will store the Reqres API ID. It's null if created offline).

firstName: Text

lastName: Text

avatar: Text (Nullable)

movieTaste: Text (Maps to the "job" field in Reqres API).

pendingSync: Boolean (Defaults to false. True if created offline and waiting for WorkManager).

Movies Table:

id: Int (Primary key. We will use the TMDB/OMDB movie ID here).

title: Text

posterPath: Text (Nullable)

releaseYear: Text (Nullable)

overview: Text (Nullable)

SavedMovies Table (Junction Table for many-to-many):

userId: Int (References Users.id)

movieId: Int (References Movies.id)

createdAt: DateTime (To sort recently saved movies)

Make the combination of userId and movieId the primary key to prevent duplicate saves.

Please write the Drift table classes, the @DriftDatabase annotation setup, and provide the command I need to run in my terminal (e.g., dart run build_runner build) to generate the database code. Confirm when ready.

**Context:**
Designing the Drift database schema to support offline-first data, including Users, Movies, and a junction table for Saved Movies.

## Entry #5: Robust API Layer with Dio & Interceptors
**Prompt:**
Task 4: Robust API Layer with Dio & Interceptors

Log this first: Please log this prompt into PROMPTS.md as Entry #5. Context: "Building the Dio network client, including API services for Reqres and TMDB, and a custom interceptor to simulate the required 30% network failure and auto-retry logic."

Action 1: The Dio Client & Interceptors
Please create a core network client at /lib/core/network/api_client.dart using the dio package.
Crucially, I need you to implement two specific interceptors:

Failure Simulator Interceptor: Based on the assignment requirements, create an interceptor that randomly fails 30% of all outgoing requests to simulate a bad connection.

Retry Interceptor: Implement a retry mechanism that catches these (and any other) network failures and automatically retries the request with a slight exponential backoff.

Action 2: API Services
Create two service classes to handle our specific endpoints:

/lib/core/network/reqres_service.dart: Needs a method to GET users with pagination (https://reqres.in/api/users?page={page}) and POST a new user (https://reqres.in/api/users).

/lib/core/network/tmdb_service.dart: Needs a method to GET trending movies with pagination (https://api.themoviedb.org/3/trending/movie/day?language=en-US&page={page}&api_key={key}) and GET movie details (https://api.themoviedb.org/3/movie/{movie_id}?api_key={key}).

Note: For the TMDB service, set it up to accept the API key via an environment variable or a constants file, but use a placeholder for now.

Please write these files and confirm when complete. Do not hook them up to the UI yet.

**Context:**
Building the Dio network client, including API services for Reqres and TMDB, and a custom interceptor to simulate the required 30% network failure and auto-retry logic.

## Entry #6: Repositories & State Management (Bloc)
**Prompt:**
Task 5: Repositories & State Management (Bloc)

Log this first: Please log this prompt into PROMPTS.md as Entry #6. Context: "Building the Repository pattern to act as the single source of truth, and setting up BLoCs/Cubits to expose database streams to the UI."

Action 1: Repositories
Create two repositories in /lib/core/repositories/:

UserRepository:

Needs a method to fetch users from the ReqresService, save them into the Drift database, and return a Stream of users directly from the database.

Needs a method to create a new user. If offline, it saves to Drift with pendingSync = true. If online, it sends to the API and saves to Drift.

MovieRepository:

Needs a method to fetch trending movies from TmdbService, save them to Drift, and return a Stream of movies from Drift.

Needs a method to toggle a movie's "saved" status for a specific user in the SavedMovies junction table.

Action 2: State Management (Bloc/Cubit)
Create the state management for our main features:

In /lib/features/users/bloc/: Create a UserCubit (or Bloc) that listens to the UserRepository's user stream. It should emit loading states, loaded states (with the list of users), and error states.

In /lib/features/movies/bloc/: Create a MovieCubit (or Bloc) that listens to the MovieRepository's trending movies stream. It should also have a method to trigger the "save/unsave" action.

Please generate these classes. Ensure they are structured cleanly and handle offline scenarios gracefully (e.g., if the API fetch fails, the repository should catch the error but the Stream from the database should still emit whatever is locally available). Confirm when complete.

**Context:**
Building the Repository pattern to act as the single source of truth, and setting up BLoCs/Cubits to expose database streams to the UI.

## Entry #7: Background Sync (WorkManager) & App Initialization
**Prompt:**
Task 6: Background Sync (WorkManager) & App Initialization

Log this first: Please log this prompt into PROMPTS.md as Entry #7. Context: "Implementing the WorkManager background task to sync offline-created users to the server, and setting up the app icon and splash screen packages."

Action 1: WorkManager Background Task
In /lib/features/sync/, create a file called sync_manager.dart. I need you to implement the WorkManager callback dispatcher.
The background task should do the following:

Query the UserRepository (or directly via the Drift database) for any users where pendingSync == true.

For each pending user, attempt to POST them to the Reqres API via our ReqresService.

If successful, update that user's record in the Drift database with the new serverId returned from the API, and set pendingSync = false.

Handle errors gracefully (if the network is still down, the task should fail so WorkManager knows to retry it later).

Action 2: Initialize in Main
Update main.dart to initialize WorkManager, register the background task, and ensure our Drift database and Dio client are initialized before runApp is called.

Action 3: Polish Packages
Please add flutter_launcher_icons and flutter_native_splash to the dev_dependencies in pubspec.yaml. Create the base configuration for both in pubspec.yaml (or their respective config files) using our "Cinematic Gold" dark background color (#121212). Use a placeholder image path like assets/images/logo.png for now.

Please generate these files and confirm when complete.

**Context:**
Implementing the WorkManager background task to sync offline-created users to the server, and setting up the app icon and splash screen packages.

## Entry #8: UI - Users Page, Add User Form, & Routing
**Prompt:**
Task 7: UI - Users Page, Add User Form, & Routing

Log this first: Please log this prompt into PROMPTS.md as Entry #8. Context: "Building the initial UI screens (Users Page and Add User Form) using the Cinematic Gold theme, integrating the UserBloc, and setting up GoRouter."

Action 1: App Router
In /lib/core/router/app_router.dart, configure GoRouter.

Create a route for / that points to UsersPage.

Create a route for /add_user that points to AddUserPage.
(We will add the other routes later, just set up the shell for now).

Action 2: Users Page (Page 01)
In /lib/features/users/presentation/users_page.dart, build the main screen.

AppBar: Include a title and an action icon button for "Matches" (just make it print a debug log for now).

Body: Use a BlocBuilder to listen to our UserCubit.

Loading State: If the state is loading, display a Shimmer placeholder list (do NOT use a basic CircularProgressIndicator).

Loaded State: Display a ListView.builder. Each item should be a Card showing the user's avatar (using CachedNetworkImage with a fade-in), First/Last name, and their saved movie count.

Pagination: Implement a scroll controller to fetch the next page when the user reaches the bottom.

FAB: Add a FloatingActionButton using our Primary Gold color that navigates to /add_user.

Action 3: Add User Page (Page 02)
In /lib/features/users/presentation/add_user_page.dart, build the form.

Add two TextFormFields: Name and Movie Taste.

Add a submit button. When pressed, call the createUser method on the UserCubit.

Crucial UI Requirement: Once the save is complete (or if offline, immediately after local DB save), show a SnackBar at the bottom saying "User added successfully", then pop the screen to return to the Users list. Do NOT use blocking dialogs.

Please generate these files, apply the app_theme.dart styles, and confirm when complete.

**Context:**
Building the initial UI screens (Users Page and Add User Form) using the Cinematic Gold theme, integrating the UserBloc, and setting up GoRouter.

## Entry #9: OMDB Integration, Movies Page, & Detail Page
**Prompt:**
Task 8: OMDB Integration, Movies Page, & Detail Page

Log this first: Please log this prompt into PROMPTS.md as Entry #9. Context: "Pivoting the API layer from TMDB to OMDB due to API availability, and building the Movies Page and Movie Detail Page UIs."

Action 1: Swap TMDB for OMDB
We are using OMDB instead of TMDB. Please update our network layer:

Create/Update OmdbService in /lib/core/network/.

Add a method to fetch a list of movies: GET https://www.omdbapi.com/?s={query}&page={page}&apikey={YOUR_KEY}. Since OMDB requires a search term, please hardcode a default query like "Batman" or "Marvel" for the main feed.

Add a method to fetch details: GET https://www.omdbapi.com/?i={imdbId}&apikey={YOUR_KEY}.

Update MovieRepository to use OmdbService. Ensure that data fetched from OMDB is mapped correctly to our Drift Movies table.

Action 2: Movies Page (Page 03)
In /lib/features/movies/presentation/movies_page.dart:

Body: A paginated list of movies. Use a Shimmer effect while loading.

Movie Card: Show the poster (using CachedNetworkImage), title, and release year.

Save Button & Badge: Add a button to save/unsave the movie for the currently active user. Include a live badge showing how many total users have saved this movie (read from the local DB stream).

Navigation: Tapping the card (not the save button) should navigate to the Movie Detail page using a Hero animation for the poster.

Action 3: Movie Detail Page (Page 04)
In /lib/features/movies/presentation/movie_detail_page.dart:

Show the large poster (Hero destination), title, release date, and plot description.

Show the Save/Unsave button.

Below the details, show a section: "X users want to watch this" along with small avatars of the users who saved it. If 0, show "Be the first to save this."

Action 4: Routing
Update app_router.dart to include /movies and /movie/:id.

Please generate these updates and confirm when complete. Let me know where I should paste my OMDB API key in the code.

**Context:**
Pivoting the API layer from TMDB to OMDB due to API availability, and building the Movies Page and Movie Detail Page UIs.

## Entry #10: Saved Movies Page & Matches Page (The Final UI)
**Prompt:**
Task 9: Saved Movies Page & Matches Page (The Final UI)

Log this first: Please log this prompt into PROMPTS.md as Entry #10. Context: "Building the final UI screens—User's Saved Movies and the Matches Page—relying entirely on local database streams for offline support and real-time updates."

Action 1: User's Saved Movies (Page 05)
In /lib/features/users/presentation/saved_movies_page.dart:

Header: Show the active user's profile photo, name, and Movie Taste note.

Body: Listen to a stream from the database that joins SavedMovies and Movies for this specific user.

List: Display their saved movies (poster and title). Allow the user to unsave directly from this page.

Empty State: If they have no saved movies, show a friendly empty state prompting them to browse.

Action 2: The Matches Page (Page 06)
In /lib/features/movies/presentation/matches_page.dart:

Body: Listen to a stream from the database that calculates movies saved by 2 or more users.

List Requirements: Sort from most saves to least. Show the poster, title, save count, and small profile photos (avatars) of the users who saved it.

Top Pick Logic: If a movie has been saved by all currently available users, highlight it visually (e.g., a gold border or a "Group Pick!" badge).

Empty State: If there are no matches, show an explanation of how matching works.

Action 3: Routing & Connections

Update app_router.dart with routes for /saved_movies and /matches.

Update the MoviesPage AppBar to include an action button navigating to /saved_movies.

Update the UsersPage (and anywhere else needed) so the "Matches" button navigates to /matches.

Please generate these pages, apply our 'Cinematic Gold' theme, and confirm when complete.

**Context:**
Building the final UI screens—User's Saved Movies and the Matches Page—relying entirely on local database streams for offline support and real-time updates.
