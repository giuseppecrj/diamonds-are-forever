// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

//interfaces

//libraries

//contracts
import "./utils/TestUtils.sol";
import {DeployFacet} from "scripts/DeployFacet.s.sol";
import {Facet} from "src/facet/Facet.sol";

contract FacetTest is TestUtils {
  Facet facet;

  function setUp() external {
    DeployFacet facetDeployer = new DeployFacet();
    facet = Facet(facetDeployer.deploy());
  }

  function testFacet() external {
    assertTrue(address(facet) != address(0), "Facet should be deployed");
  }
}
