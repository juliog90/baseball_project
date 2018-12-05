<?php

require_once('team.php');
require_once('matches.php');
require_once('player.php');
require_once('exceptions/recordnotfoundexception.php');

class LineUp {

    private $id;
    private $team;
    private $player;
    private $position;
    private $match;
    private $turn;

    public function getId() { return $this->id; }

    public function getTeam() { return $this->team; }
    public function setTeam($team) { $this->team = $team; }

    public function getPosition() { return $this->position; }
    public function setPosition($position) { $this->position = $position; }

    public function getPlayer() { return $this->player; }
    public function setPlayer($player) { $this->player = $player; }

    public function getMatch() { return $this->match; }
    public function setMatch($match) { $this->match = $match; }

    public function getTurn() { return $this->turn; }
    public function setTurn($turn) { $this->turn = $turn; }

    public function __construct() {
        if(func_num_args() == 0) {
            $this->id = 0;
            $this->team = new Team();
            $this->position = '';
            $this->player = new Player();
            $this->match = 0;
            $this->turn = 0;
        }

        if(func_num_args() == 1) {
            $connection = MySqlConnection::getConnection();
            $query = 'select lupId, plaId, teaId, lupBattingTurn, posId, matId from lineups where lupId = ?';
            $command = $connection->prepare($query);
            $idTemp = func_get_arg(0);
            $command->bind_param('i', $idTemp);
            $command->execute();
            $command->bind_result($id, $player, $team, $turn, $position, $match);
            if($command->fetch()) {
                $this->id = $id;
                $this->player = new Player($player);
                $this->team = new Team($team);
                $this->turn = $turn;
                $this->position = $position;
                $this->match = $match;
            } 
            else 
            {
                throw new RecordNotFoundException(func_get_arg(0));
            }

            mysqli_stmt_close($command);
            $connection->close();
        }

        if(func_num_args() == 7) {
            $this->id = func_get_arg(0);
            $this->team = func_get_arg(1);
            $this->position = func_get_arg(2);
            $this->player = func_get_arg(3);
            $this->match = func_get_arg(4);
            $this->turn = func_get_arg(5);
        }
    }

    public static function getAll()
    {
        $lineups = array();
        $connection = MySqlConnection::getConnection();
        $query = 'select lupId, plaId, teaId, lupBattingTurn, posId, matId from lineups';
        $command = $connection->prepare($query);
        $command->execute();
        $command->bind_result($id, $player, $team, $turn, $position, $match);
        while($command->fetch()) {
            array_push($lineups, new LineUp($id, $team, $position, $player, $match, $turn));
        } 

        mysqli_stmt_close($command);
        $connection->close();

        return $lineups;
    }

    public function getPlayers()
    {
        $players = array();
        $connection = MySqlConnection::getConnection();
        $query = 'select players.plaId from players inner join lineups
            on lineups.plaId = players.plaId where lineups.lupId = ?';
        $command = $connection->prepare($query);
        $linId = $this->id;

        $command->bind_param('i', $linId);
        $command->execute();

        $command->bind_result($id);

        while($command->fetch())
        {
            array_push($players, new Player($id));
        }

        $jsonPlayers = array();

        foreach($players as $player) 
        {
            array_push($jsonPlayers, json_decode($player->toJson()));

        }

        return json_encode($jsonPlayers);
    }

    public static function getAllPlayerToJson($team, $match)
    {
        $lineupsJson = array();
        $lineups = array();

        $connection = MySqlConnection::getConnection();
        $query = 'select lupId from lineups where teaId = ? and matId = ?';
        $command = $connection->prepare($query);

        $command->bind_param('ii', $team, $match);
        $command->execute();

        $command->bind_result($id);
        while($command->fetch()) {
            $lin = new LineUp($id);
            array_push($lineups, $lin);
        } 



        $jsonLineUps = array();

        foreach($lineups as $lineup) 
        {
            array_push($jsonLineUps, json_decode($lineup->toJson()));
        }

        return json_encode($jsonLineUps);
    }

    public function toJson() {
        return json_encode(array(
            'id'=>$this->id,
            'team' => json_decode($this->team->toJson()),
            'turn'=> $this->turn,
            'position'=> $this->position,
            'match' => $this->match,
            'players' => $this->id,
        ));
    }

    public function delete()
    {
        // delete lineup 
        $connection = MySqlConnection::getConnection(); 
        $statement = 'delete from lineups where lupId = ?';    
        $command = $connection->prepare($statement);
        $id = $this->id;
        $command->bind_param('i', $id);
        $result = $command->execute();

        mysqli_stmt_close($command);
        $connection->close();

        return $result;
    }

    public function edit($teamFilter, $matchFilter)
    {
        $connection = MySqlConnection::getConnection();
        $statement = 'update lineups set plaId = ?, teaId = ?, lupsBattingTurn = ?, posId = ?, matId = ?
            where matId = ? and teaId = ? and lupId = ?';
        $command = $connection->prepare($statement);
        $player = $this->player->getId();
        $team = $this->team->getId();
        $turn = $this->turn;
        $position = $this->position;
        $match = $this->match;
        $id = $this->id;
        $command->bind_param('iiisiiii',$player, $team, $turn, $position, $match, $teamFilter, $matchFilter, $id);
        $result = $command->execute();
        mysqli_stmt_close($command);
        $connection->close();

        return $result;
    }

    public function add()
    {
        $connection = MySqlConnection::getConnection();
        $statement = 'insert into lineups(plaId, teaId, lupBattingTurn, posId, matId) values (?, ?, ?, ?, ?)';

        $command = $connection->prepare($statement);
        $player = $this->player->getId();
        $team = $this->team->getId();
        $turn = $this->turn;
        $position = $this->position;
        $match = $this->match;

        $command->bind_param('iiisi',$player, $team, $turn, $position, $match);
        $result = $command->execute();

        mysqli_stmt_close($command);
        $connection->close();

        return $result;
    }
}
?>

