// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// ----------------------------------
//  CANDIDATO  |   EDAD    |   ID
// ----------------------------------
//  Toni       |    20     |  12345X
//  Alberto    |    23     |  54321T
//  Joan       |    21     |  98765P
//  Javier     |    19     |  56789W

contract Votacion {
    // Direccion del propietario del contrato
    address public owner;
    // Relacion entre el nombre del candidato
    // y el hash de sus datos personales
    mapping(string => bytes32) idCandidato;
    // Relacion entre el nombre del candidato
    // y el hash de sus datos personales
    mapping(string => uint256) votosCandidato;
    // Lista para almacenar los nombres de los candidatos
    string[] candidatos;
    // Lista de los hashes de la identidad de los votantes
    bytes32[] votantes;

    // Constructor
    constructor() {
        owner = msg.sender;
    }
}
