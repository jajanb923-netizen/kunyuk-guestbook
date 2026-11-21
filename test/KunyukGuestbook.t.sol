// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/KunyukGuestbook.sol";

/// @notice Minimal stand-in for the Agent ID ERC-721, used ONLY in tests.
/// The real Agent ID contract lives at 0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F
/// on BNB Chain mainnet; this mock only reproduces its balanceOf behaviour.
contract MockAgentId {
    mapping(address => uint256) private _balances;

    function mint(address to) external {
        _balances[to] = 1;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }
}

/// @notice Tests run against a KunyukGuestbook pointed at the mock.
/// The mock address is injected by deploying the guestbook via a test-only
/// harness: we deploy the guestbook, then use vm.etch to place the mock's
/// bytecode at the real Agent ID address, so the production code path
/// (hard-coded AGENT_ID address) is exercised exactly as deployed.
contract KunyukGuestbookTest is Test {
    KunyukGuestbook public guestbook;
    MockAgentId public mock;

    address public constant AGENT_ID_ADDR =
        0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F;

    address holder = address(0xA11CE);
    address holder2 = address(0xB0B);
    address nonHolder = address(0xBAD);

    event Signed(
        address indexed signer,
        string message,
        uint256 timestamp,
        uint256 index
    );

    function setUp() public {
        mock = new MockAgentId();
        guestbook = new KunyukGuestbook();
        // Place the mock's runtime bytecode at the real Agent ID address so
        // the guestbook's hard-coded balanceOf call hits the mock.
        vm.etch(AGENT_ID_ADDR, address(mock).code);
        // Calls to the etched address run with that address's own storage,
        // so minting through it populates the balances the guestbook reads.
        MockAgentId(AGENT_ID_ADDR).mint(holder);
        MockAgentId(AGENT_ID_ADDR).mint(holder2);
    }

    function test_holderCanSign() public {
        vm.prank(holder);
        guestbook.sign("Hello from kunyuk95!");
        assertEq(guestbook.totalSignatures(), 1);
        assertTrue(guestbook.hasSigned(holder));
        (address signer, string memory message, uint256 ts) = guestbook
            .getSignature(0);
        assertEq(signer, holder);
        assertEq(message, "Hello from kunyuk95!");
        assertEq(ts, block.timestamp);
    }

    function test_nonHolderCannotSign() public {
        vm.prank(nonHolder);
        vm.expectRevert("KunyukGuestbook: caller does not hold an Agent ID");
        guestbook.sign("I should not get in");
        assertEq(guestbook.totalSignatures(), 0);
    }

    function test_emptyMessageReverts() public {
        vm.prank(holder);
        vm.expectRevert("KunyukGuestbook: empty message");
        guestbook.sign("");
    }

    function test_messageTooLongReverts() public {
        string memory longMsg = new string(281);
        // Fill with 'a' (281 bytes > 280 cap).
        bytes memory b = bytes(longMsg);
        for (uint256 i = 0; i < b.length; i++) b[i] = "a";
        vm.prank(holder);
        vm.expectRevert("KunyukGuestbook: message too long");
        guestbook.sign(string(b));
    }

    function test_messageExactly280Accepted() public {
        bytes memory b = new bytes(280);
        for (uint256 i = 0; i < b.length; i++) b[i] = "a";
        vm.prank(holder);
        guestbook.sign(string(b));
        assertEq(guestbook.totalSignatures(), 1);
    }

    function test_oneSignaturePerAddress() public {
        vm.prank(holder);
        guestbook.sign("first");
        vm.prank(holder);
        vm.expectRevert("KunyukGuestbook: already signed");
        guestbook.sign("second");
        assertEq(guestbook.totalSignatures(), 1);
    }

    function test_signedEventEmitted() public {
        vm.prank(holder);
        vm.expectEmit(true, false, false, true, address(guestbook));
        emit Signed(holder, "event check", block.timestamp, 0);
        guestbook.sign("event check");
    }

    function test_multipleSignersAndViews() public {
        vm.prank(holder);
        guestbook.sign("one");
        vm.prank(holder2);
        guestbook.sign("two");

        assertEq(guestbook.totalSignatures(), 2);
        assertTrue(guestbook.hasSigned(holder));
        assertTrue(guestbook.hasSigned(holder2));
        assertFalse(guestbook.hasSigned(nonHolder));

        (address s0, string memory m0, ) = guestbook.getSignature(0);
        (address s1, string memory m1, ) = guestbook.getSignature(1);
        assertEq(s0, holder);
        assertEq(m0, "one");
        assertEq(s1, holder2);
        assertEq(m1, "two");
    }

    function test_getSignatureOutOfBoundsReverts() public {
        vm.expectRevert();
        guestbook.getSignature(0);
    }

    function test_noOwnerOrAdminFunctions() public {
        // The contract exposes no owner() and no admin entry points: the
        // only external functions are sign, totalSignatures, getSignature,
        // hasSigned, MAX_MESSAGE_LENGTH and AGENT_ID.
        // A call to a non-existent owner() selector must revert (no fallback).
        (bool ok, ) = address(guestbook).call(
            abi.encodeWithSignature("owner()")
        );
        assertFalse(ok);
        (ok, ) = address(guestbook).call(
            abi.encodeWithSignature("pause()")
        );
        assertFalse(ok);
    }
}
