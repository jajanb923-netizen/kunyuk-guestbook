// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/KunyukGuestbook.sol";

/// @notice Deploys KunyukGuestbook to BNB Chain mainnet (chain 56).
/// @dev DRY-RUN ONLY by default: run WITHOUT --broadcast to simulate and
///      print the exact deploy gas. Broadcasting requires the deployer's
///      private key and an explicit user approval AFTER a gas preview.
///      Usage:
///        forge script script/Deploy.s.sol --rpc-url https://bsc-rpc.publicnode.com
///        forge script script/Deploy.s.sol --rpc-url https://bsc-rpc.publicnode.com --broadcast --private-key $DEPLOYER_KEY
contract Deploy is Script {
    function run() external {
        uint256 gasBefore = gasleft();
        vm.startBroadcast();
        KunyukGuestbook guestbook = new KunyukGuestbook();
        vm.stopBroadcast();
        uint256 gasUsed = gasBefore - gasleft();
        console.log("KunyukGuestbook deployed at:", address(guestbook));
        console.log("Deploy gas (approx, incl. script overhead):", gasUsed);
        console.log("Agent ID contract:", address(guestbook.AGENT_ID()));
        console.log("MAX_MESSAGE_LENGTH:", guestbook.MAX_MESSAGE_LENGTH());
    }
}
