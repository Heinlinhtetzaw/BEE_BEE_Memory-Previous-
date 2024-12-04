<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="utf-8">
    <title>Multiplying Number Game</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            font-family: sans-serif;
        }

        html {
            height: 100%;
        }
        body {
            background-color: #7CC0CF;
        }
        .gametitle {
            text-align: center;
            font-size: 30px;
            color: #FFF;
            margin-top: 50px;
        }
        #board {
            background-color: #FF8C00;
            width: 500px;
            height: 380px;
            border-radius: 5px;  
            box-shadow: 0px 5px 5px #134b80;
            position: relative;
            margin: 50px auto;
        }
        #right {
            padding: 5px;
            background-color: #4fb832;
            width: 70px;
            position: absolute;
            margin: 20px 200px;
            text-align: center;
            color: white;
            border-radius: 5px;
            box-shadow: 0px 5px 5px #133512;
            display: none;
        }
        #wrong {
            padding: 5px;
            background-color: #bb1010;
            width: 70px;
            position: absolute;    
            margin: 20px 200px;
            text-align: center;
            color: white;
            border-radius: 5px;
            box-shadow: 0px 5px 5px #45150c;
            display: none;
        }
        #problem {
            padding: 5px;
            background-color: #7CC0CF;
            width: 400px;
            height: 60px;
            text-align: center;
            position: absolute;
            margin: 85px 40px;
            font-size: 40px;
            line-height: 60px;
            color: white;
            border-radius: 5px;
            box-shadow: 0px 5px 5px #153d93;
        }
        #instruction {
            padding: 5px;
            background-color: #75ba26;
            width: 400px;
            height: 30px;    
            text-align: center;
            line-height: 30px;
            position: absolute;
            margin: 165px 40px;
            font-size: 20px;
            color: white;
            border-radius: 5px;
            box-shadow: 0px 5px 5px #223927;
        }
        #answers {
            margin: 215px 40px;
            position: absolute;   
        }
        #answer1, #answer2, #answer3, #answer4 {
            padding: 5px;
            height: 50px; 
            line-height: 50px;
            width: 60px;
            background-color: aliceblue;
            float: left;
            border-radius: 5px;
            font-size: 34px;
            text-align: center;
            margin-right: 43px;
            box-shadow: 0px 5px 5px grey;
        }
        #answer1:hover, #answer2:hover, #answer3:hover, #answer4:hover {
            background-color: #4b4ecc;
            color: white;
            cursor: pointer;
        }
        #answer4 {
            margin-right: 0;
        }
        #start {
            padding: 5px;
            background-color: #0000cd;
            width: 70px;
            position: absolute;    
            margin: 300px 210px;
            text-align: center;
            color: white;
            border-radius: 5px;   
            box-shadow: 0px 5px 5px #281036;
        }
        #reset {
            padding: 5px;
            background-color: #9837ae;
            width: 70px;
            position: absolute;    
            margin: 300px 210px;
            text-align: center;
            color: white;
            border-radius: 5px;
            box-shadow: 0px 5px 5px #281036;    
            display: none;
        }
        #reset:hover, #start:hover {
            background-color: #b739e9;
            cursor: pointer;
        }
        #time {
            padding: 5px;
            background-color: #e4c6f0;
            width: 105px;
            text-align: center;
            position: absolute;
            margin: 310px 350px;
            border-radius: 5px;
            box-shadow: 0px 5px 5px #0b353b;
            display: none;
        }
        #gameover {
            padding: 5px;
            line-height: 50px;
            background-color: #304f96;
            color: white;
            width: 350px;
            height: 210px;
            position: absolute;
            margin: 75px 70px;
            text-align: center;
            font-size: 30px; 
            border-radius: 5px;
            z-index: 2;
            display: none;
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
            color: #fff;
        }
    </style>
    
        
</head>
<body>
    <div id="container">
        <!-- title -->
        <h1 class="gametitle">Multiplying Number Game &nbsp;<span id="level">Level 1</span>
        <br><br>You need 10 correct answers to proceed to the next level.</h1>
        <!-- Victory Screen -->
        <div class="victory-screen">
            <h1>Level <span id="victory-level-number">1</span> Complete!</h1>
            <div class="score">Win</div>
            <div class="buttons">
                <button id="replay-button">Replay</button>
                <button id="home-button">Home</button>
                <button id="next-level-button">Next Level</button>
            </div>
        </div>

        <!-- Try Again Screen -->
        <div class="try-again-screen">
            <h1>Incorrect!</h1>
            <div class="buttons">
                <button id="replay-again-button">Replay</button>
                <button id="home-again-button">Home</button>
            </div>
        </div>

        <!-- Game Board -->
        <div id="board">
            <div id="right">Right</div>
            <div id="wrong">Try again</div>
            <div id="problem"></div>
            <div id="instruction"></div>
            <div id="answers">
                <div id="answer1"></div>
                <div id="answer2"></div>
                <div id="answer3"></div>
                <div id="answer4"></div>
            </div>
            <div id="start">Start Game</div>
            <div id="time">Time: <span id="remainingTime">30</span> sec</div>
            <div id="gameover">GAME OVER</div>
        </div>
    </div>
<!-- Hidden Form for Submitting Game Progress -->
    <form id="game-form" action="multiplying.jsp" method="POST" style="display: none;">
        <input type="hidden" name="game_id" value="4"> <!-- Replace with the actual game ID -->
    </form>
    
  <script>
        var playing = false;
        var timeRemaining;
        var action;
        var correctAnswer;
        var score = 0;
        var level = 1;  // Start at level 1
        var maxScore = 10;  // Correct answers required to complete the level

        document.getElementById("start").onclick = function() {
            if (playing) {
                location.reload();
            } else {
                playing = true;
                initializeGame(level);  // Initialize game at current level
            }
        }

        function initializeGame(level) {
            score = 0;
            document.getElementById("instruction").innerHTML = "Click on the right answer";
            show("time");
            setTimeForLevel(level);
            hide("gameover");
            document.getElementById("start").innerHTML = "Reset Game";
            startCountdown();
            generateQA();
        }

        for (var i = 1; i <= 4; i++) {
            document.getElementById("answer" + i).onclick = function() {
                if (playing) {
                    if (this.innerHTML == correctAnswer) {
                        show("right");
                        setTimeout(function() {
                            hide("right");
                        }, 1000);
                        hide("wrong");
                        score++;
                        if (score >= maxScore) {
                            if (level < 10) {
                                showVictoryScreen();
                            } else {
                                showGameOver();
                            }
                        } else {
                            generateQA();
                        }
                    } else {
                        show("wrong");
                        setTimeout(function() {
                            hide("wrong");
                        }, 1000);
                        hide("right");
                    }
                }
            }
        }

        function setTimeForLevel(level) {
            timeRemaining = 36 - level;
            if (timeRemaining < 5) timeRemaining = 5;
            document.getElementById("remainingTime").innerHTML = timeRemaining;
        }

        function startCountdown() {
            stopCountdown();
            action = setInterval(function() {
                timeRemaining--;
                document.getElementById("remainingTime").innerHTML = timeRemaining;
                if (timeRemaining <= 0) {
                    stopCountdown();
                    if (score < maxScore) {
                        showTryAgainScreen();
                    } else {
                        showVictoryScreen();
                    }
                }
            }, 1000);
        }

        function stopCountdown() {
            clearInterval(action);
        }

        function showVictoryScreen() {
            hide("time");
            hide("right");
            hide("wrong");
            document.querySelector(".victory-screen").style.display = "block";
            document.getElementById("victory-level-number").innerText = level;
        }

        function showTryAgainScreen() {
            hide("time");
            hide("right");
            hide("wrong");
            document.querySelector(".try-again-screen").style.display = "block";
        }

        function showGameOver() {
            hide("time");
            hide("right");
            hide("wrong");
            hide("board");
            alert("Congratulations! You've completed all levels!");
            playing = false;
            document.getElementById("start").innerHTML = "Start Game";
        }

        function generateQA() {
            var randomNumber1 = Math.round(Math.random() * 10);
            var randomNumber2 = Math.round(Math.random() * 10);

            document.getElementById("problem").innerHTML = randomNumber1 + " x " + randomNumber2;
            correctAnswer = randomNumber1 * randomNumber2;
            var answerBox = Math.round(Math.random() * 3) + 1;

            document.getElementById("answer" + answerBox).innerHTML = correctAnswer;

            var answers = [correctAnswer];

            for (var i = 1; i <= 4; i++) {
                if (i !== answerBox) {
                    var wrongAnswer;
                    do {
                        wrongAnswer = (Math.round(Math.random() * 10)) * (Math.round(Math.random() * 10));
                    } while (answers.indexOf(wrongAnswer) > -1);

                    document.getElementById("answer" + i).innerHTML = wrongAnswer;
                    answers.push(wrongAnswer);
                }
            }
        }

        function hide(id) {
            document.getElementById(id).style.display = "none";
        }

        function show(id) {
            document.getElementById(id).style.display = "block";
        }

        function goHome() {
            // Implement navigation to home or main page
            window.location.href = 'Home.html';
        }

        function replay() {
            hideVictoryScreen();
            hideTryAgainScreen();
            initializeGame(level);  // Replay the current level
        }

        function hideVictoryScreen() {
            document.querySelector(".victory-screen").style.display = "none";
        }

        function hideTryAgainScreen() {
            document.querySelector(".try-again-screen").style.display = "none";
        }

        function nextLevel() {
            hideVictoryScreen();
            level++;
            
            if (level > 10) {
                
                document.getElementById('game-form').submit();
                
                alert("Congratulations! You've completed all levels!");
                
            } else {
                document.getElementById("level").innerText = "Level " + level;
                initializeGame(level);  // Initialize game for the next level
            }
        }


        // Add event listeners for buttons
        document.getElementById("home-button").addEventListener("click", goHome);
        document.getElementById("replay-button").addEventListener("click", replay);
        document.getElementById("next-level-button").addEventListener("click", nextLevel);
        document.getElementById("home-again-button").addEventListener("click", goHome);
        document.getElementById("replay-again-button").addEventListener("click", replay);
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
