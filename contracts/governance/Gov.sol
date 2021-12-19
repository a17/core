// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/governance/GovernorUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorSettingsUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/extensions/GovernorCountingSimpleUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "./GovVotes.sol";
import "./GovVotesQuorumFraction.sol";

contract Gov is Initializable, GovernorUpgradeable, GovernorSettingsUpgradeable, GovernorCountingSimpleUpgradeable, GovVotesUpgradeable, GovVotesQuorumFractionUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {
        // solhint-disable-previous-line no-empty-blocks
    }

    function initialize(ERC20VotesUpgradeable _token, ERC20VotesUpgradeable _token2) public initializer {
        __Governor_init("Gov");
        __GovernorSettings_init(100 /* 100 blocks */, 6545 /* 1 day */, 10);
        __GovernorCountingSimple_init();
        __GovVotesUpgradeable_init(_token, _token2);
        __GovVotesQuorumFraction_init(4);
        __Ownable_init();
        __UUPSUpgradeable_init();
    }

    function _authorizeUpgrade(address newImplementation)
    internal
    onlyOwner
    override
    {
        // solhint-disable-previous-line no-empty-blocks
    }

    // The following functions are overrides required by Solidity.

    function votingDelay()
    public
    view
    override(IGovernorUpgradeable, GovernorSettingsUpgradeable)
    returns (uint256)
    {
        return super.votingDelay();
    }

    function votingPeriod()
    public
    view
    override(IGovernorUpgradeable, GovernorSettingsUpgradeable)
    returns (uint256)
    {
        return super.votingPeriod();
    }

    function quorum(uint256 blockNumber)
    public
    view
    override(IGovernorUpgradeable, GovVotesQuorumFractionUpgradeable)
    returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    function getVotes(address account, uint256 blockNumber)
    public
    view
    override(IGovernorUpgradeable, GovVotesUpgradeable)
    returns (uint256)
    {
        return super.getVotes(account, blockNumber);
    }

    function proposalThreshold()
    public
    view
    override(GovernorUpgradeable, GovernorSettingsUpgradeable)
    returns (uint256)
    {
        return super.proposalThreshold();
    }
}
