## Persiapan Project Antrian

1. Local Server Laragon/Xampp 
2. Composer
3. Git
4. Node.js
5. php version >= 8.2

## Setup Project Antrian

Perhatikan untuk menjalankan atau mensetup project ini.

### Traditional Setup

1. Buat database terlebih dahulu
2. Konfigurasikan file .env dengan database yang telah dibuat
3. Import Database dengan file antrian.sql pada projek
4. Jalankan perintah `php artisan serve` untuk menjalankan projek
5. Buka browser dan kunjungi link http://127.0.0.1:8000
6. Login dengan email (admin@gmail.com) dan password (admin123)

### Docker Setup (Recommended)

For a standalone Docker application, follow these steps:

1. Pastikan Docker dan Docker Compose sudah terinstall
2. Jalankan perintah `docker-compose up -d` untuk memulai container
3. Akses aplikasi di browser melalui http://localhost:8000
4. Login dengan email (admin@gmail.com) dan password (admin123)

Aplikasi siap di gunakan....