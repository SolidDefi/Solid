pragma solidity >=0.7.3;

import './interfaces/ISolidERC20.sol';
import './libraries/SafeMath.sol';
//import './libraries/Math.sol';
import './All_math.sol';


contract SolidERC20 is ISolidERC20 {
    using SafeMath for uint;

    string public override constant name = 'Solid';
    string public override constant symbol = '$olid';
    uint8 public override constant decimals = 18;
    uint  public override totalSupply = 200000000 * 10 ** decimals;
    uint public override solidPrice;
    mapping(address => uint) public override balanceOf;
    mapping(address => mapping(address => uint)) public override allowance;

    bytes32 public override DOMAIN_SEPARATOR;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public override constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public override nonces;

    //event Approval(address indexed owner, address indexed spender, uint value);
    //event Transfer(address indexed from, address indexed to, uint value);
    
    //code for Solid
    mapping(address => uint256) public override coinprice;
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
    
    
    //address tokenID should be in the below function(mintOnbuy and burnOnsell);
    function mintOnbuy_regular(uint value) external view returns(uint256 z){
        //require(balanceOf[msg.sender] > value, 'Not enough balance');
        //uint256 x = Math.cubic((value*3/2+(Math.sqrt_callable(totalSupply)**3))**2);
        
        //uint256 x = (3*value/2+(Math.sqrt_callable(totalSupply)**3/(10**9)))**2;
        //uint256 y = Math.cubic(x/(10**18));
        //y = y*10**12-totalSupply;
        
        return Math.cubic((3*value/2+(Math.sqrt_callable(totalSupply)**3/(10**9)))**2/(10**18))*10**12-totalSupply;
    }
    
     //address tokenID should be in the below function(mintOnbuy and burnOnsell);
    function mintOnbuy_asquare_plus2ab_plus_bsquare(uint value) external view returns(uint256 z){
        //require(balanceOf[msg.sender] > value, 'Not enough balance');
        
        //uint256 b = (Math.sqrt_callable(totalSupply)**3)/(10**9);
        //uint256 x = (3*value/2)**2+3*value*b+(totalSupply**3)/(10**18);
        //x = x/(10**18);
        //uint256 y = Math.cubic(x)*10**12-totalSupply;
        
        //((3*value/2)**2+3*value*((Math.sqrt_callable(totalSupply)**3)/(10**9))+(totalSupply**3)/(10**18))/(10**18)
        return Math.cubic(((3*value/2)**2+3*value*((Math.sqrt_callable(totalSupply)**3)/(10**9))+(totalSupply**3)/(10**18))/(10**18))*10**12-totalSupply;
    }
    
    
    //function burnOnsell(uint value) external{
        
    //    uint256 x = Math.sqrt_callable(totalSupply)**3-Math.sqrt_callable(totalSupply-value)**3
    //}

    function _mint(address to, uint value) internal {
        totalSupply = totalSupply.add(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(address(0), to, value);
    }

    function _burn(address from, uint value) internal {
        balanceOf[from] = balanceOf[from].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Transfer(from, address(0), value);
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
