<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");


$pdo = include "../connect.php";

$username = filterRequest('username');
$password = filterRequest('password');

$query = "SELECT * FROM public.companies WHERE username = ? AND password = ?;";

$stmt = $pdo ->prepare($query);
$stmt ->execute(
    array($username, $password)
);
$data = $stmt->fetch(PDO::FETCH_ASSOC);
$count = $stmt->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success", "data" => $data));
} else{
    echo json_encode(array("status" => "fail"));
}
?>