<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");


$pdo = include "../connect.php";

$company_name = filterRequest('company_name');
$username = filterRequest('username');
$password = filterRequest('password');

$query = "INSERT INTO public.companies(company_name, username, password) VALUES (?, ?, ?);";
$stmt = $pdo ->prepare($query);
$stmt -> execute( array($company_name, $username, $password)
);
$count = $stmt->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success"));
} else{
    echo json_encode(array("status" => "fail"));
}
?> 
