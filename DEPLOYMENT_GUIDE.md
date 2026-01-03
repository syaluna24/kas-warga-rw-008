# 🚀 Deployment Guide - Deploy Kas Warga ke Vercel

## 📋 Prasyarat Sebelum Deploy

Sebelum deploy ke Vercel, Anda harus memiliki:

### 1. ✅ Akun GitHub
- Daftar di: https://github.com/signup
- Gratis untuk repository publik/private

### 2. ✅ Akun Vercel
- Daftar di: https://vercel.com/signup
- Gratis untuk deploy aplikasi

### 3. ✅ Database Cloud (Supabase)
- Daftar di: https://supabase.com/signup
- Gratis untuk database PostgreSQL (500MB)

---

## 🔧 Langkah 1: Setup Database Cloud (Supabase)

### A. Buat Project Supabase
1. Login ke: https://supabase.com
2. Klik "New Project"
3. Isi form:
   - **Name**: `kas-warga-rw-008`
   - **Database Password**: Buat password yang kuat (catat/simpan!)
   - **Region**: Pilih yang terdekat (Southeast Asia)
4. Klik "Create new project"
5. Tunggu database siap (sekitar 1-2 menit)

### B. Copy DATABASE_URL
1. Di sidebar, klik "Settings" → "Database"
2. Scroll ke section "Connection String"
3. Copy "Connection String" yang berbentuk:
   ```
   postgres://postgres.xxxx:[YOUR-PASSWORD]@aws-0-ap-southeast-1.pooler.supabase.com:5432/postgres
   ```

---

## 📝 Langkah 2: Update Prisma Schema untuk PostgreSQL

### A. Edit file `prisma/schema.prisma`
Buka file `/prisma/schema.prisma` dan update seperti ini:

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        Int      @id @default(autoincrement())
  username  String   @unique
  password  String
  nama_rt   String
  role      String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Warga {
  id          Int      @id @default(autoincrement())
  userId      Int
  nama        String
  blok        String
  status      String
  username    String   @unique
  password    String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  @@index([userId])
  @@index([username])

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
}

model Pemasukan {
  id          Int      @id @default(autoincrement())
  userId      Int
  wargaId    Int?
  tanggal     DateTime
  deskripsi   String
  jumlah      Int
  sumber      String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  @@index([userId])
  @@index([tanggal])
  @@index([wargaId])

  warga      Warga?   @relation(fields: [wargaId], references: [id])
}

model Pengeluaran {
  id          Int      @id @default(autoincrement())
  userId      Int
  wargaId    Int?
  tanggal     DateTime
  deskripsi   String
  jumlah      Int
  keperluan   String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  @@index([userId])
  @@index([tanggal])
  @@index([wargaId])

  warga      Warga?   @relation(fields: [wargaId], references: [id])
}
```

---

## 🌐 Langkah 3: Push Kode ke GitHub

### A. Init Repository Git (jika belum)
Di terminal di project root:

```bash
cd /home/z/my-project
git init
git add .
git commit -m "Initial commit - Kas Warga RW 008"
```

### B. Buat Repository GitHub
1. Login ke: https://github.com
2. Klik tombol "+" → "New repository"
3. Isi:
   - **Repository name**: `kas-warga-rw-008`
   - **Description**: Sistem Manajemen Kas Warga RW 008
   - **Visibility**: Private (lebih aman) atau Public
4. Klik "Create repository"
5. Copy repository URL (berbentuk: `https://github.com/username/kas-warga-rw-008.git`)

### C. Push ke GitHub
Di terminal:

```bash
git remote add origin https://github.com/username/kas-warga-rw-008.git
git branch -M main
git push -u origin main
```

Masukkan GitHub username dan password/token saat diminta.

---

## 📦 Langkah 4: Connect Repository ke Vercel

### A. Import di Vercel
1. Login ke: https://vercel.com
2. Klik "Add New" → "Project"
3. Pilih "Import Git Repository"
4. Anda akan diminta untuk install Vercel CLI atau authorize GitHub
5. Authorize Vercel untuk akses repository GitHub Anda
6. Pilih repository `kas-warga-rw-008` yang baru saja dibuat
7. Vercel akan scan repository dan detect Next.js project

### B. Configure Project
1. **Project Name**: `kas-warga-rw-008` (default dari repo)
2. **Framework Preset**: Next.js (auto-detect)
3. **Root Directory**: `./` (root dari repo)
4. Klik "Deploy"

---

## ⚙️ Langkah 5: Setup Environment Variables di Vercel

### A. Add DATABASE_URL
1. Setelah deploy dimulai (atau jika deploy gagal), buka Vercel Dashboard
2. Pilih project `kas-warga-rw-008`
3. Klik tab "Settings"
4. Klik "Environment Variables"
5. Add new variable:
   - **Name**: `DATABASE_URL`
   - **Value**: [Paste DATABASE_URL dari Supabase]
   - **Environment**: Production, Preview, Development (centang semua)
6. Klik "Save"

### B. Other Variables (opsional)
Jika ada environment variables lain, tambahkan dengan cara yang sama.

---

## 🔄 Langkah 6: Deploy Kembali

### A. Redeploy dengan Environment Variables Baru
1. Di Vercel Dashboard, klik tab "Deployments"
2. Klik tombol "Redeploy" di kanan atas deployment terbaru
3. Tunggu proses deploy selesai
4. Vercel akan memberikan URL deployment, contoh: `https://kas-warga-rw-008.vercel.app`

---

## 🗄️ Langkah 7: Setup Database Production

### A. Run Database Migration
Vercel secara otomatis akan:
1. Membuat semua tabel sesuai schema Prisma
2. Setup foreign keys
3. Create indexes

### B. Seed Data Production
1. Buka Vercel Dashboard → Deployments
2. Klik deployment terbaru
3. Cari "Logs" untuk melihat status database
4. Anda perlu menjalankan seed script untuk mengisi data user

**Cara 1: Melalui Vercel Logs**
1. Di terminal, buka Vercel logs:
   ```bash
   vercel logs --follow
   ```
2. Cari endpoint `/api/seed` (jika dibuat)

**Cara 2: Melalui Database Dashboard**
1. Buka Supabase Dashboard → Table Editor
2. Insert user manual:
   ```sql
   INSERT INTO "User" (username, password, nama_rt, role, createdAt, updatedAt)
   VALUES
     ('tri', '$2b$10$YOUR_HASHED_PASSWORD', 'RT 001', 'bendahara_rt', NOW(), NOW()),
     ('aryan', '$2b$10$YOUR_HASHED_PASSWORD', 'RT 002', 'bendahara_rt', NOW(), NOW()),
     ('imam', '$2b$10$YOUR_HASHED_PASSWORD', 'RT 003', 'bendahara_rt', NOW(), NOW()),
     ('reza', '$2b$10$YOUR_HASHED_PASSWORD', 'RW 008', 'bendahara_rw', NOW(), NOW())
   ```

**Note**: Password harus di-hash menggunakan bcrypt. Gunakan online bcrypt tool untuk hash password `123456`.

---

## ✅ Langkah 8: Verify Deployment

### A. Cek Aplikasi
Buka URL deployment: `https://kas-warga-rw-008.vercel.app`

### B. Test Login
1. Buka halaman `/login`
2. Login dengan username: `tri`, password: `123456`
3. Cek apakah bisa login dan diarahkan ke dashboard

### C. Test Fitur
1. Kelola Data Warga - Coba tambah warga baru
2. Kelola Pemasukan - Coba tambah pemasukan
3. Kelola Pengeluaran - Coba tambah pengeluaran
4. Laporan - Cek laporan lengkap

---

## 🔍 Troubleshooting Deployment

### Masalah 1: Deploy Gagal - "Could not find Prisma schema"
**Solusi**: Pastikan file `prisma/schema.prisma` sudah ada di repository dan sudah di-commit.

### Masalah 2: "P1001: Can't reach database server"
**Solusi**: Pastikan DATABASE_URL benar dan connection string Supabase masih valid.

### Masalah 3: Login Gagal - "Username atau password salah"
**Solusi**: Pastikan database production sudah di-seed dengan user yang benar.

### Masalah 4: "Module not found: @prisma/client"
**Solusi**: Jalankan `bun prisma generate` sebelum deploy.

### Masalah 5: "Application error: 500"
**Solusi**: Cek Vercel Logs untuk melihat error detail:
```bash
vercel logs
```

---

## 🎉 Selesai!

Setelah selesai semua langkah di atas, aplikasi Anda sudah live di Vercel dan bisa diakses dari internet!

---

## 📞 Bantuan Tambahan

Jika ada masalah selama deployment:
1. Vercel Docs: https://vercel.com/docs
2. Prisma Docs: https://www.prisma.io/docs
3. Supabase Docs: https://supabase.com/docs
