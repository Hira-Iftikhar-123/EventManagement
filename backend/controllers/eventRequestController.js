const db = require('../config/database');

exports.getAllEventRequests = (req, res) => {
    db.query('SELECT * FROM eventrequests', (err, result) => {
        if (err) {
            res.status(500).json({ error: err.message });
        } else {
            res.status(200).json(result);
        }
    });
};


exports.createEventRequest = (req, res) => {
    const { event_name, event_day, emp_id, capacity } = req.body;

    if (!event_name || !event_day || !capacity) {
        return res.status(400).json({ error: "Event name, day, and capacity are required" });
    }

    const formattedEventDay = new Date(event_day);

    if (isNaN(formattedEventDay.getTime())) {
        return res.status(400).json({ error: "Invalid event day format. Please use YYYY-MM-DD." });
    }
    const formattedDate = formattedEventDay.toISOString().split('T')[0];  

    const query = `INSERT INTO eventrequests (event_name, event_day, emp_id, status, capacity) VALUES (?, ?, ?, 'Pending', ?)`;
    db.query(query, [event_name, formattedDate, emp_id, capacity], (err, result) => {
        if (err) {
            res.status(500).json({ error: err.message });
        } else {
            res.status(201).json({
                message: "Event request created successfully",
                request_id: result.insertId
            });
        }
    });
};



exports.getEventRequest = (req, res) => {
    const { id } = req.params;

    db.query('SELECT * FROM eventrequests WHERE request_id = ?', [id], (err, result) => {
        if (err) {
            res.status(500).json({ error: err.message });
        } else {
            res.status(200).json(result[0]);
        }
    });
};

exports.updateEventRequest = (req, res) => {
    const { id } = req.params;
    const { event_name, event_day } = req.body;

    db.query('SELECT status FROM eventrequests WHERE request_id = ?', [id], (err, result) => {
        if (err || result.length === 0) {
            return res.status(404).json({ error: 'Event request not found' });
        }

        if (result[0].status != 'Pending') {
            return res.status(400).json({ error: 'Cannot update an event request once sent' });
        }

        const updateQuery = `UPDATE eventrequests SET event_name = ?, event_day = ? WHERE request_id = ?`;
        db.query(updateQuery, [event_name, event_day, id], (updateErr) => {
            if (updateErr) {
                res.status(500).json({ error: updateErr.message });
            } else {
                res.status(200).json({ message: "Event request updated successfully" });
            }
        });
    });
};


exports.deleteEventRequest = (req, res) => {
    const { id } = req.params;

    db.query('DELETE FROM eventrequests WHERE request_id = ? AND status = "Pending"', [id], (err, result) => {
        if (err) {
            res.status(500).json({ error: err.message });
        } else if (result.affectedRows === 0) {
            res.status(400).json({ error: "Cannot delete the event request after sending" });
        } else {
            res.status(200).json({ message: "Event request deleted successfully" });
        }
    });
};

exports.approveEventRequest = (req, res) => {
    const { id } = req.params;

    const query = `UPDATE eventrequests SET status = 'Approved' WHERE request_id = ? AND status = 'Pending'`;
    db.query(query, [id], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        } else if (result.affectedRows === 0) {
            return res.status(409).json({ error: "Cannot approve an already processed request" });
        } else {
            return res.status(200).json({
                message: "Event request approved successfully",
                request_id: id,
                status: "Approved"
            });
        }
    });
};

exports.rejectEventRequest = (req, res) => {
    const { id } = req.params;

    const query = `UPDATE eventrequests SET status = 'Rejected' WHERE request_id = ? AND status = 'Pending'`;
    db.query(query, [id], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        } else if (result.affectedRows === 0) {
            return res.status(409).json({ error: "Cannot reject an already processed request" });
        } else {
            return res.status(200).json({
                message: "Event request rejected successfully",
                request_id: id,
                status: "Rejected"
            });
        }
    });
};
