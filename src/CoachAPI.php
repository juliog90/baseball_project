<?php
    require_once("php/coach.php");
    if($_SERVER['REQUEST_METHOD'] == 'GET'){
        
        if(isset($_GET['id']))
        {
            try
            {
                $c = new Coach($_GET['id']);
                echo json_encode(array(
                    'status' => 0,
                    'Coach' => json_decode($c->toJson())
                ));
            }
            catch (Exception $ex)
            {
                echo json_encode(array(
                    'status' =>2,
                    'errorMessage' => $ex->getMessage()
                ));
            }
        }
        else
        {
            echo json_encode(array(
                'status' => 0,
                'coaches' => json_decode(Coach::getAllToJson())
            ));
        }
    }
    if($_SERVER['REQUEST_METHOD'] == 'POST'){
        if(isset($_POST['id'])){
                $c = new Coach();
                if($c->add($_POST['id'])){
                    echo json_encode(array(
                        'status' => 0,
                        'message' => 'Added succesfully'
                    ));
                }else{
                    echo json_encode(array(
                        'status' => 666,
                        'errorMessage' => 'Could not add coach'
                    ));
                }
            
        }else{
            echo json_encode(array(
                'status' => 999,
                'errorMessage' => 'Could not find id'
            ));
        }
    }
    if($_SERVER['REQUEST_METHOD'] == 'DELETE'){
        parse_str(file_get_contents('php://input'), $putData);
        if(isset($putData['dataDeleteCoach']))
        {
            $jsonData = json_decode($putData['dataDeleteCoach'], true);
        }
        if (isset($jsonData['id']))
        {
            $c = new Coach($jsonData['id']);
            if($c->delete())
            {
                echo json_encode(array(
                    'status' => 0,
                    'Message' => 'Correct Delete'
                ));
            }
        }
        else
        {
            echo json_encode(array(
                'status' => 1,
                'Message' => 'Incorrect Delete'
            ));
        }
    }
?>
