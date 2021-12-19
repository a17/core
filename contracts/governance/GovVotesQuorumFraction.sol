// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./GovVotes.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @dev Custom extension of {Governor} for voting weight extraction from two {ERC20Votes} tokens and a quorum expressed as a
 * fraction of the total supply of first token.
 */
abstract contract GovVotesQuorumFractionUpgradeable is Initializable, GovVotesUpgradeable {
    uint256 private _quorumNumerator;

    event QuorumNumeratorUpdated(uint256 oldQuorumNumerator, uint256 newQuorumNumerator);

    function __GovVotesQuorumFraction_init(
        // solhint-disable-previous-line func-name-mixedcase
        uint256 quorumNumeratorValue
    ) internal initializer {
        __Context_init_unchained();
        __ERC165_init_unchained();
        __IGovernor_init_unchained();
        __GovVotesQuorumFraction_init_unchained(quorumNumeratorValue);
    }

    function __GovVotesQuorumFraction_init_unchained(
        // solhint-disable-previous-line func-name-mixedcase
        uint256 quorumNumeratorValue
    ) internal initializer {
        _updateQuorumNumerator(quorumNumeratorValue);
    }

    function quorumNumerator() public view virtual returns (uint256) {
        return _quorumNumerator;
    }

    function quorumDenominator() public view virtual returns (uint256) {
        return 100;
    }

    function quorum(uint256 blockNumber) public view virtual override returns (uint256) {
        return (token.getPastTotalSupply(blockNumber) * quorumNumerator()) / quorumDenominator();
    }

    function updateQuorumNumerator(uint256 newQuorumNumerator) external virtual onlyGovernance {
        _updateQuorumNumerator(newQuorumNumerator);
    }

    function _updateQuorumNumerator(uint256 newQuorumNumerator) internal virtual {
        require(
            newQuorumNumerator <= quorumDenominator(),
            "quorumNumerator Denominator"
        );

        uint256 oldQuorumNumerator = _quorumNumerator;
        _quorumNumerator = newQuorumNumerator;

        emit QuorumNumeratorUpdated(oldQuorumNumerator, newQuorumNumerator);
    }
    uint256[49] private __gap;
}
