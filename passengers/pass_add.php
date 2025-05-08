<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

$pdo = include "../connect.php";

$booking_id = filterRequest('booking_id');
$seat_id = filterRequest('seat_id');
$passenger_name = filterRequest('passenger_name');
$tc = filterRequest('tc');




$query = "INSERT INTO public.passenger(booking_id, seat_id, passenger_name, tc) VALUES (?, ?, ?, ?);";

$stmt = $pdo ->prepare($query);
$stmt ->execute(
    array($booking_id, $seat_id, $passenger_name, $tc)
);
$count = $stmt->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success"));
} else{
    echo json_encode(array("status" => "fail"));
}
?> 
