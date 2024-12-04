<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Page</title>
    <link rel="stylesheet" href="css/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
    <div class="background"></div>
    <header>
        <img src="image/memory_game_logo-removebg-preview.png">
        <nav class="navigation">
            <a href="Home.html"><i class="fa-solid fa-house">&nbsp;</i>Home</a>
            <a href="Aboutgame.html"><i class="fa-solid fa-bars">&nbsp;</i>About game</a>
            <a href="Profile.jsp"><i class="fa-solid fa-user">&nbsp;</i>Profile</a>
            <a href="Contact.html"><i class="fa-solid fa-id-card-clip">&nbsp;</i>Contact</a>
            <a href="LogoutServlet"><i class="fa-solid fa-right-from-bracket">&nbsp;</i>Logout</a>
        </nav>
    </header>

    <div class="profile-container">
        <div class="profile-card">
            <div class="profile-image">
                <i class="fa-solid fa-user"></i>
            </div>
            <div class="profile-details">
                <p><strong>Id:</strong> <%= session.getAttribute("user_id") %></p>
                <p><strong>Name:</strong> <%= session.getAttribute("username") %></p>
                <p><strong>Email:</strong> <%= session.getAttribute("email") %></p>
               
                
            </div>
            <div> 
                <center><button class="btn2" onclick="toggleForm()">Update Your Information</button></center>
            </div>
        </div>

        <div class="user-info-table">
            <h2>Game Activity Table</h2>
            <table>
                <thead>
                    <tr>
                        <th>Game ID</th>
                        <th>Game Name</th>
                        <th>Date Played</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    String url = "jdbc:mysql://localhost:3306/project";
                    String dbUsername = "root";
                    String dbPassword = "root";
                    Connection connection = null;
                    PreparedStatement statement = null;
                    ResultSet resultSet = null;

                    try {
                        // Connect to the database
                        connection = DriverManager.getConnection(url, dbUsername, dbPassword);

                        // Prepare the SQL query
                        String sql = "SELECT gp.game_id, g.game_name, gp.date_played FROM game_played gp JOIN game g ON gp.game_id = g.game_id WHERE gp.user_id = ? ORDER BY gp.date_played DESC";
                        statement = connection.prepareStatement(sql);
                        statement.setInt(1, (int) session.getAttribute("user_id"));
                        // Execute the query
                        resultSet = statement.executeQuery();
                        
                        // Loop through the result set and display data in table rows
                        while (resultSet.next()) {
                    %>
                        <tr>
                            <td><%= resultSet.getInt("game_id") %></td>
                            <td><%= resultSet.getString("game_name") %></td>
                            <td><%= resultSet.getTimestamp("date_played") %></td>
                        </tr>
                    <% 
                        }
                    } catch (SQLException e) {
                        e.printStackTrace(); // Handle exceptions
                    } finally {
                        try {
                            if (resultSet != null) resultSet.close();
                            if (statement != null) statement.close();
                            if (connection != null) connection.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <div id="updateForm" class="profile-form" style="display:none;">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2>Update Profile Information</h2>
        <form action="ProfileUpdateServlet" method="POST">
            <input type="hidden" name="profile-id" value="<%= session.getAttribute("user_id") %>">
            <table>
                <tr>
                    <td><label for="profile-name">Name:</label></td>
                    <td><input type="text" id="profile-name" name="profile-name" value="<%= session.getAttribute("username") %>"></td>
                </tr>
                <tr>
                    <td><label for="profile-email">Email:</label></td>
                    <td><input type="email" id="profile-email" name="profile-email" value="<%= session.getAttribute("email") %>"></td>
                </tr>
                <tr>
                    <td colspan="2"><button type="submit">Update</button></td>
                </tr>
            </table>
        </form>
    </div>

    <script>
        function toggleForm() {
            const form = document.getElementById('updateForm');
            form.style.display = form.style.display === 'none' ? 'block' : 'none';
        }

        function closeModal() {
            const form = document.getElementById('updateForm');
            form.style.display = 'none';
        }
    </script>
    
</body>
</html>