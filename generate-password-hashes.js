// Script untuk generate hash password untuk PostgreSQL
const bcrypt = require('bcrypt');

const passwordsToHash = [
  { username: 'tri', password: '123456' },
  { username: 'aryan', password: '123456' },
  { username: 'imam', password: '123456' },
  { username: 'reza', password: '123456' }
];

console.log('=== PASSWORD HASHES FOR POSTGRESQL ===\n');

passwordsToHash.forEach(user => {
  const salt = bcrypt.genSaltSync(10);
  const hash = bcrypt.hashSync(user.password, salt);
  
  console.log(`INSERT INTO "User" (username, password, nama_rt, role, "createdAt", "updatedAt")`);
  console.log(`VALUES ('${user.username}', '${hash}', '${user.username === 'tri' ? 'RT 001' : user.username === 'aryan' ? 'RT 002' : user.username === 'imam' ? 'RT 003' : 'RW 008'}', '${user.username === 'tri' ? 'bendahara_rt' : user.username === 'aryan' ? 'bendahara_rt' : user.username === 'imam' ? 'bendahara_rt' : 'bendahara_rw'}', NOW(), NOW());\n`);
});

console.log('\n=== SEED SQL COMMANDS ===\n');
console.log('Copy semua perintah di atas dan jalankan di Railway Database Console atau Prisma Studio\n');
