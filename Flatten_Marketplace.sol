// SPDX-License-Identifier: MIT

// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

pragma solidity 0.8.21;

contract MintingEngineMarketplace is Ownable {
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

    function excludeFromFee(address account) external onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) external onlyOwner {
        _isExcludedFromFee[account] = false;
    }

   
    event log(string reason);
    // Function
    function addItem(uint256 tokenId, address tokenAddress, uint256[] memory askingPrices, uint256 expirationTime, uint256 fee) external 
        validFeeItem(fee)
        onlyItemOwner(tokenAddress, tokenId)
        isApproved(tokenAddress, tokenId)
        validAskingPrices(askingPrices)
        validateExpirationTime(expirationTime) {
            _addItem(tokenId, tokenAddress, askingPrices, expirationTime, fee);
    }

    function bulkAddItems( uint256[] memory tokenIds, address tokenAddress, uint256[] memory askingPrices, uint256 expirationTime, uint256 fee) external
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