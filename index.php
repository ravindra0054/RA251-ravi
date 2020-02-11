<?php

include("config/database.php");
//extract($_POST);
if(isset($_POST['sub'])){

  echo '<pre>';
  //print_r($_POST);
  //print_r($_FILES['att']); //die;
  $uploadedFiles = $_FILES['att'];
  $uploadedFilesNames = $uploadedFiles['name'];
  //print_r($uploadedFilesNames); //die;
  foreach($uploadedFilesNames as $filename){
	  echo $filename; die;
  }
  
  // Getting file name
  $fn = $_FILES['att']['name'];
 
  // Valid extension
  $valid_ext = array('png','jpeg','jpg','gif');

  // Location
  $location = "img/".$fn;

  // file extension
  $arr = pathinfo($location, PATHINFO_EXTENSION);
  $ext = strtolower($arr);

  // Check extension
  if(in_array($ext,$valid_ext)){

    // Compress Image
	
	echo 'Image before compress =>'.$_FILES['att']['tmp_name'];
  
    compressImage($_FILES['att']['tmp_name'],$location,60);

  }else{
    echo "Invalid file type.";
  }
}

// Compress image
function compressImage($source, $destination, $quality) {

  $info = getimagesize($source);
  
  echo '<pre>';
  print_r($info);

  if ($info['mime'] == 'image/jpeg') 
    $image = imagecreatefromjpeg($source);

  else if ($info['mime'] == 'image/gif') 
    $image = imagecreatefromgif($source);

  else if ($info['mime'] == 'image/jpg') 
    $image = imagecreatefromgif($source);

  else if ($info['mime'] == 'image/png') 
    $image = imagecreatefrompng($source);

  imagejpeg($image, $destination, $quality);
  
  echo '<br>Tesing Image =>'.$filename.'<=>'.$image;
  
  move_uploaded_file($filename,"img/".$image);
	

}

//die;


if(mysqli_query($link,"INSERT INTO gallery(heading,description,images)VALUES ('$heading','$message','$image')"))
{
	//header("location:dashboard.php");
}





?>



<html>
	<head>
		<title>Gallery</title>
	</head>
	<body>
	<h2>Gallery</h2>
		<table align="center" cellspacing="0px" cellpadding="0px">
		<form method="post" enctype="multipart/form-data">
		
		
		
			<input type="text" placeholder="Heading" name="heading" value="" required/>
			</br>
			<textarea name="message" rows="10" name="message" cols="30"></textarea>
			</br>
			<input type="file" name="att[]" multiple>
			</br>
		
		<input type="submit" name="sub" value="submit" >
		</form>
		<table>
	</body>
</html>