<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

$pdo = include "../connect.php";


$departure_city = filterRequest('departure_city_id');
$arrival_city = filterRequest('arrival_city_id');
$departure_time =filterRequest('departure_time');

$query = "SELECT 
    t.trip_id,
    t.company_id,
    c.company_name,
     c.logo,
    dep.name AS departure_city, 
    arr.name AS arrival_city, 
    t.departure_time, 
    t.arrival_time,
    t.price, 
    t.bus_id,
    b.total_seats 
FROM public.trips t
JOIN public.companies c ON t.company_id = c.company_id
JOIN public.cities dep ON t.departure_city_id = dep.city_id
JOIN public.cities arr ON t.arrival_city_id = arr.city_id
JOIN public.buses b ON t.bus_id = b.bus_id
WHERE t.departure_city_id = ? 
AND t.arrival_city_id = ? 
AND t.departure_time BETWEEN ? AND ?;";

$dateOnly = date('Y-m-d', strtotime($departure_time));
$start = "$dateOnly 00:00:00";
$end = "$dateOnly 23:59:59";
$stmt = $pdo->prepare($query);
$stmt->execute([$departure_city, $arrival_city, $start, $end]);
$data = $stmt->fetchAll(PDO::FETCH_ASSOC);
$count = $stmt->rowCount();

if ($count > 0) {
    echo json_encode(array("status" => "success", "data" => $data), JSON_UNESCAPED_UNICODE);
  
} else {
    echo json_encode(array("status" => "fail"));
}
?>
