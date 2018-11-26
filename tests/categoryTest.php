<?php

use PHPUnit\Framework\TestCase;

class CategoryTests extends TestCase
{
    public function testDbCategory()
    {
	$category = new Category(1);
        $this->assertNotNull($category);
    }

    public function testAllDbCategorys()
    {
        $this->assertNotNull(Category::getAll());
    }

    public function testDelCategory()
    {
        $category = new Category(2);
        $this->assertTrue($category->delete());

    }

    public function testUpdCategory()
    {
        $category = new Category(1);
        $category->setName("Hola");
        $this->assertTrue($category->update());
    }

    public function testAddCategory()
    {
        $category = new Category();
        $category->setName("Hola");
        $category->assertTrue($category->add());
    }
}
