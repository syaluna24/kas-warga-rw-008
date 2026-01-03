# 🚀 Deployment Guide - Deploy Kas Warga ke Railway

## 📋 Apa yang Telah Disiapkan

### ✅ Konfigurasi yang Sudah Dibuat
1. ✅ `railway.json` - Konfigurasi build dan deploy ke Railway
2. ✅ `.railwayignore` - File-file yang di-ignore saat deploy
3. ✅ `prisma/schema.prisma` - Di-update ke PostgreSQL
4. ✅ Prisma Client - Generated untuk PostgreSQL

---

## 🔧 Langkah 1: Login ke Railway

### A. Buat Akun Railway (jika belum ada)
1. Buka: https://railway.app/
2. Klik tombol **"Login"** di kanan atas
3. Pilih salah satu cara login:
   - **GitHub** (Disarankan) - Login dengan akun GitHub Anda
   - **Email** - `sigitprastiya56@gmail.com`
   - **Google** - Jika akun Google sudah terhubung

### B. Verifikasi Akun
1. Cek email untuk verifikasi (jika menggunakan email)
2. Klik link verifikasi di email

---

## 🚨 PENTING: Database Cloud vs Lokal

### Perbedaan Database:
- **Lokal (Sebelumnya)**: SQLite - file `custom.db` di folder `db/`
- **Railway (Sekarang)**: PostgreSQL - database cloud di server Railway

### Implikasi Perubahan:
1. ✅ **Tidak ada file database lokal** - Data akan disimpan di cloud
2. ✅ **Connection via Environment Variable** - Railway akan otomatis mengatur `DATABASE_URL`
3. ✅ **Migration Otomatis** - Railway akan menjalankan `prisma db push` saat deploy
4. ✅ **Production Ready** - Database lebih scalable dan handal

---

## 🔧 Langkah 2: Buat Project Database di Railway

### A. Buat Project Baru
1. Di Railway Dashboard, klik **"New Project"**
2. Isi form:
   - **Name**: `kas-warga-rw-008`
   - **Region**: Pilih yang terdekat (Singapore / Tokyo)
3. Klik **"Create Project"**

### B. Tambah Database PostgreSQL
1. Di dalam project, klik **"New Service"**
2. Pilih **"Database"**
3. Pilih **"PostgreSQL"** (pilih icon gajah/elephant)
4. Konfigurasi:
   - **Name**: `kas-warga-db`
5. Klik **"Create Database"**

### C. Ambil Database URL
1. Klik service database yang baru saja dibuat
2. Pilih tab **"Variables"**
3. Copy **DATABASE_URL** (berbentuk: `postgres://postgres.xxxx:password@containers-us-west-xxx.railway.app:5432/railway`)
4. **CATAT/SAVE** URL ini! Akan digunakan untuk seed data user.

---

## 📝 Langkah 3: Push Kode ke GitHub

### A. Inisialisasi Git (jika belum)
Di terminal `/home/z/my-project`:

```bash
git init
git add .
git commit -m "Ready for Railway deploy - Kas Warga RW 008 (PostgreSQL)"
```

### B. Create Repository di GitHub
1. Login ke: https://github.com
2. Klik **"+"** di kanan atas
3. Pilih **"New repository"**
4. Isi:
   - **Repository name**: `kas-warga-rw-008`
   - **Description**: Sistem Manajemen Kas Warga RW 008 - Railway Deployment
   - **Public/Private**: Private (lebih aman)
5. Klik **"Create repository"**

### C. Push ke GitHub
```bash
git remote add origin https://github.com/USERNAME/kas-warga-rw-008.git
git branch -M main
git push -u origin main
```

*Ganti `USERNAME` dengan username GitHub Anda.*

---

## 🚀 Langkah 4: Deploy ke Railway

### Opsi A: Deploy via CLI (Disarankan - Lebih Cepat)

#### A. Install Railway CLI (jika belum ada)
```bash
bun install -g @railway/cli
```

#### B. Login ke Railway
```bash
railway login
```
Anda akan diarahkan ke browser untuk authorize.

#### C. Init dan Deploy
Di terminal `/home/z/my-project`:

```bash
railway init
railway up
```

Railway akan otomatis:
1. Scan project dan build command
2. Create service di Railway
3. Deploy aplikasi
4. Generate URL deployment

---

### Opsi B: Deploy via GitHub (Manual - Lebih Terkontrol)

#### A. Connect GitHub ke Railway
1. Di Railway Dashboard, klik **"New Project"**
2. Pilih **"Deploy from GitHub repo"**
3. Authorize Railway untuk akses repository GitHub Anda
4. Pilih repository: `kas-warga-rw-008`
5. Pilih branch: `main`
6. Klik **"Deploy Now"**

Railway akan otomatis:
1. Detect Next.js project
2. Build application
3. Create deployment
4. Generate URL

---

## ⚙️ Langkah 5: Setup Environment Variables

### A. Add DATABASE_URL (Manual Jika CLI Tidak Melakukannya)
1. Di Railway Dashboard, pilih project `kas-warga-rw-008`
2. Klik tab **"Variables"**
3. Klik **"New Variable"**
4. Isi:
   - **Name**: `DATABASE_URL`
   - **Value**: [Paste DATABASE_URL dari service database]
   - **Scope**: All (centang semua)
5. Klik **"Add Variable"**

### B. Other Variables (Opsional)
Tidak perlu menambah environment variables lain karena `DATABASE_URL` sudah mencakup semua.

---

## 📊 Langkah 6: Seed Data User (PENTING!)

Setelah deploy selesai, database akan KOSONG. Anda perlu menjalankan script seed untuk membuat user bendahara.

### Opsi A: Via Railway Console (Disarankan)

#### A. Buka Railway Console
1. Di Railway Dashboard, pilih project
2. Klik service aplikasi (bukan database)
3. Klik tab **"Console"**
4. Anda akan melihat terminal

#### B. Run Seed Script
Di Railway Console (shell):

```bash
bun run prisma/seed.ts
```

Atau jika `bun` tidak tersedia:

```bash
node prisma/seed.js
```

### Opsi B: Via Prisma Studio (GUI)

1. Di Railway Dashboard, pilih service database
2. Klik **"Open Prisma Studio"**
3. Anda akan melihat GUI database
4. Pilih model **"User"**
5. Klik **"Add record"**
6. Isi data untuk 4 user:

**User 1 (RT 001):**
- id: 1
- username: `tri`
- password: `$2b$10$SALT-HASH-PASSWORD` (Harus di-hash dulu!)
- nama_rt: `RT 001`
- role: `bendahara_rt`

**User 2 (RT 002):**
- id: 2
- username: `aryan`
- password: `$2b$10$SALT-HASH-PASSWORD`
- nama_rt: `RT 002`
- role: `bendahara_rt`

**User 3 (RT 003):**
- id: 3
- username: `imam`
- password: `$2b$10$SALT-HASH-PASSWORD`
- nama_rt: `RT 003`
- role: `bendahara_rt`

**User 4 (RW 008):**
- id: 4
- username: `reza`
- password: `$2b$10$SALT-HASH-PASSWORD`
- nama_rt: `RW 008`
- role: `bendahara_rw`

**CATAT**: Password harus di-hash menggunakan bcrypt. Jalankan script ini untuk generate hash password `123456`:

```bash
node -e "const bcrypt = require('bcrypt'); const salt = bcrypt.genSaltSync(10); const hash = bcrypt.hashSync('123456', salt); console.log(hash);"
```

### Opsi C: Via Railway Environment Variables

1. Di Railway Console, jalankan:
```bash
npx prisma db seed --force
```

---

## ✅ Langkah 7: Verify Deployment

### A. Cek Deployment Status
1. Di Railway Dashboard, pilih project
2. Cek tab **"Deployments"**
3. Pastikan deployment terakhir **SUCCESS** (warna hijau)
4. Cek log jika ada error

### B. Cek Environment Variables
1. Klik tab **"Variables"**
2. Pastikan `DATABASE_URL` sudah ada
3. Pastikan scope sudah **All** (centang semua)

### C. Cek Logs
1. Klik tab **"Logs"**
2. Lihat ada error atau tidak
3. Search keyword: `Error`, `Failed`, `500`

### D. Test Akses Aplikasi
1. Buka URL deployment Railway
   - Berbentuk: `https://app-name.railway.app`
   - Contoh: `https://kas-warga-rw-008-production.up.railway.app`
2. Akses: `/login`
3. Login dengan: `tri` / `123456`
4. Cek apakah bisa login dan diarahkan ke dashboard

---

## 🛠️ Troubleshooting

### Masalah 1: "Error: Cannot find module '@prisma/client'"
**Solusi**:
1. Jalankan: `bun run db:generate`
2. Commit dan push ulang
3. Redeploy di Railway

### Masalah 2: "Error: P1001: Can't reach database server"
**Solusi**:
1. Cek `DATABASE_URL` environment variable di Railway
2. Pastikan database service sudah berjalan
3. Cek apakah service database tidak mati

### Masalah 3: Login Gagal - "Username atau password salah"
**Solusi**:
1. Pastikan seed script sudah dijalankan
2. Cek table User di Prisma Studio
3. Pastikan password sudah di-hash dengan benar
4. Login dengan username/password yang benar

### Masalah 4: "Error: 404 Page Not Found"
**Solusi**:
1. Cek build logs di Railway
2. Pastikan Next.js berhasil di-build
3. Cek root directory (harus `/` bukan sub-folder)

### Masalah 5: Deployment Gagal - "Build Error"
**Solusi**:
1. Cek `railway.json` configuration
2. Pastikan `buildCommand` benar
3. Cek dependency di `package.json`
4. Pastikan Node.js version kompatibel

---

## 📞 Bantuan dan Resources

### Railway Docs
- Website: https://railway.app/docs
- CLI Guide: https://railway.app/cli
- Pricing: https://railway.app/pricing

### Prisma Docs
- Website: https://www.prisma.io/docs
- Railway Guide: https://www.prisma.io/docs/guides/deployment/deploy-to-railway

### Next.js Docs
- Deployment: https://nextjs.org/docs/deployment

---

## 🎯 Ringkasan Akun

| RT/RW | Username | Password | Role |
|-------|----------|----------|------|
| RT 001 | `tri` | `123456` | Bendahara RT |
| RT 002 | `aryan` | `123456` | Bendahara RT |
| RT 003 | `imam` | `123456` | Bendahara RT |
| RW 008 | `reza` | `123456` | Bendahara RW |

---

## ⚠️ PENTING: Setelah Deploy Sukses

### 1. Simpan URL Deployment
URL Railway Anda akan berbentuk:
```
https://[random-name].up.railway.app
```
Simpan URL ini!

### 2. Jalankan Seed Script
Database akan KOSONG setelah deploy. Anda WAJIB menjalankan seed script untuk membuat user bendahara:
```bash
# Via Railway Console
bun run prisma/seed.ts
```

### 3. Test Aplikasi
1. Buka URL Railway
2. Login dengan user bendahara
3. Kelola data warga
4. Kelola pemasukan/pengeluaran
5. Lihat laporan

---

## 🚀 Aplikasi Siap Di-deploy ke Railway!

Berikut adalah checklist yang perlu Anda lakukan:

### 📋 Checklist Deployment:

- [ ] Login ke Railway dengan email `sigitprastiya56@gmail.com`
- [ ] Push kode ke GitHub
- [ ] Connect GitHub ke Railway / atau gunakan Railway CLI
- [ ] Deploy aplikasi ke Railway
- [ ] Create database PostgreSQL di Railway
- [ ] Setup `DATABASE_URL` environment variable
- [ ] Jalankan seed script via Railway Console
- [ ] Test login dengan `tri` / `123456`
- [ ] Test semua fitur aplikasi
- [ ] Simpan URL deployment

---

## 💡 Tips

1. ✅ **Gunakan Railway CLI** - Lebih cepat dan terautomasi
2. ✅ **Monitor Logs** - Cek Railway Logs untuk error
3. ✅ **Gunakan Prisma Studio** - GUI database sangat membantu
4. ✅ **Auto-redeploy** - Setiap push ke GitHub akan trigger deploy baru
5. ✅ **Custom Domain** - Setelah berhasil deploy, bisa tambahkan domain sendiri

---

**Selamat Deploy ke Railway! Aplikasi Anda akan live di Railway dengan database PostgreSQL cloud yang scalable dan reliable.** 🎉
