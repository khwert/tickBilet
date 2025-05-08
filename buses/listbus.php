<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");



$pdo = include "../connect.php";

$company_id = filterRequest('company_id');

$query = "SELECT * FROM public.buses WHERE company_id = ?;";

$stmt = $pdo ->prepare($query);
$stmt ->execute(
    array($company_id)
);
$data = $stmt->fetchAll(PDO::FETCH_ASSOC);
$count = $stmt->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success", "data" => $data));
} else{
    echo json_encode(array("status" => "fail"));
}
?>