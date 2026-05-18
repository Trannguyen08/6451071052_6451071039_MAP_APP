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
    throw new Error(
      'Missing Firebase credentials. Set FIREBASE_SERVICE_ACCOUNT_PATH or FIREBASE_SERVICE_ACCOUNT_JSON.',
    );
  }
}

const db = getFirestore(admin.app(), process.env.FIREBASE_DATABASE_NAME || 'fastfood');
const now = new Date();
const daysAgo = (days, hour = 12) => {
  const date = new Date(now);
  date.setDate(date.getDate() - days);
  date.setHours(hour, 0, 0, 0);
  return date;
};

const categories = [
  { id: 'burger', name: 'Burger', icon: '🍔' },
  { id: 'pizza', name: 'Pizza', icon: '🍕' },
  { id: 'chicken', name: 'Gà rán', icon: '🍗' },
  { id: 'drinks', name: 'Đồ uống', icon: '🥤' },
  { id: 'salad', name: 'Salad', icon: '🥗' },
];

const products = [
  {
    id: 'prd-burger-cheese',
    name: 'Burger bò phô mai',
    description: 'Bò nướng, cheddar, sốt đặc biệt.',
    price: 85000,
    imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
    categoryId: 'burger',
    brand: 'FoodHero Burger',
    isAvailable: true,
  },
  {
    id: 'prd-burger-double',
    name: 'Double beef burger',
    description: 'Hai lớp bò nướng, hành caramel, phô mai.',
    price: 119000,
    imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=800',
    categoryId: 'burger',
    brand: 'FoodHero Burger',
    isAvailable: true,
  },
  {
    id: 'prd-pizza-seafood',
    name: 'Pizza hải sản',
    description: 'Tôm, mực, sốt pesto và phô mai.',
    price: 155000,
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
    categoryId: 'pizza',
    brand: 'Pizza House',
    isAvailable: true,
  },
  {
    id: 'prd-pizza-pepperoni',
    name: 'Pizza pepperoni',
    description: 'Pepperoni cay nhẹ, mozzarella kéo sợi.',
    price: 139000,
    imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=800',
    categoryId: 'pizza',
    brand: 'Pizza House',
    isAvailable: true,
  },
  {
    id: 'prd-chicken-crispy',
    name: 'Gà rán giòn',
    description: 'Gà ướp cay, vỏ giòn rụm.',
    price: 49000,
    imageUrl: 'https://images.unsplash.com/photo-1562967916-eb82221dfb92?w=800',
    categoryId: 'chicken',
    brand: 'Crispy Chicken',
    isAvailable: true,
  },
  {
    id: 'prd-chicken-wings',
    name: 'Cánh gà sốt cay',
    description: '6 cánh gà phủ sốt buffalo.',
    price: 79000,
    imageUrl: 'https://images.unsplash.com/photo-1608039755401-742074f0548d?w=800',
    categoryId: 'chicken',
    brand: 'Crispy Chicken',
    isAvailable: true,
  },
  {
    id: 'prd-drink-cola',
    name: 'Coca-Cola',
    description: 'Lon 330ml mát lạnh.',
    price: 18000,
    imageUrl: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=800',
    categoryId: 'drinks',
    brand: 'Coca-Cola',
    isAvailable: true,
  },
  {
    id: 'prd-drink-orange',
    name: 'Nước cam',
    description: 'Cam ép tươi 350ml.',
    price: 32000,
    imageUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=800',
    categoryId: 'drinks',
    brand: 'Fresh Bar',
    isAvailable: true,
  },
  {
    id: 'prd-salad-caesar',
    name: 'Caesar salad',
    description: 'Xà lách, gà nướng, parmesan.',
    price: 69000,
    imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=800',
    categoryId: 'salad',
    brand: 'Green Bowl',
    isAvailable: true,
  },
  {
    id: 'prd-salad-tuna',
    name: 'Salad cá ngừ',
    description: 'Cá ngừ, trứng, rau củ tươi.',
    price: 76000,
    imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
    categoryId: 'salad',
    brand: 'Green Bowl',
    isAvailable: false,
  },
];

const users = [
  {
    id: 'demo-user-001',
    fullName: 'Nguyễn An Nhiên',
    email: 'annhien.demo@gmail.com',
    phoneNumber: '0901234567',
    avatar: 'https://i.pravatar.cc/150?img=1',
    status: 'active',
    isBlocked: false,
    isVerified: true,
  },
  {
    id: 'demo-user-002',
    fullName: 'Trần Văn Tú',
    email: 'vantu.demo@gmail.com',
    phoneNumber: '0988776554',
    avatar: 'https://i.pravatar.cc/150?img=2',
    status: 'blocked',
    isBlocked: true,
    isVerified: true,
  },
  {
    id: 'demo-user-003',
    fullName: 'Lê Thu Thảo',
    email: 'thuthao.demo@gmail.com',
    phoneNumber: '0345678901',
    avatar: 'https://i.pravatar.cc/150?img=3',
    status: 'active',
    isBlocked: false,
    isVerified: true,
  },
  {
    id: 'demo-user-004',
    fullName: 'Hoàng Minh Anh',
    email: 'minhanh.demo@gmail.com',
    phoneNumber: '0912334455',
    avatar: 'https://i.pravatar.cc/150?img=4',
    status: 'active',
    isBlocked: false,
    isVerified: true,
  },
];

const orders = [
  {
    id: 'demo-order-1001',
    orderCode: '#FH-1001',
    userId: 'demo-user-001',
    customerName: 'Nguyễn An Nhiên',
    customerPhone: '0901234567',
    payment: 'cash',
    items: [
      { productId: 'prd-burger-cheese', productName: 'Burger bò phô mai', quantity: 2, price: 85000 },
      { productId: 'prd-drink-cola', productName: 'Coca-Cola', quantity: 2, price: 18000 },
    ],
    totalAmount: 206000,
    status: 'completed',
    createdAt: daysAgo(6, 11),
  },
  {
    id: 'demo-order-1002',
    orderCode: '#FH-1002',
    userId: 'demo-user-003',
    customerName: 'Lê Thu Thảo',
    customerPhone: '0345678901',
    payment: 'online',
    items: [
      { productId: 'prd-pizza-seafood', productName: 'Pizza hải sản', quantity: 1, price: 155000 },
      { productId: 'prd-drink-orange', productName: 'Nước cam', quantity: 2, price: 32000 },
    ],
    totalAmount: 219000,
    status: 'delivered',
    createdAt: daysAgo(4, 19),
  },
  {
    id: 'demo-order-1003',
    orderCode: '#FH-1003',
    userId: 'demo-user-004',
    customerName: 'Hoàng Minh Anh',
    customerPhone: '0912334455',
    payment: 'cash',
    items: [
      { productId: 'prd-chicken-wings', productName: 'Cánh gà sốt cay', quantity: 1, price: 79000 },
      { productId: 'prd-salad-caesar', productName: 'Caesar salad', quantity: 1, price: 69000 },
    ],
    totalAmount: 148000,
    status: 'processing',
    createdAt: daysAgo(2, 18),
  },
  {
    id: 'demo-order-1004',
    orderCode: '#FH-1004',
    userId: 'demo-user-001',
    customerName: 'Nguyễn An Nhiên',
    customerPhone: '0901234567',
    payment: 'online',
    items: [
      { productId: 'prd-pizza-pepperoni', productName: 'Pizza pepperoni', quantity: 1, price: 139000 },
    ],
    totalAmount: 139000,
    status: 'pending_payment',
    createdAt: daysAgo(1, 20),
  },
  {
    id: 'demo-order-1005',
    orderCode: '#FH-1005',
    userId: 'demo-user-002',
    customerName: 'Trần Văn Tú',
    customerPhone: '0988776554',
    payment: 'cash',
    items: [
      { productId: 'prd-burger-double', productName: 'Double beef burger', quantity: 1, price: 119000 },
    ],
    totalAmount: 119000,
    status: 'cancelled',
    createdAt: daysAgo(1, 14),
  },
  {
    id: 'demo-order-1006',
    orderCode: '#FH-1006',
    userId: 'demo-user-003',
    customerName: 'Lê Thu Thảo',
    customerPhone: '0345678901',
    payment: 'cash',
    items: [
      { productId: 'prd-chicken-crispy', productName: 'Gà rán giòn', quantity: 2, price: 49000 },
      { productId: 'prd-drink-cola', productName: 'Coca-Cola', quantity: 1, price: 18000 },
    ],
    totalAmount: 116000,
    status: 'pending',
    createdAt: daysAgo(0, 10),
  },
];

async function upsertCollection(collectionName, docs) {
  const batch = db.batch();
  docs.forEach(({ id, ...data }) => {
    const ref = db.collection(collectionName).doc(id);
    batch.set(
      ref,
      {
        ...data,
        updatedAt: now,
        createdAt: data.createdAt || now,
      },
      { merge: true },
    );
  });
  await batch.commit();
}

async function main() {
  await upsertCollection('categories', categories);
  await upsertCollection('products', products);
  await upsertCollection('users', users);
  await upsertCollection('orders', orders);

  console.log('Seeded demo data successfully.');
  console.log(
    JSON.stringify(
      {
        categories: categories.length,
        products: products.length,
        users: users.length,
        orders: orders.length,
      },
      null,
      2,
    ),
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error('Seed failed:', error);
    process.exit(1);
  });
