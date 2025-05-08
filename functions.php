<?php

define('MB' , 1048576);
function filterRequest ($requestname){
   return  htmlspecialchars(strip_tags($_POST[$requestname]));
}

function imageUpload($imageRequest){
   global $msgError;
   $imagename = rand(1, 100). $_FILES[$imageRequest]['name'];
   $imagetmp = $_FILES[$imageRequest]['tmp_name'];
   $imagesize = $_FILES[$imageRequest]['size'];
   $allowExt =  array("jpg", "png");
   $strToArray = explode(".",$imagename);
   $ext    = end($strToArray);
   $ext = strtolower($ext);

   if (!empty($imagename) && !in_array($ext , $allowExt)) {
     $msgError [] = "Ext Error";
   }
    if ($imagesize > 2 * MB) {
       $msgError[] = "Size Error";
    }

   if (empty($msgError)) {
      move_uploaded_file($imagetmp, "../upload/".$imagename);
      return $imagename;
   } else {
       return "fail";
   }
}

function deleteFile($dir, $imagename){ // Use it in delete company or Update image
   if (file_exists($dir. "/". $imagename)) {
       unlink($dir. "/". $imagename);
   }
}
?>
