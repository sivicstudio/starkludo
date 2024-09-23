import "../../styles/Leaderboard.scss";

const Leaderboard = () => {
  return (
    <div>
      <div className="top-players">
        <div className="player player-one">
          <div className="avatar">
            <div className="avatar-outer-ring">
              <div className="avatar-inner-ring">
                <div className="avatar-inner-inner-ring">
                  <div>
                    <img src="" alt="" />
                  </div>
                </div>
              </div>
            </div>
            <div className="player-name">PLAYER NAME</div>
            <h4 className="player-rank">NO. 1</h4>
          </div>
        </div>
        <div className="second-third">
          <div className="player">
            <div className="avatar">
              <div className="avatar-outer-ring">
                <div className="avatar-inner-ring">
                  <div className="avatar-inner-inner-ring">
                    <div>
                      <img src="" alt="" />
                    </div>
                  </div>
                </div>
              </div>
              <div className="player-name">PLAYER NAME</div>
              <h4 className="player-rank">NO. 2</h4>
            </div>
          </div>
          <div className="player">
            <div className="avatar">
              <div className="avatar-outer-ring">
                <div className="avatar-inner-ring">
                  <div className="avatar-inner-inner-ring">
                    <div>
                      <img src="" alt="" />
                    </div>
                  </div>
                </div>
              </div>
              <div className="player-name">PLAYER NAME</div>
              <h4 className="player-rank">NO. 3</h4>
            </div>
          </div>
        </div>
      </div>
      <div className="other-players">
        <div className="player-strip">
          <div className="number">01</div>
          <div className="account-name">Account Name</div>
          <div className="cash">389k</div>
          <div className="wins">9</div>
          <div className="draws">9</div>
          <div className="losses">9</div>
        </div>
        <div className="player-strip">
          <div className="number">02</div>
          <div className="account-name">Account Name</div>
          <div className="cash">223k</div>
          <div className="wins">9</div>
          <div className="draws">9</div>
          <div className="losses">9</div>
        </div>
        <div className="player-strip">
          <div className="number">03</div>
          <div className="account-name">Account Name</div>
          <div className="cash">102k</div>
          <div className="wins">9</div>
          <div className="draws">9</div>
          <div className="losses">9</div>
        </div>
        <div className="player-strip">
          <div className="number">04</div>
          <div className="account-name">Account Name</div>
          <div className="cash">65k</div>
          <div className="wins">9</div>
          <div className="draws">9</div>
          <div className="losses">9</div>
        </div>
      </div>
    </div>
  );
};

export default Leaderboard;
