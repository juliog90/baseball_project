<?php

use PHPUnit\Framework\TestCase;

class LineUpTests extends TestCase
{
    public function testDbLineUp()
    {
	$lineup = new LineUp(1);
        $this->assertNotNull($lineup);
    }

    public function testAllDbLineUp()
    {
        $this->assertNotNull(LineUp::getAll());
    }

    public function testAddLineUp()
    {
        $lineup = new LineUp();
        $lineup->setPostion(1);
        $tea = new Team(1);
        $lineup->setTeam($tea);
        $pla = new Player(1);
        $lineup->setPlayer($pla);
        $lineup->setTurn(1);
        $lineup->setMatch(1);
        $this->assertTrue($lineup->add());
    }

    public function testDelUsedLineUp()
    {
        $lineup = new LineUp(2);
        $this->assertFalse($lineup->delete());

    }

    public function testUpdLineUp()
    {
        $lineup = new LineUp(2);
        $lineup->setPostion(1);
        $tea = new Team(1);
        $lineup->setTeam($tea);
        $pla = new Player(1);
        $lineup->setPlayer($pla);
        $lineup->setTurn(1);
        $lineup->setMatch(1);
        $this->assertTrue($lineup->edit());
    }

}
