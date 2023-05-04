<?php

include_once 'headers.php';
require __DIR__.'/vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

class SendNotificationsResp
{
    public $code = '';
    public $message = '';
}

$resp = new SendNotificationsResp;
$resp->code = 'OK';
$resp->message = 'Message success';

try {
    if (isset($_POST['ID'], $_POST['TITLE'], $_POST['MESSAGE'])) {
        if (!isset($_POST['ID'], $_POST['TITLE'], $_POST['MESSAGE'])) {
            $resp->code = 'Err';
            $resp->message = 'Missing parameters';
            throw new Exception('Missing parameters');
        }

        $id = $_POST['ID'];
        $TITLE = $_POST['TITLE'];
        $messageNotification = $_POST['MESSAGE'];

        // DB CONNECT
        $mysqli = new mysqli($_ENV['DB_HOST'], $_ENV['DB_USER'], $_ENV['DB_PASS'], $_ENV['DB_NAME']);

        // SEARCH IN DB
        $ids = array();
        $data = array();

        $consult = mysqli_prepare($mysqli, 'SELECT DISPO FROM DIVICES WHERE ID = ?');
        mysqli_stmt_bind_param($consult, 'i', $id);
        mysqli_stmt_execute($consult);

        $rta = mysqli_stmt_get_result($consult);
        while ($row = mysqli_fetch_assoc($rta)) {
            if ($row['DISPO'] != null) {
                $ids[] = $row['DISPO'];
            }
        }
        $consult->close();

        // PARAMETERS VALIDATION
        if (empty($ids)) {
            $resp->code = 'Error!!';
            $resp->message = 'No devices found';
        }

        $notifications = array();
        $notifications["TITLE"] = $title;
        $notifications["BODY"] = $messageNotification;

        $fields = array(
            'ids' => $ids,
            'notification' => $notifications,
            'direct_book_ok' => true
        );

        //API KEY SERVER FIREBASE
        $serverURL = $_ENV['SERVER_API'];

        //HEADER FOR REQUESTS // API KEY OF FCM
        $headers = array("authorization: key=" . $_ENV['FCM_API'] . "", "content-type: application/json");

        //CURL CONNECTION FOR REQUESTS
        $connectCURL = curl_init();

        //PARAMETERS OF RESQ
        curl_setopt($connectCURL, CURLOPT_URL, $serverURL);
        curl_setopt($connectCURL, CURLOPT_POST, true);
        curl_setopt($connectCURL, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($connectCURL, CURLOPT_RETURNTRANSFER, true);

        //It is set to false because we are in development environment
        curl_setopt($connectCURL, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($connectCURL, CURLOPT_POSTFIELDS, json_encode($fields));

        $result = curl_exec($connectCURL);
        if ($result === false) {
            // die('Curl failed: ' . curl_error($ch));
        }
        curl_close($connectCURL);
    } else {
        $resp->code = "Error";
        $resp->message = "Missing data";
    }
} catch (Exception $e) {
    echo 'Error: ' . $e->getMessage();
}

$jsonI = json_encode($resp);
echo $jsonI;
