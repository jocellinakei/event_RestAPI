import express from "express";
import {
  getEvents,
  getEvent,
  createNewEvent,
  updateEventById,
  deleteEventById
} from "./event.controller.js";

const router = express.Router();

// GET ALL
router.get("/", getEvents);

// GET BY ID
router.get("/:id", getEvent);

// POST
router.post("/", createNewEvent);

// PUT
router.put("/:id", updateEventById);

// DELETE
router.delete("/:id", deleteEventById);

export default router;