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
        $coa = new Coach(1);
        $team->setCoach($coa);
        $team->setImage("hola.png");
        $sea = new Season(1);
        $team->setSeason($sea);
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
        $coa = new Coach(1);
        $team->setCoach($coa);
        $sea = new Season(1);
        $team->setSeason($sea);
        $team->setImage("hola.png");
        $this->assertTrue($team->edit());
    }

}
