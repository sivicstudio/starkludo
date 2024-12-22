import { useState } from "react";
import "../../styles/Leaderboard.scss";

interface PlayerData {
  rank: string;
  accountName: string;
  wins: number;
  loss: number;
}

const globalPlayers: PlayerData[] = [
  { rank: "01", accountName: "Account Name", wins: 3227, loss: 122 },
  { rank: "02", accountName: "Account Name", wins: 2500, loss: 98 },
  { rank: "03", accountName: "Account Name", wins: 1800, loss: 150 },
  { rank: "04", accountName: "Account Name", wins: 1444, loss: 213 },
];

const friendPlayers: PlayerData[] = [
  { rank: "01", accountName: "Friend 1", wins: 1500, loss: 89 },
  { rank: "02", accountName: "Friend 2", wins: 1200, loss: 76 },
  { rank: "03", accountName: "Friend 3", wins: 900, loss: 65 },
  { rank: "04", accountName: "Friend 4", wins: 600, loss: 45 },
];

export default function Leaderboard() {
  const [activeTab, setActiveTab] = useState<"global" | "friends">("global");

  return (
    <div className="leaderboard-container">
      <div className="leaderboard">
        <div className="leaderboard__tabs">
          <button
            className={`leaderboard__tab ${activeTab === "global" ? "active" : ""
              }`}
            onClick={() => setActiveTab("global")}
          >
            Global Ranking
          </button>
          <button
            className={`leaderboard__tab ${activeTab === "friends" ? "active" : ""
              }`}
            onClick={() => setActiveTab("friends")}
          >
            Friends Ranking
          </button>
        </div>

        <div className="leaderboard__content">
          <table className="leaderboard__table">
            <thead>
              <tr>
                <th>Rank</th>
                <th>Account Name</th>
                <th>Wins</th>
                <th>Loss</th>
              </tr>
            </thead>

            <tbody>
              {(activeTab === "global" ? globalPlayers : friendPlayers).map(
                (player) => (
                  <tr key={player.rank}>
                    <td>{player.rank}</td>
                    <td>{player.accountName}</td>
                    <td>{player.wins}</td>
                    <td>{player.loss}</td>
                  </tr>
                )
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}