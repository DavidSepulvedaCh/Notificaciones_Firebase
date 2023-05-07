<?php
include_once 'headers.php';
require __DIR__ . '/vendor/autoload.php';
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

class SendMenssage
{
    public $code = "";
    public $message = "";

}

$resp = new SendMenssage;
$resp->code = "Ok";
$resp->message = "Mensaje enviado exitosamente";
$tokenUser = [];

$mysqli = new mysqli($_ENV['DB_HOST'], $_ENV['DB_USER'], $_ENV['DB_PASS'], $_ENV['DB_NAME']);
if ($mysqli->connect_error) {
    $resp->code = "Error";
    $resp->message = ("Error al conectar a la base de datos: " . $mysqli->connect_error);
}

if (!empty($_POST['EMAIL_REM']) && !empty($_POST['EMAIL_RES']) && !empty($_POST['TITLE']) && !empty($_POST['MESSAGE']) && !empty($_POST['ID_RES'])) {
    $emailRem = $_POST['EMAIL_REM'];
    $emailRes = $_POST['EMAIL_RES'];
    $idRes = $_POST['ID_RES'];
    $title = $_POST['TITLE'];
    $body = $_POST['MESSAGE'];


    $consulta = $mysqli->prepare("SELECT token_fcm FROM dispositivos WHERE usuario_id = ?");
    $consulta->bind_param("i", $idRes);
    $consulta->execute();
    $rta = $consulta->get_result();
    while ($row = $rta->fetch_assoc()) {
        $tokenUser[] = $row['token_fcm'];
    }
    $consulta->close();

    $notification = [
        "title" => $title,
        "body" => $body
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
        $resp->message = "Error al enviar el mensaje, intentalo de nuevo";
    } else {
        $resp->code = "OK";
        $resp->message = "El mensaje se envio exitosamente";
        $msm = $mysqli->prepare("INSERT INTO mensajes (titulo, cuerpo, remitente_email, destinatario_email, 
            destinatario_dispositivo_id, resultado_notificacion_push) VALUES (?, ?, ?, ?, ?, ?)");
        $msm->bind_param("ssssis", $title, $body, $emailRem, $emailRes, $idRes, $resp->code);
        $msm->execute();
        $msm->close();

    }

} else {
    $resp->code = "error";
    $resp->message = "No se envio el mensaje, perdida de datos.";
}
echo json_encode($resp);
?>

?>