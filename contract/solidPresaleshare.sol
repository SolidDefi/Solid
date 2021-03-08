// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.8.0;

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
}
library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}
contract SolidPresaleShare is IERC20{
    bool public lock=false;
    address public team_address=0x2B6C7F44DD5A627496A92FDB12080162e368aB1E;
    
    using SafeMath for uint;
    bytes32 public override DOMAIN_SEPARATOR;
    mapping(address => uint) public override balanceOf;
    mapping(address => mapping(address => uint)) public override allowance;
    uint public override totalSupply;
    string public override constant name = 'SolidPresaleShare';
    string public override constant symbol = 'SPS';
    uint8 public override constant decimals = 18;

    bytes32 public override constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public override nonces;
    
    constructor() public {
        uint chainId;
        assembly {
            chainId := chainid()
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(name)),
                keccak256(bytes('1')),
                chainId,
                address(this)
            )
        );
    }
    
    function contractApprove(address spender,uint amount) external{
        require(spender==team_address && !lock);
		//(S)MAUSDC 0x9719d867A500Ef117cC201206B8ab51e794d3F82 will be replace be contract address of SMAUSDC
        IERC20(0x9719d867A500Ef117cC201206B8ab51e794d3F82).approve(spender,amount);
        IERC20(0x9719d867A500Ef117cC201206B8ab51e794d3F82).approve(spender,amount);
    }
    //Forever out of control when lock is true
    function burnLock(address spender) external{
        require(spender==team_address);
        lock=true;
    }
    
    function depositMAUSDC(uint amount) external{
        require(!lock);
        uint _amount = amount*10**12;
        balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
        totalSupply = totalSupply.add(_amount);
        IERC20(0x9719d867A500Ef117cC201206B8ab51e794d3F82).transferFrom(msg.sender,address(this),amount);
    }
    
    function depositSMAUSDC(uint amount) external{
        require(!lock);
        uint _amount = amount;
        balanceOf[msg.sender] = balanceOf[msg.sender].add(_amount);
        totalSupply = totalSupply.add(_amount);
        IERC20(0x9719d867A500Ef117cC201206B8ab51e794d3F82).transferFrom(msg.sender,address(this),amount);
    }
    function _approve(address owner, address spender, uint value) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(address from, address to, uint value) private {
        balanceOf[from] = balanceOf[from].sub(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint value) override external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint value) override external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) override external returns (bool) {
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _transfer(from, to, value);
        return true;
    }

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) override external {
        require(deadline >= block.timestamp, 'Solid: EXPIRED');
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, 'Solid: INVALID_SIGNATURE');
        _approve(owner, spender, value);
    }
        
   
}