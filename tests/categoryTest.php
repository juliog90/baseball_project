<?php

use PHPUnit\Framework\TestCase;

class CategoryTests extends TestCase
{
    public function testDBCategory()
    {
	$category = new Category(1);
        $this->assertNotNull($category);
    }

    public function testDelCategory()
    {
        $category = new Category(2);
        $this->assertTrue($category->delete());

    }
}
