# 🧮 BMI Calculator App

A *Flutter* application that helps users calculate their *Body Mass Index (BMI)* based on health input data and track progress over time with *local history* and *analytics charts*.

---

## 📲 Features

- ✅ Input personal details: Name, Age, Gender, Height, and Weight
- 🔁 Unit switch: Metric (cm/kg) or Imperial (in/lbs)
- ⚖ Calculate BMI and get instant health categorization
- 🕒 History screen to track past BMI calculations (stored locally)
- 📊 Analytics screen with:
  - Average BMI
  - Count of users in each category
  - Line chart of BMI over time
- 🧭 Bottom Navigation Bar to switch between screens
- 🧹 Option to delete BMI history

---

## 🏥 BMI Categories Used

| Category      | BMI Range       |
|---------------|-----------------|
| Underweight   | < 18.5          |
| Normal        | 18.5 – 24.9     |
| Overweight    | 25.0 – 29.9     |
| Obese         | 30.0 and above  |

---

## 📷 Screenshots



---![WhatsApp Image 2025-06-28 at 03 10 44_00ec84e0](https://github.com/user-attachments/assets/a8d31bd0-44d0-4cad-8b9b-f89ce2f973af)

![WhatsApp Image 2025-06-28 at 03 10 44_c8d236ca](https://github.com/user-attachments/assets/4b1ab6db-287a-4994-ad8f-db8e0aab3a90)


![WhatsApp Image 2025-06-28 at 03 10 44_688723d5](https://github.com/user-attachments/assets/0227bdd3-5c84-4334-9025-e00f13f8026e)

## 🧪 Sample Test Data

| Name            | Age | Height (cm) | Weight (kg) | BMI   | Category    |
|-----------------|-----|-------------|-------------|-------|-------------|
| Rohan Patel     | 22  | 180         | 54          | 16.7  | Underweight |
| Nidhi Sharma    | 30  | 165         | 58          | 21.3  | Normal      |
| Sameer Bansal   | 35  | 175         | 78          | 25.5  | Overweight  |
| Fatima Sheikh   | 40  | 160         | 90          | 35.2  | Obese       |

---

## 🧰 Technologies & Packages

- *Flutter* 3.x
- *Dart*
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [fl_chart](https://pub.dev/packages/fl_chart)

---

## 🛠 Setup Instructions
## 🔁 Clone the Repository

To get a local copy up and running, run the following command in your terminal:

```bash
git clone https://github.com/your-username/BMI-Calculator.git
cd BMI-Calculator
## 📦 Install Dependencies

Before running the app, make sure to install all required Flutter dependencies:

```bash
flutter pub get
## 📱 Note: Running the App

To run the BMI Calculator app on your device, make sure to *do one of the following*:

- ✅ Connect a physical Android/iOS device with *USB debugging enabled*
  
  - For Android: Enable Developer Options → USB Debugging
  - For iOS: Trust the connected device and enable debugging via Xcode 

*OR*

- 💻 Launch a virtual device/emulator:

  - For Android: Use *Android Virtual Device (AVD)* via Android Studio
  - For iOS: Use the *Simulator* from Xcode
## 🚀 Run the App

To launch the Flutter app on your connected device or emulator, use the following command:

```bash
flutter run
