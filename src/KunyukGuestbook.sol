// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Kunyuk Guestbook
/// @notice A minimal guestbook on BNB Chain where only Agent ID (.ai) holders can sign.
/// @dev Agent ID is the SPACE ID Agent ID ERC-721 (non-transferable) on BNB Chain:
///      0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F. Holding is checked with
///      balanceOf(address) > 0, exactly as documented in the official Binance
///      Agent ID Hackathon announcement (2026-11-18).
///
///      Design guarantees, for the hackathon safety rules:
///      - NO owner / admin functions. Nobody can pause, upgrade, change fees,
///        freeze, or withdraw anything. There are no funds to withdraw: the
///        contract holds no BNB and charges no fee.
///      - NO token, NO minting, NO trading. This is not a trading product.
///      - NO name-to-wallet lookup: the contract never resolves an .ai name to
///        an address, and the frontend never offers such a lookup.
///      - One signature per address, so the on-chain metric "number of
///        interacting Agent ID addresses" is exactly the number of distinct
///        signers, and no single address can spam the guestbook.
///      - Signing is a plain user-confirmed transaction. The frontend never
///        asks for seed phrases, private keys, API secrets, or pairing codes,
///        and never uses QR-code / WalletConnect pairing.
interface IAgentId {
    function balanceOf(address account) external view returns (uint256);
}

contract KunyukGuestbook {
    /// @notice The Agent ID contract (SPACE ID Agent ID, ERC-721, non-transferable).
    IAgentId public constant AGENT_ID =
        IAgentId(0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F);

    /// @notice Maximum message length in bytes (280 characters, ASCII-friendly).
    uint256 public constant MAX_MESSAGE_LENGTH = 280;

    struct Signature {
        address signer;
        string message;
        uint256 timestamp;
    }

    Signature[] private _signatures;

    /// @notice True once an address has signed. One signature per address.
    mapping(address => bool) public hasSigned;

    /// @notice Emitted for every signature.
    event Signed(
        address indexed signer,
        string message,
        uint256 timestamp,
        uint256 index
    );

    /// @notice Sign the guestbook with a short message.
    /// @dev Reverts unless the caller holds an Agent ID (balanceOf > 0).
    ///      Each signature is a separate user-confirmed on-chain transaction.
    function sign(string calldata message) external {
        require(
            AGENT_ID.balanceOf(msg.sender) > 0,
            "KunyukGuestbook: caller does not hold an Agent ID"
        );
        require(!hasSigned[msg.sender], "KunyukGuestbook: already signed");
        bytes memory raw = bytes(message);
        require(raw.length > 0, "KunyukGuestbook: empty message");
        require(
            raw.length <= MAX_MESSAGE_LENGTH,
            "KunyukGuestbook: message too long"
        );

        uint256 index = _signatures.length;
        _signatures.push(
            Signature({
                signer: msg.sender,
                message: message,
                timestamp: block.timestamp
            })
        );
        hasSigned[msg.sender] = true;

        emit Signed(msg.sender, message, block.timestamp, index);
    }

    /// @notice Total number of signatures so far.
    function totalSignatures() external view returns (uint256) {
        return _signatures.length;
    }

    /// @notice One signature by index.
    function getSignature(
        uint256 index
    )
        external
        view
        returns (address signer, string memory message, uint256 timestamp)
    {
        Signature storage s = _signatures[index];
        return (s.signer, s.message, s.timestamp);
    }
}
