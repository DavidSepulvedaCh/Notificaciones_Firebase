<?php
include_once 'headers.php';
require __DIR__ . '/vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();
use \Firebase\JWT\JWT;
use \Firebase\JWT\Key;


$jwt = $_POST['token'];
$key = $_ENV['TOKEN_KEY'];

try {
    $decoded = JWT::decode($jwt, new Key($key, 'HS256'));
    $user_id = $decoded->user_id;
    $user_name = $decoded->username;
    $user_email = $decoded->email;
    $exp = $decoded->exp;

    if ($decoded->exp < time()) {
        echo "Error: JWT expirado";
        return;
    }

} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
    return;
}

$mysqli = new mysqli($_ENV['DB_HOST'], $_ENV['DB_USER'], $_ENV['DB_PASS'], $_ENV['DB_NAME']);
$sql = "SELECT nombre_completo, email FROM usuarios WHERE id = '$user_id'";
$result = $mysqli->query($sql);
if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $db_user_name = $row['nombre_completo'];
    $db_user_email = $row['email'];
} else {
    echo 'Usuario no encontrado';
    exit;
}


echo "JWT válido";


?>