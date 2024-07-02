// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.25;

//interfaces

//libraries

//contracts
import {Deployer} from "./utils/Deployer.s.sol";
import {Facet} from "src/facet/Facet.sol";

contract DeployFacet is Deployer {
  function versionName() public pure override returns (string memory) {
    return "facet";
  }

  function __deploy(uint256 deployerPK) public override returns (address) {
    vm.broadcast(deployerPK);
    return address(new Facet());
  }
}
