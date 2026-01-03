-- COPY SEMUA PERINTAH INI DAN JALANKAN DI RAILWAY DATABASE CONSOLE

-- USER 1 (RT 001)
INSERT INTO "User" (username, password, nama_rt, role, "createdAt", "updatedAt")
VALUES ('tri', '$2b$10$Yiu3AdFLnPnr1jY1Gdf8T.cAA4p3g0GbY005gW5BWC4/gUWgHhgNW', 'RT 001', 'bendahara_rt', datetime('now'), datetime('now'));

-- USER 2 (RT 002)
INSERT INTO "User" (username, password, nama_rt, role, "createdAt", "updatedAt")
VALUES ('aryan', '$2b$10$6PxmY4tFAjLlN0iXPzPPluPksDQWAXvLcl.d.0UpKeJKNPSP7V3se', 'RT 002', 'bendahara_rt', datetime('now'), datetime('now'));

-- USER 3 (RT 003)
INSERT INTO "User" (username, password, nama_rt, role, "createdAt", "updatedAt")
VALUES ('imam', '$2b$10$JXzEcnVSPAk.ZvgyYoD88.vpFpk51ZRakCgQkVoyLVsrM54Q42DOK', 'RT 003', 'bendahara_rt', datetime('now'), datetime('now'));

-- USER 4 (RW 008)
INSERT INTO "User" (username, password, nama_rt, role, "createdAt", "updatedAt")
VALUES ('reza', '$2b$10$ARj1oAdF.2BjT/9DMj4Q/egRLZUX.GubG.8ZVC.RrSxd2twOE/AaK', 'RW 008', 'bendahara_rw', datetime('now'), datetime('now'));
