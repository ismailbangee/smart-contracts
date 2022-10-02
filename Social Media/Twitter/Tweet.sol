// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Tweet {

    address public immutable owner;
    uint256 private counter;
    string public test;

    constructor() {
        owner = msg.sender;}

    struct tweet {
        address tweeter;
        uint256 id;
        string tweetText;
        string tweetImage;
        uint256 tweetValue;
    }

    struct tweetReply {
        uint256 tweetId;
        address tweeter;
        uint256 id;
        string tweetText;
        string tweetImage;
        uint256 tweetValue;
    }    

    event tweetEvent (
        address tweeter,
        uint256 id,
        string tweetText,
        string tweetImage,
        uint256 tweetValue
    );

    event tweetReplyEvent (
        uint256 tweetId,
        address tweeter,
        uint256 id,
        string tweetText,
        string tweetImage,
        uint256 tweetValue
    );


    mapping(uint256 => tweet) Tweets;
    mapping(uint256 => uint256) likeTweets;
    mapping(uint256 => uint256) collectioFromTweet;
    mapping(uint256 => uint256) replyCounter;
    mapping(uint256 => mapping(uint256 => tweetReply)) tweetsReplies;
    mapping(address => mapping(uint256 => tweet)) userTweets;

    modifier minimumContribution {
        require(
                msg.value >= (0.001 ether),
                "Minimum 0.001"
            );
        _;
    }

    modifier tweetIdExists(uint256 tweetId) {
        require(
                counter >= tweetId,
                "Id not exists"
            );

        _;
    }

    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        _;
    }


    // Tweet with amount
    function addTweet(
        string memory tweetText,
        string memory tweetImage
    ) public payable minimumContribution {

        // Adding Tweet
        tweet storage newTweet = Tweets[counter];
        
        newTweet.tweeter = msg.sender;
        newTweet.id = counter;
        newTweet.tweetText = tweetText;
        newTweet.tweetImage = tweetImage;
        newTweet.tweetValue = msg.value;

        // Adding User Wise Tweet
        // user[0x0933][0] = {"tweet1", "image1",0.001}
        tweet storage newUserTweet = userTweets[msg.sender][counter];
        newUserTweet.tweetText = tweetText;
        newUserTweet.tweetImage = tweetImage;
        newUserTweet.tweetValue = msg.value;

        emit tweetEvent (
            msg.sender,
            counter,
            tweetText,
            tweetImage,
            msg.value
        );  

        collectioFromTweet[counter] = collectioFromTweet[counter] + msg.value;

        counter++;

        payable(owner).transfer(msg.value);
    }


    // Reply On Tweet
    function addTweetReply(
        uint256 tweetId,
        string memory tweetText,
        string memory tweetImage
    ) public payable minimumContribution tweetIdExists(tweetId) {

        tweetReply storage newTweet = tweetsReplies[tweetId][replyCounter[tweetId]];
        
        newTweet.tweetId = tweetId;
        newTweet.tweeter = msg.sender;
        newTweet.id = replyCounter[tweetId];
        newTweet.tweetText = tweetText;
        newTweet.tweetImage = tweetImage;
        newTweet.tweetValue = msg.value;

        emit tweetReplyEvent (
            tweetId,
            msg.sender,
            replyCounter[tweetId],
            tweetText,
            tweetImage,
            msg.value
        );  

        replyCounter[tweetId] = replyCounter[tweetId] + 1;

        collectioFromTweet[tweetId] = collectioFromTweet[tweetId] + msg.value;

        payable(owner).transfer(msg.value);
    }

    //Replies Count
    function tweetRpliesCount(
        uint256 tweetId
    ) public view  tweetIdExists(tweetId) returns (uint256) {
        return(replyCounter[tweetId]);
    }

    // Replies
    function tweetRplies(
        uint256 tweetId,
        uint256 replyId 
    ) public view  tweetIdExists(tweetId) returns (       string memory,
        string memory,
        address,
        uint256) {
        tweetReply storage t = tweetsReplies[tweetId][replyId];
        return(t.tweetText,t.tweetImage,t.tweeter,t.tweetValue);
    }

    // Like Tweet with amount
    function likeTweet(
        uint256 tweetId
    ) public payable minimumContribution  tweetIdExists(tweetId) {
        likeTweets[tweetId] = likeTweets[tweetId] + 1;    
        collectioFromTweet[tweetId] = collectioFromTweet[tweetId] + msg.value;   
    }

    // Get User Tweets By Tweet Id
    function getUserTweet(uint256 tweetId) public view  tweetIdExists(tweetId)  returns (
        string memory,
        string memory,
        address,
        uint256
    ) {
        tweet storage t = userTweets[msg.sender][tweetId];
        return(t.tweetText,t.tweetImage,t.tweeter,t.tweetValue);
    }

    // Get All Tweets By Tweet Id
    function getTweet(uint256 tweetId) public view  tweetIdExists(tweetId) returns (
        string memory,
        string memory,
        address,
        uint256
    ) {

        tweet storage t = Tweets[tweetId];

        return(t.tweetText,t.tweetImage,t.tweeter,t.tweetValue);
    }

    // Get Tweet Likes by Tweet Id
    function getTweetLikes(uint256 tweetId) public view  tweetIdExists(tweetId) returns (
        uint256
    ) {
        return likeTweets[tweetId];
    }

    // Get Tweet Collection
    function getTweetCollections(uint256 tweetId) public view  tweetIdExists(tweetId) returns (
        uint256
    ) {
        return collectioFromTweet[tweetId];
    }

    // Get All Tweets Collections
    function getTotalCollections() public view returns (
        uint256
    ) {

        uint256 total_collection = 0;

        for(uint256 i = 0; i < counter; i++) {
            total_collection = total_collection + collectioFromTweet[i];
        }

        return total_collection;

    }

    // Get Contract Balance
    function getContractBalance() public view onlyOwner returns (
        uint256
    ) {
        return address(this).balance;
    }
}