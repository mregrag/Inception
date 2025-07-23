document.addEventListener("DOMContentLoaded", function() {
    // Theme Toggle Functionality
    const themeToggle = document.getElementById('theme-toggle');
    const themeIcon = themeToggle.querySelector('i');
    
    // Check for saved theme preference or respect OS preference
    const prefersDarkScheme = window.matchMedia("(prefers-color-scheme: dark)");
    
    // Check if user has a saved preference
    const currentTheme = localStorage.getItem("theme");
    if (currentTheme === "dark") {
        document.body.classList.add("dark-theme");
        themeIcon.classList.remove('fa-moon');
        themeIcon.classList.add('fa-sun');
    } else if (currentTheme === "light") {
        document.body.classList.remove("dark-theme");
        themeIcon.classList.remove('fa-sun');
        themeIcon.classList.add('fa-moon');
    } else if (prefersDarkScheme.matches) {
        // If no saved preference, use OS preference
        document.body.classList.add("dark-theme");
        themeIcon.classList.remove('fa-moon');
        themeIcon.classList.add('fa-sun');
    }
    
    // Listen for theme toggle clicks
    themeToggle.addEventListener("click", function() {
        // Toggle theme
        document.body.classList.toggle("dark-theme");
        
        // Update icon
        if (document.body.classList.contains("dark-theme")) {
            themeIcon.classList.remove('fa-moon');
            themeIcon.classList.add('fa-sun');
            localStorage.setItem("theme", "dark");
        } else {
            themeIcon.classList.remove('fa-sun');
            themeIcon.classList.add('fa-moon');
            localStorage.setItem("theme", "light");
        }
    });
    
    // Handle contact form submission
    const contactForm = document.querySelector('.contact-form');
    const sendButton = document.getElementById('send-message');
    
    sendButton.addEventListener('click', function(e) {
        e.preventDefault();
        
        const nameInput = document.getElementById('name');
        const emailInput = document.getElementById('email');
        const messageInput = document.getElementById('message');
        
        // Simple validation
        if (!nameInput.value || !emailInput.value || !messageInput.value) {
            alert('Please fill in all fields');
            return;
        }
        
        // In a real application, you'd send this data to a server
        // For now, we'll just show a success message
        
        // Create success message
        const successMessage = document.createElement('div');
        successMessage.className = 'success-message';
        successMessage.innerHTML = `
            <p>Thanks for your message, ${nameInput.value}!</p>
            <p>This is a static demo, so no message was actually sent.</p>
        `;
        successMessage.style.padding = '1rem';
        successMessage.style.marginTop = '1rem';
        successMessage.style.backgroundColor = '#d1fae5';
        successMessage.style.borderRadius = 'var(--border-radius)';
        successMessage.style.color = '#065f46';
        
        // Add to page
        contactForm.appendChild(successMessage);
        
        // Clear form
        nameInput.value = '';
        emailInput.value = '';
        messageInput.value = '';
        
        // Remove message after 5 seconds
        setTimeout(() => {
            successMessage.remove();
        }, 5000);
    });
    
    // Add animation to elements when they come into view
    const observeElements = document.querySelectorAll('section');
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = 1;
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, { threshold: 0.1 });
    
    observeElements.forEach(element => {
        // Set initial styles
        element.style.opacity = 0;
        element.style.transform = 'translateY(20px)';
        element.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(element);
    });
    
    // Add project image placeholders
    const projectImages = document.querySelectorAll('.project-image.placeholder');
    const projectIcons = ['fa-code', 'fa-globe', 'fa-gamepad'];
    
    projectImages.forEach((image, index) => {
        const icon = document.createElement('i');
        icon.className = `fas ${projectIcons[index % projectIcons.length]}`;
        image.appendChild(icon);
    });
});
