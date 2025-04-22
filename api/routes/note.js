const express = require("express");
const router = express.Router();
const auth = require("@middleware/auth");
const noteController = require("@controllers/noteController");

router.get("/", auth, noteController.getAllNotes);
router.post("/create", auth, noteController.createNote);
router.put("/update", auth, noteController.updateNote);
router.delete("/delete/:id", auth, noteController.deleteNote);

module.exports = router;
