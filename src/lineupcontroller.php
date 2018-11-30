<?php 
require_once('php/lineup.php');
require_once('php/exceptions/recordnotfoundexception.php');

// get
if($_SERVER['REQUEST_METHOD'] == 'GET')
{
    if($parameters != '')
    {
        try
        {
            $t = new LineUp($parameters);

            echo json_encode(array(
                'status' => 0,
                'lineup' => json_decode($t->toJson())
            ));
        }       
        catch(RecordNotFoundException $ex)
        {
            echo json_encode(array(
                'status' => 2,
                'errorMessage' => 'Invalid lineup id',
                'details' => $ex->getMessage()
            ));
        }

    }
    else
    {
        $line = new LineUp($parameters);
        echo json_encode(array(
            'status' => 0,
            'lineups' => json_decode($line->getAllPlayerToJson)
        ));
    }
}

// post
if($_SERVER['REQUEST_METHOD'] == 'POST')
{
    $parametersOk = false;

   if(isset($_POST['nameLineUp']) && isset($_POST['categoryLineUp']) && isset($_POST['coachLineUp']))
   {
       $parametersOk = true;
       $right = true;

       $t = new LineUp();
       $t->setName($_POST['nameLineUp']);

       try {
           $cat = new Category($_POST['categoryLineUp']);
           $t->setCategory($cat);
           
       } catch (RecordNotFoundException $ex) {
                   $right = false;
            echo json_encode(array(
                'status' => 2,
                'errorMessage' => 'Invalid lineup id',
                'details' => $ex->getMessage()
            ));
       }

       if ($right) {
           try {
               $co = new Coach($_POST['coachLineUp']);
               $t->setCoach($co);
               
           } catch (RecordNotFoundException $ex) {
               $right = false;
                echo json_encode(array(
                    'status' => 2,
                    'errorMessage' => 'Invalid coach id',
                    'details' => $ex->getMessage()
                ));
           }
       }

       if($right)
       {
           if($t->add())
           {       
               echo json_encode(array(
                   'status' => 0,
                   'message' => 'LineUp added successfully'
               ));
           }       
           else
           {   
               $right = false;
               echo json_encode(array(
                   'status' => 2,
                   'errorMessage' => 'Could not add lineup'
               ));
           }   
       }


       }

   if(!$parametersOk)
   {
       echo json_encode(array(
           'status' => 1,
           'errorMessage' => 'Missing parameters'
       ));
   }

}   

if($_SERVER['REQUEST_METHOD'] == 'PUT')
{
    $parametersOk = false;
    parse_str(file_get_contents("php://input"), $jsonData);
    if(isset($jsonData['dataLineUp'])){
        $post_vars = json_decode($jsonData['dataLineUp'], true);
    }

    if(isset($post_vars['idLineUp']) && isset($post_vars['nameLineUp']) && isset($post_vars['categoryLineUp']) && isset($post_vars['coachLineUp']))
    {
        $parametersOk = true;
	$right = true;

        try
        {
	    $t = new LineUp($post_vars['idLineUp']);
	    $t->setName($post_vars['nameLineUp']);
        }       
        catch(RecordNotFoundException $ex)
        {
	    $right = false;
            echo json_encode(array(
                'status' => 2,
                'errorMessage' => 'Invalid lineup id',
                'details' => $ex->getMessage()
            ));
        }

       if ($right) {
           try {
               $co = new Coach($post_vars['coachLineUp']);
               $t->setCoach($co);
               
           } catch (RecordNotFoundException $ex) {
               $right = false;
                echo json_encode(array(
                    'status' => 2,
                    'errorMessage' => 'Invalid coach id',
                    'details' => $ex->getMessage()
                ));
           }
       }

       if ($right) {
           try {
               $cat = new Coach($post_vars['categoryLineUp']);
               $t->setCategory($cat);
               
           } catch (RecordNotFoundException $ex) {
               $right = false;
                echo json_encode(array(
                    'status' => 2,
                    'errorMessage' => 'Invalid coach id',
                    'details' => $ex->getMessage()
                ));
           }
       }

        if($right)
        {
            
	    if($t->edit())
	    {       
		echo json_encode(array(
		    'status' => 0,
		    'message' => 'LineUp updated successfully'
		));
	    }       
	    else
	    {   
		echo json_encode(array(
		    'status' => 2,
		    'errorMessage' => 'Could not update lineup'
		));
	    }   
        }
    }

   if(!$parametersOk)
   {
       echo json_encode(array(
           'status' => 1,
           'errorMessage' => 'Missing parameters'
       ));
   }
}

if($_SERVER['REQUEST_METHOD'] == 'DELETE')
{
    parse_str(file_get_contents("php://input"), $jsonData);
    $post_vars = json_decode($jsonData['data'], true);

    $parametersOk = false;

    if(isset($post_vars['idLineUp']))
    {
        $parametersOk = true;
	$right = true;

	try
	{
	    $t = new LineUp($post_vars['idLineUp']);
	}	
	catch(RecordNotFoundException $ex)
	{
	    $right = false;
            echo json_encode(array(
                'status' => 2,
                'errorMessage' => 'Invalid lineup id',
                'details' => $ex->getMessage()
            ));
	}

	if($right)
	{		
	    try
	    {       
                if($t->delete())
                {
                    echo json_encode(array(
                        'status' => 0,
                        'message' => 'LineUp deleted successfully'
                    ));
                }
                else
                {
                    echo json_encode(array(
                        'status' => 2,
                        'errorMessage' => 'Could not delete lineup'
                    ));

                }
	    }       
	    catch(mysqli_sql_exception $ex)
	    {   
                $error = $ex->getCode();
                if($error == 1453)
                {
                    echo json_encode(array(
                        'status' => 999,
                        'errorMessage' => 'Delete LineUp Players',
                    ));
                }
                else
                {
                    echo json_encode(array(
                        'status' => 3,
                        'errorMessage' => $ex->getMessage(),
                    ));
                }
	    }   
	}
    }
    
    if(!$parametersOk)
    {
        echo json_encode(array(
            'status' => 1,
            'errorMessage' => 'Missing parameters'
        ));
    }
}
?>
