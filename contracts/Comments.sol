//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract Comments is Ownable {
    struct Comment {
        uint32 id;
        string topic;
        address creator_address;
        string message;
        uint256 created_at;
        bool is_hide;
    }

    uint32 private idCounter;

    mapping(string => Comment[]) private commentsByTopic;

    mapping(address => uint256) public lastWavedAt;

    event CommentAdded(Comment comment);

    function getComments(string calldata topic)
        public
        view
        returns (Comment[] memory)
    {
        return commentsByTopic[topic];
    }

    function getComment(string calldata topic, uint256 index)
        public
        view
        returns (Comment memory)
    {
        return commentsByTopic[topic][index];
    }

    function addComment(string calldata topic, string calldata message)
        public
        payable
    {
        // ban contract
        require(msg.sender == tx.origin, "not contract");

        // ban same wallet
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        Comment memory comment = Comment({
            id: idCounter,
            topic: topic,
            creator_address: msg.sender,
            message: message,
            created_at: block.timestamp,
            is_hide: false
        });
        commentsByTopic[topic].push(comment);
        idCounter++;
        emit CommentAdded(comment);
    }

    function setHide(
        string memory topic,
        uint256 index,
        bool is_hide
    ) public onlyOwner {
        commentsByTopic[topic][index].is_hide = is_hide;
    }

    function withdraw(address payable recipient) external onlyOwner {
        uint256 balance = address(this).balance;
        (bool success, ) = recipient.call{value: balance}("");
        require(success, "");
    }
}
