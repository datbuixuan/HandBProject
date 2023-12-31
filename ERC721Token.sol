// contracts/MintingEngine.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MintingEngine is ERC721Enumerable, IERC2981, IERC721Receiver, Ownable {
    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;

    struct Item {
        string uri;
        address royaltyAddress;
        uint96 royaltyPercentage;
    }

    address public MintingAddress;
    address public TransferAddress;

    mapping (uint256 => Item) private Items;
    string private ContractURI;

    constructor (string memory name, string memory symbol) ERC721(name, symbol){ }

    event itemsCreated(uint256[] tokenIds, string[] tokenUris, address owner, address royaltyAddress, uint96 royaltyPercentage);
   
    modifier onlyOwnerOrMinting()
    {
        require(msg.sender == owner() || msg.sender == MintingAddress, "You have not permission");
        _;         
    }

    modifier onlyTransfer() {
        require(msg.sender == TransferAddress, "You have not permission");
        _;
    }

    function updateMintingAddress(address newMintingAddress) public onlyOwner{
        require(newMintingAddress != MintingAddress, "Minting Address already exists");
        MintingAddress = newMintingAddress;
    }

    function updateTransferAddress(address newTransferAddress) public onlyOwner{
        require(newTransferAddress != TransferAddress, "Transfer Address already exists");
        TransferAddress = newTransferAddress;
    }

    function createItems(string[] memory uris, address owner, address royaltyAddress, uint96 royaltyPercentage) public onlyOwnerOrMinting {
        require(uris.length > 0, "The token URIs is not valid");
        uint256[] memory newItems = new uint256[](uris.length);

        for (uint256 i = 0; i < uris.length; i++) {
            uint256 newItemId = totalSupply() + 1;
            _safeMint(owner, newItemId);
            
            Items[newItemId] = Item(
                uris[i],
                royaltyAddress,
                royaltyPercentage
            );

            newItems[i] = newItemId;
        }

        emit itemsCreated(newItems, uris, owner, royaltyAddress, royaltyPercentage);
    }


    function setApprovalForItems(address to, uint256[] memory tokenIds) public{
        require(tokenIds.length > 0, "The input data is incorrect");
        
        for(uint256 i = 0; i < tokenIds.length; i++){
            require(_isApprovedOrOwner(msg.sender, tokenIds[i]), "You are not owner of item");

            _approve(to, tokenIds[i]);
        }
    }

    function transfers(address[] memory froms, address[] memory tos, uint256[] memory tokenIds) public{
        require(froms.length == tos.length, "The input data is incorrect");
        require(tokenIds.length == tos.length, "The input data is incorrect");

        for(uint256 i = 0; i < froms.length; i++){
            require(_isApprovedOrOwner(msg.sender, tokenIds[i]), "You are not owner of item");

            _transfer(froms[i], tos[i], tokenIds[i]);
        }
    }

    function transferOut(uint256[] memory tokenIds, address[] memory tos) public onlyTransfer {
        require(tokenIds.length == tos.length, "The input data is incorrect");
        for(uint256 i = 0; i < tos.length; i++){
            require(_exists(tokenIds[i]), "No token ID exists");

            _transfer(address(this), tos[i], tokenIds[i]);
        }
    }
    
    function setContractURI(string memory contractUri) public onlyOwner{
        ContractURI = contractUri;
    }


    // view function
    function tokenURI(uint256 tokenId) public view override returns (string memory)
    {
        require(_exists(tokenId), "No token ID exists");
        return Items[tokenId].uri;
    }

    function royaltyInfo(uint256 tokenId, uint256 salePrice) external view override returns (address receiver, uint256 royaltyAmount)
    {
        require(_exists(tokenId), "No token ID exists");
        Item memory _item = Items[tokenId];

        return (_item.royaltyAddress, (salePrice * _item.royaltyPercentage) / 1000);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721Enumerable) returns (bool)
    {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }

    function contractURI() public view returns (string memory) {
        return ContractURI;
    }

     function onERC721Received(address operator, address from,uint256 tokenId, bytes calldata data) external override returns (bytes4){
         return IERC721Receiver.onERC721Received.selector;
    }
}
