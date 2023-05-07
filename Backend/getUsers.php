<?php

include_once 'headers.php';
require __DIR__ . '/vendor/autoload.php';
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();


class GetUsers
{
    public $code = "";
    public $message = "";

}
$resp = new GetUsers;
$resp->code = "Sucess";
$resp->message = "dfdd";

$mysqli = new mysqli($_ENV['DB_HOST'], $_ENV['DB_USER'], $_ENV['DB_PASS'], $_ENV['DB_NAME']);

$users = array();
$consulta = mysqli_query($mysqli, "SELECT * FROM usuarios");

while ($row = mysqli_fetch_array($consulta)) {
    $users[] = $row;
}
mysqli_close($mysqli);

echo json_encode($users);


?>