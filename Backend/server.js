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

app.get('/', (req, res) => {
  res.send("Socket.IO server is running 🚀");
});

// When a client connects
io.on('connection', (socket) => {
  console.log('🟢 New client connected:', socket.id);

  // Receive message from client
  socket.on('sendMessage', (data) => {
    console.log('📩 Received:', data);

    // Send response back to all clients
    io.emit('receiveMessage', {
      message: `Server received: ${data}`,
      time: new Date().toLocaleTimeString()
    });
  });

  // When client disconnects
  socket.on('disconnect', () => {
    console.log('🔴 Client disconnected:', socket.id);
  });
});

const PORT = 3000;
server.listen(PORT, () => console.log(`✅ Server running on port ${PORT}`));
