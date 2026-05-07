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
