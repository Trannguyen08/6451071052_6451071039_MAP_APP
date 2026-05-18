const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');
const admin = require('firebase-admin');
const { getFirestore } = require('firebase-admin/firestore');

dotenv.config({ path: path.join(__dirname, '../env') });

const serviceAccountPath =
  process.env.FIREBASE_SERVICE_ACCOUNT_PATH ||
  process.env.GOOGLE_APPLICATION_CREDENTIALS;
const serviceAccountJson = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
const resolvedServiceAccountPath = serviceAccountPath
  ? path.isAbsolute(serviceAccountPath)
    ? serviceAccountPath
    : path.join(__dirname, '..', serviceAccountPath)
  : '';

if (!admin.apps.length) {
  if (serviceAccountJson) {
    admin.initializeApp({
      credential: admin.credential.cert(JSON.parse(serviceAccountJson)),
      projectId: process.env.FIREBASE_PROJECT_ID,
    });
  } else if (resolvedServiceAccountPath && fs.existsSync(resolvedServiceAccountPath)) {
    admin.initializeApp({
      credential: admin.credential.cert(require(resolvedServiceAccountPath)),
      projectId: process.env.FIREBASE_PROJECT_ID,
    });
  } else {
    throw new Error('Missing Firebase credentials.');
  }
}

const db = getFirestore(admin.app(), process.env.FIREBASE_DATABASE_NAME || 'fastfood');

async function main() {
  const [categories, products, users, orders] = await Promise.all([
    db.collection('categories').get(),
    db.collection('products').get(),
    db.collection('users').get(),
    db.collection('orders').get(),
  ]);

  const demoOrders = orders.docs.filter((doc) => doc.id.startsWith('demo-order-'));

  console.log(
    JSON.stringify(
      {
        categories: categories.size,
        products: products.size,
        users: users.size,
        orders: orders.size,
        demoOrders: demoOrders.length,
      },
      null,
      2,
    ),
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
