const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*", // allow all origins (you can restrict later)
    methods: ["GET", "POST"]
  }
});

let connectedUsers = {}; // Store userId → socketId mapping

app.get('/', (req, res) => {
  res.send("Socket.IO server is running 🚀");
});

app.get('/users', (req, res) => {
  res.json(connectedUsers);
});

// When a client connects
io.on('connection', (socket) => {
  console.log('🟢 New client connected:', socket.id);

  // Receive message from client
  // socket.on('sendMessage', (data) => {
  //   console.log('📩 Received:', data);

  //   // Send response back to all clients
  //   io.emit('receiveMessage', {
  //     message: `Server received: ${data}`,
  //     time: new Date().toLocaleTimeString()
  //   });
  // });

  socket.on('registerUser', (userId) => {
    connectedUsers[userId] = socket.id;
    console.log(`✅ Registered ${userId} -> ${socket.id}`);
  });

  // Example: receive request to send form to specific user
  socket.on('sendFormToUser', (userId) => {
    const targetSocketId = connectedUsers[userId];
    if(targetSocketId) {
      io.to(targetSocketId).emit('showForm', {
        fields: [
          { name: "name", type: "text", label: "Full Name" },
          { name: "age", type: "number", label: "Age" },
          { name: "email", type: "email", label: "Email" },
          { name: "password", type: "password", label: "Password" },
          // { name: "gender", type: "dropdown", label: "Gender", options: ["Male", "Female", "Other"] },
          // { name: "agree", type: "checkbox", label: "Accept Terms & Conditions" },
          // { name: "dob", type: "date", label: "Date of Birth" }
        ]
      });
      console.log(`📤 Sent form to ${userId}`);
    } else {
      console.log(`⚠️ User ${userId} not found`);
    }
  });

  socket.on('sendGalleryToUser', (userId) => {
  const targetSocketId = connectedUsers[userId];
  if (targetSocketId) {
    io.to(targetSocketId).emit('showGallery', {
      images: [
        { url: 'https://cdn.pixabay.com/photo/2016/05/08/15/39/icon-1379313_1280.png', w: 2, h: 2 },
        { url: 'https://media.istockphoto.com/id/1208313447/vector/teamwork-concept-with-building-puzzle-people-working-together-with-giant-puzzle-elements.jpg?s=2048x2048&w=is&k=20&c=BEk9PBMQnvP7MAuBnLd62PT96lS91tpgdVXI9OBSQbc=', w: 1, h: 1 },
        { url: 'https://cdn.pixabay.com/photo/2017/07/11/00/24/house-2492054_1280.png', w: 2, h: 1 },
        { url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9eFuJyAS3Ef-fza4rasTmWUE_5XHBbeiRAA&s', w: 1, h: 2 },
        { url: 'https://cdn.pixabay.com/photo/2016/05/08/15/39/icon-1379313_1280.png', w: 2, h: 2 },
        { url: 'https://media.istockphoto.com/id/1208313447/vector/teamwork-concept-with-building-puzzle-people-working-together-with-giant-puzzle-elements.jpg?s=2048x2048&w=is&k=20&c=BEk9PBMQnvP7MAuBnLd62PT96lS91tpgdVXI9OBSQbc=', w: 1, h: 1 },
        { url: 'https://cdn.pixabay.com/photo/2017/07/11/00/24/house-2492054_1280.png', w: 2, h: 1 },
        { url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9eFuJyAS3Ef-fza4rasTmWUE_5XHBbeiRAA&s', w: 1, h: 2 },
        { url: 'https://cdn.pixabay.com/photo/2016/05/08/15/39/icon-1379313_1280.png', w: 2, h: 2 },
        { url: 'https://media.istockphoto.com/id/1208313447/vector/teamwork-concept-with-building-puzzle-people-working-together-with-giant-puzzle-elements.jpg?s=2048x2048&w=is&k=20&c=BEk9PBMQnvP7MAuBnLd62PT96lS91tpgdVXI9OBSQbc=', w: 1, h: 1 },
        { url: 'https://cdn.pixabay.com/photo/2017/07/11/00/24/house-2492054_1280.png', w: 2, h: 1 },
        { url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9eFuJyAS3Ef-fza4rasTmWUE_5XHBbeiRAA&s', w: 1, h: 2 },
        { url: 'https://cdn.pixabay.com/photo/2016/05/08/15/39/icon-1379313_1280.png', w: 2, h: 2 },
        { url: 'https://media.istockphoto.com/id/1208313447/vector/teamwork-concept-with-building-puzzle-people-working-together-with-giant-puzzle-elements.jpg?s=2048x2048&w=is&k=20&c=BEk9PBMQnvP7MAuBnLd62PT96lS91tpgdVXI9OBSQbc=', w: 1, h: 1 },
        { url: 'https://cdn.pixabay.com/photo/2017/07/11/00/24/house-2492054_1280.png', w: 2, h: 1 },
        { url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9eFuJyAS3Ef-fza4rasTmWUE_5XHBbeiRAA&s', w: 1, h: 2 },
        { url: 'https://cdn.pixabay.com/photo/2016/05/08/15/39/icon-1379313_1280.png', w: 2, h: 2 },
        { url: 'https://media.istockphoto.com/id/1208313447/vector/teamwork-concept-with-building-puzzle-people-working-together-with-giant-puzzle-elements.jpg?s=2048x2048&w=is&k=20&c=BEk9PBMQnvP7MAuBnLd62PT96lS91tpgdVXI9OBSQbc=', w: 1, h: 1 },
        { url: 'https://cdn.pixabay.com/photo/2017/07/11/00/24/house-2492054_1280.png', w: 2, h: 1 },
        { url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9eFuJyAS3Ef-fza4rasTmWUE_5XHBbeiRAA&s', w: 1, h: 2 },
        { url: 'https://cdn.pixabay.com/photo/2016/05/08/15/39/icon-1379313_1280.png', w: 2, h: 2 },
        { url: 'https://media.istockphoto.com/id/1208313447/vector/teamwork-concept-with-building-puzzle-people-working-together-with-giant-puzzle-elements.jpg?s=2048x2048&w=is&k=20&c=BEk9PBMQnvP7MAuBnLd62PT96lS91tpgdVXI9OBSQbc=', w: 1, h: 1 },
     

      ]
    });
    console.log(`📤 Sent gallery to ${userId}`);
  }
});

  // When client disconnects
  socket.on('disconnect', () => {
    console.log('🔴 Client disconnected:', socket.id);
    // Optional cleanup
    for(const key in connectedUsers) {
      if(connectedUsers[key] === socket.id) {
        delete connectedUsers[key];
        console.log(`🗑️ Removed ${key} from connected users`);
      }
    }
  });
});

const PORT = 3000;
server.listen(PORT, () => console.log(`✅ Server running on port ${PORT}`));
