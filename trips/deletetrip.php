<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");




$pdo = include "../connect.php";

$trip_id = filterRequest('trip_id');

$query = "DELETE FROM public.trips WHERE trip_id = ?;";

$stmt = $pdo ->prepare($query);
$stmt ->execute(
    array($trip_id)
);
$data = $stmt->fetch(PDO::FETCH_ASSOC);
$count = $stmt->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success", "data" => $data));
} else{
    echo json_encode(array("status" => "fail"));
}
?>