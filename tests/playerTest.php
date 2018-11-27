<?php

use PHPUnit\Framework\TestCase;

class PlayerTests extends TestCase
{
    public function testDbPlayer()
    {
	$player = new Player(1);
        $this->assertNotNull($player);
    }

    public function testAllDbPlayers()
    {
        $this->assertNotNull(Player::getAll());
    }

    public function testDelPlayer()
    {
        $player = new Player(2);
        $this->assertTrue($player->delete());

    }

    public function testUpdPlayer()
    {
        $player = new Player(1);
        $player->setPerson(2);
        $player->setStatus(2);
        $player->setTeam(2);
        $player->setNickName("ansioso");
        $player->setBirthDate('2009-10-10');
        $player->setDebut("2015-10-10");
        $player->setImage("ansioso.png");
        $player->setPlayerNumber(5);
        $this->assertTrue($player->edit());
    }

    public function testAddPlayer()
    {
        $player = new Player();
        $player->setPerson(3);
        $player->setStatus(2);
        $player->setTeam(2);
        $player->setNickName("ansioso");
        $player->setBirthDate('2009-10-10');
        $player->setDebut("2015-10-10");
        $player->setImage("ansioso.png");
        $player->setPlayerNumber(5);
        $this->assertTrue($player->add());
    }
}
