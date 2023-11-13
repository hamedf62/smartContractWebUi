// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CF {
    address public projectOwner;
    uint256 public goalAmount;
    uint256 public totalFunding;
    // mapping(address => uint256) public contributions;
    // address[] public contributorList; // Store contributor addresses

    struct Contributor {
        address contributorAddress;
        uint256 contributionAmount;
        uint contributionDateTime;
    }
    Contributor[] public contributors;

    bool public fundingGoalReached;
    bool public projectCompleted;

    event FundingReceived(address contributor, uint256 amount);
    event FundingGoalReached(uint256 totalFunding);
    event ProjectCompleted(bool success);
    event RefundedContributor(
        address contributor,
        uint256 amount,
        uint timestamp
    );

    constructor(uint256 _goalAmount) {
        projectOwner = msg.sender;
        goalAmount = _goalAmount;
        fundingGoalReached = false;
        projectCompleted = false;
    }

    modifier onlyOwner() {
        require(
            msg.sender == projectOwner,
            "Only the project owner can perform this action."
        );
        _;
    }

    modifier projectNotCompleted() {
        require(!projectCompleted, "The project has already been completed.");
        _;
    }

    function isOwner() external view returns (address) {
        // return (msg.sender == projectOwner);
        return msg.sender;
    }

    function contribute() external payable projectNotCompleted {
        require(msg.value > 0, "Contribution amount must be greater than 0.");
        // contributions[msg.sender] += msg.value;
        contributors.push(Contributor(msg.sender, msg.value, block.timestamp));
        // contributorList.push(msg.sender); // Add contributor to the list
        // Check if the contributor's address is not already in the contributorList
        // bool isContributor = false;
        // for (uint256 i = 0; i < contributorList.length; i++) {
        //     if (contributorList[i] == msg.sender) {
        //         isContributor = true;
        //         break;
        //     }
        // }

        // // If the contributor is not in the list, add them
        // if (!isContributor) {
        //     contributorList.push(msg.sender); // Add contributor to the list
        // }

        totalFunding += msg.value;
        emit FundingReceived(msg.sender, msg.value);

        if (totalFunding >= goalAmount) {
            fundingGoalReached = true;
            emit FundingGoalReached(totalFunding);
        }
    }

    function completeProject()
        external
        onlyOwner
        projectNotCompleted
        returns (bool)
    {
        require(fundingGoalReached, "Funding goal has not been reached.");

        // Perform actions to complete the construction project.
        // This is a placeholder and should be customized based on your project.

        projectCompleted = true;
        emit ProjectCompleted(true);
        return true;
    }

    function withdrawFunds() external onlyOwner {
        require(
            projectCompleted,
            "The project must be completed to withdraw funds."
        );
        payable(projectOwner).transfer(totalFunding);
        totalFunding = 0;
    }

    function refundContributors() external onlyOwner {
        require(
            !fundingGoalReached,
            "Funding goal has been reached; contributors cannot be refunded."
        );

        // for (uint i = 0; i < totalFunding; i++) {
        //     address contributor = payable(msg.sender);
        //     uint amount = contributions[contributor];
        //     if (amount > 0) {
        //         payable(contributor).transfer(amount);
        //         contributions[contributor] = 0;
        //     }
        // }
        for (uint256 i = 0; i < contributors.length; i++) {
            address contributor = contributors[i].contributorAddress;
            // uint256 amount = contributions[contributor];
            uint256 amountRefunded = contributors[i].contributionAmount;
            uint dateTime = contributors[i].contributionDateTime;
            if (amountRefunded > 0) {
                payable(contributor).transfer(amountRefunded);
                // contributions[contributor] = 0;
                contributors[i].contributionAmount = 0;
                emit RefundedContributor(contributor, amountRefunded, dateTime);

                totalFunding -= amountRefunded;
            }
        }
    }

    function getContributorCount() external view returns (uint256) {
        return contributors.length;
    }

    // function getContributors() public view returns (address[] memory) {
    //     return contributors;
    // }
    function getContributors()
        public
        view
        returns (address[] memory, uint256[] memory, uint[] memory)
    {
        address[] memory contributorAddresses = new address[](
            contributors.length
        );
        uint256[] memory contributionAmounts = new uint256[](
            contributors.length
        );

        uint[] memory contributionDateTimes = new uint[](contributors.length);

        for (uint256 i = 0; i < contributors.length; i++) {
            contributorAddresses[i] = contributors[i].contributorAddress;
            contributionAmounts[i] = contributors[i].contributionAmount;
            contributionDateTimes[i] = contributors[i].contributionDateTime;
        }

        return (
            contributorAddresses,
            contributionAmounts,
            contributionDateTimes
        );
    }

    // function getContributorAtIndex(
    //     uint256 index
    // ) external view returns (address) {
    //     require(index < contributors.length, "Index out of range");
    //     return contributors[index];
    // }
}
