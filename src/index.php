<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Headers: ");


    //get request URI
    $requestUri = $_SERVER['REQUEST_URI']; 
    //split uri parts
    $uriParts = explode('/', $requestUri);
    //get URI info
    $controller = $uriParts[sizeof($uriParts) - 2]; 
    $parameters = $uriParts[sizeof($uriParts) - 1];
        
        switch ($controller) {
            case strtolower('team') : require_once('teamcontroller.php'); break;
            case strtolower('season') : require_once('seasoncontroller.php');break;
            case strtolower('category') : require_once('categorycontroller.php');break;
            case strtolower('stat') : require_once('statcontroller.php');break;
            case strtolower('displaymatches') : require_once('displaymatchescontroller.php');break;
            case strtolower('teamplayers') : require_once('teamplayerscontroller.php');break;
            case strtolower('lineup') : require_once('lineupcontroller.php');break;
            case strtolower('matches') : require_once('matchescontroller.php');break;
            default:
             echo json_encode(array(
             'status' => 999, 
            'errorMessage' => 'Invalid Controller'
                ));
        }
?>
