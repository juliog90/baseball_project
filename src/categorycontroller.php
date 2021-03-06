<?php 
require_once('php/category.php');
require_once('php/exceptions/recordnotfoundexception.php');

// get
if($_SERVER['REQUEST_METHOD'] == 'GET')
{
    if($parameters != '')
    {
        try
        {
            $c = new Category($parameters);

            echo json_encode(array(
                'status' => 0,
                'category' => json_decode($c->toJson())
            ));
        }       
        catch(RecordNotFoundException $ex)
        {
            echo json_encode(array(
                'status' => 2,
                'errorMessage' => 'Invalid category id',
                'details' => $ex->getMessage()
            ));
        }
    }
    else
    {
        echo json_encode(array(
            'status' => 0,
            'categories' => json_decode(Category::getAllToJson())
        ));
    }
}

// post
if($_SERVER['REQUEST_METHOD'] == 'POST')
{
    $parametersOk = false;

    if($headers['newCat'])
    {
        $parametersOk = true;

        $c = new Category();

        $c->setName($headers['newCat']);

        if($c->add())
        {       
            echo json_encode(array(
                'status' => 0,
                'message' => 'Category added successfully'
            ));
        }       
        else
        {   
            echo json_encode(array(
                'status' => 2,
                'errorMessage' => 'Could not add category'
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

if($_SERVER['REQUEST_METHOD'] == 'PUT')
{

    $post_vars = json_decode(file_get_contents("php://input"), true);

    if(isset($post_vars['idCategory']) && isset($post_vars['nameCategory'])) 
    {
        $parametersOk = true;

        $right = true;

        try
        {
            $c = new Category($post_vars['idCategory']);
            $c->setName($post_vars['nameCategory']);
        }       
        catch(RecordNotFoundException $ex)
        {
            $right = false;
            echo json_encode(array(
                'status' => 2,
                'errorMessage' => 'Invalid category id',
                'details' => $ex->getMessage()
            ));
        }
        if($right)
        {

            if($c->edit())
            {       
                echo json_encode(array(
                    'status' => 0,
                    'message' => 'Category updated successfully'
                ));
            }       
            else
            {   
                echo json_encode(array(
                    'status' => 2,
                    'errorMessage' => 'Could not update category'
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

    if(isset($post_vars['idCategory']))
    {
        $parametersOk = true;
        $right = true;

        try
        {
            $c = new Category($post_vars['idCategory']);
        }	
        catch(RecordNotFoundException $ex)
        {
            $right = false;
            echo json_encode(array(
                'status' => 2,
                'errorMessage' => 'Invalid category id',
                'details' => $ex->getMessage()
            ));
        }

        if($right)
        {		
            try
            {       
                if($c->delete())
                {
                    echo json_encode(array(
                        'status' => 0,
                        'message' => 'Category deleted successfully'
                    ));
                }
                else
                {
                    echo json_encode(array(
                        'status' => 2,
                        'errorMessage' => 'Could not delete Category'
                    ));

                }
            }       
            catch(mysqli_sql_exception $ex)
            {   
                $error = $ex->getCode();
                if($error == 1451)
                {
                    echo json_encode(array(
                        'status' => 999,
                        'errorMessage' => 'Delete Category Teams',
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
