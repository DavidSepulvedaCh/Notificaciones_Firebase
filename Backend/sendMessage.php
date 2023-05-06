<?php

include_once 'headers.php';
require __DIR__ . '/vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

class SendMessage
{
    public $code = "";
    public $message = "";
}

$resp = new SendMessage;
$resp->code = "Ok";
$resp->message = "Message send!";
$tokenUser = [];



$mysqli = new mysqli($_ENV['DB_HOST'], $_ENV['DB_USER'], $_ENV['DB_PASS'], $_ENV['DB_NAME']);

if ($mysqli->connect_error) {
    $resp->code = "Error";
    $resp->message = "Error en la conexión con la  BD: " . $mysqli->connect_error;
}

/* $users = [];
$consulta = mysqli_query($mysqli, "SELECT * FROM usuarios");
while ($row = mysqli_fetch_assoc($consulta)) {
array_push($users, $row);
} */


//obteniedo el token del destinatario
if (!empty($_POST['id_user']) && !empty($_POST['titulo']) && !empty($_POST['mensaje'])) {
    $id = $_POST['id_user'];
    $consulta = $mysqli->prepare("SELECT token_fcm FROM dispositivos WHERE usuario_id = ?");
    $consulta->bind_param("i", $id);
    $consulta->execute();
    $result = $consulta->get_result();
    while ($row = $result->fetch_assoc()) {
        $tokenUser[] = $row['token_fcm'];
    }
    $consulta->close();
    $mysqli->close();


    $titulo = $_POST['titulo'];
    $mensaje = $_POST['mensaje'];
    $notification = [
        "title" => $titulo,
        "body" => $mensaje
    ];

    $fields = [
        'registration_ids' => $tokenUser,
        'notification' => $notification,
        'direct_book_ok' => true
    ];

    $url = 'https://fcm.googleapis.com/fcm/send';
    $headers = [
        "authorization: key=" . $_ENV['FCM_API'],
        "content-type: application/json"
    ];
    $ch = curl_init();
    curl_setopt_array($ch, [
        CURLOPT_URL => $url,
        CURLOPT_POST => true,
        CURLOPT_HTTPHEADER => $headers,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_POSTFIELDS => json_encode($fields)
    ]);
    $result = curl_exec($ch);
    curl_close($ch);

    if ($result === false) {
        $resp->code = "ERR";
        $resp->message = "Error";
    } else {
        $resp->code = "OK";
        $resp->message = "El mensaje se envio exitosamente";
    }
} else {
    $resp->code = "error";
    $resp->message = "No se envio el mensaje, perdida de datos.";
}
echo json_encode($resp);
?>