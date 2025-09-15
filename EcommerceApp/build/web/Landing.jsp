<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>HappyStore-Welcome</title>
    <style>
        body {
    margin: 0; 
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #667eea, #764ba2);
    animation: gradientShift 15s ease infinite;
    color: #fff;
}

@keyframes gradientShift {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

.container {
    text-align: center;
    background: rgba(255, 255, 255, 0.1);
    padding: 50px 70px;
    border-radius: 15px;
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    max-width: 400px;
    width: 90%;
}

h1 {
    margin-bottom: 40px;
    font-weight: 900;
    font-size: 2.8rem;
    letter-spacing: 2px;
    text-shadow: 0 2px 8px rgba(0,0,0,0.3);
}

.btn {
    display: inline-block;
    margin: 15px 25px;
    padding: 18px 50px;
    font-size: 20px;
    font-weight: 700;
    color: #fff;
    background: linear-gradient(45deg, #ff416c, #ff4b2b);
    border: none;
    border-radius: 50px;
    text-decoration: none;
    cursor: pointer;
    box-shadow: 0 8px 15px rgba(255, 75, 43, 0.4);
    transition: all 0.4s ease;
    position: relative;
    overflow: hidden;
}

.btn::before {
    content: "";
    position: absolute;
    top: 50%;
    left: 50%;
    width: 300%;
    height: 300%;
    background: rgba(255, 255, 255, 0.15);
    transform: translate(-50%, -50%) rotate(45deg);
    transition: all 0.5s ease;
    opacity: 0;
    pointer-events: none;
}

.btn:hover {
    background: linear-gradient(45deg, #ff4b2b, #ff416c);
    box-shadow: 0 12px 20px rgba(255, 75, 43, 0.6);
}

.btn:hover::before {
    opacity: 1;
    width: 400%;
    height: 400%;
}

    </style>
</head>
<body>

<div class="container">
    <h1>Welcome to HappyStore</h1>
    <a href="register.jsp" class="btn">Register</a>
    <a href="Login.jsp" class="btn">Login</a>
</div>

</body>
</html>
