<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");


$pdo = include "../connect.php";

$email = filterRequest('email');
$password_hash = filterRequest('password_hash');

$query = "SELECT * FROM public.users WHERE email = ? AND password_hash = ?;";

$stmt = $pdo ->prepare($query);
$stmt ->execute(
    array($email, $password_hash)
);
$data = $stmt->fetch(PDO::FETCH_ASSOC);
$count = $stmt->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success", "data" => $data));
} else{
    echo json_encode(array("status" => "fail"));
}
?>