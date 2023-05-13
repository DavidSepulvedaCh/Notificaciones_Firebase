<?php

include_once 'headers.php';
require __DIR__ . '/vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

class RegisterUser
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

$resp = new RegisterUser;


// Conectar a la base de datos
$mysqli = new mysqli($_ENV['DB_HOST'], $_ENV['DB_USER'], $_ENV['DB_PASS'], $_ENV['DB_NAME']);

// Verificar la conexión
if ($mysqli->connect_error) {
    die("Error al conectar a la base de datos: " . $mysqli->connect_error);
}

function encrypt_string($contra, $key)
{
    $iv = openssl_random_pseudo_bytes(16); // Generar un vector de inicialización aleatorio
    $ciphertext = openssl_encrypt($contra, 'AES-256-CBC', $key, OPENSSL_RAW_DATA, $iv); // Encriptar el string
    $encrypted_string = base64_encode($iv . $ciphertext); // Concatenar el vector de inicialización y el texto cifrado, y codificar en base64
    return $encrypted_string; // Devolver el string encriptado
}

if (!empty($_POST['email_usuario']) && !empty($_POST['token_fcm'])) {

    $email = $_POST["email_usuario"];

    // Verificar si el correo ya está registrado
    $sql = "SELECT * FROM usuarios WHERE email = '$email'";
    $result = $mysqli->query($sql);

    if ($result->num_rows > 0) {
        // El correo ya está registrado
        $resp->code = "Error";
        $resp->message = "El correo electrónico ya está registrado. Por favor, elige otro correo electrónico.";
    } else {
        // Registrar usuario
        if (isset($_POST["email_usuario"]) && isset($_POST['clave']) && isset($_POST["foto_usuario"]) && isset($_POST["nombre_completo"]) && isset($_POST["numero_telefonico"]) && isset($_POST["cargo"])) {
            $email = $_POST["email_usuario"];
            $clave = encrypt_string($_POST['clave'], $_ENV['KEY_ENCRYPT']);
            $foto = $_POST["foto_usuario"];
            $nombre = $_POST["nombre_completo"];
            $telefono = $_POST["numero_telefonico"];
            $cargo = $_POST["cargo"];

            if (!empty($email) && !empty($nombre)) {
                $sql = "INSERT INTO usuarios (email, foto, nombre_completo, numero_telefonico, cargo, clave) VALUES ('$email', '$foto', '$nombre', '$telefono', '$cargo', '$clave')";
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
                    $payload = [
                        "user_id" => $usuario_id,
                        "username" => $nombre,
                        "exp" => time() + 3600
                    ];
                    $alg = 'HS256';
                    $key_token = $_ENV['TOKEN_KEY'];
                    $jwt = \Firebase\JWT\JWT::encode($payload, $key_token, $alg);
                    $resp->tk = $jwt;

                    $loginRespModel = new LoginRespModel();
                    $loginRespModel->id = strval($usuario_id);
                    $loginRespModel->name = $nombre;
                    $loginRespModel->email = $email;
                    $loginRespModel->photo = $foto;
                    $loginRespModel->role = $cargo;
                    $loginRespModel->tel = $telefono;
                    $loginRespModel->token = $jwt;
                    $resp->loginRespModel = $loginRespModel;

                } else {
                    $resp->code = "Error";
                    $resp->message = "Error al registrar dispositivo: " . $mysqli->error;
                }
            } else {
                $resp->code = "Error";
                $resp->message = "Error al registrar el dispositivo. Campos obligatorios vacios.";
            }
        }
    }


} else {
    $resp->code = "Error";
    $resp->message = "No se pudo realizar el registro por perdida de datos";
}

// Cerrar la conexión a la base de datos
$mysqli->close();
$myJSON = json_encode($resp);
header('Content-Type: application/json');
echo json_encode($resp);
?>