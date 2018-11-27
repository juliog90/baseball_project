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

    public function testDelTeam()
    {
        $team = new Team(2);
        $this->assertTrue($team->delete());

    }

    public function testUpdTeam()
    {
        $team = new Team(1);
        $team->setName("Hola");
        $team->setCategory(1);
        $team->setCoach(1);
        $team->setImage("hola.png");
        $team->setSeason(1);
        $this->assertTrue($team->edit());
    }

    public function testAddTeam()
    {
        $team = new Team();
        $team->setName("Hola");
        $team->setCategory(1);
        $team->setCoach(1);
        $team->setImage("hola.png");
        $team->setSeason(1);
        $this->assertTrue($team->add());
    }
}
