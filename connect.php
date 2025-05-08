<?php
$host = 'localhost';
$db = 'your_db_name';
$user = 'your_db_user';
$pass = 'your_db_pass';  



function connect(string $host, string $db, string $user, string $pass): PDO
{
    try {
        $dsn = "pgsql:host=$host;port=5432;dbname=$db;";

     
        $pdo = new PDO(
            $dsn,
            $user,
            $pass,
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
        );

    
        $pdo->exec("SET NAMES 'UTF8'");
          include "functions.php";
        return $pdo;
    } catch (PDOException $e) {
        die($e->getMessage());
    }
}

return connect($host, $db, $user, $pass);
?>
