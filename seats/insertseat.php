<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

$pdo = include "../connect.php";
$bus_id = filterRequest('bus_id');
$trip_id = filterRequest('trip_id');
$seat_number = filterRequest('seat_number');
$is_available = filterRequest('is_available');
$gender = filterRequest('gender');

$query = "INSERT INTO public.seat(bus_id, trip_id, seat_number, is_available, gender)
	VALUES (?, ?, ?, ?, ?);";
$stmt = $pdo ->prepare($query);
$stmt ->execute(
    array($bus_id, $trip_id, $seat_number, $is_available, $gender)
);
$count = $stmt->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success"));
} else{
    echo json_encode(array("status" => "fail"));
}
?> 