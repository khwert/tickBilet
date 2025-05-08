<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

$pdo = include "../connect.php";
$company_id = filterRequest('company_id');


$query = "SELECT 
    t.trip_id,
    t.departure_time,
    t.arrival_time,
    t.price,
    d.name AS departure_city_name,
    a.name AS arrival_city_name,
    b.plate_number
FROM trips t
JOIN cities d ON t.departure_city_id = d.city_id
JOIN cities a ON t.arrival_city_id = a.city_id
JOIN buses b ON t.bus_id = b.bus_id
WHERE t.company_id = ?";

$stmt = $pdo->prepare($query);
$stmt->execute([$company_id]);
$data = $stmt->fetchAll(PDO::FETCH_ASSOC);

if ($stmt->rowCount() > 0) {
    echo json_encode(["status" => "success", "data" => $data]);
} else {
    echo json_encode(["status" => "fail"]);
}
?>
