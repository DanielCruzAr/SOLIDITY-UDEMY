// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import "./Copy_ERC20.sol";

contract Disney {
    //-------------------------------- DECLARACIONES INICIALES --------------------------------

    // Instancia del contrato token
    ERC20 private token;

    // Direccion de Disney (owner)
    address payable public owner;

    // Estructura de datos para almacenar a los clientes de Disney
    struct Client {
        uint256 tokens;
        string[] atractions;
    }

    // Estructura de la atraccion
    struct Atraction {
        string name;
        uint256 price;
        bool state;
    }

    // Estructura del menu
    struct Food {
        string name;
        uint256 price;
        bool state;
    }

    // Mapping para el registro de clientes
    mapping(address => Client) public clients;

    // Mapping para relacionar la estructura atraccion con su nombre
    mapping(string => Atraction) public atractionsMapping;
    
    // Mapping para relacionar la comida con su nombre
    mapping(string => Food) public menuMapping;

    // Mapping para relacionar un cliente con su historial en Disney
    mapping(address => string[]) atractionHistory;
    mapping(address => string[]) clientFoodOrders;

    // Array para almacenar el nombre de las atracciones
    string[] atractions;

    // Array para almacenar el nombre de la comida
    string[] menu;

    // Constructor
    constructor() {
        token = new ERC20(10000);
        owner = payable(msg.sender);
    }

    // Eventos
    event enjoyAtraction(string, uint256, address);
    event enjoyFood(string, uint256, address);
    event newAtractionAdded(string, uint256);
    event newFoodAdded(string, uint256);
    event atractionRemoved(string);
    event foodRemoved(string);

    // Modificadores
    modifier isOwner(address _address) {
        require(
            _address == owner,
            "No tienes permisos para ejecutar esta funcion"
        );
        _;
    }

    //-------------------------------- GESTION DE TOKENS --------------------------------

    // Funcion para establecer el precio de un Token
    function tokenPrice(uint256 _numTokens) internal pure returns (uint256) {
        return _numTokens * (1 ether);
    }

    // Balance de tokens del contrato disney
    function balanceOf() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    // Funcion para comprar tokens en disney y subir a las atracciones
    function compraTokens(uint256 _numTokens) public payable {
        // Establecer el precio de los tokens
        uint256 cost = tokenPrice(_numTokens);
        // Obtencion del numero de tokens disponibles
        uint256 balance = balanceOf();
        require(
            msg.value >= cost,
            "Compra menos tokens o paga con mas ethers."
        );
        require(_numTokens <= balance, "Compra un numero menor de Tokens");

        // Diferencia de lo que el cliente paga
        uint256 returnValue = msg.value - cost;
        // Disney retorna la cantidad de ethers al cliente
        payable(msg.sender).transfer(returnValue);
        // Se transfiere el numero de tokens al cliente
        token.transfer(msg.sender, _numTokens);
        // Registro de tokens comprados
        clients[msg.sender].tokens += _numTokens;
    }

    // Visualizar el numero de tokens restantes de un cliente
    function myTokens() public view returns (uint256) {
        return token.balanceOf(msg.sender);
    }

    // Funcion para genrar mas tokens
    function createTokens(uint256 _numTokens) public isOwner(msg.sender) {
        token.increaseTotalSupply(_numTokens);
    }

    //-------------------------------- GESTION DE DISNEY --------------------------------

    // Crear nuevas atracciones para Disney
    function newAtraction(string memory _name, uint256 _price)
        public
        isOwner(msg.sender)
    {
        atractionsMapping[_name] = Atraction(_name, _price, true);
        atractions.push(_name);
        emit newAtractionAdded(_name, _price);
    }

    // Dar de baja atracciones en Disney
    function removeAtraction(string memory _name) public isOwner(msg.sender) {
        atractionsMapping[_name].state = false;
        emit atractionRemoved(_name);
    }

    // Visualizar las atracciones de Disney
    function avaiableAtractions() public view returns (string[] memory) {
        return atractions;
    }

    // Funcion para subirse a una atraccion de Disney y pagar en tokens
    function buyAtraction(string memory _name) public {
        // Verifica el estado de la atraccion
        require(
            atractionsMapping[_name].state == true,
            "La atraccion no esta disponible en estos momentos."
        );
        // Precio de la atraccion en tokens
        uint256 atractionTokens = atractionsMapping[_name].price;
        // Verifica el numero de tokens que tiene el cliente para subirse a la atraccion
        require(
            atractionTokens <= myTokens(),
            "Necesitas mas tokens para subirte a esta atraccion."
        );

        // El cliente paga la atraccion en tokens
        token.transferDisney(msg.sender, address(this), atractionTokens);
        atractionHistory[msg.sender].push(_name);
        emit enjoyAtraction(_name, atractionTokens, msg.sender);
    }

    // Visualiza el historial de atracciones del cliente
    function clientHistory() public view returns (string[] memory) {
        return atractionHistory[msg.sender];
    }

    // Funcion para que un cliente de Disney pueda devolver Tokens
    function returnTokens(uint256 _numTokens) public payable {
        require(
            _numTokens > 0,
            "Necesitas devolver una cantidad positiva de tokens."
        );
        require(
            _numTokens <= myTokens(),
            "No tienes los tokens que deseas devolver."
        );

        token.transferDisney(msg.sender, address(this), _numTokens);
        payable(msg.sender).transfer(tokenPrice(_numTokens));
    }

    //-------------------------------- COMIDA --------------------------------

    // Crear nuevos menus
    function addFood(string memory _name, uint256 _price)
        public
        isOwner(msg.sender)
    {
        menuMapping[_name] = Food(_name, _price, true);
        menu.push(_name);
        emit newFoodAdded(_name, _price);
    }

    // Eliminar comida del menu
    function removeFood(string memory _name) public isOwner(msg.sender) {
        menuMapping[_name].state = false;
        emit foodRemoved(_name);
    }

    // Visualizar el menu
    function viewMenu() public view returns (string[] memory) {
        return menu;
    }

    // Ordenar comida
    function orderFood(string memory _name) public {
        require(
            menuMapping[_name].state == true,
            "El alimento no esta disponible en estos momentos."
        );
        uint256 foodTokens = menuMapping[_name].price;
        require(
            foodTokens <= myTokens(),
            "Necesitas mas tokens para ordenar este alimento."
        );

        token.transferDisney(msg.sender, address(this), foodTokens);
        clientFoodOrders[msg.sender].push(_name);
        emit enjoyFood(_name, foodTokens, msg.sender);
    }
}
