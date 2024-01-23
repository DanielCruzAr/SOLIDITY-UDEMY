// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/// Juan Gabriel ---> 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
/// Daniel Cruz ---> 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
/// Maria Santos ---> 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

// Interface de nuestro token ERC20
interface IERC20 {
    // Evento que se debe emitir cuando una cantidad de tokens pase de un origen a un destino
    event Transfer(address indexed from, address indexed to, uint256 amount);

    // Evento que se debe emitir cuando se establece una asignacion con el metodo allowance()
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // Devuelve la cantidad de tokens en existencia
    function totalSuply() external view returns (uint256);

    // Devuelve la cantidad de tokens para una direccion indicada por parametro
    function balanceOf(address _account) external view returns (uint256);

    // Devuelve el numero de token que el spender podra gastar en nombre del propietario (owner)
    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256);

    // Devuelve un valor booleano rsultado de la operacion indicada
    function transferDisney(address _client, address _recipient, uint256 _amount)
        external
        returns (bool);

    function transfer(address _recipient, uint256 _amount)
        external
        returns (bool);

    // Devuelve un valor booleano con el resultado de la operacion de gasto
    function approve(address _spender, uint256 _amount) external returns (bool);

    // Devuelve un valor booleano con el resultado de la operacion
    // de paso de una cantidad de tokens usando el metodo alowance()
    function transferFrom(
        address _sender,
        address _recipient,
        uint256 _amount
    ) external returns (bool);
}

// Implementacion de las funciones del token ERC20
contract ERC20 is IERC20 {
    string public constant name = "ERC20BlockchainAZ";
    string public constant symbol = "ERC";
    uint8 public constant decimals = 2;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    uint256 totalSuply_;

    constructor(uint256 _initialSupply) {
        totalSuply_ = _initialSupply;
        balances[msg.sender] = totalSuply_;
    }

    function totalSuply() public view override returns (uint256) {
        return totalSuply_;
    }

    function increaseTotalSupply(uint256 _newTokensAmount) public {
        totalSuply_ += _newTokensAmount;
        balances[msg.sender] += _newTokensAmount;
    }

    function balanceOf(address _tokenOwner)
        public
        view
        override
        returns (uint256)
    {
        return balances[_tokenOwner];
    }

    function allowance(address _owner, address _delegate)
        public
        view
        override
        returns (uint256)
    {
        return allowed[_owner][_delegate];
    }

    function transferDisney(address _client, address _recipient, uint256 _numTokens)
        public
        override
        returns (bool)
    {
        require(_numTokens <= balances[_client]);

        balances[_client] = balances[_client] - _numTokens;
        balances[_recipient] = balances[_recipient] + _numTokens;
        emit Transfer(_client, _recipient, _numTokens);
        return true;
    }

    function transfer(address _recipient, uint256 _numTokens)
        public
        override
        returns (bool)
    {
        require(_numTokens <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender] - _numTokens;
        balances[_recipient] = balances[_recipient] + _numTokens;
        emit Transfer(msg.sender, _recipient, _numTokens);
        return true;
    }

    function approve(address _delegate, uint256 _numTokens)
        public
        override
        returns (bool)
    {
        allowed[msg.sender][_delegate] = _numTokens;
        emit Approval(msg.sender, _delegate, _numTokens);
        return true;
    }

    function transferFrom(
        address _owner,
        address _buyer,
        uint256 _numTokens
    ) public override returns (bool) {
        require(_numTokens <= balances[_owner]);
        require(_numTokens <= allowed[_owner][msg.sender]);
        
        balances[_owner] = balances[_owner] - _numTokens;
        allowed[_owner][msg.sender] = allowed[_owner][msg.sender] - _numTokens;
        balances[_buyer] = balances[_buyer] + _numTokens;
        emit Transfer(_owner, _buyer, _numTokens);
        return true;
    }
}
