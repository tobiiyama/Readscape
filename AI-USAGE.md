# AI Usage 

I used **ChatGPT** as an AI development assistant during the development of **Readscape**. I used AI to help with Flutter setup, coding, debugging, navigation, UI implementation, and understanding how different parts of the application work.

I remained responsible for making decisions about the design and functionality of Readscape, testing the code, modifying AI-generated code, and checking whether the results matched my project requirements and mockups.

---

## 1. How I Used AI

### 1.1 Flutter Project Setup and Troubleshooting

**Date:** August 28, 2026  
**AI Tool:** ChatGPT

**What I asked for:**  
I asked ChatGPT for help setting up the Readscape Flutter project and troubleshooting problems with Flutter commands not being recognized in PowerShell.

**What AI gave me:**  
ChatGPT provided troubleshooting steps for checking the Flutter installation, PATH configuration, creating the Flutter project, and running the application.

**What I kept:**  
I followed the troubleshooting steps that helped me get Flutter working on my computer.

**What I changed:**  
I adjusted the setup based on my own computer and project requirements. I also corrected the project setup when the initial project naming caused a Flutter/Dart naming issue.

---

### 1.2 Welcome, Login, and Sign-Up Screens

**Date:** September 26, 2026  
**AI Tool:** ChatGPT

**What I asked for:**  
I asked ChatGPT for help implementing the Readscape welcome, login, and sign-up screens based on my project mockups.

**What AI gave me:**  
ChatGPT provided Flutter widget and layout code for buttons, images, text fields, and navigation.

**What I kept:**  
I kept parts of the Flutter widget structure and used the generated code as a starting point for the screens.

**What I changed:**  
I changed the colors, spacing, positioning, text, buttons, and other visual details so the screens matched my Readscape design and mockups.

---

### 1.3 Main Screen and Navigation

**Date:** September 26, 2026  
**AI Tool:** ChatGPT

**What I asked for:**  
I asked ChatGPT for help connecting the login and sign-up screens to the main Readscape screen and organizing the application's navigation.

**What AI gave me:**  
ChatGPT provided Flutter navigation code and a structure for the `MainScreen`.

**What I kept:**  
I kept the basic navigation approach and modified it for my application.

**What I changed:**  
I decided which screens and features should be accessible from the main screen, including **Top 10 Books, History, Favorites, Notifications, Search, and the menu**.

---

### 1.4 Search Screen

**Date:** September 27, 2026  
**AI Tool:** ChatGPT

**What I asked for:**  
I asked ChatGPT for help creating the Readscape Search screen and implementing search functionality using book titles and authors.

**What AI gave me:**  
ChatGPT provided Flutter code using a text field, search logic, book lists, and widgets for displaying search results.

**What I kept:**  
I kept the general structure for receiving search input, checking the book information, and displaying matching results.

**What I changed:**  
I modified the interface, colors, spacing, layout, book information, and search behavior to match my Readscape design.

---

### 1.5 Search History

**Date:** September 27, 2026  
**AI Tool:** ChatGPT

**What I asked for:**  
I asked ChatGPT for help adding search history to the Search screen.

**What AI gave me:**  
ChatGPT provided code for storing previous searches, displaying them, selecting a previous search, removing individual searches, and clearing all searches.

**What I kept:**  
I kept the basic list and interaction logic for search history.

**What I changed:**  
I changed the interface and behavior to match my Search screen mockup. I also made sure users could select previous searches, remove individual history items, and use **Clear All**.

---

### 1.6 Top 10 Books Screen

**Date:** September 30, 2026  
**AI Tool:** ChatGPT

**What I asked for:**  
I asked ChatGPT for help creating a separate `topbooks_screen.dart` file and connecting it to the main Readscape screen.

**What AI gave me:**  
ChatGPT provided Flutter code for the Top 10 Books screen and navigation between screens.

**What I kept:**  
I kept the idea of separating the Top 10 Books screen into its own file instead of placing all of the code in one file.

**What I changed:**  
I changed the layout, spacing, colors, book cards, positioning, and navigation so the screen matched my approved Readscape mockup.

---

## 2. Where the AI Got It Wrong

AI-generated code was not always correct for my project. I tested the code myself and made changes when the generated solution did not match my intended design or application behavior.

### 2.1 Authentication Navigation

**What AI gave me:**  
The initial authentication implementation did not properly navigate from the Create Account and Log In buttons to the main Readscape screen. Instead, it displayed a SnackBar message such as **"Create account selected."**

**What was wrong:**  
The buttons were not following the intended Readscape user flow. After logging in or creating an account, the user should enter the main application screen.

**What I did instead:**  
I changed the navigation so that the authentication buttons open the `MainScreen`.

---

### 2.2 Top 10 and Search Navigation

**What AI gave me:**  
The initial navigation between the main screen, Top 10 Books screen, and Search screen did not behave the way I expected.

**What was wrong:**  
When navigating between screens, returning from the Search screen did not always return to the expected Top 10/main screen behavior.

**What I did instead:**  
I reorganized the screens and created a separate `topbooks_screen.dart` file so the Top 10 Books screen could have its own navigation and structure.

---

### 2.3 Top 10 Screen Did Not Match My Mockup

**What AI gave me:**  
The first AI-generated version of the Top 10 Books screen was functional but did not visually match my approved Readscape mockup.

**What was wrong:**  
The layout, spacing, positioning, and overall appearance were different from the design I created.

**What I did instead:**  
I compared the Flutter screen with my mockup and changed the layout, spacing, colors, positioning, and components until the screen was closer to my intended design.

---

## 3. Who Wrote What

Although I used AI assistance during development, I made my own decisions about the design, screen organization, navigation, and functionality of Readscape. I also manually tested and modified the generated code.

### 3.1 Readscape Project Structure and Screen Organization

**Files:**  
`lib/main.dart`  
`lib/main_screen.dart`  
`lib/search_screen.dart`  
`lib/topbooks_screen.dart`

**What I wrote or decided:**  
I organized the application into separate screen files instead of keeping all of the code in one file.

**My explanation:**  
Separating the screens makes the project easier to understand and maintain. For example, the Top 10 Books screen is placed in `topbooks_screen.dart`, while the Search screen is placed in `search_screen.dart`. This keeps the code for each screen organized.

---

### 3.2 Search Behavior and Search History

**File:** `lib/search_screen.dart`

**What I wrote or changed:**  
I implemented and modified the search behavior and search history to fit the Readscape design.

**My explanation:**  
The Search screen allows the user to enter a book title or author and see matching books. Previous searches are displayed as search history. A user can select a previous search to search again, remove an individual search, or use **Clear All** to remove the search history.

---

### 3.3 Readscape Navigation and User Flow

**Files:**  
`lib/main.dart`  
`lib/main_screen.dart`  
`lib/topbooks_screen.dart`  
`lib/search_screen.dart`

**What I wrote or decided:**  
I decided how users move through the main parts of the Readscape application.

**My explanation:**  
The application begins with the authentication entry screen. After logging in or signing up, the user enters the main Readscape interface. From there, the user can access features such as Top 10 Books and Search. I adjusted the navigation based on my project design and testing.

---

### 3.4 AI-Written Code I Understand Best

**File:** `lib/search_screen.dart`

**What AI helped write:**  
ChatGPT helped me write parts of the search and search-history implementation.

**My explanation:**  
The Search screen uses a text controller to read what the user enters. The application checks the entered text against the book information and displays matching results. Search terms can also be stored in a list so previous searches can be displayed. Individual searches can be removed, or all searches can be cleared.

I understand this code because I tested the search features myself and modified the implementation to match the behavior and design I wanted for Readscape.

---

## AI Assistance Summary

I used **ChatGPT** as an AI development assistant throughout the development of Readscape. AI helped me with Flutter setup, coding, debugging, navigation, UI implementation, and understanding Flutter concepts.

I did not simply use the generated code without checking it. I tested the application, compared the results with my mockups, changed generated code when necessary, and identified situations where the AI-generated solution did not work correctly for my project.
