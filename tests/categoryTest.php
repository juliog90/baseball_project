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

    public function testUsedDelCategory()
    {
        $category = new Category(3);
        $this->assertFalse($category->delete());

    }

    public function testUpdCategory()
    {
        $category = new Category(1);
        $category->setName("Hola");
        $this->assertTrue($category->edit());
    }

    public function testAddCategory()
    {
        $category = new Category();
        $category->setName("Hola");
        $this->assertTrue($category->add());
    }
}
