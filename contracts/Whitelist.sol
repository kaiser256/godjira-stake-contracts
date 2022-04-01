//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";

contract WhitelistChecker is EIP712Upgradeable {

    string private constant SIGNING_DOMAIN = "Gen";
    string private constant SIGNATURE_VERSION = "1";

    struct whitelisted {
        address whiteListAddress;
        uint256 genTokenId;
        string genMultiplier;
        uint256[] gen2TokenIds;
        string[] gen2Earnings;
        bytes signature;
    }

    // constructor() EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION){}
  
    function __Whitelist_init() internal {
        __EIP712_init(SIGNING_DOMAIN, SIGNATURE_VERSION);
    }
  
    function getSigner(whitelisted memory list) internal view returns(address){
        return _verify(list);
    }

    
    /// @notice Returns a hash of the given rarity, prepared using EIP712 typed data hashing rules.
  
    function _hash(whitelisted memory list) internal view returns (bytes32) {
        return _hashTypedDataV4(
            keccak256(
                abi.encode(
                    keccak256("whitelisted(address whiteListAddress,uint256 genTokenId,string genMultiplier,uint256[] gen2TokenIds,string[] gen2Earnings)"),
                    list.whiteListAddress,
                    list.genTokenId,
                    list.genMultiplier,
                    keccak256(abi.encode(list.gen2TokenIds)),
                    keccak256(abi.encode(list.gen2Earnings))
                )
            )
        );
    }

    function _verify(whitelisted memory list) internal view returns (address) {
        bytes32 digest = _hash(list);
        return ECDSAUpgradeable.recover(digest, list.signature);
    }

    function getChainID() external view returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }
}