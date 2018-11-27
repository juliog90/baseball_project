<?php

use PHPUnit\Framework\TestCase;

class TeamTests extends TestCase
{
    public function testDbTeam()
    {
	$team = new Team(1);
        $this->assertNotNull($team);
    }

    public function testAllDbCategorys()
    {
        $this->assertNotNull(Team::getAll());
    }

    public function testDelTeam()
    {
        $team = new Team(2);
        $this->assertTrue($team->delete());

    }

    public function testUpdTeam()
    {
        $team = new Team(1);
        $team->setName("Hola");
        $this->assertTrue($team->edit());
    }

    public function testAddTeam()
    {
        $team = new Team();
        $team->setName("Hola");
        $this->assertTrue($team->add());
    }
}
