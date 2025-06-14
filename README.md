
# 🩺 MediTrack – Medicine & Appointment Reminder App

**MediTrack** is a full-featured mobile application developed in **Flutter** that empowers users to manage their medical routines efficiently. Whether it's scheduling doctor appointments, receiving timely medication reminders, or maintaining a medical history – MediTrack serves as your digital healthcare companion.


## 📦 Features

- **🔔 Smart Medicine Reminders**  
  Schedule medicine doses with customizable time, frequency, and duration.

- **📅 Doctor Appointment Management**  
  Book, view, and update upcoming doctor visits.

- **📊 Medication Progress Tracking**  
  Monitor your treatment adherence and view weekly/monthly stats.

- **📝 Medical History Log**  
  Keep a secure and searchable record of past prescriptions and consultations.

- **🛒 Online Medicine Orders** *(upcoming)*  
  Integrated support for ordering medicines from trusted online pharmacies.

- **👤 Secure User Profiles**  
  Users can register, log in, and manage their personal medical data.

- **🔐 Firebase Authentication**  
  Robust and secure sign-in/signup using Firebase Auth.

- **☁️ Cloud Sync with Firestore**  
  Real-time data sync and backup across devices using Firebase Firestore.


## 🧰 Tech Stack

| Layer             | Technology                       |
| ---------------- | -------------------------------- |
| **Frontend**      | Flutter (Dart)                   |
| **State Management** | Riverpod                     |
| **Backend**       | Firebase Authentication & Firestore |
| **Local Database**| Hive (for offline support)       |
| **Architecture**  | Clean Architecture (DDD-style)   |


## 🗂 Project Structure


lib/
├── core/              # Common utilities, constants, error handling
├── config/            # App-wide configurations
├── features/          # Feature-wise separation (modular)
│   ├── auth/          # Authentication logic
│   ├── medicine/      # Medicine reminder logic
│   ├── appointments/  # Doctor appointment scheduling
│   ├── history/       # Medical history handling
│   └── shared/        # Reusable UI & domain models
├── main.dart          # App entry point



## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Latest stable version)
- Firebase Project
- Dart >= 3.0.0
- Android Studio or VSCode

### Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/MediTrack.git
   cd MediTrack

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**

   * Add `google-services.json` to `android/app/`
   * Add `GoogleService-Info.plist` to `ios/Runner/`
   * Enable **Authentication** and **Firestore Database** in Firebase Console.

4. **Run the application:**

   ```bash
   flutter run
   ```


## 📸 UI Showcase

> Based on the original design:
> [MediTrack UI/UX on Behance](https://www.behance.net/gallery/219988471/MediTrack-Medicine-Appointment-Reminder-App-UIUX)

*(Add screenshots or screen recordings here for a visual overview)*


## ✅ Roadmap

| Feature                      | Status         |
| ---------------------------- | -------------- |
| Firebase Authentication      | ✅ Done         |
| Medicine Reminder Scheduling | ✅ Done         |
| Appointment Booking          | ✅ Done         |
| Progress Tracking            | ✅ Done         |
| Medical History              | ✅ Done         |
| Notifications & Alarms       | 🚧 In Progress |
| Online Medicine Ordering     | 🔜 Planned     |
| Dark Mode Support            | 🔜 Planned     |
| Multi-language Support       | 🔜 Planned     |


## 🧪 Testing & Debugging

* Unit testing planned with `flutter_test`
* Mocking data layer using `mockito`
* Use `flutter run --debug` or `flutter logs` for runtime tracking


## 🤝 Contribution

Contributions, feature suggestions, and bug reports are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m 'Add your feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a Pull Request


## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.


## 👨‍💻 Author

**Biniyam Beyene**
Full-Stack Developer | Flutter Enthusiast
[GitHub](https://github.com/your-username) • [LinkedIn](https://linkedin.com/in/your-profile)


> *“MediTrack is more than just a reminder – it’s your personal health assistant in your pocket.”*




