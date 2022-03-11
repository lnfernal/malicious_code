// SPDX-License-Identifier: MIT
pragma solidity 0.8.12;

import "./console.sol";

/*
Let's say Alice can see the code of Foo and Bar but not Mal.
It is obvious to Alice that Foo.callBar() executes the code inside Bar.log().
However Eve deploys Foo with the address of Mal, so that calling Foo.callBar()
will actually execute the code at Mal.
*/

/*
1. Eve deploys Mal
2. Eve deploys Foo with the address of Mal
3. Alice calls Foo.callBar() after reading the code and judging that it is
   safe to call.
4. Although Alice expected Bar.log() to be execute, Mal.log() was executed.
*/

contract Foo {
    Bar bar;

    constructor(address _bar) {
        console.log("Foo.constructor(), _bar is %s", _bar);
        bar = Bar(_bar);
    }

    // Fixed
    // Bar public bar;
    // constructor(address _notUsed) public {
    //     bar = new Bar();
    //     console.log("Foo.constructor(), _bar is %s", address(bar));
    // }

    function callBar() public {
        console.log("Foo.callBar(), calling bar.log()...");
        bar.log();
    }
}

contract Bar {
    event Log(string message);

    function log() public {
        console.log("Bar.log() called");
        emit Log("Bar was called");
    }
}

// This code is hidden in a separate file
contract Mal {
    event Log(string message);

    // function () external {
    //     emit Log("Mal was called");
    // }

    // Actually we can execute the same exploit even if this function does
    // not exist by using the fallback
    function log() public {
        console.log("Mal.log() called");
        emit Log("Mal was called");
    }
}
