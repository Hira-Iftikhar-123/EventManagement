const db = require('../config/database'); 

exports.createEvent = (req, res) => {
    const 
    {
        request_id,vendor_id,transport_id,venue_id,event_date,event_timings,event_category,description,budget,requested_capacity,
    }
    = req.body;
    
    const checkRequestQuery = `SELECT event_name FROM eventrequests WHERE request_id = ? AND status = 'Approved'`;
    db.query(checkRequestQuery, [request_id], (err, requestResult) => {
        if (err) {
            return res.status(500).json({ error: 'Error checking event request: ' + err.message });
        }
        if (requestResult.length === 0) {
            return res.status(404).json({ error: 'Event request not approved or does not exist' });
        }

        const checkResourceQuery = `
            SELECT event_id FROM events WHERE (vendor_id = ? OR transport_id = ? OR venue_id = ?) AND event_date = ?`;
        db.query(checkResourceQuery, [vendor_id, transport_id, venue_id, event_date], (resourceErr, resourceResult) => {
            if (resourceErr) {
                return res.status(500).json({ error: 'Error checking resource availability: ' + resourceErr.message });
            }
            if (resourceResult.length > 0) {
                return res.status(400).json({ error: 'One or more resources are already allocated to another event on the same date.' });
            }

            const checkVenueCapacityQuery = `
                SELECT capacity FROM venues WHERE venue_id = ?`;
            db.query(checkVenueCapacityQuery, [venue_id], (capacityErr, capacityResult) => {
                if (capacityErr) {
                    return res.status(500).json({ error: 'Error checking venue capacity: ' + capacityErr.message });
                }
                if (capacityResult.length === 0) {
                    return res.status(404).json({ error: 'Venue does not exist' });
                }
                if (capacityResult[0].capacity < requested_capacity) {
                    return res.status(400).json({ error: 'Requested capacity exceeds venue capacity' });
                }

                const insertEventQuery = `INSERT INTO events (event_name, description, budget, event_date, event_timings, event_category, coordinator_id, vendor_id, transport_id, venue_id, event_request_id)
                    VALUES (?, ?, ?, ?, ?, ?, 4, ?, ?, ?, ?)`;
                db.query(insertEventQuery, [
                    requestResult[0].event_name,description || null,budget || 0,event_date, 
                    event_timings || null,event_category || null,vendor_id,transport_id,venue_id, request_id],
                    (insertErr, insertResult) => {
                    if (insertErr) {
                        return res.status(500).json({ error: 'Error creating event: ' + insertErr.message });
                    }
                    return res.status(200).json({ message: 'Event successfully created' });
                });
            });
        });
    });
};

exports.viewApprovedEvents = (req, res) => {
    const viewEventsQuery = `SELECT event_id,event_name, description, event_date, event_timings, event_category FROM events`;
    db.query(viewEventsQuery, (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Error fetching events: ' + err.message });
        }
        return res.status(200).json(results);
    });
};

exports.checkResourceAvailability = (req, res) => {
    const { vendor_id, transport_id, venue_id, event_date } = req.body;

    const checkResourceQuery = `
        SELECT event_id FROM events WHERE (vendor_id = ? OR transport_id = ? OR venue_id = ?) AND event_date = ?`;
    db.query(checkResourceQuery, [vendor_id, transport_id, venue_id, event_date], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Error checking resource availability: ' + err.message });
        }
        if (results.length > 0) {
            return res.status(400).json({ message: 'One or more resources are already allocated on this date.' });
        }
        return res.status(200).json({ message: 'Resources are available.' });
    });
};
