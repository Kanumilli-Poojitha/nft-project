// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NftCollection is ERC721URIStorage, Ownable, Pausable {
    using Counters for Counters.Counter;

    uint256 public immutable maxSupply;
    Counters.Counter private _tokenIdCounter;
    string private _baseTokenURI;

    event Minted(address indexed to, uint256 indexed tokenId, string tokenURI);

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_,
        string memory baseURI_
    ) ERC721(name_, symbol_) {
        require(maxSupply_ > 0, "maxSupply must be > 0");
        maxSupply = maxSupply_;
        _baseTokenURI = baseURI_;
    }

    function mint(address to, string memory tokenURI_) external onlyOwner whenNotPaused returns (uint256) {
        require(to != address(0), "mint to zero address");
        uint256 current = _tokenIdCounter.current();
        require(current < maxSupply, "max supply reached");

        _tokenIdCounter.increment();
        uint256 newId = _tokenIdCounter.current();
        _safeMint(to, newId);
        if (bytes(tokenURI_).length > 0) {
            _setTokenURI(newId, tokenURI_);
        }
        emit Minted(to, newId, tokenURI_);
        return newId;
    }

    function burn(uint256 tokenId) external {
        require(_exists(tokenId), "nonexistent token");
        address owner = ownerOf(tokenId);
        require(
            msg.sender == owner ||
            getApproved(tokenId) == msg.sender ||
            isApprovedForAll(owner, msg.sender),
            "not authorized to burn"
        );
        _burn(tokenId);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function setBaseURI(string memory newBase) external onlyOwner {
        _baseTokenURI = newBase;
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override
        whenNotPaused
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }
}
