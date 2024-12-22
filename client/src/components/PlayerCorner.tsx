import { FC } from 'react';
import { FaPlay } from 'react-icons/fa';
import '../styles/PlayerCorner.scss';

interface PlayerCornerProps {
    playerNumber: number;
    isCurrentTurn: boolean;
    playerColor: string;
    avatarUrl: string;
    playerName: string;
    score: number;
}

const PlayerCorner: FC<PlayerCornerProps> = ({
    playerNumber,
    isCurrentTurn,
    playerColor,
    avatarUrl,
    playerName,
    score
}) => {
    return (
        <div className={`player-corner player-corner-${playerNumber} ${playerColor}`}>
            <div className={`corner-content ${isCurrentTurn ? 'active-turn' : ''}`}>
                {/* Avatar Container */}
                <div className="avatar-container">
                    <div className="avatar-wrapper">
                        <img
                            src={avatarUrl}
                            alt={`Player ${playerNumber}`}
                            className="player-avatar object-cover [image-rendering:pixelated]"
                        />
                        {isCurrentTurn && (
                            <div className="turn-indicator flex items-center gap-1 whitespace-nowrap">
                                <FaPlay size={10} className="turn-icon" />
                                <span className="font-bold text-[10px]">YOUR TURN</span>
                            </div>
                        )}
                    </div>
                </div>

                {/* Player Info */}
                <div className="player-info text-center">
                    <div className="player-name text-white">
                        {playerName}
                        <span className="player-number opacity-60">
                            #{playerNumber}
                        </span>
                    </div>
                    <div className="score-dots-container inline-flex gap-2 justify-center w-full">
                        {[...Array(4)].map((_, i) => (
                            <div
                                key={i}
                                className={`score-dot transition-all duration-300 ${i < score ? 'filled' : ''}`}
                            />
                        ))}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default PlayerCorner; 