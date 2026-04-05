import {
  getAllEvents,
  getEventById,
  createEvent,
  updateEvent,
  deleteEvent
} from "./event.service.js";

// GET ALL
export const getEvents = async (req, res) => {
  try {
    const data = await getAllEvents();
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// GET BY ID
export const getEvent = async (req, res) => {
  try {
    const { id } = req.params;

    const data = await getEventById(id);

    if (!data) {
      return res.status(404).json({ message: "Event not found" });
    }

    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// POST
export const createNewEvent = async (req, res) => {
  try {
    const data = await createEvent(req.body);
    res.status(201).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// PUT
export const updateEventById = async (req, res) => {
  try {
    const { id } = req.params;

    const data = await updateEvent(id, req.body);

    if (!data) {
      return res.status(404).json({ message: "Event not found" });
    }

    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// DELETE
export const deleteEventById = async (req, res) => {
  try {
    const { id } = req.params;

    const data = await deleteEvent(id);

    if (!data) {
      return res.status(404).json({ message: "Event not found" });
    }

    res.json({ message: "Event deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};