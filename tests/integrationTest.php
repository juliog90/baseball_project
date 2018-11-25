<?php

use PHPUnit\Framework\TestCase;

class CategoryTests extends TestCase
{
    public function testAdd()
    {
	$category = new Category(1);
        $this->assertNotNull($category);
    }
}
/* ./vendor/bin/phpunit --bootstrap vendor/autoload.php tests/EmailTest */
