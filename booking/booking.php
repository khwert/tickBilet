<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

$pdo = include "../connect.php";

$user_id = filterRequest('user_id');
$trip_id = filterRequest('trip_id');
$booking_date = filterRequest('booking_date');
$seat_number = filterRequest('seat_number');

$query = "INSERT INTO public.booking(user_id, trip_id, booking_date, seat_number) VALUES (?, ?, ?, ?);";

$stmt = $pdo ->prepare($query);
$stmt ->execute(
    array($user_id, $trip_id, $booking_date, $seat_number)
);
$count = $stmt->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success"));
} else{
    echo json_encode(array("status" => "fail"));
}
?> 
