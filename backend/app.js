const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors'); 
const eventRequestRoutes = require('./routes/eventRequestRoutes');
const eventRoutes = require('./routes/eventRoutes');
const attendeeRegisterRoutes = require('./routes/attendeeRegisterRoutes')

dotenv.config();
const app = express();
app.use(cors());  
app.use(express.json());

app.use('/api/eventRequests', eventRequestRoutes);
app.use('/api/events', eventRoutes);
app.use('/api/attendees', attendeeRegisterRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
