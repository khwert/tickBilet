<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");


$pdo = include "../connect.php";

$company_id = filterRequest('company_id');
$total_seats = filterRequest('total_seats');
$plate_number = filterRequest('plate_number');

$query = "INSERT INTO public.buses(company_id, total_seats, plate_number) VALUES (?, ?, ?);";
$stmt = $pdo ->prepare($query);
$stmt -> execute( array($company_id, $total_seats, $plate_number)
);
$count = $stmt->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success"));
} else{
    echo json_encode(array("status" => "fail"));
}
?> 
