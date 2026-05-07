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
