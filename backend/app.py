from flask import Flask, request, jsonify, render_template
from web3 import Web3
from ape import Contract, chain, networks, accounts, project, convert, api
from flask_cors import CORS

app = Flask(__name__)
CORS(app, support_credentials=True)

w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))
w3.eth.default_account = w3.eth.accounts[0]


# APE
with networks.parse_network_choice("ethereum:local:ganache") as provider:
    js = project.CF.contract_type.dict()
ExampleContract = w3.eth.contract(
    abi=js["abi"], bytecode=js["deploymentBytecode"]["bytecode"]
)
tx_hash = ExampleContract.constructor(w3.to_wei(3, "ether")).transact()
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
contract = w3.eth.contract(address=tx_receipt.contractAddress, abi=js["abi"])


@app.route("/api/contract_status")
def index():
    contract_status = {}
    contract_status["contract_address"] = contract.address
    contract_status["project_owner"] = contract.functions.projectOwner().call()
    contract_status["goal_amount"] = (
        str(w3.from_wei(contract.functions.goalAmount().call(), "ether")) + " ether"
    )

    contract_status["total_funding"] = (
        str(w3.from_wei(contract.functions.totalFunding().call(), "ether")) + " ether"
    )
    contract_status[
        "funding_goal_reached"
    ] = contract.functions.fundingGoalReached().call()
    contract_status["project_completed"] = contract.functions.projectCompleted().call()
    contract_status["countributors"] = contract.functions.getContributorCount().call()
    return contract_status


@app.route("/api/contributors")
def contributors():
    (
        contributor_addresses,
        contribution_amounts,
        contribution_datetime,
    ) = contract.functions.getContributors().call()
    contributors = []
    for i in range(len(contributor_addresses)):
        contributors.append(
            {
                "account": contributor_addresses[i],
                "amount": str(w3.from_wei(contribution_amounts[i], "ether")) + " ether",
                "datetime": contribution_datetime[i],
            }
        )
    return contributors


@app.route("/api/accounts")
def accounts():
    accounts = w3.eth.accounts[1:]
    return accounts


@app.route("/api/contribute", methods=["POST"])
def send_transaction():
    form_data = request.get_json()
    # return {"s": 1}
    # print(request.form.get("account"))
    # Extract the contract address and transaction details from the request body
    contributor = form_data["account"]
    # private_key = request.form["private_key"]
    amount = form_data["amount"]
    # gas = request.form["gas"]
    # gasPrice = request.form["gasPrice"]
    # input(js["abi"])

    tx = {
        "chainId": w3.eth.chain_id,  # Replace with the chain ID of your network
        "from": contributor,
        # "to": tx_receipt.contractAddress,
        "value": w3.to_wei(amount, "ether"),
        # "gas": gas,
        # "gasPrice": gasPrice,
        "gas": 200000,  # Specify the gas limit
        "gasPrice": w3.to_wei("20", "gwei"),  # Specify the gas price
        # "nonce": nonce,
    }
    tx_hash = contract.functions.contribute().transact(tx)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    # pprint.pprint()
    res = dict(tx_receipt)
    print(res)
    print(type(res))
    from hexbytes import HexBytes

    def convert_hex_to_str(obj):
        if isinstance(obj, HexBytes):
            return obj.hex()
        elif isinstance(obj, list):
            for i in obj:
                return convert_hex_to_str(i)
            # return [convert_hex_to_str(item) for item in obj]
        elif isinstance(obj, dict):
            return {key: convert_hex_to_str(value) for key, value in obj.items()}
        return obj

    # Convert HexBytes to strings
    converted_data = convert_hex_to_str(res)
    print(converted_data)
    print(type(tx_receipt))
    # Render the result template with the transaction hash
    # return render_template("transaction.html", transaction_hash=transaction_hash.hex())
    # return dict(tx_receipt)
    res1 = w3.to_json(tx_receipt)
    # return {"s": 12}
    # import
    return res1

    json_data = json.dumps(converted_data, indent=2)
    return json_data


if __name__ == "__main__":
    app.run(debug=True, port=5000)
