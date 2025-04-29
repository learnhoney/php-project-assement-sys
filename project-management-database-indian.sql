-- Create database
CREATE DATABASE proj;
USE proj;

-- Faculty table to store information about professors and faculty members
CREATE TABLE faculty (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department VARCHAR(100) NOT NULL,
    position VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    specialization VARCHAR(200),
    bio TEXT,
    photo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Projects table to store information about research projects
CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    status ENUM('Planned', 'In Progress', 'Completed', 'Cancelled', 'On Hold') NOT NULL,
    budget DECIMAL(12, 2),
    funding_source VARCHAR(100),
    priority ENUM('Low', 'Medium', 'High', 'Critical') NOT NULL DEFAULT 'Medium',
    project_code VARCHAR(50),
    keywords VARCHAR(255),
    document_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Faculty-Project relationship (many-to-many)
CREATE TABLE faculty_projects (
    faculty_project_id INT AUTO_INCREMENT PRIMARY KEY,
    faculty_id INT NOT NULL,
    project_id INT NOT NULL,
    role ENUM('Principal Investigator', 'Co-Investigator', 'Research Associate', 'Technical Officer', 'Advisor', 'Collaborator') NOT NULL,
    join_date DATE NOT NULL,
    end_date DATE,
    contribution TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    UNIQUE KEY (faculty_id, project_id)
);

-- Publications related to projects
CREATE TABLE publications (
    publication_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    publication_date DATE NOT NULL,
    journal_name VARCHAR(200),
    authors VARCHAR(255) NOT NULL,
    doi VARCHAR(100),
    citation TEXT,
    abstract TEXT,
    link VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE
);

-- Project milestones
CREATE TABLE milestones (
    milestone_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    due_date DATE NOT NULL,
    completion_date DATE,
    status ENUM('Pending', 'In Progress', 'Completed', 'Delayed') NOT NULL DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE
);

-- Project funding details
CREATE TABLE funding (
    funding_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    source VARCHAR(100) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    grant_number VARCHAR(100),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE
);

-- Project files and documents
CREATE TABLE project_documents (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    file_type VARCHAR(50) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    upload_date DATE NOT NULL,
    description TEXT,
    uploaded_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by) REFERENCES faculty(faculty_id) ON DELETE SET NULL
);

-- Users table for system access
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    faculty_id INT,
    role ENUM('Admin', 'Faculty', 'Staff', 'Guest') NOT NULL DEFAULT 'Faculty',
    last_login DATETIME,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id) ON DELETE SET NULL
);

-- Departments table
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    head_faculty_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (head_faculty_id) REFERENCES faculty(faculty_id) ON DELETE SET NULL
);

-- Add foreign key to connect faculty to departments
ALTER TABLE faculty
ADD COLUMN department_id INT,
ADD FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL;

-- Sample data for departments (CSIR-like departments)
INSERT INTO departments (name, description) VALUES
('Chemical Sciences', 'Department of Chemical Sciences and Research'),
('Physical Sciences', 'Department of Physics and Material Sciences'),
('Biological Sciences', 'Department of Biological Sciences and Biotechnology'),
('Engineering Sciences', 'Department of Engineering and Technology Development'),
('Information Sciences', 'Department of Information Technology and Computer Sciences');

-- Sample faculty data with Indian names
INSERT INTO faculty (first_name, last_name, email, phone, department, position, hire_date, specialization) VALUES
('Rajesh', 'Sharma', 'rsharma@csir.res.in', '011-2345-6789', 'Chemical Sciences', 'Chief Scientist', '2009-04-15', 'Catalysis and Materials Chemistry'),
('Priya', 'Patel', 'ppatel@csir.res.in', '011-3456-7890', 'Biological Sciences', 'Senior Scientist', '2012-07-22', 'Molecular Biology and Genomics'),
('Amit', 'Kumar', 'akumar@csir.res.in', '011-4567-8901', 'Physical Sciences', 'Principal Scientist', '2010-11-30', 'Condensed Matter Physics'),
('Sunita', 'Gupta', 'sgupta@csir.res.in', '011-5678-9012', 'Engineering Sciences', 'Senior Principal Scientist', '2008-03-10', 'Material Science and Engineering'),
('Vikram', 'Singh', 'vsingh@csir.res.in', '011-6789-0123', 'Information Sciences', 'Chief Scientist', '2007-09-05', 'Artificial Intelligence and Machine Learning'),
('Deepa', 'Agarwal', 'dagarwal@csir.res.in', '011-7890-1234', 'Chemical Sciences', 'Principal Scientist', '2011-06-18', 'Polymer Chemistry'),
('Arun', 'Mehta', 'amehta@csir.res.in', '011-8901-2345', 'Engineering Sciences', 'Senior Scientist', '2013-02-25', 'Robotics and Control Systems'),
('Neha', 'Verma', 'nverma@csir.res.in', '011-9012-3456', 'Biological Sciences', 'Scientist', '2016-08-12', 'Microbiology and Fermentation Technology');

-- Sample project data based on CSIR-like projects
INSERT INTO projects (title, description, start_date, end_date, status, budget, funding_source, priority, project_code) VALUES
('Development of Catalysts for Green Hydrogen Production', 'Research on efficient and cost-effective catalysts for hydrogen production from water splitting', '2022-04-01', NULL, 'In Progress', 4500000.00, 'Ministry of New and Renewable Energy', 'High', 'CSIR-HFC-2022'),
('Genomic Approaches for Crop Improvement', 'Application of genomic tools for developing climate-resilient crop varieties', '2021-07-15', '2024-03-31', 'In Progress', 3200000.00, 'Department of Biotechnology', 'High', 'CSIR-AGR-2021'),
('Advanced Materials for Energy Storage', 'Development of novel materials for next-generation batteries and supercapacitors', '2022-01-10', NULL, 'In Progress', 5000000.00, 'Ministry of Science and Technology', 'Critical', 'CSIR-ENS-2022'),
('Traditional Knowledge Digital Library Expansion', 'Documentation and digitalization of traditional Indian medicinal knowledge', '2020-10-01', '2023-09-30', 'Completed', 2800000.00, 'Ministry of AYUSH', 'Medium', 'CSIR-TKD-2020'),
('AI-Based Systems for Healthcare Diagnostics', 'Development of artificial intelligence algorithms for early disease detection', '2023-01-15', NULL, 'In Progress', 3800000.00, 'Department of Science and Technology', 'High', 'CSIR-HLT-2023'),
('Waste to Wealth: Plastic Recycling Technologies', 'Innovative approaches for plastic waste management and value-added products', '2021-04-01', '2023-10-31', 'Completed', 2500000.00, 'Ministry of Environment, Forest and Climate Change', 'Medium', 'CSIR-ENV-2021'),
('Quantum Computing Applications', 'Research on quantum algorithms and their applications in cryptography and optimization', '2023-06-01', NULL, 'Planned', 6000000.00, 'Ministry of Electronics and Information Technology', 'Critical', 'CSIR-QCT-2023');

-- Sample faculty-project assignments
INSERT INTO faculty_projects (faculty_id, project_id, role, join_date) VALUES
(1, 1, 'Principal Investigator', '2022-04-01'),
(6, 1, 'Co-Investigator', '2022-04-01'),
(2, 2, 'Principal Investigator', '2021-07-15'),
(8, 2, 'Research Associate', '2021-08-01'),
(3, 3, 'Co-Investigator', '2022-01-10'),
(4, 3, 'Principal Investigator', '2022-01-10'),
(6, 4, 'Principal Investigator', '2020-10-01'),
(2, 4, 'Advisor', '2020-10-01'),
(5, 5, 'Principal Investigator', '2023-01-15'),
(3, 5, 'Co-Investigator', '2023-01-15'),
(1, 6, 'Co-Investigator', '2021-04-01'),
(4, 6, 'Principal Investigator', '2021-04-01'),
(5, 7, 'Principal Investigator', '2023-06-01'),
(3, 7, 'Co-Investigator', '2023-06-01');

-- Sample publications
INSERT INTO publications (project_id, title, publication_date, journal_name, authors, doi) VALUES
(1, 'Novel Nickel-Iron Layered Double Hydroxide Catalysts for Efficient Hydrogen Evolution', '2023-06-15', 'International Journal of Hydrogen Energy', 'Sharma R., Agarwal D., Reddy K.', '10.1016/j.ijhydene.2023.05.123'),
(2, 'CRISPR-Cas9 Mediated Genome Editing for Drought Tolerance in Rice', '2022-10-01', 'Journal of Plant Biotechnology', 'Patel P., Verma N., Das S., et al.', '10.1007/s11240-022-02354-w'),
(3, 'Sustainable Electrode Materials Derived from Agricultural Waste for Energy Storage Applications', '2023-03-20', 'ACS Sustainable Chemistry & Engineering', 'Gupta S., Kumar A., Singh R., et al.', '10.1021/acssuschemeng.3b00567'),
(4, 'Documentation and Scientific Validation of Traditional Herbal Formulations for Diabetes Management', '2022-08-05', 'Journal of Ethnopharmacology', 'Agarwal D., Patel P., Chakraborty S., et al.', '10.1016/j.jep.2022.07.032'),
(5, 'Deep Learning Framework for Early Detection of Diabetic Retinopathy from Retinal Images', '2023-09-12', 'IEEE Journal of Biomedical and Health Informatics', 'Singh V., Kumar A., Bhatia R., et al.', '10.1109/JBHI.2023.3201456'),
(6, 'Catalytic Pyrolysis of Plastic Waste: A Sustainable Approach to Value-Added Chemicals', '2023-02-15', 'Waste Management', 'Gupta S., Sharma R., Nair V., et al.', '10.1016/j.wasman.2023.01.023');

-- Sample milestones for active projects
INSERT INTO milestones (project_id, title, description, due_date, completion_date, status) VALUES
(1, 'Synthesis of First-Generation Catalysts', 'Complete the synthesis and characterization of 5 catalyst candidates', '2022-08-31', '2022-09-15', 'Completed'),
(1, 'Electrochemical Performance Testing', 'Evaluate hydrogen evolution performance of synthesized catalysts', '2023-01-31', '2023-02-10', 'Completed'),
(1, 'Stability and Durability Assessment', 'Long-term testing of promising catalyst formulations', '2023-07-31', NULL, 'In Progress'),
(1, 'Pilot Scale Demonstration', 'Demonstration of catalyst performance at larger scale', '2024-03-31', NULL, 'Pending'),
(2, 'Gene Target Identification', 'Identify key genes associated with drought tolerance', '2021-12-31', '2022-01-15', 'Completed'),
(2, 'CRISPR Construct Development', 'Design and validation of CRISPR-Cas9 constructs', '2022-06-30', '2022-07-22', 'Completed'),
(2, 'Transgenic Plant Generation', 'Development of modified plant lines', '2023-03-31', '2023-04-10', 'Completed'),
(2, 'Field Testing of Modified Crops', 'Evaluate performance under natural conditions', '2023-12-31', NULL, 'In Progress'),
(3, 'Material Synthesis Protocol Development', 'Establish procedures for synthesizing electrode materials', '2022-05-31', '2022-06-15', 'Completed'),
(3, 'Electrochemical Characterization', 'Comprehensive testing of electrochemical properties', '2022-11-30', '2022-12-10', 'Completed'),
(3, 'Prototype Cell Assembly', 'Fabrication of prototype battery cells', '2023-06-30', '2023-07-20', 'Completed'),
(3, 'Performance Optimization', 'Refinement of materials for improved energy density', '2023-12-31', NULL, 'In Progress');

-- Sample user accounts (passwords would be properly hashed in production)
INSERT INTO users (username, password, faculty_id, role) VALUES
('rsharma', '$2y$10$examplehashedpassword', 1, 'Faculty'),
('ppatel', '$2y$10$examplehashedpassword', 2, 'Faculty'),
('akumar', '$2y$10$examplehashedpassword', 3, 'Faculty'),
('sgupta', '$2y$10$examplehashedpassword', 4, 'Faculty'),
('vsingh', '$2y$10$examplehashedpassword', 5, 'Faculty'),
('dagarwal', '$2y$10$examplehashedpassword', 6, 'Faculty'),
('amehta', '$2y$10$examplehashedpassword', 7, 'Faculty'),
('nverma', '$2y$10$examplehashedpassword', 8, 'Faculty'),
('admin', '$2y$10$examplehashedpassword', NULL, 'Admin');

-- Sample funding details
INSERT INTO funding (project_id, source, amount, grant_number, start_date, end_date, description) VALUES
(1, 'Ministry of New and Renewable Energy', 4500000.00, 'MNRE/HFC/2022-25/003', '2022-04-01', '2025-03-31', 'Grant under the National Hydrogen Mission'),
(2, 'Department of Biotechnology', 3200000.00, 'DBT/AGR/2021-24/127', '2021-07-15', '2024-07-14', 'Funding under the Agricultural Biotechnology Initiative'),
(3, 'Ministry of Science and Technology', 5000000.00, 'MST/ENS/2022-25/089', '2022-01-10', '2025-01-09', 'Special grant for Energy Storage Research'),
(4, 'Ministry of AYUSH', 2800000.00, 'AYUSH/TK/2020-23/045', '2020-10-01', '2023-09-30', 'Traditional Knowledge Documentation Project Funding'),
(5, 'Department of Science and Technology', 3800000.00, 'DST/AI-HLT/2023-26/112', '2023-01-15', '2026-01-14', 'AI for Healthcare Initiative Grant'),
(6, 'Ministry of Environment, Forest and Climate Change', 2500000.00, 'MOEFCC/WM/2021-23/076', '2021-04-01', '2023-10-31', 'Funding under Waste Management Technologies Program'),
(7, 'Ministry of Electronics and Information Technology', 6000000.00, 'MEITY/QC/2023-26/028', '2023-06-01', '2026-05-31', 'National Quantum Mission Grant');

-- Sample project documents
INSERT INTO project_documents (project_id, title, file_type, file_path, upload_date, description, uploaded_by) VALUES
(1, 'Project Proposal', 'PDF', '/documents/projects/CSIR-HFC-2022/proposal.pdf', '2022-03-15', 'Initial project proposal document', 1),
(1, 'First Year Progress Report', 'PDF', '/documents/projects/CSIR-HFC-2022/progress_y1.pdf', '2023-04-10', 'Annual progress report for first year', 1),
(2, 'Experimental Protocol', 'DOCX', '/documents/projects/CSIR-AGR-2021/protocol.docx', '2021-08-20', 'Detailed protocol for CRISPR experiments', 2),
(2, 'Gene Sequencing Data', 'XLSX', '/documents/projects/CSIR-AGR-2021/sequence_data.xlsx', '2022-02-10', 'Raw sequencing data from selected crop varieties', 8),
(3, 'Material Characterization Report', 'PDF', '/documents/projects/CSIR-ENS-2022/characterization.pdf', '2022-07-15', 'Detailed analysis of synthesized materials', 4),
(3, 'Battery Performance Data', 'XLSX', '/documents/projects/CSIR-ENS-2022/battery_tests.xlsx', '2023-01-20', 'Test results from prototype batteries', 3),
(4, 'Herbal Formulation Database', 'XLSX', '/documents/projects/CSIR-TKD-2020/formulations.xlsx', '2021-03-15', 'Compiled database of documented formulations', 6),
(5, 'AI Algorithm Documentation', 'PDF', '/documents/projects/CSIR-HLT-2023/algorithm_doc.pdf', '2023-03-10', 'Technical documentation of the developed algorithm', 5);
