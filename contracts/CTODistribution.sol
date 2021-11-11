// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CTODistribution is Ownable{
    IERC20 public constant CTO = IERC20(0xa5e48a6E56e164907263e901B98D9b11CCB46C47);
    mapping(address => uint256) public balance;

    constructor()
    {
        transferOwnership(0xDAc57a2C77a64AEFC171339F2891871d9A298EC5);

        balance[0x707E4A05B3dDC2049387BF7B7CFe82D6F09e986e] = 1464286 * (10 ** (18 - 1));
        balance[0x316D0e55B47ad86443b25EAa088e203482645046] = 75000 * (10 ** 18);
        balance[0xA7060deA79008DEf99508F50DaBDCDe7293c1D8A] = 69741 * (10 ** 18);

        balance[0x3C68319b15Bc0145ce111636f6d8043ACF4D59f6] = 57143 * (10 ** 18);
        balance[0x175dd00579DF16669fC993F8AFA4EE8AA962865A] = 57143 * (10 ** 18);
        balance[0x729Ea64B1393eD633C069aF04b45e1212905b4A9] = 30000 * (10 ** 18);
        balance[0x2C9bC9793AD5c24feD22654Ee13F287329668B55] = 142858 * (10 ** (18 - 1));
        balance[0x2295b2e2F0C8CF5e4E9c2cae33ad4F4cCbc95fD5] = 214286 * (10 ** (18 - 1));

        balance[0xB7d41bb3863E403c29Fe4CA85D31206b6b507630] = 62500 * (10 ** 18);
        balance[0x6D9e32012eC93EBb858F9103B9F7f52eBAb6299F] = 87500 * (10 ** 18);
        balance[0x97CA08d4CA2015545eeb81ca71d1Ac719Fe4A8F6] = 31250 * (10 ** 18);
        balance[0x32c9B7BD4E0aaBDe8C81cBe5d3fE30E01d34329B] = 218750 * (10 ** 18);

        balance[0x16f9cEB2D822ee203a304635d12897dBD2cEeB75] = 31250 * (10 ** 18);
        balance[0xe32341a633FA57CA963D2F2dc78D31D76ee258B7] = 21875 * (10 ** 18);
        balance[0xE88540354a9565300D2E7109d7737508F4155A4d] = 18750 * (10 ** 18);
        balance[0x570DaFD281d70d8d69D19c5A004b0FC3fF52Fd0b] = 18750 * (10 ** 18);
        balance[0x9D400eb10623d34CCEc7aaa9FC347921866B9c86] = 25000 * (10 ** 18);

        balance[0xb87230a8169366051b1732DfB4687F2A041564cf] = 70475 * (10 ** (18 - 1));
        balance[0x67c069523115A6ffE9192F85426cF79f8b4ba7a5] = 862075 * (10 ** (18 - 2));
        balance[0x8786CB3682Cb347AE1226b5A15E991339A877Dfb] = 862075 * (10 ** (18 - 2));
    }


    function addBalance(address _user, uint _amount) external onlyOwner{
        balance[_user] = balance[_user] + _amount;
    }

    function resetBalance(address _user) external onlyOwner{
        balance[_user] = 0;
    }

    function withdraw() external {
        address user = _msgSender();
        uint canWithdraw = balance[user];
        require(canWithdraw > 0, "Insufficient balance");
        balance[user] = 0;
        CTO.transfer(user, canWithdraw);
    }
}
