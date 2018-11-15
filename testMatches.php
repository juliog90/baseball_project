<?php
require_once('models/matches.php');
//get 
if($_SERVER['REQUEST_METHOD']=='GET'){
    if(isset($_GET['id'])){
        try{
            $c = new Match($_GET['id']);
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
?>
