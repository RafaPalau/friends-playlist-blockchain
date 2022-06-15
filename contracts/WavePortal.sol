// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

     uint256 private seed;

     event NewWave(address indexed from, uint256 timestamp, string music);

      struct Wave {
        address waver; 
        string music; 
        uint256 timestamp; 
    }

    Wave[] waves;

     mapping(address => uint256) public lastWavedAt;

   constructor() payable {
       console.log("Contrato construido!");
        /*
         * Define a semente inicial
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _music) public {
        /*
         * Precisamos garantir que o valor corrente de timestamp é ao menos 15 minutos maior que o último timestamp armazenado
         */
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Espere 30 segundos"
        );

        /*
         * Atualiza o timestamp atual do usuário
         */
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s Enviou a musica %s", msg.sender, _music);

        waves.push(Wave(msg.sender, _music, block.timestamp));

        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("# randomico gerado: %d", seed);

        

       if (seed <= 50) {
            console.log("%s ganhou!", msg.sender);

            /*
             * O mesmo código que tínhamos anteriormente para enviar o prêmio.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Tentando sacar mais dinheiro que o contrato possui."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Falhou em sacar dinheiro do contrato.");
        }

        emit NewWave(msg.sender, block.timestamp, _music);
    }

  



    /*
     * Adicionei uma função getAllWaves que retornará as músicas.
     * Isso permitirá recuperar as músicas a partir do nosso site!
     */
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        // Opcional: Adicione esta linha se você quer ver o contrato imprimir o valor!
        // Também imprimirá em run.js.
        console.log("Temos %d tchauzinhos no total!", totalWaves);
        return totalWaves;
    }
}