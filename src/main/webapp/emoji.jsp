<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Card Game</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: monospace;
        }
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: #7CC0CF;
        }
        .container {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            gap: 30px;
            background:linear-gradient(#2CB729,#1AC4CF);
            padding: 40px 60px;
            border-radius: 10px;
        }
        h2 {
            font-size: 3em;
            color: #fff;
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }
        .game {
            width: 440px;
            height: 440px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            perspective: 500px;
        }
        .item {
            position: relative;
            width: 100px;
            height: 100px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 3em;
            background: #fff;
            transition: 0.25s;
            cursor: pointer;
            border-radius: 5px;
        }
        .item::after {
            content: '';
            position: absolute;
            inset: 0;
            background: #b1f098;
            transition: 0.25s;
            transform: rotateY(0deg);
            backface-visibility: hidden;
            border-radius: 5px;
        }
        .boxOpen::after,
        .boxMatch::after {
            transform: rotateY(180deg);
        }
        .victory-screen, .try-again-screen {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            padding: 20px;
            width: 300px;
            z-index: 1000;
        }
        .victory-screen h1 {
            color: goldenrod;
            font-size: 2em;
            margin: 0;
        }
        .try-again-screen h1 {
            color: red;
            font-size: 2em;
            margin: 0;
        }
        .score {
            font-size: 1.5em;
            margin: 10px 0;
        }
        .buttons {
            display: flex;
            justify-content: space-around;
            margin-top: 20px;
        }
        .buttons button {
            background-color: #03783b;
            border: none;
            border-radius: 5px;
            color: #fff;
            padding: 10px 20px;
            cursor: pointer;
        }
        .buttons button:hover {
            background-color: skyblue;
        }
        .timer {
            font-size: 1.5em;
            color: #141111;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Card Game - Level <span id="level-number">1</span></h2>
        <div class="timer">🕥Time Left: <span id="timer">10</span> seconds</div>
        <div class="game"></div>
    </div>
    <div class="victory-screen">
        <h1>Level <span id="victory-level-number">1</span> Completed</h1>
            <div class="score">Win</div>
            <div class="buttons">
              <button id="replay-button">Replay</button>&nbsp;&nbsp;
              <button id="home-button">Home</button>&nbsp;&nbsp;
              <button id="next-level-button">Next Level</button>&nbsp;&nbsp;
            </div>
          </div>
      
          <div class="try-again-screen" id="try-again-screen">
            <h1>Incorrect!</h1>
            <div class="buttons">
              <button id="replay-try-again-button">Replay</button>
              <button id="home-try-again-button">Home</button>
            </div>
          </div>
          
           <!-- Hidden Form for Submitting Game Progress -->
    <form id="game-form" action="emoji.jsp" method="POST" style="display: none;">
        <input type="hidden" name="game_id" value="3"> <!-- Replace with the actual game ID -->
    </form>
        
    <script>
        const emojis = [
            "&#128507;", "&#128508;", "&#128511;", "&#128512;",
            "&#128640;", "&#128052;", "&#127843;", "&#127804;"
        ];

        let level = 1;
        const maxLevel = 5; // Adjusted to 7 levels
        const gameContainer = document.querySelector('.game');
        const victoryScreen = document.querySelector('.victory-screen');
        const tryAgainScreen = document.querySelector('.try-again-screen');
        const levelNumber = document.getElementById('level-number');
        const victoryLevelNumber = document.getElementById('victory-level-number');
        const timerElement = document.getElementById('timer');
        let timerInterval;
        let gameCompleted = false;

        function startGame() {
            gameContainer.innerHTML = ''; // Clear previous game state
            gameCompleted = false;
            const numberOfCards = 4 + (level - 1) * 4;
            const numPairs = numberOfCards / 2;
            const selectedEmojis = [];
            for (let i = 0; i < numPairs; i++) {
                const emoji = emojis[i % emojis.length];
                selectedEmojis.push(emoji, emoji);
            }
            const shuffledEmojis = selectedEmojis.sort(() => Math.random() - 0.5);
            shuffledEmojis.forEach(emoji => {
                let box = document.createElement('div');
                box.className = 'item';
                box.innerHTML = emoji;
                box.onclick = function() {
                    if (!this.classList.contains('boxOpen') && !this.classList.contains('boxMatch')) {
                        this.classList.add('boxOpen');
                        setTimeout(() => {
                            const openBoxes = document.querySelectorAll('.boxOpen');
                            if (openBoxes.length > 1) {
                                const [first, second] = openBoxes;
                                if (first.innerHTML === second.innerHTML) {
                                    first.classList.add('boxMatch');
                                    second.classList.add('boxMatch');
                                }
                                first.classList.remove('boxOpen');
                                second.classList.remove('boxOpen');
                                if (document.querySelectorAll('.boxMatch').length === numberOfCards) {
                                    gameCompleted = true;
                                    showVictoryScreen();
                                }
                            }
                        }, 500);
                    }
                };
                gameContainer.appendChild(box);
            });
            startTimer();
        }

        function startTimer() {
            let timeLeft = level * 12; // Time based on level
            timerElement.textContent = timeLeft;
            timerInterval = setInterval(() => {
                timeLeft--;
                timerElement.textContent = timeLeft;
                if (timeLeft <= 0) {
                    clearInterval(timerInterval);
                    if (!gameCompleted) {
                        showTryAgainScreen();
                    }
                }
            }, 1000);
        }

        function showVictoryScreen() {
            victoryLevelNumber.textContent = level;
            victoryScreen.style.display = 'block';
            clearInterval(timerInterval);
        }

        function showTryAgainScreen() {
            tryAgainScreen.style.display = 'block';
        }

        function goHome() {
            window.location.href = 'Home.html';
            // Implement functionality to navigate home
        }

        function replay() {
            startGame();
            victoryScreen.style.display = 'none';
            tryAgainScreen.style.display = 'none';
        }

        function nextLevel() {
            if (level < maxLevel) {
                level++;
                levelNumber.textContent = level;
                startGame();
                victoryScreen.style.display = 'none';
           
                if (level === maxLevel) {
                    // Submit the form and wait for a brief period to ensure submission completes
                    document.getElementById('game-form').submit();

                    // Use a delay to allow the form submission to complete before redirecting
                    
                    alert('Congratulations! You have completed all levels!');
                }
            }
        }

        document.getElementById('home-button').addEventListener('click', goHome);
        document.getElementById('replay-button').addEventListener('click', replay);
        document.getElementById('next-level-button').addEventListener('click', nextLevel);

        document.getElementById('replay-try-again-button').addEventListener('click', replay);
        document.getElementById('home-try-again-button').addEventListener('click', goHome);

        startGame(); // Start the game initially
    </script>
    
    <%
    // Ensure the user is logged in and retrieve user ID
    if (session == null || session.getAttribute("user_id") == null) {
        // Redirect to login page if user is not logged in
        response.sendRedirect("login.jsp");
        return;
    }
	
    
    
    // Handle form submission for game progress
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int userId = (int) session.getAttribute("user_id");
        int gameId = Integer.parseInt(request.getParameter("game_id"));

        // Database connection details
        String url = "jdbc:mysql://localhost:3306/project";
        String dbUsername = "root";
        String dbPassword = "root";

        Connection connection = null;
        PreparedStatement statement = null;

        try {
            // Connect to the database
            connection = DriverManager.getConnection(url, dbUsername, dbPassword);

            // SQL query to insert a new record into the game_played table
            String sql = "INSERT INTO game_played (user_id, game_id, date_played) VALUES (?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setInt(1, userId);
            statement.setInt(2, gameId);
            statement.setTimestamp(3, new Timestamp(System.currentTimeMillis()));

            // Execute the query
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Handle exceptions
        } finally {
            try {
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    %>
    
</body>
</html>
