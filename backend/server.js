const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

const path = require('path');
const PayOS = require('@payos/node');

dotenv.config({ path: path.join(__dirname, '../env') });

const app = express();
app.use(cors());
app.use(express.json());

// PayOS Initialization
const payos = new PayOS(
  process.env.PAYOS_CLIENT_ID,
  process.env.PAYOS_API_KEY,
  process.env.PAYOS_CHECKSUM_KEY
);

// Mock Data for Cart
let cart = {
  items: [
    {
      id: '1',
      name: 'Bánh Burger Bò Phô Mai',
      options: 'Size L • Thêm thịt nướng',
      price: 85000,
      quantity: 1,
      image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500'
    },
    {
      id: '2',
      name: 'Pizza Hải Sản Pesto',
      options: 'Đế mỏng • Gấp đôi hải sản',
      price: 155000,
      quantity: 1,
      image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500'
    }
  ],
  deliveryInfo: {
    address: '123 Lê Lợi, Phường Bến Thành, Quận 1',
    name: '',
    phone: ''
  },
  paymentMethod: 'cash', // 'cash' or 'online'
  shippingFee: 15000,
  discount: 48000
};

// Helper function to calculate cart totals
const calculateCartTotals = (cart) => {
  const subtotal = cart.items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  const total = subtotal + cart.shippingFee - cart.discount;
  return { ...cart, subtotal, total };
};

// Mock Data for Admin Users
let users = [
  {
    id: 'CUS-2041',
    name: 'Nguyễn An Nhiên',
    email: 'annhien@gmail.com',
    phone: '0901 234 567',
    avatar: 'https://i.pravatar.cc/150?img=1',
    ordersCount: 42,
    totalSpending: 12450000,
    status: 'active'
  },
  {
    id: 'CUS-2038',
    name: 'Trần Văn Tú',
    email: 'vantu.tran@outlook.com',
    phone: '0988 776 554',
    avatar: 'https://i.pravatar.cc/150?img=2',
    ordersCount: 8,
    totalSpending: 1200000,
    status: 'blocked'
  },
  {
    id: 'CUS-2015',
    name: 'Lê Thu Thảo',
    email: 'thao_le99@gmail.com',
    phone: '0345 678 901',
    avatar: 'https://i.pravatar.cc/150?img=3',
    ordersCount: 156,
    totalSpending: 54900000,
    status: 'active'
  },
  {
    id: 'CUS-1992',
    name: 'Hoàng Minh Anh',
    email: 'minhanh_h@yahoo.com',
    phone: '0912 334 455',
    avatar: 'https://i.pravatar.cc/150?img=4',
    ordersCount: 12,
    totalSpending: 3420000,
    status: 'active'
  }
];

// Admin Routes
app.get('/api/admin/users', (req, res) => {
  const { search } = req.query;
  let filteredUsers = [...users];
  if (search) {
    filteredUsers = users.filter(u => 
      u.name.toLowerCase().includes(search.toLowerCase()) || 
      u.email.toLowerCase().includes(search.toLowerCase()) ||
      u.id.toLowerCase().includes(search.toLowerCase())
    );
  }
  res.json({
    total: 12543,
    active: 12292,
    blocked: 251,
    avgSpending: 840000,
    users: filteredUsers
  });
});

// Mock Data for Orders
let orders = [];

app.post('/api/admin/users/:id/status', (req, res) => {
  const { id } = req.params;
  const { status } = req.body;
  const user = users.find(u => u.id === id);
  if (user) {
    user.status = status;
    res.json({ success: true, user });
  } else {
    res.status(404).json({ error: 'User not found' });
  }
});

// Routes
app.get('/api/cart', (req, res) => {
  res.json(calculateCartTotals(cart));
});

app.post('/api/cart/items', (req, res) => {
  const { id, quantity } = req.body;
  const itemIndex = cart.items.findIndex(item => item.id === id);
  if (itemIndex > -1) {
    cart.items[itemIndex].quantity = quantity;
    if (cart.items[itemIndex].quantity <= 0) {
      cart.items.splice(itemIndex, 1);
    }
  }
  res.json(calculateCartTotals(cart));
});

app.post('/api/cart/delivery', (req, res) => {
  cart.deliveryInfo = { ...cart.deliveryInfo, ...req.body };
  res.json(calculateCartTotals(cart));
});

app.post('/api/cart/payment', (req, res) => {
  cart.paymentMethod = req.body.method;
  res.json(calculateCartTotals(cart));
});

app.post('/api/checkout', async (req, res) => {
  const orderId = Date.now();
  const isOnline = cart.paymentMethod === 'online';
  
  const newOrder = {
    id: orderId.toString(),
    userId: 'sample_user_id',
    items: [...cart.items],
    delivery: { ...cart.deliveryInfo },
    payment: cart.paymentMethod,
    total: cart.total,
    status: isOnline ? 'pending_payment' : 'processing',
    createdAt: new Date().toISOString()
  };

  // Save order to "database"
  orders.push(newOrder);

  if (isOnline) {
    try {
      const paymentData = {
        orderCode: orderId,
        amount: cart.total,
        description: `Thanh toan don hang ${orderId}`,
        items: cart.items.map(item => ({
          name: item.name,
          quantity: item.quantity,
          price: item.price
        })),
        returnUrl: 'fastfoodapp://payment-success',
        cancelUrl: 'fastfoodapp://payment-cancel',
      };

      const paymentLink = await payos.createPaymentLink(paymentData);
      
      // Clear cart even if online, but order is pending_payment
      cart.items = [];
      
      return res.json({ 
        success: true, 
        online: true,
        checkoutUrl: paymentLink.checkoutUrl,
        orderId: newOrder.id
      });
    } catch (error) {
      console.error('PayOS Error:', error);
      // Even if PayOS fails, the order is already in 'pending_payment' status
      cart.items = [];
      return res.json({ 
        success: true, 
        online: true, 
        error: 'PayOS link creation failed, please retry from order history',
        orderId: newOrder.id 
      });
    }
  }

  // Cash payment logic
  cart.items = [];
  res.json({ success: true, online: false, orderId: newOrder.id });
});

// Admin/User endpoint to get orders
app.get('/api/orders', (req, res) => {
  res.json(orders.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt)));
});

// Retry Payment
app.post('/api/orders/:id/retry-payment', async (req, res) => {
  const { id } = req.params;
  const order = orders.find(o => o.id === id);

  if (!order) return res.status(404).json({ error: 'Order not found' });
  if (order.status !== 'pending_payment') return res.status(400).json({ error: 'Order is not in pending_payment status' });

  try {
    const paymentData = {
      orderCode: parseInt(order.id),
      amount: order.total,
      description: `Thanh toan lai don hang ${order.id}`,
      items: order.items.map(item => ({
        name: item.name,
        quantity: item.quantity,
        price: item.price
      })),
      returnUrl: 'fastfoodapp://payment-success',
      cancelUrl: 'fastfoodapp://payment-cancel',
    };

    const paymentLink = await payos.createPaymentLink(paymentData);
    res.json({ success: true, checkoutUrl: paymentLink.checkoutUrl });
  } catch (error) {
    res.status(500).json({ error: 'Không thể tạo lại link thanh toán' });
  }
});

// Cancel Order
app.post('/api/orders/:id/cancel', (req, res) => {
  const { id } = req.params;
  const order = orders.find(o => o.id === id);

  if (!order) return res.status(404).json({ error: 'Order not found' });
  order.status = 'cancelled';
  res.json({ success: true, order });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
