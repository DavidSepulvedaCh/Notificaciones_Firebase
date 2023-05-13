<?php

include_once 'headers.php';
require __DIR__ . '/vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

class LoginUser
{
    public $code = "";
    public $message = "";
    public $tk = "";
    public $loginRespModel;
}

class LoginRespModel
{
    public $id;
    public $name;
    public $email;
    public $photo;
    public $role;
    public $tel;
    public $token;

}

$resp = new LoginUser;

// Conectar a la base de datos
$mysqli = new mysqli($_ENV['DB_HOST'], $_ENV['DB_USER'], $_ENV['DB_PASS'], $_ENV['DB_NAME']);

// Verificar la conexión
if ($mysqli->connect_error) {
    die("Error al conectar a la base de datos: " . $mysqli->connect_error);
}

function decrypt_string($encrypted_string, $key)
{
    $data = base64_decode($encrypted_string);
    $iv = substr($data, 0, 16);
    $ciphertext = substr($data, 16);
    $plaintext = openssl_decrypt($ciphertext, 'AES-256-CBC', $key, OPENSSL_RAW_DATA, $iv);
    return $plaintext;
}

if (!empty($_POST['email_usuario']) && !empty($_POST['clave']) && !empty($_POST['token_fcm'])) {

    $email = $_POST["email_usuario"];
    $clave = $_POST['clave'];
    $tokenNuevo = $_POST['token_fcm'];

    // Buscar usuario en la base de datos
    $sql = "SELECT * FROM usuarios WHERE email = '$email'";
    $result = $mysqli->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $clave_encriptada = $row['clave'];
        $clave_descifrada = decrypt_string($clave_encriptada, $_ENV['KEY_ENCRYPT']);
        if ($clave === $clave_descifrada) {
            // Credenciales válidas, generar token JWT
            $usuario_id = $row['id'];
            $nombre = $row['nombre_completo'];

            $payload = [
                "user_id" => $usuario_id,
                "username" => $nombre,
                "email" => $email,
                "exp" => time() + 604800
            ];

            $sql = "SELECT * FROM dispositivos WHERE usuario_id = '$usuario_id' AND token_fcm = '$tokenNuevo'";
            $result = $mysqli->query($sql);
            if ($result->num_rows == 0) {
                $sql = "INSERT INTO dispositivos (usuario_id, token_fcm) VALUES ('$usuario_id', '$tokenNuevo') ";
                if ($mysqli->query($sql) == true) {
                    $resp->code = "OK";
                    $resp->message = "Login exitoso. Nuevo dispositivo registrado.";
                }
            }



            $alg = 'HS256';
            $key_token = $_ENV['TOKEN_KEY'];
            $jwt = \Firebase\JWT\JWT::encode($payload, $key_token, $alg);
            $resp->code = "OK";
            $resp->message = "Inicio de sesión exitoso";
            $resp->tk = $jwt;

            $loginRespModel = new LoginRespModel();
            $loginRespModel->id = $usuario_id;
            $loginRespModel->name = $row["nombre_completo"];
            $loginRespModel->email = $row["email"];
            $loginRespModel->photo = $row["foto"];
            $loginRespModel->role = $row["cargo"];
            $loginRespModel->tel = $row["numero_telefonico"];
            $loginRespModel->token = $jwt;
            $resp->loginRespModel = $loginRespModel;

        } else {
            // Contraseña incorrecta
            $resp->code = "Error";
            $resp->message = "Contraseña incorrecta";
        }
    } else {
        // Usuario no encontrado
        $resp->code = "Error";
        $resp->message = "Usuario no encontrado";
    }

} else {
    // Datos incompletos
    $resp->code = "Error";
    $resp->message = "Por favor, ingrese su correo electrónico y contraseña";
}

// Cerrar la conexión a la base de datos
$mysqli->close();
$myJSON = json_encode($resp);
header('Content-Type: application/json');
echo json_encode($resp);
?>