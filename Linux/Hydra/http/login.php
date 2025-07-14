<!-- A fake php login page to test the effectivness of the http-form-brute script. You can make it active with php -S 127.0.0.1:8080 within the working directory -->

<?php
$valid_user = "admin";
$valid_pass = "password";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user = $_POST['username'] ?? '';
    $pass = $_POST['password'] ?? '';

    if ($user === $valid_user && $pass === $valid_pass) {
        echo "Welcome $user!";
    } else {
        echo "Login failed";
    }
    exit;
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Fake Login Page</title>
</head>
<body>
    <h2>Login</h2>
    <form action="/login.php" method="post">
        Username: <input type="text" name="username"><br><br>
        Password: <input type="password" name="password"><br><br>
        <input type="submit" value="Login">
    </form>
</body>
</html>
