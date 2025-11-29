# HairTech

**HairTech** is a mobile application that allows users to track their hair care routines and analyzes their posture to help them learn correct techniques.

---

## Technology Stack

- **Flutter**  
  Flutter was chosen for application development. This allows:
  - Fast rendering  
  - Deployment to both iOS and Android from a single codebase

- **Firebase (Backend & Database)**  
  Google Firebase is used for backend and database infrastructure. Reasons for choice:  
  - Easy integration  
  - Cloud-based reliable data management  
  - Simplified photo upload and storage

- **Google ML Kit**  
  - Face Detection (Euler Angles)  
  - Posture Detection (Shoulder Landmarks)  
  User's position is analyzed in real-time.

- **Sensors Plus**  
  - Measures phone tilt (accelerometerEventStream())  
  - Combines with ML outputs for accurate guidance

- **Camera Package & flutter_tts**  
  - Real-time camera feed analysis  
  - Instant voice commands via flutter_tts  
  - Helps the user achieve the correct posture

---

### Patient Interface
(screenshots/patient)

### Doctor Interface
(screenshots/doctor)

---

## Installation

1. Flutter SDK must be installed: [Flutter Installation](https://flutter.dev/docs/get-started/install)  
2. Create a Firebase project and add `google-services.json` / `GoogleService-Info.plist` to the respective directories  
3. Install dependencies:  
```bash
flutter pub get
