// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract CoinversationToken is ERC20Capped {
    uint256 public immutable startReleaseBlock;   // the block num when initial distribution start.
    uint256 public constant MONTH = 195622; // 30 * 24 * 60 * 60 / 13.25

    mapping(address => uint256) public locks12;
    mapping(address => uint256) public lastUnlockEra12;

    mapping(address => uint256) public locks24;
    mapping(address => uint256) public lastUnlockEra24;
    mapping(address => uint256) public addressStartReleaseBlock;
    address public constant DEV_ACCOUNT = 0x2326eAb2a83bbe25dE8B9D0A8cB6dc63Dae6BaF9;
    bool public isDevInitialFundMinted = false;

    constructor(uint256 _startReleaseBlock)
        ERC20("Coinversation Token", "CTO")
        ERC20Capped(100000000 * (10 ** decimals()))
    {
        //13566600
        startReleaseBlock = _startReleaseBlock;

        uint8 decimals = decimals();

        //for initial release
        ERC20._mint(0xDAc57a2C77a64AEFC171339F2891871d9A298EC5, 3604834 * (10 ** decimals));

        //investors' funds locks up in 12 MONTHs
        locks12[0x707E4A05B3dDC2049387BF7B7CFe82D6F09e986e] = 7107144 * (10 ** (decimals - 1));
        locks12[0x316D0e55B47ad86443b25EAa088e203482645046] = 425000 * (10 ** decimals);
        locks12[0xA7060deA79008DEf99508F50DaBDCDe7293c1D8A] = 349225 * (10 ** decimals);
        locks12[0xC286Bc3F74fAce4387959665aF71253461c28d34] = 2125000 * (10 ** decimals);

        locks12[0x3C68319b15Bc0145ce111636f6d8043ACF4D59f6] = 228572 * (10 ** decimals);
        locks12[0x175dd00579DF16669fC993F8AFA4EE8AA962865A] = 228572 * (10 ** decimals);
        locks12[0x729Ea64B1393eD633C069aF04b45e1212905b4A9] = 120000 * (10 ** decimals);
        locks12[0x2C9bC9793AD5c24feD22654Ee13F287329668B55] = 571432 * (10 ** (decimals - 1));
        locks12[0x2295b2e2F0C8CF5e4E9c2cae33ad4F4cCbc95fD5] = 857144 * (10 ** (decimals - 1));

        locks12[0xB7d41bb3863E403c29Fe4CA85D31206b6b507630] = 187500 * (10 ** decimals);
        locks12[0x6D9e32012eC93EBb858F9103B9F7f52eBAb6299F] = 262500 * (10 ** decimals);
        locks12[0x97CA08d4CA2015545eeb81ca71d1Ac719Fe4A8F6] = 93750 * (10 ** decimals);
        locks12[0x968dF8FBF4d7c6C46282a46C5DA7d514b23a98fa] = 562500 * (10 ** decimals);

        locks12[0x16f9cEB2D822ee203a304635d12897dBD2cEeB75] = 93750 * (10 ** decimals);
        locks12[0xe32341a633FA57CA963D2F2dc78D31D76ee258B7] = 65625 * (10 ** decimals);
        locks12[0xE88540354a9565300D2E7109d7737508F4155A4d] = 56250 * (10 ** decimals);
        locks12[0x570DaFD281d70d8d69D19c5A004b0FC3fF52Fd0b] = 56250 * (10 ** decimals);
        locks12[0x9D400eb10623d34CCEc7aaa9FC347921866B9c86] = 75000 * (10 ** decimals);

        locks12[0xb87230a8169366051b1732DfB4687F2A041564cf] = 211425 * (10 ** (decimals - 1));
        locks12[0x67c069523115A6ffE9192F85426cF79f8b4ba7a5] = 2586225 * (10 ** (decimals - 2));
        locks12[0x8786CB3682Cb347AE1226b5A15E991339A877Dfb] = 2586225 * (10 ** (decimals - 2));

        //Project Development Fund locks up in 24 MONTHs
        locks24[0x9C94F95fBa7aDcf936043b817817e18fcb611857] = 12750000 * (10 ** decimals);
        addressStartReleaseBlock[0x9C94F95fBa7aDcf936043b817817e18fcb611857] = _startReleaseBlock;

        //Dev Group Fund locks up in 24 MONTHs and the initial release needs to be delayed by one more MONTH
        locks24[DEV_ACCOUNT] = 13500000 * (10 ** decimals);
        addressStartReleaseBlock[DEV_ACCOUNT] = _startReleaseBlock + MONTH;
    }

    function nextUnlockBlock12(address _account) public view returns (uint) {
        if(locks12[_account] > 0){
            return startReleaseBlock + ((lastUnlockEra12[_account] + 1) * MONTH);
        }else{
            return 0;
        }
    }

    function canUnlockAmount12(address _account) public view returns (uint256, uint) {
        uint startBlock = startReleaseBlock;
        uint lastEra = lastUnlockEra12[_account];
        // When block number less than nextReleaseBlock, no CTO can be unlocked
        if (block.number < (startBlock + ((lastEra + 1) * MONTH))) {
            return (0, 0);
        }
        // When block number more than endReleaseBlock12, all locked CTO can be unlocked
        else if (block.number >= (startBlock + (12 * MONTH))) {
            return (locks12[_account], 12 - lastEra);
        }
        // When block number is more than nextReleaseBlock but less than endReleaseBlock12,
        // some CTO can be released
        else {
            uint eras = (block.number - (startBlock + (lastEra * MONTH))) / MONTH;
            return (locks12[_account] / (12 - lastEra) * eras, eras);
        }
    }

    function canUnlockAmount24(uint _specificStartReleaseBlock, address _account) public view returns (uint256, uint) {
        uint startBlock = _specificStartReleaseBlock;
        uint lastEra = lastUnlockEra24[_account];
        // When block number less than nextReleaseBlock, no CTO can be unlocked
        if (block.number < (startBlock + ((lastEra + 1) * MONTH))) {
            return (0, 0);
        }
        // When block number more than endReleaseBlock24, all locked CTO can be unlocked
        else if (block.number >= (startBlock + (24 * MONTH))) {
            return (locks24[_account], 24 - lastEra);
        }
        // When block number is more than nextReleaseBlock but less than endReleaseBlock24,
        // some CTO can be released
        else {
            uint eras = (block.number - (startBlock + (lastEra * MONTH))) / MONTH;
            return (locks24[_account] / (24 - lastEra) * eras, eras);
        }
    }


    function unlock12() public {
        (uint256 amount, uint eras) = canUnlockAmount12(msg.sender);
        require(amount > 0, "none unlocked CTO");

        _mint(msg.sender, amount);

        locks12[msg.sender] = locks12[msg.sender] - amount;
        lastUnlockEra12[msg.sender] = lastUnlockEra12[msg.sender] + eras;
    }

    function unlock24() public {
        (uint256 amount, uint eras) = canUnlockAmount24(addressStartReleaseBlock[msg.sender], msg.sender);
        require(amount > 0, "none unlocked CTO");

        _mint(msg.sender, amount);

        locks24[msg.sender] = locks24[msg.sender] - amount;
        lastUnlockEra24[msg.sender] = lastUnlockEra24[msg.sender] + eras;
    }

    function mintDevInitialFund() public {
        require(!isDevInitialFundMinted, "already minted");
        require(block.number > addressStartReleaseBlock[DEV_ACCOUNT], "time is not up yet");

        _mint(DEV_ACCOUNT, 1500000 * 10 ** decimals());
        isDevInitialFundMinted = true;
    }
}
