<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>3Number Game Combination Game</title>
    <style>
        /* Your existing CSS here */
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            background-color: #7CC0CF;
            font-family: 'Fira Mono', monospace;
            color: #0d0404;
            margin: 0;
        }
        .container h1 {
            color: black;
        }

        .game {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 600px;
            margin: 0.25rem auto;
            justify-content: center;
        }

        .target {
            border: thin solid #0e0505;
            width: 300px;
            height: 75px;
            font-size: 45px;
            text-align: center;
            background: #fff;
            border-radius: 5px;
        }

        .challenge-numbers {
            width: 100%;
            margin: 1.5rem auto;
        }

        .number {
            border: thin solid rgb(55, 158, 94);
            background: #fff;
            width: 50%;
            text-align: center;
            font-size: 36px;
            border-radius: 5px;
            margin: 5px;
            display: inline-block;
            cursor: pointer;
            text-decoration-color: #0e0505;
        }

        .timer-value {
            color: red;
            font-size: 150%;
        }

        .first {
            width: 40%;
            float: left;
            height: 50px;
        }

        .second {
            width: 40%;
            float: right;
            height: 50px;
        }

        .footer {
            display: flex;
            width: 100%;
            justify-content: space-between;
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
        .score {
            font-size: 1.5em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>3Number Game - Level <span id="level-number">1</span></h1>
        
        <div class="game">
            <div class="target">?</div>
            <div class="challenge-numbers">
                <div id="1" onclick="select()" class="number first" style="opacity: 1;">?</div>
                <div id="2" onclick="select()" class="number second" style="opacity: 1;">?</div>
                <div id="3" onclick="select()" class="number first" style="opacity: 1;">?</div>
                <div id="4" onclick="select()" class="number second" style="opacity: 1;">?</div>
                <div id="5" onclick="select()" class="number first" style="opacity: 1;">?</div>
                <div id="6" onclick="select()" class="number second" style="opacity: 1;">?</div>
            </div>
            <div class="footer">
                <span class="timer-value">Timer : </span><div class="timer-value"></div>
                <button id="start-button">Start Game</button>
            </div>
            <h3>In 15 secs, select 3 numbers from above which sum up to the number in the topmost text field. Click "Start Game" to Start and "Play Again" when done!!</h3>
        </div>
    </div>
    <div class="victory-screen">
        <h1>Level <span id="victory-level-number">1</span> Complete!</h1>
        <div class="score">Win</div>
        <div class="buttons">
            <button id="home-button">Home</button>
            <button id="replay-button">Replay</button>
            <button id="next-level-button">Next Level</button>
        </div>
    </div>
    <div class="try-again-screen">
        <h1>Incorrect!</h1>
        <div class="buttons">
            <button id="replay-again-button">Replay</button>
            <button id="home-again-button">Home</button>
        </div>
    </div>
    
    <!-- Hidden Form for Submitting Game Progress -->
    <form id="game-form" action="3number.jsp" method="POST" style="display: none;">
        <input type="hidden" name="game_id" value="5"> <!-- Replace with the actual game ID -->
    </form>
    
    <script>
        var interval = 0;
        var numbers = [];
        var answer = new Array(3);
        var count = 1;
        var sum = 0;
        var level = 1;
        var timeExpired = false;  // Track if time has expired

        function startGame() {
            freezeGame(false);
            timeExpired = false;  // Reset the timeExpired flag

            var target_number = 10 * level;  // Increase target number based on level
            var numDivs = document.getElementsByClassName("number");
            var divLength = numDivs.length;

            for (var i = 0; i < divLength; i++) {
                var num = randNum(rnd() * 10 * (i + 1));
                if (num <= 1) {
                    num = num + Math.round(i * randNum(i)) + i;
                }
                numDivs[i].innerHTML = num;
                numbers.push(num);
            }

            numbers = shuffleArray(numbers);

            var a = numbers[0],
                b = numbers[numbers.length - 1],
                c = numbers[parseInt(numbers.length / 2)];

            document.getElementsByClassName("target")[0].innerHTML = a + b + c;

            // Restore BG colors
            document.getElementsByClassName("target")[0].style.backgroundColor = "#ccc";

            for (var x = 0; x < numDivs.length; x++) {
                numDivs[x].style.backgroundColor = "#eee";
                numbers = [];
                sum = 0;
                count = 1;
                answer = [];
                clearInterval(interval);
            }

            [answer[0], answer[1], answer[2]] = [a, b, c];
            // Start timer
            startTimer(15);
        }

        function shuffleArray(array) {
            var currentIndex = array.length, temporaryValue, randomIndex;

            // While there remain elements to shuffle...
            while (0 !== currentIndex) {
                // Pick a remaining element...
                randomIndex = Math.floor(Math.random() * currentIndex);
                currentIndex -= 1;

                // And swap it with the current element.
                temporaryValue = array[currentIndex];
                array[currentIndex] = array[randomIndex];
                array[randomIndex] = temporaryValue;
            }

            return array;
        }

        function select() {
            var index = this.event.target.id - 1;
            var num = parseInt(document.getElementsByClassName("number")[index].innerHTML);

            if (count <= 3) { // Correct the limit for number selections
                sum += num;
                count++;
                document.getElementsByClassName("number")[index].style.backgroundColor = "#028482";
            }

            if (count > 3) {
                if (sum == document.getElementsByClassName("target")[0].innerHTML) {
                    // Level completed successfully
                    document.getElementById("victory-level-number").innerText = level;
                    document.querySelector(".victory-screen").style.display = "block";
                } else {
                    // Fail condition
                    document.querySelector(".try-again-screen").style.display = "block";
                }

                // Disable all buttons after selection
                freezeGame(true);
            }
        }

        function startTimer(secs) {
            var _secs = secs;
            document.getElementsByClassName("timer-value")[0].innerHTML = "Timer : " + _secs;
            interval = setInterval(function () {
                _secs--;
                document.getElementsByClassName("timer-value")[0].innerHTML = "Timer : " + _secs;
                if (_secs === 0) {
                    clearInterval(interval);
                    timeExpired = true;  // Set timeExpired flag
                    if (sum != document.getElementsByClassName("target")[0].innerHTML) {
                        freezeGame(true);
                        document.querySelector(".try-again-screen").style.display = "block";
                    }
                }
            }, 1000);
        }

        function freezeGame(freeze = true) {
            var buttons = document.getElementsByTagName("button");

            if (freeze === true) {
                document.getElementsByClassName("target")[0].style.backgroundColor = "Red";
                if (timeExpired) {
                    alert("Time's up!! The answer is : " + answer);
                }
            }

            for (var index = 0; index < buttons.length; index++) {
                if (freeze === false)
                    buttons[index].setAttribute("disabled", "disabled");
                else
                    buttons[index].removeAttribute("disabled");
            }
        }

        function nextLevel() {
            level++;
            
            if (level > 10) {
                level = 10; // Cap the level at 10
                document.querySelector(".victory-screen").style.display = "none";
                document.getElementById('game-form').submit(); // Submit the hidden form
                alert("Congratulations! You've completed all levels!");
                return;
            }
            document.getElementById("level-number").innerText = level;
            document.querySelector(".victory-screen").style.display = "none";
            startGame();
        }

        function replay() {
            document.querySelector(".try-again-screen").style.display = "none";
            startGame();
        }

        function goHome() {
            // Redirect to home page
            window.location.href = 'Home.html'; // Adjust to the correct home page URL
        }

        function rnd() {
            var today = new Date();
            var seed = today.getTime();
            // generate some random seed here
            seed = (seed * 9301 + 49297) % 233280;
            return seed / (233280.0);
        }

        function randNum(number) {
            //this will return the truncated random number
            return Math.floor(rnd() * number);
        }

        // Event listeners for buttons
        document.getElementById("start-button").addEventListener("click", startGame);
        document.getElementById("home-button").addEventListener("click", goHome);
        document.getElementById("replay-button").addEventListener("click", replay);
        document.getElementById("next-level-button").addEventListener("click", nextLevel);
        document.getElementById("replay-again-button").addEventListener("click", replay);
        document.getElementById("home-again-button").addEventListener("click", goHome);
    </script>
    <%
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
