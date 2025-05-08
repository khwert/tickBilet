<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

$pdo = include "../connect.php";


$email = filterRequest('email');
$password_hash = filterRequest('password_hash');
$name =  filterRequest('name');

$query = "INSERT INTO public.users(email, password_hash, name) VALUES (?, ?, ?);";
$stmt = $pdo ->prepare($query);
$stmt ->execute(
    array($email, $password_hash, $name)
);
$count = $stmt->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success"));
} else{
    echo json_encode(array("status" => "fail"));
}
?> 