import React from 'react';
import "../styles/RestartGameModal.scss";

interface ConfirmationModalProps {
	message: string;
	onConfirm: () => void;
	onCancel: () => void;
}

const ConfirmationModal: React.FC<ConfirmationModalProps> = ({message, onConfirm, onCancel}) => {
  return (
	<div className="restartCon">
		<div className="innerRestart">
			<p>{message}</p>
			<div className="chooseAns">
				<button onClick={onConfirm}>Yes</button>
				<button onClick={onCancel}>No</button>
			</div>
		</div>
	</div>
  )
}

export default ConfirmationModal;