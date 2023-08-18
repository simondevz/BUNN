// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract ERC20{
    uint256 public totalsupply;
    string public name;
    string public symbol;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
        owner = msg.sender;

        _mint(msg.sender, 1000e18);
    }

    function decimal() public pure returns (uint8) {
        return 18;
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
       return _transfer(msg.sender, recipient, amount);
    }

     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
        require(recipient != address(0), "ERC20 transfer to address 0");
        uint256 senderBalance = balanceOf[sender];

        require(senderBalance >= amount, "ERC20 transfer amount exceeds balance");
        balanceOf[sender] = senderBalance - amount;
        balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    function _transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
        uint256 currentBalance = allowance[sender][msg.sender];
        require(currentBalance >= amount, "ERC20 transfer amount must not exceed allowance");

        allowance[sender][msg.sender] = currentBalance - amount;
        emit Approval(sender, recipient, amount);

        return _transfer(sender, recipient, amount);
    }

    function approve( address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "ERC20 approve to the address");
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function _mint(address to, uint amount) internal {
        require(to == owner, "ERC20 unapproved address; only contract owner can mint");

        totalsupply += amount;
        balanceOf[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint amount) internal {
        require(from == owner, "ERC20 unapproved address; only contract owner can burn");

        totalsupply -= amount;
        balanceOf[from] -= amount;

        emit Transfer(from, address(0), amount);
    }
}
