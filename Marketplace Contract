// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MarvionMarketplaceRoyalty is Ownable {
    using SafeMath for uint256;

    enum ItemStatus {Open, Sold, Cancelled}

    struct SaleItem {
        uint256 id; 
        address tokenAddress;
        uint256 tokenId;
        address payable seller;
        uint256[] askingPrices;
        ItemStatus status;
        uint256 expirationTime; // Expiration timestamp - 0 for no expiry.
        uint256 fee;
    }

    struct Crypto {
        uint256 id;
        address cryptoAddress;
        bool status;
    }

    SaleItem[] public itemsForSale;
    Crypto[] public Cryptos;

    mapping(address => mapping(uint256 => uint256)) activeItemIds;
    mapping(address => bool) private _isExcludedFromFee;

    // bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;

    address private _marketWalletAddress;
    uint32 public _maxItemsInBulk = 80;

    event itemAdded(uint256 marketId,  uint256 tokenId, address tokenAddress, uint256[] askingPrices, uint256 expirationTime, uint256 fee);
    event itemSold(uint256 marketId, address buyer, uint256 askingPrice, uint256 value, uint256 cryptoId);
    event itemCancelled(uint256 marketId, address seller, uint256 tokenId, address tokenAddress);
    event itemUpdated( uint256 marketId, address seller, uint256[] askingPrices, uint256 expirationTime);

    constructor() {
        _marketWalletAddress = _msgSender();
        _isExcludedFromFee[_msgSender()] = true; // Exclude owner from fee

        itemsForSale.push(SaleItem(0, address(0), 0, payable(address(0)), new uint256[](0), ItemStatus.Cancelled, 0, 0));

        Cryptos.push(Crypto(0, address(0), true));
    }

    // Modifier
    modifier validItemOwner(uint256 marketId) {
        IERC721 tokenContract = IERC721(itemsForSale[marketId].tokenAddress);
        require(tokenContract.ownerOf(itemsForSale[marketId].tokenId) == itemsForSale[marketId].seller, "validItemOwner: Owner of item is not valid");
        _;
    }

    modifier isApproved(address tokenAddress, uint256 tokenId) {
        IERC721 tokenContract = IERC721(tokenAddress);
        bool isApprovedForAll = tokenContract.isApprovedForAll(msg.sender, address(this));
        if(!isApprovedForAll){
            require(tokenContract.getApproved(tokenId) == address(this), "hasTransferApproval: Item is not approved");   
        }
        _;
    }

    modifier validAskingPrices(uint256[] memory askingPrices) {
        require(askingPrices.length == Cryptos.length, "validAskingPrices: please enter all prices with cryptos");
        _;
    }

    modifier validateExpirationTime(uint256 expirationTime) {
        require(expirationTime == 0 || expirationTime > block.timestamp, "Expiration date incorrect");
        _;
    }

    modifier validFeeItem(uint256 fee) {
        require(fee >= 0 && fee <= 1000, "validFeeItem: Fee is not valid");
        _;
    }

    modifier onlyItemOwner(address tokenAddress, uint256 tokenId) {
        IERC721 tokenContract = IERC721(tokenAddress);
        require(tokenContract.ownerOf(tokenId) == msg.sender, "OnlyItemOwner: Only for owner of item");
        _;
    }

    modifier isApprovedAndOwnerItems(address tokenAddress, uint256[] memory tokenIds){
        IERC721 tokenContract = IERC721(tokenAddress);
        bool isApprovedForAll = tokenContract.isApprovedForAll(msg.sender, address(this));    

        for (uint256 i = 0; i < tokenIds.length; i++){
            require(tokenContract.ownerOf(tokenIds[i]) == msg.sender, "Only for owner of items");

            if(!isApprovedForAll){
                address approvedAddress = tokenContract.getApproved(tokenIds[i]);
                require(approvedAddress == address(this), "Item is not approved");
            }
        }
        _;
    }

    modifier validUpdateItems(uint256[] memory marketIds, address tokenAddress) {
        require(marketIds.length <= _maxItemsInBulk, "validUpdateItems: Max number items");
        IERC721 tokenContract = IERC721(tokenAddress);
        bool isApprovedForAll = tokenContract.isApprovedForAll(msg.sender, address(this));  

        for (uint256 i = 0; i < marketIds.length; i++) {
            require(marketIds[i] < itemsForSale.length && itemsForSale[marketIds[i]].id == marketIds[i], "validUpdateItems: Could not find item");
            require(itemsForSale[marketIds[i]].status == ItemStatus.Open, "FM4-003");
            require(itemsForSale[marketIds[i]].tokenAddress == tokenAddress, "validUpdateItems: Token address is not valid!");
            require(tokenContract.ownerOf(itemsForSale[marketIds[i]].tokenId) == msg.sender, "validUpdateItems: Only for owner of items");

             if(!isApprovedForAll){
                address approvedAddress = tokenContract.getApproved(itemsForSale[marketIds[i]].tokenId);
                require(approvedAddress == address(this), "Item is not approved");
            }
        }
        _;
    }

    modifier validCancelItems(uint256[] memory marketIds, address tokenAddress) {
        require(marketIds.length <= _maxItemsInBulk, "validUpdateItems: Max number items");
        for (uint256 i = 0; i < marketIds.length; i++) {
            require(marketIds[i] < itemsForSale.length && itemsForSale[marketIds[i]].id == marketIds[i],"validUpdateItems: Could not find item");
            require(itemsForSale[marketIds[i]].status == ItemStatus.Open, "FM4-004");
            require(itemsForSale[marketIds[i]].tokenAddress == tokenAddress, "validUpdateItems: Token address is not valid!");
            require(itemsForSale[marketIds[i]].seller == msg.sender, "validUpdateItems: Seller is not valid!");
        }
        _;
    }    

    modifier validSellerApproved(uint256 marketId) {
        SaleItem memory saleItem = itemsForSale[marketId];

        IERC721 tokenContract = IERC721(saleItem.tokenAddress);

        bool isApprovedForAll = tokenContract.isApprovedForAll(saleItem.seller, address(this));

        if (!isApprovedForAll) {
            require(tokenContract.getApproved(saleItem.tokenId) == address(this), "validSellerApproved: Item is not approved");  
        }
     
        require(tokenContract.ownerOf(saleItem.tokenId) == saleItem.seller, "validItemOwner: Owner of item is not valid");
        _;
    }

    modifier itemExists(uint256 marketId) {
        require(marketId < itemsForSale.length && itemsForSale[marketId].id == marketId, "itemExists: Could not find item");
        _;
    }

    modifier isForSale(uint256 marketId) {
        require(itemsForSale[marketId].status == ItemStatus.Open, "FM4-001");
        _;
    }

    modifier maxItemsInBulk(uint256[] memory tokenIds) {
        require(tokenIds.length <= _maxItemsInBulk, "Max number items");
        _;
    }

    modifier itemExpirationTime(uint256 marketId) {
        require(itemsForSale[marketId].expirationTime == 0 || block.timestamp < itemsForSale[marketId].expirationTime, "ItemExpirationTime: Invalid expiration time");
        _;
    }

    modifier validItemSeller(uint256 marketId) {
        require(itemsForSale[marketId].seller == msg.sender, "validItemSeller: Seller is not valid!");
        _;
    }

    modifier validAskingPrice(uint256 marketId, uint256 cryptoId) {
        require(Cryptos[cryptoId].status == true, "validAskingPrice: Invalid crypto status");
        if(cryptoId != 0){
            require(msg.value == 0, "Invalid the input data");
        }

        require(itemsForSale[marketId].askingPrices.length > cryptoId && itemsForSale[marketId].askingPrices[cryptoId] > 0, "validAskingPrice: Invalid crypto address");
        _;
    }

    

 
    //  Setting functions
    function setCryptoAddress(address crypto_) external onlyOwner{
        Cryptos.push(Crypto(Cryptos.length, crypto_, true));
    }

    function setCryptoStatus(uint256 cryptoId, bool status_) external onlyOwner{
        Cryptos[cryptoId].status = status_;
    }

    function setMarketAddress(address account) external onlyOwner {
        _marketWalletAddress = account;
    }

    function setMaxItemsInBulk(uint32 max) external onlyOwner {
        require(max > 0, "Min 1");
        _maxItemsInBulk = max;
    }

    function excludeFromFee(address account) external onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) external onlyOwner {
        _isExcludedFromFee[account] = false;
    }

   
   
    // Function
    function addItem(uint256 tokenId, address tokenAddress, uint256[] memory askingPrices, uint256 expirationTime, uint256 fee) external 
        validFeeItem(fee)
        onlyItemOwner(tokenAddress, tokenId)
        isApproved(tokenAddress, tokenId)
        validAskingPrices(askingPrices)
        validateExpirationTime(expirationTime){
            _addItem(tokenId, tokenAddress, askingPrices, expirationTime, fee);
    }

    function bulkAddItems( uint256[] memory tokenIds, address tokenAddress, uint256[] memory askingPrices, uint256 expirationTime, uint256 fee) external
        maxItemsInBulk(tokenIds)
        isApprovedAndOwnerItems(tokenAddress, tokenIds)
        validAskingPrices(askingPrices)
        validateExpirationTime(expirationTime){
            for(uint256 i = 0; i < tokenIds.length; i++){
                _addItem(tokenIds[i], tokenAddress, askingPrices, expirationTime, fee);
            }
    }



    function updateItem(uint256 marketId, uint256[] memory askingPrices, uint256 expirationTime) external
        itemExists(marketId) isForSale(marketId)
        isApproved(itemsForSale[marketId].tokenAddress, itemsForSale[marketId].tokenId)
        onlyItemOwner(itemsForSale[marketId].tokenAddress, itemsForSale[marketId].tokenId)
        validateExpirationTime(expirationTime)
        validAskingPrices(askingPrices){
            _updateItem(marketId, askingPrices, expirationTime);
    }

    function bulkUpdateItems(uint256[] memory marketIds, address tokenAddress, uint256[] memory askingPrices, uint256 expirationTime) external
        validUpdateItems(marketIds, tokenAddress)
        validateExpirationTime(expirationTime)
        validAskingPrices(askingPrices){
            for (uint256 i = 0; i < marketIds.length; i++) {
                _updateItem(marketIds[i], askingPrices, expirationTime);
            }
    }



    function cancelItem(uint256 marketId) external 
        itemExists(marketId) 
        isForSale(marketId) 
        validItemSeller(marketId){
            _cancelItem(marketId);
    }

    function bulkCancelItems(uint256[] memory marketIds, address tokenAddress) external 
        validCancelItems(marketIds, tokenAddress){
        for (uint256 i = 0; i < marketIds.length; i++) {
            _cancelItem(marketIds[i]);
        }
    }

       

    function buyItem(uint256 marketId, uint256 cryptoId) external payable
        itemExists(marketId) isForSale(marketId)
        validSellerApproved(marketId) 
        itemExpirationTime(marketId)
        validAskingPrice(marketId, cryptoId)
    {
        SaleItem storage item = itemsForSale[marketId];
        require(msg.sender != item.seller);

        if (cryptoId == 0) {
            require(msg.value >= item.askingPrices[0], "Not enough funds sent");
        } else {
            require(IERC20(Cryptos[cryptoId].cryptoAddress).balanceOf(msg.sender) >= item.askingPrices[cryptoId], "Not enough funds sent");
            require(IERC20(Cryptos[cryptoId].cryptoAddress).allowance(msg.sender, address(this)) >= item.askingPrices[cryptoId], "buyItem: transfer amount exceeds allowance");
        }

        item.status = ItemStatus.Sold;
        activeItemIds[item.tokenAddress][item.tokenId] = 0;
        IERC721(item.tokenAddress).safeTransferFrom(item.seller, msg.sender, item.tokenId);

        _payout(marketId, cryptoId);

        emit itemSold(marketId, msg.sender, item.askingPrices[cryptoId], msg.value, cryptoId);
    }

   


    // View functions

    function getActiveItemId(address tokenAddress, uint256 tokenId) public view returns (uint256){
        return activeItemIds[tokenAddress][tokenId];
    }

    function isExcludeFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account] == true;
    }

    function getPrices(uint256 marketId) public view itemExists(marketId) returns (uint256[] memory){
        return itemsForSale[marketId].askingPrices;
    }

    function getItemForSale(uint256 marketId) public view itemExists(marketId) returns (SaleItem memory){
        return itemsForSale[marketId];        
    }

    function checkRoyalty(address tokenAddress, uint256 _tokenId, uint256 _amount) public view returns (address, uint256) {
        IERC2981 tokenContract = IERC2981(tokenAddress);
        bool supportInterface = tokenContract.supportsInterface(_INTERFACE_ID_ERC2981);
        if (supportInterface) {
            return tokenContract.royaltyInfo(_tokenId, _amount);
        }
        return (address(0), 0);
    }
    
    function calculateTransFee(uint256 marketId, uint256 _amount) private view returns (uint256) {
        uint256 _marketFee = itemsForSale[marketId].fee;
        if (_marketFee == 0) {
            return 0;
        }
        return (_amount * _marketFee) / 1000;
    }


    // private function 
    function _addItem(uint256 tokenId, address tokenAddress, uint256[] memory askingPrices, uint256 expirationTime, uint256 fee) private {
        changeStatusItem(tokenAddress, tokenId);

        uint256 newItemId = itemsForSale.length;
        itemsForSale.push(SaleItem(newItemId, tokenAddress, tokenId, payable(msg.sender), askingPrices, ItemStatus.Open, expirationTime, fee));
        activeItemIds[tokenAddress][tokenId] = newItemId;

        assert(itemsForSale[newItemId].id == newItemId);
        
        emit itemAdded(newItemId, tokenId, tokenAddress, askingPrices, expirationTime, fee);
    }

    function _updateItem(uint256 marketId, uint256[] memory askingPrices, uint256 expirationTime) private {
        itemsForSale[marketId].askingPrices = askingPrices;
        itemsForSale[marketId].expirationTime = expirationTime;

        emit itemUpdated(marketId, msg.sender, itemsForSale[marketId].askingPrices, itemsForSale[marketId].expirationTime);
    }

    function _cancelItem(uint256 marketId) private {
        itemsForSale[marketId].status = ItemStatus.Cancelled;
        activeItemIds[itemsForSale[marketId].tokenAddress][itemsForSale[marketId].tokenId] = 0;

        emit itemCancelled(marketId, msg.sender, itemsForSale[marketId].tokenId, itemsForSale[marketId].tokenAddress);
    }

    function _payout(uint256 marketId, uint256 cryptoId) private returns (bool)
    {
        address cryptoAddress = Cryptos[cryptoId].cryptoAddress;
        bool takeFee = true;
        SaleItem memory item = itemsForSale[marketId];
        if (_isExcludedFromFee[item.seller]) {
            takeFee = false;
        }
        uint256 _amount = msg.value;
        if (cryptoId != 0) {
            _amount = item.askingPrices[cryptoId];
        }
        uint256 remainingAmount = _amount;
        if(takeFee){
            uint256 transferFee = calculateTransFee(marketId, _amount);

            if (transferFee != 0 && _marketWalletAddress != address(0)) {
                remainingAmount = remainingAmount.sub(transferFee);
                
                if (cryptoId == 0) {
                    payable(_marketWalletAddress).transfer(transferFee);
                } 
                else {
                    IERC20(cryptoAddress).transferFrom( msg.sender, _marketWalletAddress, transferFee);
                }
            }
        }
        

        (address receiver, uint256 royaltyAmount) = checkRoyalty(item.tokenAddress, item.tokenId, _amount);

        if (receiver != address(0) && royaltyAmount > 0) {
            remainingAmount = remainingAmount.sub(royaltyAmount);
            if (cryptoId == 0) {
                payable(receiver).transfer(royaltyAmount);
            } 
            else {
                IERC20(cryptoAddress).transferFrom(msg.sender, receiver, royaltyAmount);
            }
        }

        if (cryptoId == 0) {
            item.seller.transfer(remainingAmount);
        } 
        else {
            IERC20(cryptoAddress).transferFrom(msg.sender, item.seller, remainingAmount);
        }

        return true;
    }


    function changeStatusItem(address tokenAddress, uint256 tokenId) private {
        uint256 currentItemId = activeItemIds[tokenAddress][tokenId];
        if (currentItemId > 0 && itemsForSale[currentItemId].id == currentItemId && itemsForSale[currentItemId].status == ItemStatus.Open) {
            itemsForSale[currentItemId].status = ItemStatus.Cancelled;
            emit itemCancelled(currentItemId, msg.sender, itemsForSale[currentItemId].tokenId, itemsForSale[currentItemId].tokenAddress);           
        }
    }
}

///
/// @dev Interface for the NFT Royalty Standard
///
interface IERC2981 is IERC721 {
    /// @notice Called with the sale price to determine how much royalty
    //          is owed and to whom.
    /// @param _tokenId - the NFT asset queried for royalty information
    /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
    /// @return receiver - address of who should be sent the royalty payment
    /// @return royaltyAmount - the royalty payment amount for _salePrice
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 * TODO: remove once open zeppelin update to solc 0.5.0
 */
library SafeMath {
    /**
     * @dev Multiplies two numbers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two numbers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }
}
