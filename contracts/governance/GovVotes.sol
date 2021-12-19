// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/governance/GovernorUpgradeable.sol";
import '@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol';
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @dev Custom extension of {Governor} for voting weight extraction from two {ERC20Votes} tokens.
 */
abstract contract GovVotesUpgradeable is Initializable, GovernorUpgradeable {
    using SafeMathUpgradeable for uint256;

    ERC20VotesUpgradeable public token;
    ERC20VotesUpgradeable public token2;

    function __GovVotesUpgradeable_init(
        // solhint-disable-previous-line func-name-mixedcase
        ERC20VotesUpgradeable tokenAddress,
        ERC20VotesUpgradeable token2Address
    ) internal initializer {
        __Context_init_unchained();
        __ERC165_init_unchained();
        __IGovernor_init_unchained();
        __GovVotesUpgradeable_init_unchained(tokenAddress, token2Address);
    }

    function __GovVotesUpgradeable_init_unchained(
        // solhint-disable-previous-line func-name-mixedcase
        ERC20VotesUpgradeable tokenAddress,
        ERC20VotesUpgradeable token2Address
    ) internal initializer {
        token = tokenAddress;
        token2 = token2Address;
    }

    /**
     * Read the voting weight from the token's built in snapshot mechanism (see {IGovernor-getVotes}).
     */
    function getVotes(address account, uint256 blockNumber) public view virtual override returns (uint256) {
        return token.getPastVotes(account, blockNumber).add(token2.getPastVotes(account, blockNumber));
    }
    uint256[50] private __gap;
}
