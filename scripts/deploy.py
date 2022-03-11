from brownie import accounts, Foo, Bar, Mal


def main():
    print("Deploying Mal...")
    m = Mal.deploy({"from": accounts[0]})
    print(f"Mal deployed at {m}...")

    print("Deploying Foo with the address of Mal...")
    f = Foo.deploy(m.address, {"from": accounts[1]})
    print(f"Foo deployed at {f}...")

    print("Calling Foo.callBar()...")
    tx = f.callBar({"from": accounts[2]})
    tx.wait(1)
    print(f"Foo called")
