<?php

use PHPUnit\Framework\TestCase;

class TeamTests extends TestCase
{
    public function testDbTeam()
    {
	$team = new Team(1);
        $this->assertNotNull($team);
    }

    public function testAllDbTeams()
    {
        $this->assertNotNull(Team::getAll());
    }

    public function testAddTeam()
    {
        $team = new Team();
        $team->setName("Hola");
        $cat = new Category(1);
        $team->setCategory($cat);
        $team->setCoach(1);
        $team->setImage("hola.png");
        $team->setSeason(1);
        $this->assertTrue($team->add());
    }

    public function testDelUsedTeam()
    {
        $team = new Team(2);
        $this->assertFalse($team->delete());

    }

    public function testUpdTeam()
    {
        $team = new Team(1);
        $team->setName("Hola");
        $cat = new Category(3);
        $team->setCategory($cat);
        $team->setCoach(1);
        $team->setImage("hola.png");
        $team->setSeason(1);
        $this->assertTrue($team->edit());
    }

}
