import React from 'react'
import { useDojo } from '../../dojo/useDojo'
import "../../styles/BurnerWallet.scss";


export default function BurnerAccount() {
  const { account } = useDojo()
  console.log(account.account, "selected burner wallet")

  return (
      <div className="burner-container">
        <div className="burner-title">{`Burners Deployed: ${account.count}`}</div>
        <div className="signer-select">
          <label htmlFor="signer-select">Select Signer:</label>
          <select
            id="signer-select"
            value={account ? account.account.address : ""}
            onChange={(e) => account.select(e.target.value)}
          >
            {account?.list().map((account, index) => (
              <option value={account.address} key={index}>
                {account.address}
              </option>
            ))}
          </select>
        </div>
        <div>
          <button
            className="clear-button"
            onClick={() => account.clear()}
          >
            Clear Burners
          </button>
        </div>
      </div>


  )
}
