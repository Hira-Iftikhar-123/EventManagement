const express = require('express');
const router = express.Router();
const eventRequestController = require('../controllers/eventRequestController');

router.get('/', eventRequestController.getAllEventRequests);

router.post('/create', eventRequestController.createEventRequest);

router.get('/:id', eventRequestController.getEventRequest);

router.put('/:id', eventRequestController.updateEventRequest);

router.delete('/:id', eventRequestController.deleteEventRequest);

router.patch('/:id/approve', eventRequestController.approveEventRequest); 

router.patch('/:id/reject', eventRequestController.rejectEventRequest);   

module.exports = router;
