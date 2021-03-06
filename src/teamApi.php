<?php 
require_once('php/team.php');
require_once('php/exceptions/recordnotfoundexception.php');

// get
if($_SERVER['REQUEST_METHOD'] == 'GET')
{
    if(isset($_GET['idTeam']))
    {
        try
        {
            $t = new Team($_GET['idTeam']);

            echo json_encode(array(
                'status' => 0,
                'team' => json_decode($t->toJson())
            ));
        }       
        catch(RecordNotFoundException $ex)
        {
            echo json_encode(array(
                'status' => 2,
                'errorMessage' => 'Invalid team id',
                'details' => $ex->getMessage()
            ));
        }
    }
    else if(isset($_GET['idTeamPlay']) && isset($_GET['playTeam'])) {
        try
        {
            $t = new Team($_GET['idTeamPlay']);

            echo json_encode(array(
                'status' => 0,
                'players' => json_decode($t->getPlayers())
            ));
        }       
        catch(RecordNotFoundException $ex)
        {
            echo json_encode(array(
                'status' => 2,
                'errorMessage' => 'Invalid team id',
                'details' => $ex->getMessage()
            ));
        }
    }
    else
    {
        echo json_encode(array(
            'status' => 0,
            'teams' => json_decode(Team::getAllToJson())
        ));
    }
}

// post
if($_SERVER['REQUEST_METHOD'] == 'POST')
{
    $parametersOk = false;

    if(isset($_POST['nameTeam']) && isset($_POST['categoryTeam']) && isset($_POST['coachTeam']) && isset($_POST['seasonTeam']) && isset($_POST['imageTeam']))
    {
        $parametersOk = true;
        $right = true;


        $t = new Team();
        $t->setName($_POST['nameTeam']);
        $t->setImage($_POST['imageTeam']);
        $t->setStatus(1);

        try {
            $cat = new Category($_POST['categoryTeam']);
            $t->setCategory($cat);

        } catch (RecordNotFoundException $ex) {
            $right = false;
            echo json_encode(array(
                'status' => 2,
                'errorMessage' => 'Invalid team id',
                'details' => $ex->getMessage()
            ));
        }

        if ($right) {
            try {
                $sea = new Season($_POST['seasonTeam']);
                $t->setSeason($sea);

            } catch (RecordNotFoundException $ex) {
                $right = false;
                echo json_encode(array(
                    'status' => 2,
                    'errorMessage' => 'Invalid season id',
                    'details' => $ex->getMessage()
                ));
            }
        }

        if ($right) {
            try {
                $co = new Coach($_POST['coachTeam']);
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
                    'message' => 'Team added successfully'
                ));
            }       
            else
            {   
                $right = false;
                echo json_encode(array(
                    'status' => 2,
                    'errorMessage' => 'Could not add team'
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
    if(isset($jsonData['data'])){
        $post_vars = json_decode($jsonData['dataTeams'], true);


        if(isset($post_vars['statusTeam']) && isset($post_vars['idTeam']) && isset($post_vars['nameTeam']) && isset($post_vars['categoryTeam']) && isset($post_vars['coachTeam']) && isset($post_vars['imageTeam']) && isset($post_vars['seasonTeam'])) 
        {
            $parametersOk = true;
            $right = true;

            try
            {
                $t = new Team($post_vars['idTeam']);
                $t->setName($post_vars['nameTeam']);
                $t->setImage($post_vars['imageTeam']);
            }       
            catch(RecordNotFoundException $ex)
            {
                $right = false;
                echo json_encode(array(
                    'status' => 2,
                    'errorMessage' => 'Invalid team id',
                    'details' => $ex->getMessage()
                ));
            }

            if ($right) {
                try {
                    $sea = new Season($post_vars['seasonTeam']);
                    $t->setSeason($sea);

                } catch (RecordNotFoundException $ex) {
                    $right = false;
                    echo json_encode(array(
                        'status' => 2,
                        'errorMessage' => 'Invalid season id',
                        'details' => $ex->getMessage()
                    ));
                }
            }

            if ($right) {
                try {
                    $co = new Coach($post_vars['coachTeam']);
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
                    $cat = new Coach($post_vars['categoryTeam']);
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
                        'message' => 'Team updated successfully'
                    ));
                }       
                else
                {   
                    echo json_encode(array(
                        'status' => 2,
                        'errorMessage' => 'Could not update team'
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

        if(isset($post_vars['idTeam']))
        {
            $parametersOk = true;
            $right = true;

            try
            {
                $t = new Team($post_vars['idTeam']);
            }	
            catch(RecordNotFoundException $ex)
            {
                $right = false;
                echo json_encode(array(
                    'status' => 2,
                    'errorMessage' => 'Invalid team id',
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
                            'message' => 'Team deleted successfully'
                        ));
                    }
                    else
                    {
                        echo json_encode(array(
                            'status' => 2,
                            'errorMessage' => 'Could not delete team'
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
                            'errorMessage' => 'Delete Team Players',
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
}
?>
