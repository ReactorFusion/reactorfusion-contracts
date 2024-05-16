pragma solidity ^0.8.10;

import "./CEther.sol";

/**
 * @title Compound's Maximillion Contract
 * @author Compound
 */
contract Maximillion {
    /**
     * @notice msg.sender sends Ether to repay an account's borrow in a cEther market
     * @dev The provided Ether is applied towards the borrow balance, any excess is refunded
     * @param borrower The address of the borrower account to repay on behalf of
     * @param cEther_ The address of the cEther contract to repay in
     */
    function repayBehalfExplicit(address borrower, CEther cEther_) public payable {
        uint256 received = msg.value;
        uint256 borrows = cEther_.borrowBalanceCurrent(borrower);
        if (received > borrows) {
            cEther_.repayBorrowBehalf{value: borrows}(borrower);
            (bool success,) = msg.sender.call{value: (received - borrows)}("");
            require(success, "failed to send Ether");
        } else {
            cEther_.repayBorrowBehalf{value: received}(borrower);
        }
    }
}
