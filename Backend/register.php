<?php

include_once 'headers.php';
require __DIR__ . '/vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

class RegisterUser
{
    public $code = "";
    public $message = "";
}

$resp = new RegisterUser;


// Conectar a la base de datos
$mysqli = new mysqli($_ENV['DB_HOST'], $_ENV['DB_USER'], $_ENV['DB_PASS'], $_ENV['DB_NAME']);

// Verificar la conexión
if ($mysqli->connect_error) {
    die("Error al conectar a la base de datos: " . $mysqli->connect_error);
}

if (!empty($_POST['email_usuarios']) && !empty($_POST['token_fcm'])) {
    // Registrar usuario
    if (isset($_POST["email_usuario"]) && isset($_POST["foto_usuario"]) && isset($_POST["nombre_completo"]) && isset($_POST["numero_telefonico"]) && isset($_POST["cargo"])) {
        $email = $_POST["email_usuario"];
        $foto = $_POST["foto_usuario"];
        $nombre = $_POST["nombre_completo"];
        $telefono = $_POST["numero_telefonico"];
        $cargo = $_POST["cargo"];

        if (!empty($email) && !empty($nombre)) {
            $sql = "INSERT INTO usuarios (email, foto, nombre_completo, numero_telefonico, cargo) VALUES ('$email', '$foto', '$nombre', '$telefono', '$cargo')";
            if ($mysqli->query($sql) === TRUE) {
                $usuario_id = $mysqli->insert_id;
                $resp->code = "OK";
                $resp->message = "Usuario" . $email . " registrado con exito";
            } else {
                $resp->code = "OK";
                $resp->message = "Error al registrar usuario: " . $mysqli->error;
            }
        } else {
            $resp->code = "Error";
            $resp->message = "Error al registrar el usuario. Campos obligatorios vacios.";
        }
    }

    // Registrar dispositivo
    if (isset($usuario_id) && isset($_POST["token_fcm"])) {
        /* $usuario_id = $_POST["usuario_id"]; */
        $token_fcm = $_POST["token_fcm"];

        if (!empty($usuario_id) && !empty($token_fcm)) {
            $sql = "INSERT INTO dispositivos (usuario_id, token_fcm) VALUES ('$usuario_id', '$token_fcm')";
            if ($mysqli->query($sql) === TRUE) {
                $resp->code = "OK";
                $resp->message = "Dispositivo registrado correctamente";
            } else {
                $resp->code = "Error";
                $resp->message = "Error al registrar dispositivo: " . $mysqli->error;
            }
        } else {
            $resp->code = "Error";
            $resp->message = "Error al registrar el dispositivo. Campos obligatorios vacios.";
        }
    }
} else {
    $resp->code = "Error";
    $resp->message = "No se pudo realizar el registro por perdida de datos";
}

// Cerrar la conexión a la base de datos
$mysqli->close();
$myJSON = json_encode($resp);
echo $myJSON;
?>