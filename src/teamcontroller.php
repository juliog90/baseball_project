<?php 
require_once('php/team.php');
require_once('php/exceptions/recordnotfoundexception.php');

// get
if(isset($parameters))
{
    if($parameters != '')
    {
        try
        {
            $t = new Team($parameters);

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

    if(isset($headers['nameTeam']) && isset($headers['categoryTeam']) && isset($headers['coachTeam']))
    {
        $parametersOk = true;
        $right = true;

        $t = new Team();
        $t->setName($headers['nameTeam']);
        $t->setImage($headers['imageTeam']);
        $s = new Season($headers['seasonTeam']);
        $t->setSeason($s);

        try {
            $cat = new Category($headers['categoryTeam']);
            $t->setCategory($cat);

        } catch (RecordNotFoundException $ex) {
            $right = false;
            echo json_encode(array(
                'status' => 2,
                'errorMessage' => 'Invalid category id',
                'details' => $ex->getMessage()
            ));
        }

        if ($right) {
            try {
                $co = new Coach($headers['coachTeam']);
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
                var_dump($t);
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
    var_dump(file_get_contents("php://input"));
    $post_vars = json_decode(file_get_contents("php://input"), true);
    
    var_dump($post_vars);
    $parametersOk = false;

    if(isset($post_vars['idTeam']) && isset($post_vars['nameTeam']) && isset($post_vars['categoryTeam']) && isset($post_vars['coachTeam']))
    {
        $parametersOk = true;
        $right = true;

        try
        {
            $t = new Team($post_vars['idTeam']);
            $t->setName($post_vars['nameTeam']);
            $t->setImage($post_vars['imageTeam']);
            $s = new Season($post_vars['seasonTeam']);
            $t->setSeason($s);
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
    $post_vars = json_decode(file_get_contents("php://input"), true);

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
?>
