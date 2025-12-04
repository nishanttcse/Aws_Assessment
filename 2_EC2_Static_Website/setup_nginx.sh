#!/bin/bash
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx
cat > /var/www/html/index.html <<'EOF'
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nishant Srivastava - Resume</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f3f3f3;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 { margin-bottom: 5px; }
        h2 { margin-top: 30px; color: #444; }
        .section { margin-bottom: 20px; }
        ul { line-height: 1.6; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Nishant Srivastava</h1>
        <p><strong>Email:</strong> nishantgenius03@gmail.com | <strong>Phone:</strong> 8423233242</p>

        <h2>Summary</h2>
        <p>Motivated engineering student with strong skills in cloud computing, Python, backend development, and DevOps. Passionate about AWS, automation, and building real-world scalable systems.</p>

        <h2>Skills</h2>
        <ul>
            <li>AWS (EC2, VPC, ALB, ASG, Lambda, S3, CloudWatch)</li>
            <li>Python, FastAPI, Flask</li>
            <li>Terraform, GitHub, Docker</li>
            <li>Linux, Networking, DevOps Foundations</li>
        </ul>

        <h2>Projects</h2>
        <ul>
            <li><strong>Lumipsyche AI Therapist Chatbot:</strong> NLP-based mental health support system.</li>
            <li><strong>Algo Trading Bot:</strong> RSI + MA crossover trading automation.</li>
            <li><strong>MERN Notes Manager:</strong> Authenticated full-stack notes management system.</li>
        </ul>

        <h2>Education</h2>
        <p>B.Tech–Computer Science & Engineering  
        AKTU (Expected Graduation: 2026)</p>
    </div>
</body>
</html>
EOF
systemctl enable nginx
systemctl restart nginx
# Basic hardening suggestions:
# - Disable password auth in /etc/ssh/sshd_config (done manually or via script)
# - Keep system updated, use a minimal AMI, and restrict SSH to a single IP.
