<?php
    require_once('php/matches.php');

//get 
if($_SERVER['REQUEST_METHOD']=='GET'){
    if($parameters != ""){
        try{
            $c = new Match($parameters);
            echo json_encode(array(
                'status'=>0,
                'matches'=> json_decode($c->toJson())
            ));
        }
        catch(RecordNotFoundException $ex){
            echo json_decode(array(
                'status' => 2,
                'errorMessage'=>'Invalid match id',
                'details'=> $ex->getMessage()

            ));
        }
    }
    else {
        echo json_encode(array(
            'status' => 0,
            'matches' => json_decode(Match::getAllToJson())
        ));
    }
}

if($_SERVER['REQUEST_METHOD']=='POST'){
    $parametersOk = false;

   if(isset($_POST['nameSeason']))
   {
       $parametersOk = true;

       $c = new Season();

       $c->setName($_POST['nameSeason']);

       if($c->add())
       {       
           echo json_encode(array(
               'status' => 0,
               'message' => 'Season added successfully'
           ));
       }       
       else
       {   
           echo json_encode(array(
               'status' => 2,
               'errorMessage' => 'Could not add season'
           ));
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
