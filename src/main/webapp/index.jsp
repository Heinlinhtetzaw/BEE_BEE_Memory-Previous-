<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./css/index.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
 <header>
                <img src="image/memory_game_logo-removebg-preview.png">
                <nav class="navigation">
                    <a href="#" onclick="alert('You need to Login First')"><i class="fa-solid fa-house">&nbsp;</i>Home</a>
                    <a href="#" onclick="alert('You need to Login First')"><i class="fa-solid fa-bars">&nbsp;</i>About game</a>
                    <a href="#" onclick="alert('You need to Login First')"><i class="fa-solid fa-user">&nbsp;</i>Profile</a>
                    <a href="Contact.html"><i class="fa-solid fa-id-card-clip">&nbsp;</i>Contact</a>
                    <a href="Login.jsp"><i class="fa-solid fa-right-from-bracket">&nbsp;</i>Login</a>
                </nav>
            </header> 
            <section class="game-container">
                <h1 class="heading"> Game Playlist</h1><div class="box-container">
                  <a href="./Guest5game/guessnumber.html" class="box">
                    <img
                      src="./image/guessnumberimg.jpg"
                      alt="Game Tutorial"
                    />
                    <h3>Play Now</h3>
                  </a>
                  <a href="./Guest5game/visual.html" class="box">
                    <img
                      src="./image/visual1.png"
                      alt="Game Tutorial"
                    />
                    <h3>Play Now</h3>
                  </a>
                  <a href="./Guest5game/shuffle.html" class="box">
                    <img
                      src="./image/number puzzle.jpg"
                      alt="Game Tutorial"
                    />
                    <h3>Play Now</h3>
                  </a>
                  <a href="./Guest5game/TicTaToe.html" class="box">
                    <img
                      src="./image/tito.jpg"
                      alt="Game Tutorial"
                    />
                    <h3>Play Now</h3>
                  </a>
                  <a href="./Guest5game/typing.html" class="box">
                    <img
                      src="./image/typing.jpg"
                      alt="Game Tutorial"
                    />
                    <h3>Play Now</h3>
                  </a>
                </div>
              </section>

              <div style="color: white;
              text-align: center;
              font-family: 'Poppens',sans-serif;
              margin-top: 40px;"><h3>Sign up for a new account to play more games.</h3></div>
            <footer>
              <div class="footer-content">
                  <p>&copy; 2024 Memory Game. All rights reserved.</p>
              </div>
          </footer>
    
   
</body>
</html>