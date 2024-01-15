// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
pragma experimental ABIEncoderV2;

// ------------------------------
//  ALUMNO  |   ID   |   NOTA
// ------------------------------
//  Marcos  | 77755N |  5
//  Joan    | 12345X |  9
//  Maria   | 02468T |  2
//  Marta   | 13579U |  3

contract Notas {
    // Direccion del profesor
    address public profesor;
    // Mapping para relacionar el hash del id del alumno con su nota del examen
    mapping(bytes32 => uint256) notas;
    // Array de alumnos que pidan revisiones de examen
    string[] revisiones;

    // Constructor
    constructor() {
        profesor = msg.sender;
    }

    // Eventos
    event alumnoEvaluado(bytes32);
    event eventoRevision(string);

    // Modificadores
    modifier esProfesor(address _direccion) {
        // Requiere que la direccion introducida sea igual al owner del contrato
        require(
            _direccion == profesor,
            "No tienes permisos para ejecutar esta funcion"
        );
        _;
    }

    // Funcion para evaluar a los alumnos
    function evaluar(string memory _idAlumno, uint256 _nota)
        public
        esProfesor(msg.sender)
    {
        // Hash de la identificacion del alumno
        bytes32 hashIdAlumno = keccak256(abi.encodePacked(_idAlumno));
        // Relacion entre el hash del id del alumno y su nota
        notas[hashIdAlumno] = _nota;
        // Emision del evento
        emit alumnoEvaluado(hashIdAlumno);
    }

    // Funcion para ver las notas de un alumno
    function verNotas(string memory _idAlumno) public view returns (uint256) {
        // Hash de la identificacion del alumno
        bytes32 hashIdAlumno = keccak256(abi.encodePacked(_idAlumno));
        // Nota asociada al hash del alumno
        uint256 notaAlumno = notas[hashIdAlumno];
        // Visualizar la nota
        return notaAlumno;
    }

    // Funcion para pedir una revision del examen
    function revision(string memory _idAlumno) public {
        // Almacenamiento de la identidad del alumno en un array
        revisiones.push(_idAlumno);
        // Emision del evento
        emit eventoRevision(_idAlumno);
    }

    // Funcion para ver los alumnos que han solicitado revision de examen
    function verRevisiones()
        public
        view
        esProfesor(msg.sender)
        returns (string[] memory)
    {
        // Devolver las identidades de los alumnos
        return revisiones;
    }
}
