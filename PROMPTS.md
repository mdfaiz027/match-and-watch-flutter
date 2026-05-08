# AI Prompt Log

## Entry #1: Establish the AI Log
**Prompt:**
System Mandate: You are my expert Flutter Developer agent. We are going to build an offline-first movie discovery app called Match&Watch.

Before we write a single line of code, configure our project structure, or touch any checklists, I need you to create a file named PROMPTS.md in the root of the project.

Your Ongoing Strict Rule: From this exact moment forward, every time I give you a prompt, you must silently append it to PROMPTS.md before executing the task. You must include the prompt text and a 1-2 sentence explanation of the context/why it was asked.

Immediate Action: Create the PROMPTS.md file now. Add a title # AI Prompt Log. Then, log this exact prompt as Entry #1. Do not install packages, do not create folder structures, and do not write any Flutter code yet. Simply create the file, log this prompt, and confirm when you are finished.

**Context:**
This prompt establishes the ground rules for the project's documentation and logs the initial setup instruction for the AI Log system to ensure all future interactions are documented.

## Entry #2: Core Dependencies, Folder Structure, & Local Theming
**Prompt:**
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

## Entry #11: Fix Reqres Missing API Key Error
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #11. Context: "Fixing the Reqres 'missing_api_key' error by injecting the required 'x-api-key' header into the Dio client."

Action 1: Inject the Header
We are getting a rejected request from Reqres because we are missing the API key header.
Please update our network layer (either in /lib/core/network/api_client.dart or specifically in ReqresService, depending on how you structured it).

Add an Interceptor or update the BaseOptions for the Reqres Dio instance to automatically include the header: "x-api-key": "YOUR_REQRES_KEY".

Make sure to leave a clear comment or a constant variable so I know exactly where to paste my actual Reqres key.

Please generate the fix and confirm exactly which file I need to open to paste my key.

**Context:**
Fixing the Reqres 'missing_api_key' error by injecting the required 'x-api-key' header into the Dio client.

## Entry #12: Switch Back to TMDB API
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #12. Context: "Reverting the fallback API and fully integrating TMDB for trending movies and movie details, including the specific image prefixing required by TMDB."

Action 1: The TMDB Service
We have our TMDB API key. Please swap out OmdbService and replace it with TmdbService in /lib/core/network/.
* Add the Trending endpoint: GET https://api.themoviedb.org/3/trending/movie/day?language=en-US&page={page}&api_key={YOUR_KEY}.
* Add the Details endpoint: GET https://api.themoviedb.org/3/movie/{movie_id}?api_key={YOUR_KEY}.

Action 2: Update the Repository
Update MovieRepository to use TmdbService.
Remove the hardcoded "Batman" or "Marvel" search query we used for OMDB. We just want the pure trending feed now.
Ensure the JSON parsing maps TMDB's fields (title, release_date, overview, poster_path) correctly to our Drift Movies table.

Action 3: Fix the Image URLs
TMDB only returns the end path of an image (e.g., /something.jpg). Based on the assignment requirements, we need to construct the full URL.
Please update the UI (or a helper function in the model/repository) to prepend the base URLs:
* For the list cards (Movies Page, Matches Page, Saved Page), use: https://image.tmdb.org/t/p/w185{poster_path}.
* For the Hero image on the Movie Detail Page, use: https://image.tmdb.org/t/p/w500{poster_path}.

Please generate these changes and show me exactly where to paste my TMDB API key in the configuration.

**Context:**
Reverting the fallback API and fully integrating TMDB for trending movies and movie details, including the specific image prefixing required by TMDB.

## Entry #13: The Final UI Polish & Reconnection State
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #13. Context: "Implementing the final UI polish requirements from the assignment: Staggered list animations, animated count badges, and a non-blocking 'reconnecting...' UI bar."

Action 1: Staggered List Animations
Please add the flutter_staggered_animations package to pubspec.yaml.
Update the ListView.builder in both the UsersPage and MoviesPage. Wrap the generated cards in AnimationConfiguration.staggeredList with a FadeInAnimation and a slight SlideAnimation so the list items fade in one by one when the page loads, as required by the assignment specs.

Action 2: Animated Save Count Badge
On the MoviesPage and MatchesPage, wrap the integer inside the "Save Count" badge with an AnimatedSwitcher. When the number of users who saved the movie changes (read from the local DB stream), the number should smoothly animate (e.g., a scale or slide transition) rather than instantly snapping.

Action 3: "Reconnecting..." UI Bar
The assignment requires a small "reconnecting..." bar when the network fails and Dio is automatically retrying.

Please create a global connection state listener (e.g., a simple Cubit or ValueNotifier tied to our Dio Retry Interceptor).

Update the root MaterialApp (perhaps using the builder property) to overlay a small, non-blocking animated banner at the very top or bottom of the screen that says "Reconnecting..." whenever a retry is in progress. It should disappear when the network call succeeds.

Please implement these finishing touches and confirm when complete.

**Context:**
Implementing the final UI polish requirements from the assignment: Staggered list animations, animated count badges, and a non-blocking 'reconnecting...' UI bar.

## Entry #14: Page 1 Audit - Active User State & Dynamic Counts
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #14. Context: "Auditing Page 1 requirements to ensure dynamic saved movie counts are streamed from Drift, and establishing the 'Active User' state for navigation."

Action 1: Dynamic User Movie Count
The assignment requires the Users list to show how many movies each user has saved, and this must update in real time.

Please update UserRepository to stream a custom class (e.g., UserWithMovieCount) by joining the Users table with the SavedMovies table.

Ensure the UserCubit and UsersPage UI use this updated stream so the count badge on the user cards is accurate and reactive.

Action 2: The "Active User" Context
When a user is tapped on the UsersPage, the app needs to know they are the "Active User" for the subsequent MoviesPage and SavedMoviesPage.

Please implement a way to pass or store this context. You can either pass the User object/ID as an extra in GoRouter, OR create a simple ActiveUserCubit that holds the currently selected user.

Ensure the MovieCubit uses this active user context when the "Save" button is pressed on a movie.

Please implement these fixes and confirm when complete.

**Context:**
Auditing Page 1 requirements to ensure dynamic saved movie counts are streamed from Drift, and establishing the 'Active User' state for navigation.

## Entry #15: Page 2 Audit - Form Data Mapping & Offline Detection
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #15. Context: "Auditing Page 2 requirements to ensure correct data mapping between the UI, local DB, and Reqres API, and tightening the offline detection logic."

Action 1: Form Data Mapping (Name & Job)
The AddUserPage form has a single "Name" field, but our Users table expects firstName and lastName, and the Reqres API expects "name" and "job".

In UserRepository.createUser, please ensure the single "Name" string is safely split by space (e.g., first word is firstName, the rest is lastName) before saving to Drift.

Ensure the Dio POST request body correctly maps: {"name": fullName, "job": movieTaste}.

Action 2: Robust Offline Detection
To properly satisfy the offline requirement, the createUser method must reliably know when the device is actually offline to trigger the pendingSync = true local save.

Please ensure the repository wraps the API call in a try/catch that specifically checks for connection-related DioException types (like connectionTimeout, receiveTimeout, sendTimeout, or connectionError).

Only if it is a genuine connection error should it default to the offline pendingSync = true behavior. If it's a 4xx or 5xx server error, it should throw a normal exception so the UI can show an error Snackbar.

Please implement these refinements and confirm when complete.

**Context:**
Auditing Page 2 requirements to ensure correct data mapping between the UI, local DB, and Reqres API, and tightening the offline detection logic.

## Entry #16: Page 3 Audit - Aggressive DB Caching & Real-Time Badges
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #16. Context: "Auditing Page 3 requirements to ensure aggressive local caching of API movies and setting up individual Drift streams for real-time save count badges."

Action 1: Aggressive Caching (Upsert)
The assignment mandates that any movie fetched from the API must be stored locally immediately so it's available offline.

Please ensure that inside MovieRepository.getTrendingMovies, immediately after receiving the TMDB API response, the repository performs an upsert (insert or replace) into the Drift Movies table for every movie in the list.

Action 2: Real-Time Hybrid Badge Stream
The save count badge on each movie card must update in real-time when any user saves it.

Please create a specific query in the Drift database: watchSaveCountForMovie(int movieId) that returns a Stream<int> representing the count of rows in the SavedMovies table for that ID.

On the MoviesPage UI, wrap the save count badge in a StreamBuilder connected to this specific stream. This ensures the badge updates instantly without needing to rebuild the entire paginated list.

Action 3: Active User Save Action
Ensure the "Save/Unsave" button on the movie card correctly reads the "Active User" state we set up in Task 13, and inserts/deletes the correct (userId, movieId) pair in the SavedMovies table.

Please implement these data-flow refinements and confirm when complete.

**Context:**
Auditing Page 3 requirements to ensure aggressive local caching of API movies and setting up individual Drift streams for real-time save count badges.

## Entry #17: Page 4 Audit - Avatar Streams & Offline-First Hydration
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #17. Context: "Auditing Page 4 to ensure the UI streams the actual User avatars for saved movies, and implementing offline-first hydration for the movie details."

Action 1: Reactive User Avatars Stream
The Movie Detail Page must show the profile photos of the users who saved the movie.

Please add a query to Drift: watchUsersWhoSavedMovie(int movieId) that joins SavedMovies and Users and returns a Stream<List<User>>.

Update the MovieDetailPage UI to use this stream. If the list is empty, show "Be the first to save this." If not empty, show "X users want to watch this" along with a Row of small CachedNetworkImage avatars for those users.

Action 2: Offline-First Detail Hydration
The app must load the detail page instantly when offline, but still fetch full details if online.

In MovieDetailPage (or its Bloc), instantly load the movie data we already have cached in the local database.

In the background (without blocking the UI with a spinner), call the MovieRepository method to hit the GET /movie/{id} TMDB endpoint.

When the API returns the fresh data, perform an upsert on the Movies table in Drift. Because the UI is listening to the database stream, any new details (like a longer overview) will just smoothly pop into the UI.

Please implement these refinements and confirm when complete.

**Context:**
Auditing Page 4 to ensure the UI streams the actual User avatars for saved movies, and implementing offline-first hydration for the movie details.

## Entry #18: Page 5 Audit - Cross-User Context & Strict Offline Enforcement
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #18. Context: "Auditing Page 5 to ensure the 'Save' button reflects the Active User's state when viewing another user's profile, and enforcing strict offline-only data streams."

Action 1: Cross-User Save Logic
The assignment states that the currently active user can save a movie directly from another user's Saved Movies page.

Please audit SavedMoviesPage. The page must accept a profileUserId (the user whose page we are viewing).

The list of movies displayed must be generated from a Drift stream filtering SavedMovies by profileUserId.

However, the Save/Unsave button on each movie card must evaluate against the activeUserId (from the context established in Task 13). When tapped, it must insert/delete a record in SavedMovies for the activeUserId, NOT the profileUserId.

Action 2: Strict Offline Enforcement
The assignment mandates this page works fully offline using data cached from Page 03.

Please ensure the BLoC/ViewModel for this page does NOT make any network calls to TMDB or OMDB. It must exclusively listen to the local Drift database stream joining the Movies and SavedMovies tables.

Please implement these state separations and confirm when complete.

**Context:**
Auditing Page 5 to ensure the 'Save' button reflects the Active User's state when viewing another user's profile, and enforcing strict offline-only data streams.

## Entry #19: Page 6 Audit - Dependency Injection (get_it)
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #19. Context: "Fulfilling the strict 'Dependency Injection' requirement from the assignment's technical checklist by implementing get_it."

Action 1: Setup get_it
The assignment technical checklist explicitly requires the use of get_it for dependency injection.

Please add the get_it package to pubspec.yaml.

Create a file at /lib/core/di/injection_container.dart.

Action 2: Register Dependencies
Inside injection_container.dart, create an init() function and register all of our core components as singletons or factories:

Core: Dio client, Drift database.

Services: TmdbService, ReqresService.

Repositories: MovieRepository, UserRepository.

State Management: Register all Blocs/Cubits (UserCubit, MovieCubit, etc.) as factories.

Action 3: Refactor Main & UI

Update main.dart to await the init() function before runApp.

Ensure all our UI pages and Routers instantiate their Cubits using the get_it locator (e.g., sl<UserCubit>()) instead of direct instantiation.

Please implement this DI refactor and confirm when complete.

**Context:**
Fulfilling the strict 'Dependency Injection' requirement from the assignment's technical checklist by implementing get_it.

## Entry #20: Page 7 Audit - Exponential Backoff & The Offline ID Swap
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #20. Context: "Auditing Page 07 requirements to ensure the network retry logic uses exponential backoff and that offline database foreign keys remain intact after a server sync."

Action 1: Exponential Backoff Verification
The assignment mandates that network retries wait "a little longer between each retry" to handle the 30% failure simulation.

Please audit the custom Dio Retry Interceptor we built. Ensure it uses an exponential backoff formula (e.g., delay = baseDelay * (2 ^ attempt)) rather than a fixed delay.

Action 2: The "ID Swap" Safety Check
The reviewers will create a user offline, save movies, and then go online. We must ensure no saved movies are unlinked during the background sync.

Please audit the SavedMovies database table and the WorkManager sync logic.

Confirm that SavedMovies.userId references the local SQLite auto-incremented id, NOT the Reqres serverId.

Confirm that when SyncManager successfully posts the pending user to the API, it ONLY updates the serverId column for that user in the database, leaving the local id completely untouched so the foreign key relationship to their saved movies remains perfectly intact.

Please implement these verifications and confirm when complete.

**Context:**
Auditing Page 07 requirements to ensure the network retry logic uses exponential backoff and that offline database foreign keys remain intact after a server sync.

## Entry #21: Page 8 Audit - Image Fallbacks & Global Error States
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #21. Context: "Auditing Page 08 UI requirements to ensure graceful visual degradation for offline images and robust first-launch error states."

Action 1: CachedNetworkImage Fallbacks
We must gracefully handle broken images or offline scenarios where the image isn't cached.

Please audit every instance of CachedNetworkImage (Users Page avatars, Movie Cards, Movie Detail Hero, Matches Page avatars).

Add an errorWidget to all of them. Use a clean, themed placeholder (e.g., a dark grey container with a subtle Icons.movie or Icons.person in the center using our primary Gold color).

Action 2: "First Launch Offline" Feed States
If the MoviesPage or UsersPage fails to fetch from the API and the Drift database returns an empty list (meaning it's the first launch and they are offline), we cannot show a blank screen.

Please update the UI logic for these main feeds: If state is Error AND the database stream is empty, display a highly polished Column in the center of the screen with a relevant icon (e.g., Icons.wifi_off), a title ("No Connection"), a subtitle ("Please connect to the internet to load the initial feed."), and a "Retry" button.

Action 3: SafeArea Audit
Ensure the main scaffold bodies are wrapped appropriately so that lists do not awkwardly clip into the phone's hardware notch or bottom gesture bar.

Please implement these UI safety nets and confirm when complete.

**Context:**
Auditing Page 08 UI requirements to ensure graceful visual degradation for offline images and robust first-launch error states.

## Entry #22: First-Launch Onboarding Screens
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #22. Context: "Implementing a first-launch onboarding experience using shared_preferences to introduce the app's core features."

Action 1: Setup and State

Please add the shared_preferences package to pubspec.yaml.

Update our get_it injection container (/lib/core/di/injection_container.dart) to register SharedPreferences as an asynchronous singleton.

Create a simple utility or Cubit to check and set a boolean flag: hasSeenOnboarding.

Action 2: The Onboarding UI

Create a new file at /lib/features/onboarding/presentation/onboarding_page.dart.

Build a beautiful, customized PageView using our "Cinematic Gold" theme. It should have 3 pages:

Discover: "Find trending movies instantly." (Use a movie reel or popcorn icon).

Offline Ready: "Save your favorites. Access them anywhere, even on airplane mode." (Use an offline/download icon).

Match: "See what your friends want to watch and find the perfect movie night pick." (Use a group/matching icon).

Add a smooth dot indicator at the bottom and a prominent "Get Started" button on the final page using our Gold primary color.

Action 3: Routing Logic

Update app_router.dart. We need to determine the initial route dynamically. Check the hasSeenOnboarding flag from SharedPreferences. If false, set the initial route to /onboarding. If true, set it to / (Users Page).

When the user taps "Get Started" on the last onboarding screen, set the flag to true and navigate to /.

Please implement this flow, ensure the app compiles, and confirm when complete.

**Context:**
Implementing a first-launch onboarding experience using shared_preferences to introduce the app's core features.

## Entry #23: Contextual Coach Marks & Premium Lottie Onboarding Upgrade
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #23. Context: "Implementing premium onboarding animations and adding contextual tutorial coach marks using the showcaseview package to guide the user through the core UI."

Action 1: Setup Lottie and ShowcaseView
Please add the lottie and showcaseview packages to pubspec.yaml.
Update our MaterialApp or root router setup so that our main screens are wrapped in a ShowCaseWidget.

Action 2: Instrument the UI with Coach Marks
Highlight three specific features using Showcase widgets:
- On UsersPage: Highlight the "Add User" FAB and the "Matches" icon.
- On MoviesPage: Highlight the "Save" button on the first movie card.

Action 3: Premium Lottie Onboarding Upgrade
Upgrade the onboarding UI in onboarding_page.dart by replacing static icons with Lottie.asset() animations.
Implement a smooth transition effect using an AnimatedBuilder tied to the PageController for parallax/scale effects as the user swipes.

Action 4: Trigger Logic
The Showcase should only trigger the very first time the user visits these pages.
Use SharedPreferences to track hasSeenUsersTutorial and hasSeenMoviesTutorial flags.

Please implement these enhancements and confirm when complete.

**Context:**
Implementing premium onboarding animations and adding contextual tutorial coach marks using the showcaseview package to guide the user through the core UI.

## Entry #24: Premium Contextual Coach Marks
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #24. Context: "Implementing premium contextual coach marks using showcaseview, featuring background blurring, custom tooltips, and haptic feedback."

Action 1: Setup Advanced ShowcaseWidget

Please add the showcaseview package to pubspec.yaml (if not already added).

Wrap our root application or router inside a ShowCaseWidget.

The Premium Polish: Configure the ShowCaseWidget to use a blurValue (e.g., 2.0 or 3.0) so the background UI beautifully blurs out, rather than just dimming.

Action 2: Instrument the UI with Custom Tooltips
Please create GlobalKeys and wrap the following widgets in a Showcase widget. Do not use the default styling. Instead, style the tooltips to look premium: use our dark surface color for the tooltip background, add our Gold primary color for the text/title, and include rounded corners.

On UsersPage: Highlight the "Add User" FAB. (Title: "New User", Description: "Start here! Create a profile to start saving movies.")

On UsersPage: Highlight the "Matches" AppBar icon. (Title: "Matches", Description: "Tap here to see which movies everyone wants to watch!")

On MoviesPage: Highlight the "Save" button on the first movie card. (Title: "Save Movie", Description: "Tap to save a movie to your offline list.")

Action 3: Trigger Logic & Haptics

Use SharedPreferences to create boolean flags (e.g., hasSeenUsersTutorial, hasSeenMoviesTutorial).

In the initState of UsersPage and MoviesPage, check these flags. If false, trigger the showcase using ShowCaseWidget.of(context).startShowCase([...]) and set the flag to true.

The Premium Polish: Add HapticFeedback.lightImpact() (import services.dart) inside the onStart and onComplete callbacks of the showcases so the user physically feels the tutorial appearing and disappearing.

Please implement this premium tutorial flow and confirm when complete.

**Context:**
Implementing premium contextual coach marks using showcaseview, featuring background blurring, custom tooltips, and haptic feedback.

## Entry #25: Automatic Retry and Manual Refresh
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #25. Context: "Adding RefreshIndicator and explicit Retry buttons to empty states to ensure data fetch reliability when the API returns no results."

Action 1: Add RefreshIndicator
Integrate a RefreshIndicator into the ListView on both the UsersPage and MoviesPage to allow manual pull-to-refresh functionality.

Action 2: Implement Explicit Retry Buttons
Update the empty state UI for both pages to include a "Retry" button. When pressed, it should trigger the respective Cubit to fetch data from the API again.

Please implement these reliability features and confirm when complete.

**Context:**
Added `RefreshIndicator` and an explicit "Retry" button to the empty states of both `UsersPage` and `MoviesPage`. This allows users to manually "call the api again" if they encounter an empty list, ensuring data can be fetched even if the initial automatic sync failed or was incomplete.

## Entry #26: Final Rubric Audit & High-Impact Documentation
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #26. Context: "Performing a final audit against the assignment rubric and generating high-impact Mermaid-enhanced documentation."

Action 1: Final Reliability Checks
Perform final reliability checks on SyncManager and Dio Interceptors to ensure robust offline-sync and error handling.

Action 2: Code Quality Refactor
Refactor the codebase for quality, ensuring adherence to clean architecture and proper separation of concerns.

Action 3: High-Impact Documentation
Generate a high-impact README featuring Mermaid diagrams to visualize the app's architecture and data flow.

Please complete these final polish steps and confirm.

**Context:**
Final audit against the assignment scoring rubric (Functionality, UI Quality, Code Quality, Offline Sync, and Connection Handling) and generating the submission documentation.

## Entry #27: Strategic Test Suite (Unit & Widget Tests)
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #27. Context: "Implementing a strategic test suite to verify core offline-sync logic and UI responsiveness, satisfying the 'go beyond' criteria."

Action 1: Add Test Dependencies
Add `bloc_test` and `mocktail` to `dev_dependencies` in `pubspec.yaml`.

Action 2: Unit and Bloc Testing
Create comprehensive unit tests for `MovieRepository` and Bloc tests for `UserCubit` to verify data flow and state transitions.

Action 3: Widget Testing
Implement widget tests for `MovieCard` and other key UI components to ensure visual consistency and interaction reliability.

Action 4: Testing Strategy Documentation
Update the `README.md` with a detailed Testing Strategy section.

Please implement this test suite and confirm when complete.

**Context:**
Implementing a strategic test suite (Unit and Widget tests) to verify core offline-sync logic and UI responsiveness, satisfying the 'go beyond' criteria.

## Entry #28: Professional Package Name Refactor
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #28. Context: "Refactoring the project to replace the default 'com.example' bundle ID with a unique, professional package name."

Action 1: Add Package Rename Tool
Add `change_app_package_name` to `dev_dependencies` in `pubspec.yaml`.

Action 2: Execute Package Name Change
Execute the package name change to `com.platform_commons.match_and_watch.app` across the entire project.

Action 3: Configuration Verification
Manually verify Android and iOS configurations to ensure the new bundle ID is correctly applied. Perform a full clean and rebuild.

Please execute this refactor and confirm when complete.

**Context:**
Refactoring the project to replace the default 'com.example' bundle ID with a unique, professional package name.

## Entry #29: Final Master Cleanup & Project Optimization
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #29. Context: "Performing a final deep-clean of the project to remove dead code, unused assets, and redundant dependencies before the final production build."

Action 1: Dead Code & Import Audit
Please run a project-wide scan. Remove any import statements that are grayed out or unused.
Remove any commented-out code blocks, "TODO" comments (unless critical), or print statements that were missed in previous steps.
Ensure all classes and variables follow the camelCase and PascalCase Dart conventions strictly.

Action 2: Asset & Dependency Purge
Audit the assets/ folder. Delete any images or Lottie files that are not actually being called in the UI.
Check pubspec.yaml. Remove any packages that were added during development but are no longer used in the final architecture.

Action 3: Android Resource Shrinking
Open android/app/build.gradle.
Inside buildTypes.release, ensure the following are set to true:
minifyEnabled true
shrinkResources true
This will trigger R8 to strip out unused Java/Kotlin code and resources from the final APK.

Action 4: Final Documentation Sync
Ensure the README.md and PROMPTS.md are in their final state and saved in the root directory.
Please confirm when the cleanup is complete. Once done, I will run the final build command.

**Context:**
Performing a final deep-clean of the project to remove dead code, unused assets, and redundant dependencies before the final production build.

## Entry #30: Prevent Duplicate Submissions & Add Loading State
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #30. Context: "Enhancing the 'Add User' flow to prevent duplicate submissions by disabling the button and showing a loader during the asynchronous operation."

Action 1: Update UserCubit State
Ensure the UserCubit has a specific state for UserAdding or check if the state is UserLoading.

Action 2: Update Add User Button UI
Open the "Add User" dialog or screen.
Wrap the "Add" button's content in an AnimatedSwitcher.
Logic: If the state is Loading, replace the "Add User" text with a small, themed CircularProgressIndicator (use strokeWidth: 2 to keep it elegant).
Disabled State: Set the onPressed callback to null if the state is Loading. This automatically greys out/disables the button in Flutter.

Action 3: Haptic Confirmation
Trigger HapticFeedback.mediumImpact() the moment the button is pressed, and a HapticFeedback.lightImpact() once the user is successfully added and the dialog closes.

Please implement this and confirm. This ensures a "one-tap" guarantee for our database integrity.

**Context:**
Enhancing the 'Add User' flow to prevent duplicate submissions by disabling the button and showing a loader during the asynchronous operation.

## Entry #31: Fix Showcase Sequence Logic
**Prompt:**
Log this first: Please log this prompt into PROMPTS.md as Entry #31.
Context: "The Showcase sequence on UsersPage breaks after the first item (FAB) because the onTargetClick callback triggers navigation to a new page, which kills the showcase context before the 'Matches' tutorial can appear."

Action 1: Core Implementation
Modify onTargetClick: In UsersPage.dart, locate the Showcase widget wrapping the FloatingActionButton. Remove the context.push('/add_user') call from the onTargetClick property.

Explanation: onTargetClick fires when the user taps the highlighted FAB during the tutorial. If this navigates away, the ShowcaseWidget sequence is destroyed. Removing navigation allows the sequence to progress to the _matchesKey (the Matches icon in the AppBar).

Verify Sequence: Ensure ShowCaseWidget.of(context).startShowCase([_fabKey, _matchesKey]) is still correctly called in _checkShowcase.

Action 2: Professional Standards Audit
Clean Code: Ensure the GlobalKey references (_fabKey and _matchesKey) remain private and properly initialized.
UX Feedback: Ensure HapticFeedback.lightImpact() is still called on target click to provide tactile confirmation that the tutorial is progressing.
Navigation Logic: Verify that the onPressed of the actual FloatingActionButton still handles the navigation correctly for normal usage (outside of the showcase).

Action 3: File Organization & Scalability
Naming Sync: Ensure the title of this task in PROMPTS.md matches "Entry #31: Fix Showcase Sequence Logic".

**Context:**
Fixing the Showcase sequence on UsersPage by removing premature navigation that breaks the tutorial context.

## Entry #32: Scalable Social Proof UI (Stacked Avatars)
**Prompt:**
Log this first: Please log this into PROMPTS.md as Entry #32.
Context: "Implementing a scalable 'Social Proof' stacked avatar UI for movie cards and performing the final synchronization of the project log for submission."

Action 1: Scalable Social Proof UI (Stacked Avatars)

Requirement: Movie cards must show which users have bookmarked a specific movie to provide social proof.

Widget Creation: Create a reusable widget SocialAvatars in lib/core/widgets/social_avatars.dart.

Logic:

Accept a list of User objects.

1 User: Show 1 avatar.

2 Users: Show 2 overlapping avatars using a Stack.

> 2 Users: Show 2 overlapping avatars and a circular badge with +N (e.g., if 5 people saved it, show 2 avatars and a +3 badge).

Styling: Use AppDimensions.avatarSm. Add a 2dp border (using AppColors.surfaceGrey) around each avatar to create a "cutout" effect that separates them visually.

Action 2: Integration & Data Flow

Update the MovieCard widget to include the SocialAvatars row.

Data Source: Ensure the widget receives the list of users who have saved that specific movie by querying the SavedMovies relationship in the Drift database.

UX: The row should animate in along with the card using the existing staggered animation logic.

Action 3: Final Log Synchronization

Perform a final sweep of PROMPTS.md.

Unification: Ensure every single log follows the unified "Entry #[Number]: [Title]" format.

Cleanup: Remove any redundant references to "Task X" or "Step Y" that conflict with the "Entry" numbering.

Verification: Ensure the log is chronologically perfect, ending with this entry (#32).

**Context:**
Implementing a scalable 'Social Proof' stacked avatar UI for movie cards to provide social validation, and performing a final audit/synchronization of the AI prompt log.
\n## Entry #33: Reposition Social Proof UI\n**Prompt:**\nentry 36: put it in movies details page and also in the matches page  becuase there also weare showing how many people has bookmarked it and remove it from movies_page\n\n**Context:**\nMoving the stacked avatar 'Social Proof' UI from the main movie list to the Movie Details and Matches pages for better contextual relevance.\n
