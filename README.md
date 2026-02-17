# 🌿 Menjelajah Lingkungan Sekitar

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**Menjelajah Lingkungan Sekitar** adalah aplikasi game edukasi interaktif yang dirancang untuk membantu anak-anak mengenal dan memahami lingkungan sekitarnya melalui cara yang menyenangkan dan interaktif.

## ✨ Fitur Utama

- 🎮 **Game Edukasi**:
  - **Puzzle Lingkungan**: Susun potongan gambar bertema alam.
  - **Susun Huruf**: Latihan mengeja nama benda-benda di sekitar.
  - **Puzzle Klasik**: Mengasah logika dengan tantangan puzzle yang seru.
- 📚 **Materi Pembelajaran**: Konten edukatif tentang lingkungan alam dan buatan.
- 🏆 **Papan Peringkat (Leaderboard)**: Berkompetisi secara sehat dengan pengguna lain untuk meraih skor tertinggi.
- 🔐 **Autentikasi Aman**: Login dan sinkronisasi data menggunakan Firebase Authentication.
- 🎨 **UI/UX Modern**: Desain yang ceria dengan animasi halus menggunakan Lottie dan Flutter Animate.
- 🎵 **Audio Interaktif**: Efek suara yang meningkatkan pengalaman belajar anak.

## 🚀 Teknologi yang Digunakan

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **Backend**: [Firebase](https://firebase.google.com) (Auth & Firestore)
- **State Management**: Provider
- **Animasi**: Lottie & Flutter Animate
- **Penyimpanan Lokal**: Shared Preferences
- **Asset**: Google Fonts & SVG Icons

## 📂 Struktur Proyek

```text
lib/
├── core/               # Konfigurasi, konstanta, dan utilitas
├── data/               # Layanan Firebase dan model data
├── presentation/       # UI (Pages, Widgets, Screens)
│   ├── pages/
│   │   ├── auth/       # Login & Register
│   │   ├── games/      # Berbagai macam permainan
│   │   ├── materi/     # Konten edukasi
│   │   └── leaderboard/# Papan skor
│   └── widgets/        # Komponen UI global
└── providers/          # Logika aplikasi dan state management
```

## 🛠️ Cara Menjalankan

1. **Clone repositori ini**:
   ```bash
   git clone https://github.com/Rahmat-dkh/game-edukasi.git
   ```
2. **Setup Firebase**:
   - Pastikan Anda sudah memiliki file `google-services.json` (Android) atau `GoogleService-Info.plist` (iOS) dari proyek Firebase Anda.
   - Masukkan file tersebut ke direktori yang sesuai (`android/app` atau `ios/Runner`).
3. **Install dependensi**:
   ```bash
   flutter pub get
   ```
4. **Jalankan aplikasi**:
   ```bash
   flutter run
   ```

## 📸 Cuplikan Layar

*(Tambahkan screenshot aplikasi di sini)*

| Home Screen | Game Puzzle | Leaderboard |
| :---: | :---: | :---: |
| ![Home](https://via.placeholder.com/200x400?text=Home) | ![Game](https://via.placeholder.com/200x400?text=Game) | ![Leaderboard](https://via.placeholder.com/200x400?text=Leaderboard) |

---

Developed with ❤️ for Education.
