import React from 'react';
import "../styles/RestartGameModal.scss";

interface ConfirmationModalProps {
	message: string;
	onConfirm: () => void;
	onCancel: () => void;
	extraMessage: string;
}

const ConfirmationModal: React.FC<ConfirmationModalProps> = ({message, onConfirm, onCancel, extraMessage}) => {
  return (
	<div className="restartCon">
		<div className="innerRestartCon">
		<div className="innerRestart">
			<p className='restartMessage'>{message}<br /> {extraMessage}</p>
			<div className="chooseAns">
			<button onClick={onCancel}><span>No</span></button>
			<button onClick={onConfirm}><span>Yes</span></button>
				
			</div>
		</div>
		</div>
		
	</div>
  )
}

export default ConfirmationModal;