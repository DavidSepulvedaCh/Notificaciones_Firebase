<?php

include_once 'headers.php';
require __DIR__ . '/vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();


class SendNotifications
{
    public $code = "";
    public $message = "";
}

$resp = new SendNotifications;

if (!isset($_POST['ID'], $_POST['TITLE'], $_POST['MESSAGE'])) {
    $resp->code = "ERR";
    $resp->message = "Faltan campos";
    echo json_encode($resp);
    exit;
}

$id = $_POST['ID'];
$title = $_POST['TITLE'];
$message = $_POST['MESSAGE'];

if ($id === "" || $title === "" || $message === "") {
    $resp->code = "ERR";
    $resp->message = "Faltan parametro";
    echo json_encode($resp);
    exit;
}

$ids = [];
$notification = [
    "title" => $title,
    "body" => $message
];

//busco en la DB el id
$mysqli = new mysqli($_ENV['DB_HOST'], $_ENV['DB_USER'], $_ENV['DB_PASS'], $_ENV['DB_NAME']);

$consulta = $mysqli->prepare("SELECT DISPO FROM DIVICES WHERE ID = ?");
$consulta->bind_param("i", $id);
$consulta->execute();
$resultado = $consulta->get_result();
while ($fila = mysqli_fetch_assoc($resultado)) {
    if ($fila["DISPO"] !== null) {
        $ids[] = $fila["DISPO"];
    }
}

$consulta->close();
$mysqli->close();

$fields = [
    'registration_ids' => $ids,
    'notification' => $notification,
    //'data' => $datos,
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
    $resp->message = "Enviado correctamente";
}

echo json_encode($resp);
?>