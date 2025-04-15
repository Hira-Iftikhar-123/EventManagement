const express = require('express');
const router = express.Router();
const db = require('../config/database');

router.post('/register', (req, res) => 
{
  const { eventId,name, age, education, cnic, phone, email, paymentLocation } = req.body;

  const attendeeSql = `INSERT INTO attendees (event_id,name, age, education, cnic, phone, email, payment_location) VALUES (?,?, ?, ?, ?, ?, ?, ?)`;
  db.query(attendeeSql, [eventId,name, age, education, cnic, phone, email, paymentLocation], (err, attendeeResult) => {
    if (err) {
      console.error(err);
      res.status(500).json({ success: false, message: 'Database error during attendee registration' });
      return;
    }
    const attendeeId = attendeeResult.insertId;
    const registrationSql = `INSERT INTO registrations (event_id, attendee_id, eligibility_status, registration_status) VALUES (?, ?, 'Not Eligible', 'Pending')`;
    db.query(registrationSql, [eventId, attendeeId], (err) => {
      if (err) {
        console.error(err);
        res.status(500).json({ success: false, message: 'Database error during event registration' });
      } else {
        res.status(200).json({ success: true, attendeeId, eventId });
      }
    });
  });
});
router.put('/update_status', (req, res) => 
{
  const { eventId, attendeeId, eligibilityStatus, registrationStatus } = req.body;

  const updateSql = `UPDATE registrations SET eligibility_status = ?, registration_status = ? WHERE event_id = ? AND attendee_id = ?`;
  db.query(updateSql, [eligibilityStatus, registrationStatus, eventId, attendeeId], (err) => {
    if (err) {
      console.error(err);
      res.status(500).json({ success: false, message: 'Database error during status update' });
    } else {
      res.status(200).json({ success: true, message: 'Registration status updated successfully' });
    }
  });
});

router.get('/registrations', (req, res) => 
{
  const query = `SELECT attendees.name, registrations.* FROM registrations JOIN attendees ON attendees.attendee_id = registrations.attendee_id`; 
  db.query(query, (err, results) => {
    if (err) {
      console.error(err);
      res.status(500).json({ success: false, message: 'Database error while fetching registrations' });
    } else {
      res.status(200).json(results);
    }
  });
});

module.exports = router;
