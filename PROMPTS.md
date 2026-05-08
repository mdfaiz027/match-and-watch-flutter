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
Setting up the project's foundational dependencies, clean architecture folder structure, and Material 3 design system using local fonts.

Action 1: Dependencies
Please update my pubspec.yaml with the following packages required for our architecture:
State Management: flutter_bloc and equatable
Network: dio
Local DB: drift, sqlite3_flutter_libs, path_provider, path (and drift_dev, build_runner under dev_dependencies)
Background Sync: workmanager
Navigation: go_router
UI/Design: cached_network_image, shimmer (for the required loading states)

Action 2: Folder Structure & Asset Declaration
Create a clean, feature-based folder structure inside /lib: /lib/core, /lib/features/users, /lib/features/movies, and /lib/features/sync.
Update pubspec.yaml for image assets and local fonts (Poppins).

Action 3: The Theme
Create /lib/core/theme/app_theme.dart. Implement a Material 3 dark theme and set the global fontFamily to 'Poppins'.

**Context:**
Initializing the project with core dependencies, directory structure, and the visual design foundation.

## Entry #3: Implement the "Cinematic Gold" Material 3 Theme
**Prompt:**
Implementing the centralized Material 3 'Cinematic Gold' dark theme and applying the local Poppins font family.

Action: Create a comprehensive theme configuration at /lib/core/theme/app_theme.dart using high-contrast Gold (#FFC107) and premium charcoal backgrounds. Define typography and component themes for Cards, Buttons, and AppBars.

**Context:**
Defining the aesthetic identity of the application to ensure a premium, modern user experience.

## Entry #4: Drift Database Schema & Offline-First Setup
**Prompt:**
Designing the Drift database schema to support offline-first data, including Users, Movies, and a junction table for Saved Movies.

Action: Set up local SQLite database using drift. Define tables for Users (local + server IDs), Movies (TMDB/OMDB mapped), and SavedMovies (junction table). Provide build commands for code generation.

**Context:**
Establishing the local storage layer which serves as the single source of truth for all application data.

## Entry #5: Robust API Layer with Dio & Interceptors
**Prompt:**
Building the Dio network client, including API services for Reqres and TMDB, and a custom interceptor to simulate the required 30% network failure and auto-retry logic.

Action 1: Dio Client & Interceptors. Create a network client with Failure Simulator (30% random failure) and Retry Interceptor with exponential backoff.
Action 2: API Services. Create ReqresService for user management and TmdbService for movie metadata.

**Context:**
Developing a resilient network layer that satisfies the technical requirements for connection handling and reliability.

## Entry #6: Repositories & State Management (Bloc)
**Prompt:**
Building the Repository pattern to act as the single source of truth, and setting up BLoCs/Cubits to expose database streams to the UI.

Action 1: Repositories. Create UserRepository and MovieRepository to manage data flow between API and Drift DB.
Action 2: State Management. Create UserCubit and MovieCubit to emit states based on database streams.

**Context:**
Implementing the bridge between the data layer and the UI, ensuring reactive updates when local data changes.

## Entry #7: Background Sync (WorkManager) & App Initialization
**Prompt:**
Implementing the WorkManager background task to sync offline-created users to the server, and setting up the app icon and splash screen packages.

Action 1: WorkManager. Implement sync_manager.dart to handle background synchronization of pending users.
Action 2: Initialize in Main. Configure WorkManager and core dependencies in main.dart.
Action 3: Polish Packages. Configure flutter_launcher_icons and flutter_native_splash.

**Context:**
Ensuring that data created while offline eventually reaches the server and providing professional first-launch visuals.

## Entry #8: UI - Users Page, Add User Form, & Routing
**Prompt:**
Building the initial UI screens (Users Page and Add User Form) using the Cinematic Gold theme, integrating the UserBloc, and setting up GoRouter.

Action 1: App Router. Configure GoRouter with initial routes.
Action 2: Users Page. Implement paginated list with shimmer loading states and staggered animations.
Action 3: Add User Page. Create form with success SnackBars and navigation logic.

**Context:**
Creating the primary user interface components and navigation flow for the user management feature.

## Entry #9: OMDB Integration, Movies Page, & Detail Page
**Prompt:**
Pivoting the API layer from TMDB to OMDB due to API availability, and building the Movies Page and Movie Detail Page UIs.

Action 1: OMDB Swap. Update network layer and repositories to use OMDB API.
Action 2: Movies Page. Implement paginated movie list with save count badges.
Action 3: Movie Detail Page. Build Hero animations and detail views with save/unsave functionality.

**Context:**
Expanding the movie discovery features and handling external API constraints with a flexible architecture.

## Entry #10: Saved Movies Page & Matches Page (The Final UI)
**Prompt:**
Building the final UI screens—User's Saved Movies and the Matches Page—relying entirely on local database streams for offline support and real-time updates.

Action 1: Saved Movies Page. Show user-specific saved movies with unsave functionality.
Action 2: Matches Page. Implement "Group Pick" logic for movies saved by multiple users.
Action 3: Routing & Connections. Finalize app navigation and cross-page links.

**Context:**
Completing the social discovery features and ensuring all pages work seamlessly in offline mode.

## Entry #11: Fix Reqres Missing API Key Error
**Prompt:**
Fixing the Reqres 'missing_api_key' error by injecting the required 'x-api-key' header into the Dio client.

Action: Update Reqres Dio configuration to include the "x-api-key" header in every request.

**Context:**
Resolving a specific API authentication issue to restore user creation functionality.

## Entry #12: Switch Back to TMDB API
**Prompt:**
Reverting the fallback API and fully integrating TMDB for trending movies and movie details, including the specific image prefixing required by TMDB.

Action 1: TMDB Service. Implement Trending and Details endpoints.
Action 2: Repository Update. Map TMDB fields to Drift Movies table.
Action 3: Image URLs. Construct full URLs for TMDB images using appropriate size prefixes.

**Context:**
Restoring the preferred high-quality movie data source and handling vendor-specific data requirements.

## Entry #13: The Final UI Polish & Reconnection State
**Prompt:**
Implementing the final UI polish requirements from the assignment: Staggered list animations, animated count badges, and a non-blocking 'reconnecting...' UI bar.

Action 1: Staggered Animations. Add flutter_staggered_animations to main lists.
Action 2: Animated Badges. Use AnimatedSwitcher for save counts.
Action 3: Reconnecting Bar. Implement a global connection listener and overlay UI.

**Context:**
Satisfying the advanced UI requirements for fluid motion and real-time connection feedback.

## Entry #14: Page 1 Audit - Active User State & Dynamic Counts
**Prompt:**
Auditing Page 1 requirements to ensure dynamic saved movie counts are streamed from Drift, and establishing the 'Active User' state for navigation.

Action 1: Dynamic Counts. Update repositories to stream joined user-movie data.
Action 2: Active User Context. Implement ActiveUserCubit to track user selection across pages.

**Context:**
Ensuring that user statistics update in real-time as users interact with the movie database.

## Entry #15: Page 2 Audit - Form Data Mapping & Offline Detection
**Prompt:**
Auditing Page 2 requirements to ensure correct data mapping between the UI, local DB, and Reqres API, and tightening the offline detection logic.

Action 1: Form Mapping. Ensure firstName/lastName split and correct JSON mapping for Reqres.
Action 2: Offline Detection. Implement specific catch logic for Dio connection exceptions to trigger pending sync.

**Context:**
Strengthening the data integrity and offline resilience of the user registration process.

## Entry #16: Page 3 Audit - Aggressive DB Caching & Real-Time Badges
**Prompt:**
Auditing Page 3 requirements to ensure aggressive local caching of API movies and setting up individual Drift streams for real-time save count badges.

Action 1: Upsert Caching. Store every API response in Drift immediately.
Action 2: Badge Streams. Create specific Drift queries for per-movie save counts to ensure UI reactivity.

**Context:**
Optimizing the movie list for performance and real-time social validation.

## Entry #17: Page 4 Audit - Avatar Streams & Offline-First Hydration
**Prompt:**
Auditing Page 4 to ensure the UI streams the actual User avatars for saved movies, and implementing offline-first hydration for the movie details.

Action 1: Avatar Streams. Join SavedMovies and Users to show who saved each movie.
Action 2: Background Hydration. Load cached data instantly and fetch fresh details in the background.

**Context:**
Enhancing the movie details view with social proof and ensuring no-wait loading states.

## Entry #18: Page 5 Audit - Cross-User Context & Strict Offline Enforcement
**Prompt:**
Auditing Page 5 to ensure the 'Save' button reflects the Active User's state when viewing another user's profile, and enforcing strict offline-only data streams.

Action 1: Cross-User Logic. Separate "Profile User" context from "Active User" actions.
Action 2: Offline Enforcement. Ensure the page only listens to local DB streams.

**Context:**
Clarifying multi-user interactions and maintaining strict offline-first data principles.

## Entry #19: Page 6 Audit - Dependency Injection (get_it)
**Prompt:**
Fulfilling the strict 'Dependency Injection' requirement from the assignment's technical checklist by implementing get_it.

Action 1: Set up get_it.
Action 2: Register Dependencies. Initialize Services, Repositories, and Cubits as singletons/factories.
Action 3: Refactor UI. Use service locator for all dependency instantiation.

**Context:**
Decoupling application components to improve testability and maintainability.

## Entry #20: Page 7 Audit - Exponential Backoff & The Offline ID Swap
**Prompt:**
Auditing Page 07 requirements to ensure the network retry logic uses exponential backoff and that offline database foreign keys remain intact after a server sync.

Action 1: Backoff Formula. Verify retry delays increase exponentially.
Action 2: ID Integrity. Confirm background sync only updates the serverId, keeping the local primary key intact for relationships.

**Context:**
Securing the integrity of relational data during complex background synchronization tasks.

## Entry #21: Page 8 Audit - Image Fallbacks & Global Error States
**Prompt:**
Auditing Page 08 UI requirements to ensure graceful visual degradation for offline images and robust first-launch error states.

Action 1: Fallback Widgets. Add errorWidget to all CachedNetworkImages.
Action 2: Empty Feed States. Implement "No Connection" screens with retry logic.
Action 3: SafeArea Audit. Ensure UI elements don't clip into system notches.

**Context:**
Providing a polished user experience even in degraded network conditions or empty data states.

## Entry #22: First-Launch Onboarding Screens
**Prompt:**
Implementing a first-launch onboarding experience using shared_preferences to introduce the app's core features.

Action 1: Setup and State. Register SharedPreferences and track hasSeenOnboarding flag.
Action 2: Onboarding UI. Build a 3-page customized PageView with dot indicators and Lottie animations.
Action 3: Dynamic Routing. Set initial route based on onboarding status.

**Context:**
Guiding new users through the application's unique value propositions during their first visit.

## Entry #23: Contextual Coach Marks & Premium Lottie Onboarding Upgrade
**Prompt:**
Implementing premium onboarding animations and adding contextual tutorial coach marks using the showcaseview package to guide the user through the core UI.

Action 1: Setup Lottie and ShowcaseView.
Action 2: Instrument UI. Add Showcase wrappers to FAB and AppBar icons.
Action 3: Animation Upgrade. Replace icons with Lottie animations in onboarding.

**Context:**
Enhancing the interactive learning experience for new users through visual guidance.

## Entry #24: Premium Contextual Coach Marks
**Prompt:**
Implementing premium contextual coach marks using showcaseview, featuring background blurring, custom tooltips, and haptic feedback.

Action 1: Advanced Setup. Configure blurValue and custom themes.
Action 2: Styled Tooltips. Apply Cinematic Gold theme to all tutorial popups.
Action 3: Polish. Add HapticFeedback on start/complete of tutorial steps.

**Context:**
Providing professional-grade user guidance that matches the application's high-fidelity theme.

## Entry #25: Automatic Retry and Manual Refresh
**Prompt:**
Adding RefreshIndicator and explicit Retry buttons to empty states to ensure data fetch reliability when the API returns no results.

Action 1: Pull-to-refresh. Integrate RefreshIndicator on main lists.
Action 2: Manual Retry. Add buttons to empty state views to trigger Cubit reload.

**Context:**
Giving users control over data synchronization and recovery from transient network errors.

## Entry #26: Final Rubric Audit
**Prompt:**
Performing a final audit against the assignment scoring rubric (Functionality, UI Quality, Code Quality, Offline Sync, and Connection Handling).

Action: Verify SyncManager reliability and Dio Interceptor robustness. Refactor codebase for clean architecture adherence.

**Context:**
Ensuring all technical requirements are met to the highest standard before final submission.

## Entry #27: High-Impact Documentation
**Prompt:**
Generating high-impact README featuring Mermaid diagrams to visualize the app's architecture and data flow.

Action: Create comprehensive documentation including Architecture diagrams, DB Schema, and technical feature explanations.

**Context:**
Visualizing the project's complexity and technical depth for the review team.

## Entry #28: Strategic Test Suite: Unit & Bloc Testing
**Prompt:**
Implementing a strategic test suite to verify core offline-sync logic and UI responsiveness.

Action: Create unit tests for MovieRepository and Bloc tests for UserCubit using mocktail and bloc_test.

**Context:**
Verifying the internal logic and state transitions to ensure a bug-free application.

## Entry #29: Strategic Test Suite: Widget Testing
**Prompt:**
Implementing widget tests for key UI components to ensure visual consistency and interaction reliability.

Action: Create widget tests for MovieCard and other critical UI elements.

**Context:**
Ensuring the user interface behaves correctly across different devices and interactions.

## Entry #30: Testing Strategy Documentation
**Prompt:**
Updating the README.md with a detailed Testing Strategy section.

Action: Document the types of tests implemented and instructions for running the suite.

**Context:**
Communicating the testing philosophy and results to stakeholders.

## Entry #31: Professional Package Name Refactor
**Prompt:**
Refactoring the project to replace the default 'com.example' bundle ID with a unique, professional package name.

Action: Use change_app_package_name to update the project to com.platform_commons.match_and_watch.app.

**Context:**
Moving away from boilerplate configurations to a production-ready application identity.

## Entry #32: Package Name Change Execution
**Prompt:**
Executing and verifying the package name change across Android and iOS configurations.

Action: Manually verify build.gradle and system files for correct bundle ID propagation. Perform a full clean and rebuild.

**Context:**
Ensuring the build system is correctly configured for deployment.

## Entry #33: Prevent Duplicate Submissions & Add Loading State
**Prompt:**
Enhancing the 'Add User' flow to prevent duplicate submissions by disabling the button and showing a loader during the asynchronous operation.

Action: Update UserCubit state and Add User button UI with AnimatedSwitcher and haptic feedback.

**Context:**
Ensuring data integrity by preventing rapid multiple taps on the submission form.

## Entry #34: Fix Showcase Sequence Logic
**Prompt:**
Fixing the Showcase sequence on UsersPage by removing premature navigation that breaks the tutorial context.

Action: Remove context navigation from onTargetClick in the FAB showcase and set disposeOnTap to false to allow the sequence to progress to the AppBar icon.

**Context:**
Correcting the tutorial flow to ensure users see all intended coach marks before moving to a new screen.

## Entry #35: Scalable Social Proof UI (Stacked Avatars)
**Prompt:**
Implementing a scalable 'Social Proof' stacked avatar UI for movie cards to provide social validation.

Action: Create reusable SocialAvatars widget with overlapping circle borders and +N badge logic.

**Context:**
Adding visual proof of user engagement to encourage movie saving and social interaction.

## Entry #36: Reposition Social Proof UI
**Prompt:**
entry 36: put it in movies details page and also in the matches page becuase there also weare showing how many people has bookmarked it and remove it from movies_page

**Context:**
Moving the stacked avatar 'Social Proof' UI from the main movie list to the Movie Details and Matches pages for better contextual relevance.

## Entry #37: Social Proof UI Verification & Automated Tests
**Prompt:**
Adding automated tests to verify the social proof UI logic on specific pages, validating junction table relationships, and performing the final synchronization of the project log.

Action 1: Widget Verification (SocialAvatars). Create widget tests for overflow logic.
Action 2: Integration Testing. Verify junction table stream in MovieRepository.

**Context:**
Validating the stability of the social proof feature and its integration with the local data layer.

## Entry #38: Final Master Cleanup & Project Optimization
**Prompt:**
Performing the absolute final deep-clean and optimization of the project before generating the production release APK.

Action 1: Final Dead Code & Import Audit. Remove unused imports, non-critical TODOs, and print statements.
Action 2: Asset & Dependency Purge. Delete unreferenced assets and unused packages.
Action 3: Production Build Configuration. Enable R8 minification and resource shrinking in build.gradle.kts.
Action 4: Final Documentation Sync. Sequential re-numbering of AI logs and finalized README.md with Release APK links.

**Context:**
The final verification and stabilization step to ensure the project is in a perfect state for the official production build.
