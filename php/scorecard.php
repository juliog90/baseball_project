<?php
    class ScoreCard{
        #attributes
        private $id;
        private $entry;
        private $batter; //este podría ser un objeto jugador
        private $balls;
        private $strikes;
        private $outs;
        private $RunsHome; //meterlo en un array para luego desplegarlo
        private $RunsGuest; //meterlo en un array para luego desplegarlo
        private $base1; //este podría ser un objeto jugador
        private $base2; //este podría ser un objeto jugador
        private $base3; //este podría ser un objeto jugador
    
        #getters&setters
        public function getId(){return $this->id;}
        public function getEntry(){return $this->entry;}
        public function setEntry($entry){$this->entry = $entry;}
        public function getBatter(){return $this->batter;}
        public function setBatter($batter){$this->batter = $batter;}
        public function getBalls(){return $this->balls;}
        public function setBalls($balls){$this->balls = $balls;}
        public function getStrikes(){return $this->strikes;}
        public function setStrikes($strikes){$this->strikes = $strikes;}
        public function getOuts(){return $this->outs;}
        public function setOuts($outs){$this->outs=$outs;}
        public function getRunsHome(){return $this->RunsHome;}
        public function setRunsHome($RunsHome){$this->RunsHome = $RunsHome;}
        public function getRunsGuest(){return $this->RunsGuest;}
        public function setRunsGuest($RunsGuest){$this->RunsGuest = $RunsGuest;}
        public function getBase1(){return $this->base1;}
        public function setBase1($base1){$this->base1 = $base1;}
        public function getBase2(){return $this->base2;}
        public function setBase2($base2){$this->base2 = $base2;}
        public function getBase3(){return $this->base3;}
        public function setBase3($base3){$this->base3 = $base3;}
        public function __construct(){
            if(func_num_args() == 0){
                $this->id = "";
                $this->entry = "";
                $this->batter = "";
                $this->balls = "";
                $this->strikes = "";
                $this->outs = "";
                $this->RunsHome = "";
                $this->RunsGuest = "";
                $this->base1 = "";
                $this->base2 = "";
                $this->base3 = "";
            }
            if(func_num_args() == 11){
                $this->id = func_get_arg(0);
                $this->entry = func_get_arg(1);
                $this->batter = func_get_arg(2);
                $this->balls = func_get_arg(3);
                $this->strikes = func_get_arg(4);
                $this->outs = func_get_arg(5);
                $this->RunsHome = func_get_arg(6);
                $this->RunsGuest = func_get_arg(7);
                $this->base1 = func_get_arg(8);
                $this->base2 = func_get_arg(9);
                $this->base3 = func_get_arg(10);
            }
        }
    #methods
    public function toJson(){
        return json_encode(array(
                'id' => $this->id,
                'Entry' => $this->entry,
                'Batter' => $this->batter,
                'Balls' => $this->balls,
                'Strikes' => $this->strikes,
                'Outs' => $this->outs,
                'Home Runs' => $this->RunsHome,
                'Guest Runs' => $this->RunsGuest,
                'base 1' => $this->base1, //to json?
                'base 2' => $this->base2, //to json?
                'base 3' => $this->base3 //to json?
        ));
    }
    public function reset($entry, $batter, $balls, $strikes, $outs, $runsHome, $runsGuest, $base1, $base2, $base3){
        
    }
    }
    
?>