const { ethers } = require("ethers");

(async () => {
    try {
        const [deployer] = await ethers.getSigners();
        console.log('Deploying with: ', deployer.address);
    
        const ProofOfPID = await ethers.getContractFactory('ProofOfPID');
        const contract = await ProofOfPID.deploy();
    
        await contract.waitForDeployment();
    
        const contractAddress = await contract.getAddress()
    
        console.log("Contract Address:", contractAddress);
        
        process.exit(0);
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
})();
