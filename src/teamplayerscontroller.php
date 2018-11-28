<?php

require_once('php/team.php');
require_once('php/exceptions/recordnotfoundexception.php');

if($_SERVER['REQUEST_METHOD'] == 'GET')
{
    if($parameters != '')
    {
        try {
            $t = new Team($parameters);
            echo json_encode(array(
                'status' => 0,
                'players' => json_decode($t->getPlayers())
            ));
        }

        catch(RecordNotFoundException $ex) {
        echo json_encode(array(
            'status' => 1,
            'errorMessage' => $ex->getMessage() 
        ));
        }
    }
}
?>
