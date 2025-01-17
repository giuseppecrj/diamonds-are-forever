// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.25;

//interfaces

//libraries

//contracts
import "forge-std/Script.sol";
import {DeployBase} from "./DeployBase.s.sol";

abstract contract Deployer is Script, DeployBase {
  // override this with the name of the deployment version that this script deploys
  function versionName() public view virtual returns (string memory);

  // override this with the actual deployment logic, no need to worry about:
  // - existing deployments
  // - loading private keys
  // - saving deployments
  // - logging
  function __deploy(
    uint256 deployerPrivateKey
  ) public virtual returns (address);

  // will first try to load existing deployments from `deployments/<network>/<contract>.json`
  // if OVERRIDE_DEPLOYMENTS is set or if no deployment is found:
  // - read PRIVATE_KEY from env
  // - invoke __deploy() with the private key
  // - save the deployment to `deployments/<network>/<contract>.json`
  function deploy() public virtual returns (address deployedAddr) {
    bool overrideDeployment = vm.envOr("OVERRIDE_DEPLOYMENTS", uint256(0)) > 0;

    address existingAddr = isTesting()
      ? address(0)
      : getDeployment(versionName());

    if (!overrideDeployment && existingAddr != address(0)) {
      debug(
        string.concat("found existing ", versionName(), " deployment at"),
        existingAddr
      );
      debug("(override with OVERRIDE_DEPLOYMENTS=1)");
      return existingAddr;
    }

    uint256 pk = isAnvil()
      ? vm.envUint("LOCAL_PRIVATE_KEY")
      : vm.envUint("PRIVATE_KEY");

    address deployer = vm.addr(pk);

    if (!isTesting())
      info(
        string.concat(
          unicode"deploying \n\t📜 ",
          versionName(),
          unicode"\n\t⚡️ on ",
          chainAlias(),
          unicode"\n\t📬 from deployer address"
        ),
        vm.toString(deployer)
      );

    deployedAddr = __deploy(pk);

    if (!isTesting()) {
      info(
        string.concat(unicode"✅ ", versionName(), " deployed at"),
        vm.toString(deployedAddr)
      );
      saveDeployment(versionName(), deployedAddr);
      saveAddresses(versionName(), deployedAddr);
      postDeploy(deployer, deployedAddr);
    }
  }

  function postDeploy(address deployer, address deployment) public virtual {}

  function run() public virtual {
    deploy();
  }
}
