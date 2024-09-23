import "../../styles/Multiplayer.scss";

const Multiplayer = () => {
  return (
    <div>
      <div className="multiplayer-head">
        <div>
          <div className="number">No.</div>
          <div className="account-name">Account Name</div>
          <div className="cash">Point</div>
          <div className="wins">Rank</div>
        </div>
        <div className="current">CURRENT</div>
      </div>
      <div className="border"></div>
      <div className="accounts">
        <div className="account-strip">
          <div>
            <div>01</div>
            <div className="account-name">John Doe</div>
            <div>12.6k</div>
            <div>82</div>
          </div>
          <button className="current">OPEN</button>
        </div>
        <div className="account-strip">
          <div>
            <div>02</div>
            <div className="account-name">Stella Blue</div>
            <div>20.1k</div>
            <div>12</div>
          </div>
          <button className="current">OPEN</button>
        </div>
        <div className="account-strip">
          <div>
            <div>03</div>
            <div className="account-name">Gustavo F.</div>
            <div>12.0k</div>
            <div>10</div>
          </div>
          <button className="current">OPEN</button>
        </div>
        <div className="account-strip">
          <div>
            <div>04</div>
            <div className="account-name">Victor M.</div>
            <div>10.2k</div>
            <div>12</div>
          </div>
          <button className="current">CREATE</button>
        </div>
      </div>
    </div>
  );
};

export default Multiplayer;
