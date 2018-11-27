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
        $player->setName("Hola");
        $this->assertTrue($player->edit());
    }

    public function testAddPlayer()
    {
        $player = new Player();
        $player->setName("Hola");
        $this->assertTrue($player->add());
    }
}
