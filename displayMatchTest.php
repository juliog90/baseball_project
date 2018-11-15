<?php
    require_once('Models/displayMatches.php');
	//GET
	if($_SERVER['REQUEST_METHOD']=='GET')
	{
		if(isset($_GET['matId'])){
		try{
			$c=new DisplayMatches($_GET['matId']);
			echo json_encode(array(
			'status'=>0,
			'DisplayMatches'=> json_decode($c->toJson())
			));
		}
		catch(RecordNotFoundException $ex){
			echo json_encode(array(
			'status'=>2,
			'errorMessage'=> $ex->getMessage()
			));
		}
	}
	/*
	else {
		echo json_encode(array(
		'status'=>0,
		'Matches'=>json_decode(Match::getAllToJson())
		));
	}
	*/
	}

if($_SERVER['REQUEST_METHOD'] == 'POST')
{	
		// var_dump($_POST);
		//parameters ok
			$parametersOk = false;
        //check paracmeters
		if(isset($_POST['matId'])  && isset($_POST['dmtEntry']) && 
		isset($_POST['dmtBatter']) && isset($_POST['dmtBalls'])  && 
		isset($_POST['dmtStrikes']) && isset($_POST['dmtOuts']) && 
		isset($_POST['dmtRunsHomeTeam']) && isset($_POST['dmtRunsGuestTeam']) && 
		isset($_POST['dmtBase1']) && isset($_POST['dmtBase2']) && isset($_POST['dmtBase3']))
        {
			//parameters ok
            $parametersOk = true;
            //create DisplayMatches
            $c = new DisplayMatches();
			//assign values
			$c->setMatId($_POST['matId']);
			$c->setDmtEntry($_POST['dmtEntry']);
			$c->setDmtBatter($_POST['dmtBatter']);
			$c->setDmtBalls($_POST['dmtBalls']);
			$c->setDmtStrikes($_POST['dmtStrikes']);
			$c->setDmtOuts($_POST['dmtOuts']);
			$c->setDmtRunsHomeTeam($_POST['dmtRunsHomeTeam']);
			$c->setDmtRunsGuestTeam($_POST['dmtRunsGuestTeam']);
			$c->setDmtBase1($_POST['dmtBase1']);
			$c->setDmtBase2($_POST['dmtBase2']);
			$c->setDmtBase3($_POST['dmtBase3']);
            //add
            if($c->add())
            {
                echo json_encode(array(
                    'status'=> 0,
                    'message'=> 'DisplayMatches added succesfully'
                ));
            }
            else
            {
                echo json_encode(array(
                    'status'=> 2,
                    'errorMessage'=> 'Could not add DisplayMatches'
                ));
			}
		}
		else
		{
			echo json_encode(array(
				'status'=> 1,
				'errorMessage'=> 'Missing Parameters'
				));
		}
}
	

if($_SERVER['REQUEST_METHOD'] == 'DELETE')
{
    parse_str(file_get_contents("php://input"), $jsonData);
    $delet = json_decode($jsonData['data'], true);
    $parametersOk = false;
    if(isset($delet['matId']))
	{
		$parametersOk = true;
		$right = true;
		try
		{
			$c = new DisplayMatches($delet['matId']);
		}	
		catch(RecordNotFoundException $ex)
		{
			$right = false;
				echo json_encode(array(
					'status' => 2,
					'errorMessage' => 'Invalid DisplayMath matId',
					'details' => $ex->getMessage()
				));
		}
		if($right)
		{		
			if($c->delete())
			{
				echo json_encode(array(
					'status' => 0,
					'message' => 'DisplayMatch deleted successfully'
				));
			}
			else
			{
				echo json_encode(array(
					'status' => 2,
					'errorMessage' => 'Could not delete DisplayMatch'
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
}

//PUT
if ($_SERVER['REQUEST_METHOD'] == 'PUT') 
{
	//parse received data
	parse_str(file_get_contents('php://input'), $putData);
	//check if data key was received
	if (isset($putData['data'])) 
	{
		//decode data from json
		$jsonData = json_decode($putData['data'], true); 
		//check if jsonData contains correct info
		if (isset($jsonData['matId']) && isset($jsonData['dmtEntry']) && isset($jsonData['dmtBatter'])
		&& isset($jsonData['dmtBalls']) && isset($jsonData['dmtStrikes'])
		&& isset($jsonData['dmtOuts']) && isset($jsonData['dmtRunsHomeTeam'])
		&& isset($jsonData['dmtRunsGuestTeam']) && isset($jsonData['dmtBase1'])
		&& isset($jsonData['dmtBase2']) && isset($jsonData['dmtBase3']))
		{
			//parameters ok
            $parametersOk = true;
            //create DisplayMatches
            $c = new DisplayMatches();
			//assign values
			$c->setMatId($jsonData['matId']);
			$c->setDmtEntry($jsonData['dmtEntry']);
			$c->setDmtBatter($jsonData['dmtBatter']);
			$c->setDmtBalls($jsonData['dmtBalls']);
			$c->setDmtStrikes($jsonData['dmtStrikes']);
			$c->setDmtOuts($jsonData['dmtOuts']);
			$c->setDmtRunsHomeTeam($jsonData['dmtRunsHomeTeam']);
			$c->setDmtRunsGuestTeam($jsonData['dmtRunsGuestTeam']);
			$c->setDmtBase1($jsonData['dmtBase1']);
			$c->setDmtBase2($jsonData['dmtBase2']);
			$c->setDmtBase3($jsonData['dmtBase3']);
            //update
            if($c->updateDispMatch())
            {
                echo json_encode(array(
                    'status'=> 0,
                    'message'=> 'DisplayMatches update succesfully'
                ));
            }
            else
            {
                echo json_encode(array(
                    'status'=> 2,
                    'errorMessage'=> 'Could not update DisplayMatches'
                ));
			}
		}
		else {
			echo json_encode(array(
				'status' => 1,
				'errorMessage' => 'Missing data parameter'
				));
			}
	}
}


?>