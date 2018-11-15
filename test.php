<?php
    #person
    require_once("php/Person.php");
    #delete person
    if($_SERVER['REQUEST_METHOD'] == 'DELETE') {
        #parse received data
        parse_str(file_get_contents('php://input'), $putData);
        #check if data key was received
        if(isset($putData['data'])){
            #decode data from json
            $jsonData = json_decode($putData['data'], true);
            $valuesOk = true;
            #check if jsonData cotains correct info
            if(isset($jsonData['perId'])){
                try{
                    $person = new Person($jsonData['perId']);
                }catch(exception $ex){
                    $valuesOk = false;
                    echo json_encode(array(
                        'status' => 2,
                        'errorMessage' => 'Invalid id person'
                    ));
                }
                if($valuesOk){
                    if($person->delete()){
                        echo json_encode(array(
                            'status' => 0,
                            'errorMessage' => 'Person deleted successfully'
                        ));
                    }else{
                        echo json_encode(array(
                            'status' => 666,
                            'errorMessage' => 'Could not delete person'
                        ));
                    }
                }
            }else{
                echo json_encode(array(
                    'status' => 999,
                    'errorMessage' => 'data not found'
                ));
            }
        }
    }
    #put person (edit)
    if($_SERVER['REQUEST_METHOD'] == 'PUT'){

        //parse received data
        parse_str(file_get_contents('php://input'), $putData);
        //check if data key was received
        if(isset($putData['data'])){
            //decode data from json
            $jsonData = json_decode($putData['data'], true);
            $valuesOk = true;
            //check if jsonData contain correct info
            if(isset($jsonData['perId'])
            && isset($jsonData['firstName'])
            && isset($jsonData['lastName'])){
                try{
                    $person = new Person($jsonData['perId']);
                }catch(exception $ex){
                    $valuesOk = false;
                    echo json_encode(array(
                        'status' => 2,
                        'errorMessage' => 'Invalid id contact'
                    ));
                }
                $person->setFirstName($jsonData['firstName']);
                $person->setLastName($jsonData['lastName']);
                if($valuesOk){
                    if($person->edit()){
                        echo json_encode(array(
                            'status' => 0,
                            'message' => 'person edited succesfully'
                        ));
                    }else{
                        echo json_encode(array(
                            'status' => 2,
                            'errorMessage' => 'could not edit data'
                        ));
                    }
                }else{
                    echo json_encode(array(
                        'status' => 999,
                        'errorMessage' => 'values not ok'
                    ));        
                }
            }
        }else{
            echo json_encode(array(
                'status' => 999,
                'errorMessage' => 'Not found data'
            ));
        }
    }
    //post Person
    if ($_SERVER['REQUEST_METHOD'] == 'POST') 
    {
        //parameters ok
        $parametersOk = false;
        //add contact
        if (isset($_POST['firstName'])
        && isset($_POST['lastName'])) 
        {
            
            //parameters ok
            $parametersOk = true;
            //create contact
            $c = new Person();
            //assign values
            $c->setFirstName($_POST['firstName']);
            $c->setLastName($_POST['lastName']);
            
            //add
            if ($c->add())
                echo json_encode(array(
                    'status' => 0,
                    'message' => 'Person added successfully'
                ));
            else
                echo json_encode(array(
                    'status' => 2,
                    'errorMessage' => 'Could not add contact'
                ));
        }
        //add coach
        if(isset($_POST['perId'])){
            #parametersOk
            $parametersOk = true;
            

        }
    
    #coach
    /*
    require_once("php/Coach.php");
    if($_SERVER['REQUEST_METHOD'] == 'GET'){
        if(isset($_GET['coachId'])){
            try{
                $coach = new Coach($_GET['coachId']);
            echo json_encode(array(
                    'status' => 0,
                    'Coach' => json_decode($coach->toJson())
                ));
            }catch(exception $ex){
                echo json_encode(array(
                    'status' => 2,
                    'errorMessage' => 'Invalid coach Id'
                ));
            }
            
        }else{
        
        echo json_encode(array(
            'status' => 0,
            'Coaches' => json_decode(Coach::getAllToJson())
        ));
        }
      */  
    }
    
    
    #player
    /*
    require_once("php/player.php");
    $player = new Player(1, new Person(1),1,69,'Json Derulo','4/20/1998','4/21/1998','xd.png',69);
    echo $player->toJson();
    */
?>