<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

$pdo = include "../connect.php";


$company_name = filterRequest('company_name');
$descript = filterRequest('descript');
$logo= filterRequest('logoname');
$company_id = filterRequest('company_id');
$username = filterRequest('username');
$password = filterRequest('password');
$phone = filterRequest('phone');
$email = filterRequest('email');

if (isset($_FILES['logo'])) {
     deleteFile("../upload", $logo);
    $logo= imageUpload('logo');      
    }

$query = "UPDATE public.companies
	SET company_name=?, descript=?, logo=?, username=?, password=?, phone=?, email=?
	WHERE company_id=?;";

    if ($logo != 'fail') {
        $stmt = $pdo ->prepare($query);
        $stmt ->execute(
            array($company_name, $descript, $logo,  $username, $password, $phone, $email, $company_id )
        );
        $count = $stmt->rowCount();
        if ($count > 0) {
            echo json_encode(array("status" => "success"));
        } else{
            echo json_encode(array("status" => "fail"));
        }
    } else{
            echo json_encode(array("status" => "fail"));
        }

?>