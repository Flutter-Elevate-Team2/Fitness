<p align="center">
  <img src="assets/images/app_logo.png" alt="Super Fitness Logo" width="150" height="150" style="border-radius: 30px; box-shadow: 0px 4px 10px rgba(0,0,0,0.1);" />
</p>

<h1 align="center">🔥 Super Fitness : Your Ultimate AI-Powered Gym Companion</h1>

<p align="center">
  <em>Achieve your peak physical form with personalized workout plans, smart nutrition tracking, and AI-driven coaching.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.10+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" />
  <img src="https://img.shields.io/badge/Local_Storage-Hive-orange?style=for-the-badge" alt="Hive" />
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-8BC34A?style=for-the-badge" alt="Clean Architecture" />
  <img src="https://img.shields.io/badge/State_Management-BLoC-2196F3?style=for-the-badge&logo=flutter&logoColor=white" alt="BLoC" />
</p>

<p align="center">
  <a href="INSERT_LINK_TO_APK">
    <img src="https://img.shields.io/badge/Download-APK-2ea44f?style=for-the-badge&logo=android" alt="Download APK" />
  </a>
</p>

<hr>

## 📸 App Showcase

### Onboarding & User Profiling
<p align="center">
  <table>
    <tr>
      <td align="center"><strong>Splash</strong></td>
      <td align="center"><strong>Onboarding</strong></td>
      <td align="center"><strong>User Metrics</strong></td>
    </tr>
    <tr>
      <td><img src="LINK_TO_SPLASH" width="250" alt="Splash"/></td>
      <td><img src="LINK_TO_ONBOARDING" width="250" alt="Onboarding"/></td>
      <td><img src="LINK_TO_USER_INPUT" width="250" alt="Metrics"/></td>
    </tr>
  </table>
</p>

### Training & Nutrition
<p align="center">
  <table>
    <tr>
      <td align="center"><strong>Home</strong></td>
      <td align="center"><strong>Workouts</strong></td>
      <td align="center"><strong>Nutrition Details</strong></td>
    </tr>
    <tr>
      <td><img src="LINK_TO_HOME" width="250" alt="Home"/></td>
      <td><img src="LINK_TO_WORKOUTS" width="250" alt="Workouts"/></td>
      <td><img src="LINK_TO_FOOD" width="250" alt="Nutrition"/></td>
    </tr>
  </table>
</p>

### Smart Coaching (AI Chat)
<p align="center">
  <table>
    <tr>
      <td align="center"><strong>Smart Coach Chat</strong></td>
      <td align="center"><strong>Historical Sessions</strong></td>
    </tr>
    <tr>
      <td><img src="LINK_TO_CHAT" width="250" alt="AI Chat"/></td>
      <td><img src="LINK_TO_PREVIOUS" width="250" alt="History"/></td>
    </tr>
  </table>
</p>

## 🌟 Core Features

* 🔐 **Personalized Onboarding:** Tailored experience where users input weight, height, age, and goals to generate a customized fitness profile.
* 🏋️ **Dynamic Workout Engine:** Browse extensive libraries of exercises with detailed instructions and difficulty levels.
* 🥗 **Nutrition & Meal Plans:** Intelligent food recommendations with detailed ingredient lists and caloric tracking.
* 🤖 **Smart Coach (AI Integration):** A dedicated chat interface for instant fitness advice and motivation.
* 📊 **Progress Visualization:** Real-time feedback on user activities and upcoming workout schedules.

## 🧠 Key Engineering Highlights

### 1. Data-Driven Personalization Flow
The onboarding process isn't just UI; it's a **Dynamic Profile Generator**. 
- Using a dedicated `OnboardingCubit`, we capture user metrics (Height, Weight, Goals) and calculate BMI and TDEE in real-time.
- This data is then used as a seed for the Firebase Firestore profile to tailor the recommended workouts.

### 2. Clean Architecture & Scalability
The app is built using **Domain-Driven Design (DDD)** principles within Clean Architecture:
- **Presentation Layer:** Decoupled UI components using BLoC for business logic.
- **Domain Layer:** Pure Dart entities and use-cases that define "What" the app does, making it 100% testable.
- **Data Layer:** Implements repositories and handles API/Firebase communication with a clear separation of concerns.

### 3. Optimized Asset Management
Fitness apps are visual-heavy. To maintain **60 FPS performance**:
- **Lazy Loading & Pagination:** Implemented on workout lists to ensure low memory consumption.
- **Image Caching:** Using `CachedNetworkImage` to reduce network overhead for food and exercise thumbnails.
- **Lottie Animations:** Used for smooth, lightweight transitions in the splash and onboarding screens.

### 4. Smart Chat Interaction (State Preservation)
The "Smart Coach" feature uses a reactive BLoC-based messaging system:
- **Message Persistence:** Chat history is managed through Firestore to ensure users can resume conversations across devices.
- **Debounced Inputs:** To prevent excessive API calls during real-time interactions.

## ⚙️ Tech Stack & Dependencies

* **Core:** Flutter, Dart.
* **State Management:** BLoC / Cubit.
* **Backend:** Firebase (Auth, Firestore, Messaging).
* **DI:** Get_it & Injectable.
* **Networking:** Dio & Retrofit.
* **UI Utilities:** Google Fonts, Lottie, Flutter ScreenUtil.

<hr>

## 🤝 The Team
**Built by a dedicated team of engineers.**

**Mohamed Ibrahim** [![Linkedin](...)]() | [![GitHub](...)]()
**Ahmed Hussien** [![Linkedin](...)]() | [![GitHub](...)]()
**Malak Hussien** [![Linkedin](...)]() | [![GitHub](...)]()
**Nagham Arafa** [![Linkedin](...)]() | [![GitHub](...)]()
