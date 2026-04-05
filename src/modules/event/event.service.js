import pool from "../../config/db.config.js";

// GET ALL
export const getAllEvents = async () => {
  const result = await pool.query("SELECT * FROM events ORDER BY event_id DESC");
  return result.rows;
};

// GET BY ID
export const getEventById = async (id) => {
  const result = await pool.query(
    "SELECT * FROM events WHERE event_id = $1",
    [id]
  );
  return result.rows[0];
};

// CREATE
export const createEvent = async (data) => {
  const { title, description, location, event_date, organizer } = data;

  const result = await pool.query(
    `INSERT INTO events (title, description, location, event_date, organizer)
     VALUES ($1, $2, $3, $4, $5)
     RETURNING *`,
    [title, description, location, event_date, organizer]
  );

  return result.rows[0];
};

// UPDATE
export const updateEvent = async (id, data) => {
  const { title, description, location, event_date, organizer } = data;

  const result = await pool.query(
    `UPDATE events
     SET title=$1,
         description=$2,
         location=$3,
         event_date=$4,
         organizer=$5
     WHERE event_id=$6
     RETURNING *`,
    [title, description, location, event_date, organizer, id]
  );

  return result.rows[0];
};

// DELETE
export const deleteEvent = async (id) => {
  const result = await pool.query(
    "DELETE FROM events WHERE event_id=$1 RETURNING *",
    [id]
  );

  return result.rows[0];
};