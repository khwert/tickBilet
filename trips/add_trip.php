<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

$pdo = include "../connect.php";

$company_id = filterRequest('company_id');
$departure_city_id = filterRequest('departure_city_id');
$departure_time =  filterRequest('departure_time');
$arrival_time = filterRequest('arrival_time');
$price = filterRequest('price');
$arrival_city_id = filterRequest('arrival_city_id');
$bus_id = filterRequest('bus_id');


$query = "INSERT INTO public.trips(company_id, departure_city_id, departure_time, arrival_time, price, arrival_city_id, bus_id)
	VALUES (?, ?, ?, ?, ?, ?, ?);";

$stmt = $pdo ->prepare($query);
$stmt ->execute(
    array($company_id, $departure_city_id,$departure_time, $arrival_time, $price, $arrival_city_id, $bus_id)
);
$count = $stmt->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success"));
} else{
    echo json_encode(array("status" => "fail"));
}
?> 