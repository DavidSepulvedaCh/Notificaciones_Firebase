<?php

include_once 'headers.php';
require __DIR__ . '/vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();

class RegisterDivice
{
    public $code = "";
    public $message = "";
    public $id = 0;
    public $divice = "";
}

$resp = new RegisterDivice;
$resp->code = "OK";
$resp->message = "Register Successful";
$resp->id = 0;

try {
    if (isset($_POST['DISPO']) != null) {
        $divice = $_POST['DISPO'];
        if ($divice == null) {
            $resp->code = "Error";
            $resp->message = "Data missing";
            $resp->id = 0;
        } else {
            $id = $_POST['ID'];
            $mysqli = new mysqli($_ENV['DB_HOST'], $_ENV['DB_USER'], $_ENV['DB_PASS'], $_ENV['DB_NAME']);
            if ($id != null) {
                $consult = $mysqli->prepare("UPDATE DIVICES SET DISPO = ? WHERE ID = ?");
                if (!$consult) {
                    throw new Exception($mysqli->error);
                }
                $consult->bind_param("si", $divice, $id);
                $rtaOne = $consult->execute();
                $resp->divice = $divice;
                $resp->id = $id;
                $resp->message = "DIVICE UPDATE=> " . $id;
                $consult->close();
            } else {
                $consult = $mysqli->prepare("INSERT INTO DIVICES (DISPO) VALUES (?)");
                $consult->bind_param("s", $divice);
                $rtaOne = $consult->execute();
                $resp->divice = $divice;
                $resp->id = $id;
                $resp->message = "DIVICE INSERT=> " . $id;
                $resp->divice = $divice;
                $consult->close();
            }
            $mysqli->close();
        }
    } else {
        $resp->code = "error";
        $resp->message = "Device missing";
        $resp->id = 0;
    }
} catch (Exception $e) {
    $resp->code = "error";
    $resp->message = $e->getMessage();
    $resp->id = 0;
}

$myJSON = json_encode($resp);
echo $myJSON;


?>