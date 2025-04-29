<?php
header("Content-Type: application/json");
require_once '../config.php';
require_once '../projects.php';

$action = $_GET['action'] ?? '';
$user = Auth::getUser();

try {
    switch($action) {
        case 'getAll':
            $projects = ProjectManager::getAllProjects();
            echo json_encode($projects);
            break;
            
        case 'getDetails':
            $projectId = $_GET['id'] ?? 0;
            $project = ProjectManager::getProjectDetails($projectId);
            if ($project) {
                echo json_encode($project);
            } else {
                http_response_code(404);
                echo json_encode(['error' => 'Project not found']);
            }
            break;
            
        case 'add':
            if (!Auth::isLoggedIn() || !Auth::isAdmin()) {
                http_response_code(403);
                echo json_encode(['error' => 'Unauthorized']);
                break;
            }
            
            $data = json_decode(file_get_contents('php://input'), true);
            $success = ProjectManager::addProject($data);
            echo json_encode(['success' => $success]);
            break;
            
        case 'update':
            if (!Auth::isLoggedIn() || !Auth::isAdmin()) {
                http_response_code(403);
                echo json_encode(['error' => 'Unauthorized']);
                break;
            }
            
            $projectId = $_GET['id'] ?? 0;
            $data = json_decode(file_get_contents('php://input'), true);
            $success = ProjectManager::updateProject($projectId, $data);
            echo json_encode(['success' => $success]);
            break;
            
        default:
            http_response_code(400);
            echo json_encode(['error' => 'Invalid action']);
    }
} catch(PDOException $e) {
    http_response_code(500);
    echo json_encode(['