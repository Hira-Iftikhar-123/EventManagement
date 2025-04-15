const express = require('express');
const router = express.Router();
const resourceAllocation = require('../controllers/resourceAllocation');

router.get('/approved_events', resourceAllocation.viewApprovedEvents);
router.post('/check_resource',resourceAllocation.checkResourceAvailability);
router.post('/create_event', resourceAllocation.createEvent);
module.exports = router;
