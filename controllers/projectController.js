const pool = require('../config/db');

// Get all projects
exports.getAllProjects = async (req, res) => {
  try {
    const [projects] = await pool.query(`
      SELECT p.*, GROUP_CONCAT(f.first_name, ' ', f.last_name) AS team_members
      FROM projects p
      LEFT JOIN faculty_projects fp ON p.project_id = fp.project_id
      LEFT JOIN faculty f ON fp.faculty_id = f.faculty_id
      GROUP BY p.project_id
    `);
    res.status(200).json({ success: true, data: projects });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};

// Add a new project
exports.addProject = async (req, res) => {
  const { title, description, start_date, end_date, status, budget } = req.body;
  
  try {
    const [result] = await pool.query(
      `INSERT INTO projects (title, description, start_date, end_date, status, budget) 
       VALUES (?, ?, ?, ?, ?, ?)`,
      [title, description, start_date, end_date, status, budget]
    );
    res.status(201).json({ success: true, projectId: result.insertId });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
};