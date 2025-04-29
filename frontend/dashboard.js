document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.getElementById('sidebar');
    const toggleBtn = document.getElementById('toggleBtn');
    const mobileMenuBtn = document.getElementById('mobileMenuBtn');
    const menuItems = document.querySelectorAll('.menu-item');
    const contentPanels = document.querySelectorAll('.content-panel');
    const panelTitle = document.getElementById('panelTitle');
    const moreInfoLinks = document.querySelectorAll('.more-info');
    const addProjectBtn = document.getElementById('addProjectBtn');
    
    // Toggle sidebar collapse/expand
    toggleBtn.addEventListener('click', function() {
        sidebar.classList.toggle('collapsed');
        const icon = this.querySelector('i');
        if (sidebar.classList.contains('collapsed')) {
            icon.classList.remove('fa-chevron-left');
            icon.classList.add('fa-chevron-right');
        } else {
            icon.classList.remove('fa-chevron-right');
            icon.classList.add('fa-chevron-left');
        }
    });
    
    // Mobile menu toggle
    mobileMenuBtn.addEventListener('click', function() {
        sidebar.classList.toggle('show');
    });
    
    // Switch between panels
   // Modify your switchPanel function to load data dynamically
async function switchPanel(panelId) {
  // Hide all panels
  contentPanels.forEach(panel => {
      panel.classList.remove('active');
  });
  
  // Show selected panel
  const activePanel = document.getElementById(`${panelId}-panel`);
  if (activePanel) {
      activePanel.classList.add('active');
      
      // Load data for this panel if needed
      if (panelId === 'projects') {
          await fetchProjects();
      }
      // Add similar conditions for other panels
  }
  
  // Update panel title
  const activeMenuItem = document.querySelector(`.menu-item[data-panel="${panelId}"]`);
  if (activeMenuItem) {
      panelTitle.textContent = activeMenuItem.querySelector('span').textContent;
  }
}
// Error Handeling
function showError(message) {
  const errorEl = document.createElement('div');
  errorEl.className = 'error-message';
  errorEl.innerHTML = `
      <i class="fas fa-exclamation-circle"></i>
      <span>${message}</span>
  `;
  document.body.appendChild(errorEl);
  setTimeout(() => errorEl.remove(), 5000);
}

// Then modify your fetchProjects:
async function fetchProjects() {
  try {
      const response = await fetch('http://localhost:5000/api/projects');
      if (!response.ok) throw new Error('Network response was not ok');
      
      const data = await response.json();
      if (!data.success) throw new Error(data.message || 'Failed to fetch projects');
      
      renderProjectsTable(data.projects);
  } catch (error) {
      console.error('Fetch error:', error);
      showError('Failed to load projects. Please try again later.');
  }
}
    
    // Menu item click handler
    menuItems.forEach(item => {
        item.addEventListener('click', function() {
            const panelId = this.getAttribute('data-panel');
            
            // Update active menu item
            menuItems.forEach(i => i.classList.remove('active'));
            this.classList.add('active');
            
            // Switch to corresponding panel
            switchPanel(panelId);
            
            // Close mobile menu after selection
            if (window.innerWidth <= 768) {
                sidebar.classList.remove('show');
            }
        });
    });
    
    // More info links click handler
    moreInfoLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const panelId = this.getAttribute('data-panel');
            if (panelId) {
                // Update active menu item
                menuItems.forEach(i => i.classList.remove('active'));
                const targetMenuItem = document.querySelector(`.menu-item[data-panel="${panelId}"]`);
                if (targetMenuItem) {
                    targetMenuItem.classList.add('active');
                }
                
                // Switch to corresponding panel
                switchPanel(panelId);
            }
        });
    });
    
    // Add project button click handler
    if (addProjectBtn) {
        addProjectBtn.addEventListener('click', function() {
            alert('Add new project functionality would go here');
            // In a real application, this would open a modal or form
        });
    }
    
    // Close mobile menu when clicking outside
    document.addEventListener('click', function(e) {
        if (window.innerWidth <= 768 && !sidebar.contains(e.target) && e.target !== mobileMenuBtn) {
            sidebar.classList.remove('show');
        }
    });
    
    // Initialize with dashboard panel
    switchPanel('dashboard');
});
// Fetch projects from backend
async function fetchProjects() {
    try {
      const response = await fetch('http://localhost:5000/api/projects');
      if (!response.ok) throw new Error('Failed to fetch projects');
      
      const { data: projects } = await response.json();
      renderProjectsTable(projects);
    } catch (error) {
      console.error('Error:', error);
      alert('Failed to load projects. Check console for details.');
    }
  }
  
  // Render projects in the table
 // Update your render function to use documentFragment for better performance
function renderProjectsTable(projects) {
  const tableBody = document.querySelector('#projects-panel tbody');
  const fragment = document.createDocumentFragment();
  
  projects.forEach(project => {
      const row = document.createElement('tr');
      row.innerHTML = `
          <td>${project.project_id}</td>
          <td>${escapeHTML(project.title)}</td>
          <td>${project.team_members || 'No team'}</td>
          <td>${formatDate(project.start_date)}</td>
          <td>${project.end_date ? formatDate(project.end_date) : 'Ongoing'}</td>
          <td><span class="badge ${getStatusClass(project.status)}">${project.status}</span></td>
          <td>
              <button class="btn btn-outline btn-sm" onclick="viewProject(${project.project_id})">
                  <i class="fas fa-eye"></i>
              </button>
              <button class="btn btn-outline btn-sm" onclick="editProject(${project.project_id})">
                  <i class="fas fa-edit"></i>
              </button>
          </td>
      `;
      fragment.appendChild(row);
  });
  
  tableBody.innerHTML = '';
  tableBody.appendChild(fragment);
}

// Helper functions
function escapeHTML(str) {
  const div = document.createElement('div');
  div.textContent = str;
  return div.innerHTML;
}

function formatDate(dateString) {
  const options = { year: 'numeric', month: 'short', day: 'numeric' };
  return new Date(dateString).toLocaleDateString(undefined, options);
}
  
  // Helper function for status badge styling
  function getStatusClass(status) {
    const statusClasses = {
      'Planned': 'badge-info',
      'In Progress': 'badge-success',
      'Completed': 'badge-primary',
      'Cancelled': 'badge-danger',
      'On Hold': 'badge-warning'
    };
    return statusClasses[status] || 'badge-secondary';
  }
  
  // Load projects when the page loads
  document.addEventListener('DOMContentLoaded', fetchProjects);