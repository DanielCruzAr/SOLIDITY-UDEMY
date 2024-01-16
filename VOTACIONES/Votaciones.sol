// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import "@openzeppelin/contracts/utils/Strings.sol";

// ----------------------------------
//  CANDIDATO  |   EDAD    |   ID
// ----------------------------------
//  Toni       |    20     |  12345X
//  Alberto    |    23     |  54321T
//  Joan       |    21     |  98765P
//  Javier     |    19     |  56789W

contract Votacion {
    // Direccion del propietario del contrato
    address owner;
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

    // Cualquier persona puede usar esta funcion para presentarse a las elecciones
    function representar(
        string memory _nombre,
        uint256 _edad,
        string memory _id
    ) public {
        // Hash de los datos del cantidato
        bytes32 hashCandidato = keccak256(
            abi.encodePacked(_nombre, _edad, _id)
        );
        // Almacenar el hash de los datos del candidato ligados a su nombre
        idCandidato[_nombre] = hashCandidato;
        // Almacenar el nombre del candidato
        candidatos.push(_nombre);
    }

    // Permite visualizar las personas que se han presentado como candidatos a las votaciones
    function verCandidatos() public view returns (string[] memory) {
        // Devuelve la lista de los candidatos presentados
        return candidatos;
    }

    // Los votantes van a poder votar
    function votar(string memory _candidato) public {
        // Hash de la direccion de la persona que ejecuta esta funcion
        bytes32 hashVotante = keccak256(abi.encodePacked(msg.sender));

        // Verificar si el votante ya ha votado
        for (uint256 i = 0; i < votantes.length; i++) {
            require(votantes[i] != hashVotante, "Ya has votado previamente");
        }

        // Almacenamos el hash del votante dentro del array de votantes
        votantes.push(hashVotante);
        // Añadimos un voto al candidato seleccionado
        votosCandidato[_candidato]++;
    }

    // Devuelve el numero de votos que tiene un candidato dado su nombre
    function verVotos(string memory _nombre) public view returns (uint256) {
        return votosCandidato[_nombre];
    }

    // Ver los votos de cada uno de los candidatos
    function verResultados() public view returns (string memory) {
        // Guardamos en un variable string los candidatos con sus respectivos votos
        string memory resultados = "";

        for (uint256 i = 0; i < candidatos.length; i++) {
            uint256 votosCandidato_ = verVotos(candidatos[i]);
            string memory votosStr_ = Strings.toString(votosCandidato_);
            // Actualizamos el string de resultados y añadimos el candidato que
            // ocpa la posicion "i" del array candidatos
            resultados = string(
                abi.encodePacked(
                    resultados,
                    "(",
                    candidatos[i],
                    ", ",
                    votosStr_,
                    ") --------"
                )
            );
        }

        return resultados;
    }

    function ganador() public view returns (string memory) {
        // La variable ganador va a contener el nombre del candidato ganador
        string memory ganador_ = candidatos[0];
        // Variable para la situacion de empate
        bool flag;

        for (uint i = 1; i < candidatos.length; i++) {
            // Comparar si el ganador ha sido superado por otro candidato
            if (votosCandidato[ganador_] < votosCandidato[candidatos[i]]) {
                ganador_ = candidatos[i];
                flag = false;
            // Ver si hay empate entre los candidatos
            } else if (votosCandidato[ganador_] == votosCandidato[candidatos[i]]) {
                flag = true;
            }
        }

        // Comprobamos si ha habido un empate entre los candidatos
        if (flag) {
            ganador_ = "Hay un empate entre los candidatos.";
        }

        return ganador_;
    }
}
