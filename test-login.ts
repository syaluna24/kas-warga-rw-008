import * as bcrypt from 'bcrypt'
import { PrismaClient } from '@prisma/client'
import * as path from 'path'

const prisma = new PrismaClient({
  datasources: {
    db: {
      url: 'file:' + path.join(process.cwd(), 'db', 'custom.db')
    }
  }
})

async function main() {
  console.log('=== Testing Login ===')
  
  const testPassword = '123456'
  const users = await prisma.user.findMany()
  
  console.log('Users in database:', users.length)
  
  for (const user of users) {
    console.log('\n--- Testing user:', user.username, '---')
    console.log('Role:', user.role)
    console.log('RT/RW:', user.nama_rt)
    
    // Test password comparison
    const isValid = await bcrypt.compare(testPassword, user.password)
    console.log('Password "123456" valid:', isValid ? 'YES' : 'NO')
    
    if (isValid) {
      console.log('✓ User can login with password: 123456')
    } else {
      console.log('✗ Login FAILED for password: 123456')
    }
  }
}

main().catch(console.error)
