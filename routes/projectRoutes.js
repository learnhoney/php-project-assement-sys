const express = require('express');
const router = express.Router();
const projectController = require('../controllers/projectController');

// GET all projects
router.get('/', projectController.getAllProjects);

// POST a new project
router.post('/', projectController.addProject);

module.exports = router;