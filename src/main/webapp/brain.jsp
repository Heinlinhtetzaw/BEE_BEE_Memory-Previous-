<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Brain Trainer</title>
  <style>
    body {
      font-family: sans-serif;
      background-color:#7CC0CF;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      margin: 0;
    }
    .container {
      background-color: rgb(241, 170, 63);
      border-radius: 10px;
      box-shadow: 5px 2px 5px rgb(235, 41, 41);
      padding: 30px;
      text-align: center;
    }
    h1 {
      color: #333;
      font-size: 50px;
    }
    #instructions{
      font-size: 30px;
    }

    #game-area {
      width: 300px;
      height: 200px;
      border: 1px solid #502288;
      margin: 20px auto;
      font-size: 78px;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    button {
      background-color: #4CAF50;
      color: white;
      padding: 10px 20px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }
    button:hover {
      background-color: #45a049;
    }
    #user-input {
      width: 100px;
      padding: 5px;
      margin-top: 10px;
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
    .victory-screen h1{
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
      background-color:skyblue;
    }
  </style>
</head>
<body>
	  <div class="container">
	    <h1>Brain Trainer - Level <span id="level-number">1</span></h1>
	    <div id="instructions">Remember the sequence of numbers!</div>
	    <div id="game-area"></div>
	    <button id="start-button">Start Game</button>
	    <br>
	    <input type="text" id="user-input" placeholder="Enter Numbers" style="display: none;">
	    <button id="check-button" style="display: none;">Check Answer</button>
	
	    <div class="victory-screen" id="victory-screen">
	      <h1>Level Completed!</h1>
	      <div class="score">Win</div>
	      <div class="buttons">
	        <button id="replay-button">Replay</button>
	        <button id="home-button">Home</button>
	        <button id="next-level-button">Next Level</button>
	      </div>
	    </div>
	
	    <div class="try-again-screen" id="try-again-screen">
	      <h1>Incorrect!</h1>
	      <div class="buttons">
	        <button id="replay-try-again-button">Replay</button>
	        <button id="home-try-again-button">Home</button>
	      </div>
	    </div>
	  </div>
	
	<!-- Hidden Form for Submitting Game Progress -->
	    <form id="game-form" action="brain.jsp" method="POST" style="display: none;">
	        <input type="hidden" name="game_id" value="6"> <!-- Replace with the actual game ID -->
	    </form>

  <script>
    const gameArea = document.getElementById("game-area");
		const startButton = document.getElementById("start-button");
		const userInput = document.getElementById("user-input");
		const checkButton = document.getElementById("check-button");
		const levelNumber = document.getElementById("level-number");
		const victoryScreen = document.getElementById("victory-screen");
		const tryAgainScreen = document.getElementById("try-again-screen");
		const nextLevelButton = document.getElementById("next-level-button");
		const replayButton = document.getElementById("replay-button");
		const homeButton = document.getElementById("home-button");
		const replayTryAgainButton = document.getElementById("replay-try-again-button");
		const homeTryAgainButton = document.getElementById("home-try-again-button");
		
		let numbers = [];
		let level = 1;
		
		function startGame() {
		  numbers = [];
		  for (let i = 0; i < (5 + level - 1); i++) {
		    numbers.push(Math.floor(Math.random() * 10));
		  }
		  displayNumbers();
		  startButton.disabled = true;
		  userInput.value = "";
		  userInput.style.display = "none";
		  checkButton.style.display = "none";
		  document.getElementById("instructions").innerText = "Remember the sequence of numbers!";
		}
		
		function displayNumbers() {
		  let index = 0;
		  gameArea.innerText = "";
		  const interval = setInterval(() => {
		    if (index < numbers.length) {
		      gameArea.innerText = numbers[index];
		      index++;
		    } else {
		      clearInterval(interval);
		      gameArea.innerText = "";
		      document.getElementById("instructions").innerText = "Enter the numbers you saw:";
		      userInput.style.display = "block";
		      checkButton.style.display = "block";
		    }
		  }, 1000);
		}
		
		function checkAnswer() {
		  const userNumbers = userInput.value.split("").map(Number);
		  if (JSON.stringify(numbers) === JSON.stringify(userNumbers)) {
		    showVictoryScreen();
		  } else {
		    showTryAgainScreen();
		  }
		}
		
		function showVictoryScreen() {
		  victoryScreen.style.display = "block";
		  startButton.disabled = false;
		  if (level >= 10) {
		    alert("Congratulations! You've completed all levels!");
		  }
		}
		
		function showTryAgainScreen() {
		  tryAgainScreen.style.display = "block";
		  startButton.disabled = false;
		}
		
		nextLevelButton.addEventListener("click", () => {
			  level++;
			 
			  if (level > 10) {
			    level = 10; // Ensure level does not exceed 10
			    
			    // Submit the form to record game completion
			    document.getElementById('game-form').submit();
			    
			    alert("Congratulations! You've completed all levels!");
			    return;
			  }
			  
			  levelNumber.innerText = level;
			  victoryScreen.style.display = "none";
			  startGame();
			});

		replayButton.addEventListener("click", () => {
		  victoryScreen.style.display = "none";
		  startGame();
		});
		
		homeButton.addEventListener("click", () => {
		  window.location.href = "Home.html"; // Replace with your home page URL
		});
		
		replayTryAgainButton.addEventListener("click", () => {
		  tryAgainScreen.style.display = "none";
		  startGame();
		});
		
		homeTryAgainButton.addEventListener("click", () => {
		  window.location.href = "Home.html"; // Replace with your home page URL
		});
		
		startButton.addEventListener("click", startGame);
		checkButton.addEventListener("click", checkAnswer);

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
