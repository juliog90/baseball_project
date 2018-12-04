<?php
    require_once ("php/player.php");

    if($_SERVER['REQUEST_METHOD'] == 'GET')
        {
            if($parameters != '')
            {
                try
                {
                    $c = new Player($parameters);
                    echo json_encode(array(
                        'status' => 0,
                        'player' => json_decode($c->toJson())
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
                    'players' => json_decode(Player::getAllToJson())
                ));
            }
    }
    if($_SERVER['REQUEST_METHOD'] == 'POST')
    {
        parse_str(file_get_contents('php://input'), $putData);
        if(isset($putData['dataAddPlayer']))
        {
            $jsonData = json_decode($putData['dataAddPlayer'], true);
            if(isset($jsonData['perId']) && isset($jsonData['staId']) && isset($jsonData['teaId']) && isset($jsonData['plaNickname']) && isset($jsonData['plaBirthdate']) && isset($jsonData['plaDebut']) && isset($jsonData['plaImagen']) && isset($jsonData['plaNumber']))
            {
                $c = new Player($jsonData['perId'], $jsonData['staId'], $jsonData['teaId'], $jsonData['plaNickname'], $jsonData['plaBirthdate'], $jsonData['plaDebut'], $jsonData['plaImagen'], $jsonData['plaNumber']);
                if($c->add())
                {
                    echo json_encode(array(
                        'status' => 0,
                        'Message' => 'Correct'
                    ));
                }
                else
                {
                    echo json_encode(array(
                        'status' => 1,
                        'Message' => 'Incorrect'
                    ));
                }
            }
        }
    }
    if($_SERVER['REQUEST_METHOD'] == 'PUT')
    {
        parse_str(file_get_contents('php://input'), $putData);
        if(isset($putData['DataEditPlayer']))
        {
            $jsonData = json_decode($putData['DataEditPlayer'], true);
            if(isset($jsonData['plaId']) && isset($jsonData['perId']) && isset($jsonData['staId']) && isset($jsonData['teaId']) && isset($jsonData['plaNickname']) && isset($jsonData['plaBirthdate']) && isset($jsonData['plaDebut']) && isset($jsonData['plaImagen']) && isset($jsonData['plaNumber']))
            {
                $c = new Player($jsonData['plaId'], $jsonData['perId'], $jsonData['staId'], $jsonData['teaId'], $jsonData['plaNickname'], $jsonData['plaBirthdate'], $jsonData['plaDebut'], $jsonData['plaImagen'], $jsonData['plaNumber']);
                $c->edit();
                echo json_encode(array(
                    'id' => $jsonData['plaId'],
                    'person' => $jsonData['perId'],
                    'status' => $jsonData['staId'],
                    'team' => $jsonData['teaId'],
                    'nickname' => $jsonData['plaNickname'],
                    'birthDate' => $jsonData['plaBirthdate'],
                    'debut' => $jsonData['plaDebut'],
                    'image' => $jsonData['plaImagen'],
                    'number' => $jsonData['plaNumber']
                ));
            }
            else
            {
                echo json_encode(array(
                    'status' => 2,
                    'error' => 'Incorrect JSON key/values in received data'
                ));
            }
        }
    }
    if($_SERVER['REQUEST_METHOD'] == 'DELETE')
    {
        parse_str(file_get_contents('php://input'), $putData);
        if(isset($putData['dataDeletePlayer']))
        {
            $jsonData = json_decode($putData['dataDeletePlayer'], true);
            if (isset($jsonData['plaId']))
            {
                $c = new Player($jsonData['plaId']);
                if($c->delete())
                {
                    echo json_encode(array(
                        'status' => 0,
                        'Message' => 'Correct Delete'
                    ));
                }
                else
                {
                    echo json_encode(array(
                        'status' => 1,
                        'Message' => 'Incorrect Delete'
                    ));
                }
            }else{
                echo json_encode(array(
                    'status' => 666,
                    'errorMessage' => 'Invalid data'
                ));
            }
        }else{
            echo json_encode(array(
                'status' => 999,
                'errorMessage' => 'Not found data'
            ));
        }
    }
?>
