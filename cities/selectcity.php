<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

$pdo = include "../connect.php";



$query = "SELECT * FROM public.cities;"; 

$stmt = $pdo->prepare($query);
$stmt ->execute();
$data = $stmt->fetchAll(PDO::FETCH_ASSOC);
$count = $stmt->rowCount();

if ($count > 0) {
    echo json_encode(array("status" => "success", "data" => $data , JSON_UNESCAPED_UNICODE));  
} else {
    echo json_encode(array("status" => "fail"));
}
?>