<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");


$pdo = include "../connect.php";

$bus_id = filterRequest('bus_id');
$trip_id = filterRequest('trip_id');


$query = "SELECT * FROM public.seat WHERE bus_id = ? AND trip_id = ?;";

$stmt = $pdo ->prepare($query);
$stmt ->execute(
    array($bus_id, $trip_id)
);
$data = $stmt->fetchAll(PDO::FETCH_ASSOC);
$count = $stmt->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success", "data" => $data));
} else{
    echo json_encode(array("status" => "fail"));
}
?>